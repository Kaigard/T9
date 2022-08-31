//- WebAssemblyISelDAGToDAG.cpp - A dag to dag inst selector for WebAssembly -//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file defines an instruction selector for the WebAssembly target.
///
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "WebAssembly.h"
#include "WebAssemblyISelLowering.h"
#include "WebAssemblyTargetMachine.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/WasmEHFuncInfo.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/Function.h" // To access function attributes.
#include "llvm/IR/IntrinsicsWebAssembly.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/KnownBits.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "wasm-isel"

//===--------------------------------------------------------------------===//
/// WebAssembly-specific code to select WebAssembly machine instructions for
/// SelectionDAG operations.
///
namespace {
class WebAssemblyDAGToDAGISel final : public SelectionDAGISel {
  /// Keep a pointer to the WebAssemblySubtarget around so that we can make the
  /// right decision when generating code for different targets.
  const WebAssemblySubtarget *Subtarget;

public:
  WebAssemblyDAGToDAGISel(WebAssemblyTargetMachine &TM,
                          CodeGenOpt::Level OptLevel)
      : SelectionDAGISel(TM, OptLevel), Subtarget(nullptr) {
  }

  StringRef getPassName() const override {
    return "WebAssembly Instruction Selection";
  }

  bool runOnMachineFunction(MachineFunction &MF) override {
    LLVM_DEBUG(dbgs() << "********** ISelDAGToDAG **********\n"
                         "********** Function: "
                      << MF.getName() << '\n');

    Subtarget = &MF.getSubtarget<WebAssemblySubtarget>();

    return SelectionDAGISel::runOnMachineFunction(MF);
  }

  void PreprocessISelDAG() override;

  void Select(SDNode *Node) override;

  bool SelectInlineAsmMemoryOperand(const SDValue &Op, unsigned ConstraintID,
                                    std::vector<SDValue> &OutOps) override;

// Include the pieces autogenerated from the target description.
#include "WebAssemblyGenDAGISel.inc"

private:
  // add select functions here...
};
} // end anonymous namespace

void WebAssemblyDAGToDAGISel::PreprocessISelDAG() {
  // Stack objects that should be allocated to locals are hoisted to WebAssembly
  // locals when they are first used.  However for those without uses, we hoist
  // them here.  It would be nice if there were some hook to do this when they
  // are added to the MachineFrameInfo, but that's not the case right now.
  MachineFrameInfo &FrameInfo = MF->getFrameInfo();
  for (int Idx = 0; Idx < FrameInfo.getObjectIndexEnd(); Idx++)
    WebAssemblyFrameLowering::getLocalForStackObject(*MF, Idx);

  SelectionDAGISel::PreprocessISelDAG();
}

static SDValue getTagSymNode(int Tag, SelectionDAG *DAG) {
  assert(Tag == WebAssembly::CPP_EXCEPTION || WebAssembly::C_LONGJMP);
  auto &MF = DAG->getMachineFunction();
  const auto &TLI = DAG->getTargetLoweringInfo();
  MVT PtrVT = TLI.getPointerTy(DAG->getDataLayout());
  const char *SymName = Tag == WebAssembly::CPP_EXCEPTION
                            ? MF.createExternalSymbolName("__cpp_exception")
                            : MF.createExternalSymbolName("__c_longjmp");
  return DAG->getTargetExternalSymbol(SymName, PtrVT);
}

void WebAssemblyDAGToDAGISel::Select(SDNode *Node) {
  // If we have a custom node, we already have selected!
  if (Node->isMachineOpcode()) {
    LLVM_DEBUG(errs() << "== "; Node->dump(CurDAG); errs() << "\n");
    Node->setNodeId(-1);
    return;
  }

  MVT PtrVT = TLI->getPointerTy(CurDAG->getDataLayout());
  auto GlobalGetIns = PtrVT == MVT::i64 ? WebAssembly::GLOBAL_GET_I64
                                        : WebAssembly::GLOBAL_GET_I32;

  // Few custom selection stuff.
  SDLoc DL(Node);
  MachineFunction &MF = CurDAG->getMachineFunction();
  switch (Node->getOpcode()) {
  case ISD::ATOMIC_FENCE: {
    if (!MF.getSubtarget<WebAssemblySubtarget>().hasAtomics())
      break;

    uint64_t SyncScopeID = Node->getConstantOperandVal(2);
    MachineSDNode *Fence = nullptr;
    switch (SyncScopeID) {
    case SyncScope::SingleThread:
      // We lower a single-thread fence to a pseudo compiler barrier instruction
      // preventing instruction reordering. This will not be emitted in final
      // binary.
      Fence = CurDAG->getMachineNode(WebAssembly::COMPILER_FENCE,
                                     DL,                 // debug loc
                                     MVT::Other,         // outchain type
                                     Node->getOperand(0) // inchain
      );
      break;
    case SyncScope::System:
      // Currently wasm only supports sequentially consistent atomics, so we
      // always set the order to 0 (sequentially consistent).
      Fence = CurDAG->getMachineNode(
          WebAssembly::ATOMIC_FENCE,
          DL,                                         // debug loc
          MVT::Other,                                 // outchain type
          CurDAG->getTargetConstant(0, DL, MVT::i32), // order
          Node->getOperand(0)                         // inchain
      );
      break;
    default:
      llvm_unreachable("Unknown scope!");
    }

    ReplaceNode(Node, Fence);
    CurDAG->RemoveDeadNode(Node);
    return;
  }

  case ISD::INTRINSIC_WO_CHAIN: {
    unsigned IntNo = Node->getConstantOperandVal(0);
    switch (IntNo) {
    case Intrinsic::wasm_tls_size: {
      MachineSDNode *TLSSize = CurDAG->getMachineNode(
          GlobalGetIns, DL, PtrVT,
          CurDAG->getTargetExternalSymbol("__tls_size", PtrVT));
      ReplaceNode(Node, TLSSize);
      return;
    }

    case Intrinsic::wasm_tls_align: {
      MachineSDNode *TLSAlign = CurDAG->getMachineNode(
          GlobalGetIns, DL, PtrVT,
          CurDAG->getTargetExternalSymbol("__tls_align", PtrVT));
      ReplaceNode(Node, TLSAlign);
      return;
    }
    }
    break;
  }

  case ISD::INTRINSIC_W_CHAIN: {
    unsigned IntNo = Node->getConstantOperandVal(1);
    const auto &TLI = CurDAG->getTargetLoweringInfo();
    MVT PtrVT = TLI.getPointerTy(CurDAG->getDataLayout());
    switch (IntNo) {
    case Intrinsic::wasm_tls_base: {
      MachineSDNode *TLSBase = CurDAG->getMachineNode(
          GlobalGetIns, DL, PtrVT, MVT::Other,
          CurDAG->getTargetExternalSymbol("__tls_base", PtrVT),
          Node->getOperand(0));
      ReplaceNode(Node, TLSBase);
      return;
    }

    case Intrinsic::wasm_catch: {
      int Tag = Node->getConstantOperandVal(2);
      SDValue SymNode = getTagSymNode(Tag, CurDAG);
      MachineSDNode *Catch =
          CurDAG->getMachineNode(WebAssembly::CATCH, DL,
                                 {
                                     PtrVT,     // exception pointer
                                     MVT::Other // outchain type
                                 },
                                 {
                                     SymNode,            // exception symbol
                                     Node->getOperand(0) // inchain
                                 });
      ReplaceNode(Node, Catch);
      return;
    }
    }
    break;
  }

  case ISD::INTRINSIC_VOID: {
    unsigned IntNo = Node->getConstantOperandVal(1);
    switch (IntNo) {
    case Intrinsic::wasm_throw: {
      int Tag = Node->getConstantOperandVal(2);
      SDValue SymNode = getTagSymNode(Tag, CurDAG);
      MachineSDNode *Throw =
          CurDAG->getMachineNode(WebAssembly::THROW, DL,
                                 MVT::Other, // outchain type
                                 {
                                     SymNode,             // exception symbol
                                     Node->getOperand(3), // thrown value
                                     Node->getOperand(0)  // inchain
                                 });
      ReplaceNode(Node, Throw);
      return;
    }
    }
    break;
  }

  case WebAssemblyISD::CALL:
  case WebAssemblyISD::RET_CALL: {
    // CALL has both variable operands and variable results, but ISel only
    // supports one or the other. Split calls into two nodes glued together, one
    // for the operands and one for the results. These two nodes will be
    // recombined in a custom inserter hook into a single MachineInstr.
    SmallVector<SDValue, 16> Ops;
    for (size_t i = 1; i < Node->getNumOperands(); ++i) {
      SDValue Op = Node->getOperand(i);
      if (i == 1 && Op->getOpcode() == WebAssemblyISD::Wrapper)
        Op = Op->getOperand(0);
      Ops.push_back(Op);
    }

    // Add the chain last
    Ops.push_back(Node->getOperand(0));
    MachineSDNode *CallParams =
        CurDAG->getMachineNode(WebAssembly::CALL_PARAMS, DL, MVT::Glue, Ops);

    unsigned Results = Node->getOpcode() == WebAssemblyISD::CALL
                           ? WebAssembly::CALL_RESULTS
                           : WebAssembly::RET_CALL_RESULTS;

    SDValue Link(CallParams, 0);
    MachineSDNode *CallResults =
        CurDAG->getMachineNode(Results, DL, Node->getVTList(), Link);
    ReplaceNode(Node, CallResults);
    return;
  }

  default:
    break;
  }

  // Select the default instruction.
  SelectCode(Node);
}

bool WebAssemblyDAGToDAGISel::SelectInlineAsmMemoryOperand(
    const SDValue &Op, unsigned ConstraintID, std::vector<SDValue> &OutOps) {
  switch (ConstraintID) {
  case InlineAsm::Constraint_m:
    // We just support simple memory operands that just have a single address
    // operand and need no special handling.
    OutOps.push_back(Op);
    return false;
  default:
    break;
  }

  return true;
}

/// This pass converts a legalized DAG into a WebAssembly-specific DAG, ready
/// for instruction scheduling.
FunctionPass *llvm::createWebAssemblyISelDag(WebAssemblyTargetMachine &TM,
                                             CodeGenOpt::Level OptLevel) {
  return new WebAssemblyDAGToDAGISel(TM, OptLevel);
}
