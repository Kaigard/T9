//===- MemoryBuiltins.cpp - Identify calls to memory builtins -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This family of functions identifies calls to builtin functions that allocate
// or free memory.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/None.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/TargetFolder.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/Utils/Local.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalAlias.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include <cassert>
#include <cstdint>
#include <iterator>
#include <numeric>
#include <type_traits>
#include <utility>

using namespace llvm;

#define DEBUG_TYPE "memory-builtins"

enum AllocType : uint8_t {
  OpNewLike          = 1<<0, // allocates; never returns null
  MallocLike         = 1<<1, // allocates; may return null
  AlignedAllocLike   = 1<<2, // allocates with alignment; may return null
  CallocLike         = 1<<3, // allocates + bzero
  ReallocLike        = 1<<4, // reallocates
  StrDupLike         = 1<<5,
  MallocOrOpNewLike  = MallocLike | OpNewLike,
  MallocOrCallocLike = MallocLike | OpNewLike | CallocLike | AlignedAllocLike,
  AllocLike          = MallocOrCallocLike | StrDupLike,
  AnyAlloc           = AllocLike | ReallocLike
};

enum class MallocFamily {
  Malloc,
  CPPNew,             // new(unsigned int)
  CPPNewAligned,      // new(unsigned int, align_val_t)
  CPPNewArray,        // new[](unsigned int)
  CPPNewArrayAligned, // new[](unsigned long, align_val_t)
  MSVCNew,            // new(unsigned int)
  MSVCArrayNew,       // new[](unsigned int)
  VecMalloc,
  KmpcAllocShared,
};

StringRef mangledNameForMallocFamily(const MallocFamily &Family) {
  switch (Family) {
  case MallocFamily::Malloc:
    return "malloc";
  case MallocFamily::CPPNew:
    return "_Znwm";
  case MallocFamily::CPPNewAligned:
    return "_ZnwmSt11align_val_t";
  case MallocFamily::CPPNewArray:
    return "_Znam";
  case MallocFamily::CPPNewArrayAligned:
    return "_ZnamSt11align_val_t";
  case MallocFamily::MSVCNew:
    return "??2@YAPAXI@Z";
  case MallocFamily::MSVCArrayNew:
    return "??_U@YAPAXI@Z";
  case MallocFamily::VecMalloc:
    return "vec_malloc";
  case MallocFamily::KmpcAllocShared:
    return "__kmpc_alloc_shared";
  }
  llvm_unreachable("missing an alloc family");
}

struct AllocFnsTy {
  AllocType AllocTy;
  unsigned NumParams;
  // First and Second size parameters (or -1 if unused)
  int FstParam, SndParam;
  // Alignment parameter for aligned_alloc and aligned new
  int AlignParam;
  // Name of default allocator function to group malloc/free calls by family
  MallocFamily Family;
};

// clang-format off
// FIXME: certain users need more information. E.g., SimplifyLibCalls needs to
// know which functions are nounwind, noalias, nocapture parameters, etc.
static const std::pair<LibFunc, AllocFnsTy> AllocationFnData[] = {
    {LibFunc_vec_malloc,                        {MallocLike,       1,  0, -1, -1, MallocFamily::VecMalloc}},
    {LibFunc_Znwj,                              {OpNewLike,        1,  0, -1, -1, MallocFamily::CPPNew}},             // new(unsigned int)
    {LibFunc_ZnwjRKSt9nothrow_t,                {MallocLike,       2,  0, -1, -1, MallocFamily::CPPNew}},             // new(unsigned int, nothrow)
    {LibFunc_ZnwjSt11align_val_t,               {OpNewLike,        2,  0, -1,  1, MallocFamily::CPPNewAligned}},      // new(unsigned int, align_val_t)
    {LibFunc_ZnwjSt11align_val_tRKSt9nothrow_t, {MallocLike,       3,  0, -1,  1, MallocFamily::CPPNewAligned}},      // new(unsigned int, align_val_t, nothrow)
    {LibFunc_Znwm,                              {OpNewLike,        1,  0, -1, -1, MallocFamily::CPPNew}},             // new(unsigned long)
    {LibFunc_ZnwmRKSt9nothrow_t,                {MallocLike,       2,  0, -1, -1, MallocFamily::CPPNew}},             // new(unsigned long, nothrow)
    {LibFunc_ZnwmSt11align_val_t,               {OpNewLike,        2,  0, -1,  1, MallocFamily::CPPNewAligned}},      // new(unsigned long, align_val_t)
    {LibFunc_ZnwmSt11align_val_tRKSt9nothrow_t, {MallocLike,       3,  0, -1,  1, MallocFamily::CPPNewAligned}},      // new(unsigned long, align_val_t, nothrow)
    {LibFunc_Znaj,                              {OpNewLike,        1,  0, -1, -1, MallocFamily::CPPNewArray}},        // new[](unsigned int)
    {LibFunc_ZnajRKSt9nothrow_t,                {MallocLike,       2,  0, -1, -1, MallocFamily::CPPNewArray}},        // new[](unsigned int, nothrow)
    {LibFunc_ZnajSt11align_val_t,               {OpNewLike,        2,  0, -1,  1, MallocFamily::CPPNewArrayAligned}}, // new[](unsigned int, align_val_t)
    {LibFunc_ZnajSt11align_val_tRKSt9nothrow_t, {MallocLike,       3,  0, -1,  1, MallocFamily::CPPNewArrayAligned}}, // new[](unsigned int, align_val_t, nothrow)
    {LibFunc_Znam,                              {OpNewLike,        1,  0, -1, -1, MallocFamily::CPPNewArray}},        // new[](unsigned long)
    {LibFunc_ZnamRKSt9nothrow_t,                {MallocLike,       2,  0, -1, -1, MallocFamily::CPPNewArray}},        // new[](unsigned long, nothrow)
    {LibFunc_ZnamSt11align_val_t,               {OpNewLike,        2,  0, -1,  1, MallocFamily::CPPNewArrayAligned}}, // new[](unsigned long, align_val_t)
    {LibFunc_ZnamSt11align_val_tRKSt9nothrow_t, {MallocLike,       3,  0, -1,  1, MallocFamily::CPPNewArrayAligned}}, // new[](unsigned long, align_val_t, nothrow)
    {LibFunc_msvc_new_int,                      {OpNewLike,        1,  0, -1, -1, MallocFamily::MSVCNew}},            // new(unsigned int)
    {LibFunc_msvc_new_int_nothrow,              {MallocLike,       2,  0, -1, -1, MallocFamily::MSVCNew}},            // new(unsigned int, nothrow)
    {LibFunc_msvc_new_longlong,                 {OpNewLike,        1,  0, -1, -1, MallocFamily::MSVCNew}},            // new(unsigned long long)
    {LibFunc_msvc_new_longlong_nothrow,         {MallocLike,       2,  0, -1, -1, MallocFamily::MSVCNew}},            // new(unsigned long long, nothrow)
    {LibFunc_msvc_new_array_int,                {OpNewLike,        1,  0, -1, -1, MallocFamily::MSVCArrayNew}},       // new[](unsigned int)
    {LibFunc_msvc_new_array_int_nothrow,        {MallocLike,       2,  0, -1, -1, MallocFamily::MSVCArrayNew}},       // new[](unsigned int, nothrow)
    {LibFunc_msvc_new_array_longlong,           {OpNewLike,        1,  0, -1, -1, MallocFamily::MSVCArrayNew}},       // new[](unsigned long long)
    {LibFunc_msvc_new_array_longlong_nothrow,   {MallocLike,       2,  0, -1, -1, MallocFamily::MSVCArrayNew}},       // new[](unsigned long long, nothrow)
    {LibFunc_memalign,                          {AlignedAllocLike, 2,  1, -1,  0, MallocFamily::Malloc}},
    {LibFunc_vec_calloc,                        {CallocLike,       2,  0,  1, -1, MallocFamily::VecMalloc}},
    {LibFunc_vec_realloc,                       {ReallocLike,      2,  1, -1, -1, MallocFamily::VecMalloc}},
    {LibFunc_strdup,                            {StrDupLike,       1, -1, -1, -1, MallocFamily::Malloc}},
    {LibFunc_dunder_strdup,                     {StrDupLike,       1, -1, -1, -1, MallocFamily::Malloc}},
    {LibFunc_strndup,                           {StrDupLike,       2,  1, -1, -1, MallocFamily::Malloc}},
    {LibFunc_dunder_strndup,                    {StrDupLike,       2,  1, -1, -1, MallocFamily::Malloc}},
    {LibFunc___kmpc_alloc_shared,               {MallocLike,       1,  0, -1, -1, MallocFamily::KmpcAllocShared}},
};
// clang-format on

static const Function *getCalledFunction(const Value *V,
                                         bool &IsNoBuiltin) {
  // Don't care about intrinsics in this case.
  if (isa<IntrinsicInst>(V))
    return nullptr;

  const auto *CB = dyn_cast<CallBase>(V);
  if (!CB)
    return nullptr;

  IsNoBuiltin = CB->isNoBuiltin();

  if (const Function *Callee = CB->getCalledFunction())
    return Callee;
  return nullptr;
}

/// Returns the allocation data for the given value if it's a call to a known
/// allocation function.
static Optional<AllocFnsTy>
getAllocationDataForFunction(const Function *Callee, AllocType AllocTy,
                             const TargetLibraryInfo *TLI) {
  // Don't perform a slow TLI lookup, if this function doesn't return a pointer
  // and thus can't be an allocation function.
  if (!Callee->getReturnType()->isPointerTy())
    return None;

  // Make sure that the function is available.
  LibFunc TLIFn;
  if (!TLI || !TLI->getLibFunc(*Callee, TLIFn) || !TLI->has(TLIFn))
    return None;

  const auto *Iter = find_if(
      AllocationFnData, [TLIFn](const std::pair<LibFunc, AllocFnsTy> &P) {
        return P.first == TLIFn;
      });

  if (Iter == std::end(AllocationFnData))
    return None;

  const AllocFnsTy *FnData = &Iter->second;
  if ((FnData->AllocTy & AllocTy) != FnData->AllocTy)
    return None;

  // Check function prototype.
  int FstParam = FnData->FstParam;
  int SndParam = FnData->SndParam;
  FunctionType *FTy = Callee->getFunctionType();

  if (FTy->getReturnType() == Type::getInt8PtrTy(FTy->getContext()) &&
      FTy->getNumParams() == FnData->NumParams &&
      (FstParam < 0 ||
       (FTy->getParamType(FstParam)->isIntegerTy(32) ||
        FTy->getParamType(FstParam)->isIntegerTy(64))) &&
      (SndParam < 0 ||
       FTy->getParamType(SndParam)->isIntegerTy(32) ||
       FTy->getParamType(SndParam)->isIntegerTy(64)))
    return *FnData;
  return None;
}

static Optional<AllocFnsTy> getAllocationData(const Value *V, AllocType AllocTy,
                                              const TargetLibraryInfo *TLI) {
  bool IsNoBuiltinCall;
  if (const Function *Callee = getCalledFunction(V, IsNoBuiltinCall))
    if (!IsNoBuiltinCall)
      return getAllocationDataForFunction(Callee, AllocTy, TLI);
  return None;
}

static Optional<AllocFnsTy>
getAllocationData(const Value *V, AllocType AllocTy,
                  function_ref<const TargetLibraryInfo &(Function &)> GetTLI) {
  bool IsNoBuiltinCall;
  if (const Function *Callee = getCalledFunction(V, IsNoBuiltinCall))
    if (!IsNoBuiltinCall)
      return getAllocationDataForFunction(
          Callee, AllocTy, &GetTLI(const_cast<Function &>(*Callee)));
  return None;
}

static Optional<AllocFnsTy> getAllocationSize(const Value *V,
                                              const TargetLibraryInfo *TLI) {
  bool IsNoBuiltinCall;
  const Function *Callee =
      getCalledFunction(V, IsNoBuiltinCall);
  if (!Callee)
    return None;

  // Prefer to use existing information over allocsize. This will give us an
  // accurate AllocTy.
  if (!IsNoBuiltinCall)
    if (Optional<AllocFnsTy> Data =
            getAllocationDataForFunction(Callee, AnyAlloc, TLI))
      return Data;

  Attribute Attr = Callee->getFnAttribute(Attribute::AllocSize);
  if (Attr == Attribute())
    return None;

  std::pair<unsigned, Optional<unsigned>> Args = Attr.getAllocSizeArgs();

  AllocFnsTy Result;
  // Because allocsize only tells us how many bytes are allocated, we're not
  // really allowed to assume anything, so we use MallocLike.
  Result.AllocTy = MallocLike;
  Result.NumParams = Callee->getNumOperands();
  Result.FstParam = Args.first;
  Result.SndParam = Args.second.value_or(-1);
  // Allocsize has no way to specify an alignment argument
  Result.AlignParam = -1;
  return Result;
}

static AllocFnKind getAllocFnKind(const Value *V) {
  if (const auto *CB = dyn_cast<CallBase>(V)) {
    Attribute Attr = CB->getFnAttr(Attribute::AllocKind);
    if (Attr.isValid())
      return AllocFnKind(Attr.getValueAsInt());
  }
  return AllocFnKind::Unknown;
}

static AllocFnKind getAllocFnKind(const Function *F) {
  Attribute Attr = F->getFnAttribute(Attribute::AllocKind);
  if (Attr.isValid())
    return AllocFnKind(Attr.getValueAsInt());
  return AllocFnKind::Unknown;
}

static bool checkFnAllocKind(const Value *V, AllocFnKind Wanted) {
  return (getAllocFnKind(V) & Wanted) != AllocFnKind::Unknown;
}

static bool checkFnAllocKind(const Function *F, AllocFnKind Wanted) {
  return (getAllocFnKind(F) & Wanted) != AllocFnKind::Unknown;
}

/// Tests if a value is a call or invoke to a library function that
/// allocates or reallocates memory (either malloc, calloc, realloc, or strdup
/// like).
bool llvm::isAllocationFn(const Value *V, const TargetLibraryInfo *TLI) {
  return getAllocationData(V, AnyAlloc, TLI).has_value() ||
         checkFnAllocKind(V, AllocFnKind::Alloc | AllocFnKind::Realloc);
}
bool llvm::isAllocationFn(
    const Value *V,
    function_ref<const TargetLibraryInfo &(Function &)> GetTLI) {
  return getAllocationData(V, AnyAlloc, GetTLI).has_value() ||
         checkFnAllocKind(V, AllocFnKind::Alloc | AllocFnKind::Realloc);
}

/// Tests if a value is a call or invoke to a library function that
/// allocates uninitialized memory (such as malloc).
static bool isMallocLikeFn(const Value *V, const TargetLibraryInfo *TLI) {
  return getAllocationData(V, MallocOrOpNewLike, TLI).has_value();
}

/// Tests if a value is a call or invoke to a library function that
/// allocates uninitialized memory with alignment (such as aligned_alloc).
static bool isAlignedAllocLikeFn(const Value *V, const TargetLibraryInfo *TLI) {
  return getAllocationData(V, AlignedAllocLike, TLI).has_value();
}

/// Tests if a value is a call or invoke to a library function that
/// allocates zero-filled memory (such as calloc).
static bool isCallocLikeFn(const Value *V, const TargetLibraryInfo *TLI) {
  return getAllocationData(V, CallocLike, TLI).has_value();
}

/// Tests if a value is a call or invoke to a library function that
/// allocates memory similar to malloc or calloc.
bool llvm::isMallocOrCallocLikeFn(const Value *V, const TargetLibraryInfo *TLI) {
  return getAllocationData(V, MallocOrCallocLike, TLI).has_value();
}

/// Tests if a value is a call or invoke to a library function that
/// allocates memory (either malloc, calloc, or strdup like).
bool llvm::isAllocLikeFn(const Value *V, const TargetLibraryInfo *TLI) {
  return getAllocationData(V, AllocLike, TLI).has_value() ||
         checkFnAllocKind(V, AllocFnKind::Alloc);
}

/// Tests if a functions is a call or invoke to a library function that
/// reallocates memory (e.g., realloc).
bool llvm::isReallocLikeFn(const Function *F, const TargetLibraryInfo *TLI) {
  return getAllocationDataForFunction(F, ReallocLike, TLI).has_value() ||
         checkFnAllocKind(F, AllocFnKind::Realloc);
}

Value *llvm::getReallocatedOperand(const CallBase *CB,
                                   const TargetLibraryInfo *TLI) {
  if (getAllocationData(CB, ReallocLike, TLI).has_value()) {
    // All currently supported realloc functions reallocate the first argument.
    return CB->getArgOperand(0);
  }
  if (checkFnAllocKind(CB, AllocFnKind::Realloc))
    return CB->getArgOperandWithAttribute(Attribute::AllocatedPointer);
  return nullptr;
}

bool llvm::isRemovableAlloc(const CallBase *CB, const TargetLibraryInfo *TLI) {
  // Note: Removability is highly dependent on the source language.  For
  // example, recent C++ requires direct calls to the global allocation
  // [basic.stc.dynamic.allocation] to be observable unless part of a new
  // expression [expr.new paragraph 13].

  // Historically we've treated the C family allocation routines and operator
  // new as removable
  return isAllocLikeFn(CB, TLI);
}

Value *llvm::getAllocAlignment(const CallBase *V,
                               const TargetLibraryInfo *TLI) {
  const Optional<AllocFnsTy> FnData = getAllocationData(V, AnyAlloc, TLI);
  if (FnData && FnData->AlignParam >= 0) {
    return V->getOperand(FnData->AlignParam);
  }
  return V->getArgOperandWithAttribute(Attribute::AllocAlign);
}

/// When we're compiling N-bit code, and the user uses parameters that are
/// greater than N bits (e.g. uint64_t on a 32-bit build), we can run into
/// trouble with APInt size issues. This function handles resizing + overflow
/// checks for us. Check and zext or trunc \p I depending on IntTyBits and
/// I's value.
static bool CheckedZextOrTrunc(APInt &I, unsigned IntTyBits) {
  // More bits than we can handle. Checking the bit width isn't necessary, but
  // it's faster than checking active bits, and should give `false` in the
  // vast majority of cases.
  if (I.getBitWidth() > IntTyBits && I.getActiveBits() > IntTyBits)
    return false;
  if (I.getBitWidth() != IntTyBits)
    I = I.zextOrTrunc(IntTyBits);
  return true;
}

Optional<APInt>
llvm::getAllocSize(const CallBase *CB, const TargetLibraryInfo *TLI,
                   function_ref<const Value *(const Value *)> Mapper) {
  // Note: This handles both explicitly listed allocation functions and
  // allocsize.  The code structure could stand to be cleaned up a bit.
  Optional<AllocFnsTy> FnData = getAllocationSize(CB, TLI);
  if (!FnData)
    return None;

  // Get the index type for this address space, results and intermediate
  // computations are performed at that width.
  auto &DL = CB->getModule()->getDataLayout();
  const unsigned IntTyBits = DL.getIndexTypeSizeInBits(CB->getType());

  // Handle strdup-like functions separately.
  if (FnData->AllocTy == StrDupLike) {
    APInt Size(IntTyBits, GetStringLength(Mapper(CB->getArgOperand(0))));
    if (!Size)
      return None;

    // Strndup limits strlen.
    if (FnData->FstParam > 0) {
      const ConstantInt *Arg =
        dyn_cast<ConstantInt>(Mapper(CB->getArgOperand(FnData->FstParam)));
      if (!Arg)
        return None;

      APInt MaxSize = Arg->getValue().zext(IntTyBits);
      if (Size.ugt(MaxSize))
        Size = MaxSize + 1;
    }
    return Size;
  }

  const ConstantInt *Arg =
    dyn_cast<ConstantInt>(Mapper(CB->getArgOperand(FnData->FstParam)));
  if (!Arg)
    return None;

  APInt Size = Arg->getValue();
  if (!CheckedZextOrTrunc(Size, IntTyBits))
    return None;

  // Size is determined by just 1 parameter.
  if (FnData->SndParam < 0)
    return Size;

  Arg = dyn_cast<ConstantInt>(Mapper(CB->getArgOperand(FnData->SndParam)));
  if (!Arg)
    return None;

  APInt NumElems = Arg->getValue();
  if (!CheckedZextOrTrunc(NumElems, IntTyBits))
    return None;

  bool Overflow;
  Size = Size.umul_ov(NumElems, Overflow);
  if (Overflow)
    return None;
  return Size;
}

Constant *llvm::getInitialValueOfAllocation(const Value *V,
                                            const TargetLibraryInfo *TLI,
                                            Type *Ty) {
  auto *Alloc = dyn_cast<CallBase>(V);
  if (!Alloc)
    return nullptr;

  // malloc and aligned_alloc are uninitialized (undef)
  if (isMallocLikeFn(Alloc, TLI) || isAlignedAllocLikeFn(Alloc, TLI))
    return UndefValue::get(Ty);

  // calloc zero initializes
  if (isCallocLikeFn(Alloc, TLI))
    return Constant::getNullValue(Ty);

  AllocFnKind AK = getAllocFnKind(Alloc);
  if ((AK & AllocFnKind::Uninitialized) != AllocFnKind::Unknown)
    return UndefValue::get(Ty);
  if ((AK & AllocFnKind::Zeroed) != AllocFnKind::Unknown)
    return Constant::getNullValue(Ty);

  return nullptr;
}

struct FreeFnsTy {
  unsigned NumParams;
  // Name of default allocator function to group malloc/free calls by family
  MallocFamily Family;
};

// clang-format off
static const std::pair<LibFunc, FreeFnsTy> FreeFnData[] = {
    {LibFunc_vec_free,                           {1, MallocFamily::VecMalloc}},
    {LibFunc_ZdlPv,                              {1, MallocFamily::CPPNew}},             // operator delete(void*)
    {LibFunc_ZdaPv,                              {1, MallocFamily::CPPNewArray}},        // operator delete[](void*)
    {LibFunc_msvc_delete_ptr32,                  {1, MallocFamily::MSVCNew}},            // operator delete(void*)
    {LibFunc_msvc_delete_ptr64,                  {1, MallocFamily::MSVCNew}},            // operator delete(void*)
    {LibFunc_msvc_delete_array_ptr32,            {1, MallocFamily::MSVCArrayNew}},       // operator delete[](void*)
    {LibFunc_msvc_delete_array_ptr64,            {1, MallocFamily::MSVCArrayNew}},       // operator delete[](void*)
    {LibFunc_ZdlPvj,                             {2, MallocFamily::CPPNew}},             // delete(void*, uint)
    {LibFunc_ZdlPvm,                             {2, MallocFamily::CPPNew}},             // delete(void*, ulong)
    {LibFunc_ZdlPvRKSt9nothrow_t,                {2, MallocFamily::CPPNew}},             // delete(void*, nothrow)
    {LibFunc_ZdlPvSt11align_val_t,               {2, MallocFamily::CPPNewAligned}},      // delete(void*, align_val_t)
    {LibFunc_ZdaPvj,                             {2, MallocFamily::CPPNewArray}},        // delete[](void*, uint)
    {LibFunc_ZdaPvm,                             {2, MallocFamily::CPPNewArray}},        // delete[](void*, ulong)
    {LibFunc_ZdaPvRKSt9nothrow_t,                {2, MallocFamily::CPPNewArray}},        // delete[](void*, nothrow)
    {LibFunc_ZdaPvSt11align_val_t,               {2, MallocFamily::CPPNewArrayAligned}}, // delete[](void*, align_val_t)
    {LibFunc_msvc_delete_ptr32_int,              {2, MallocFamily::MSVCNew}},            // delete(void*, uint)
    {LibFunc_msvc_delete_ptr64_longlong,         {2, MallocFamily::MSVCNew}},            // delete(void*, ulonglong)
    {LibFunc_msvc_delete_ptr32_nothrow,          {2, MallocFamily::MSVCNew}},            // delete(void*, nothrow)
    {LibFunc_msvc_delete_ptr64_nothrow,          {2, MallocFamily::MSVCNew}},            // delete(void*, nothrow)
    {LibFunc_msvc_delete_array_ptr32_int,        {2, MallocFamily::MSVCArrayNew}},       // delete[](void*, uint)
    {LibFunc_msvc_delete_array_ptr64_longlong,   {2, MallocFamily::MSVCArrayNew}},       // delete[](void*, ulonglong)
    {LibFunc_msvc_delete_array_ptr32_nothrow,    {2, MallocFamily::MSVCArrayNew}},       // delete[](void*, nothrow)
    {LibFunc_msvc_delete_array_ptr64_nothrow,    {2, MallocFamily::MSVCArrayNew}},       // delete[](void*, nothrow)
    {LibFunc___kmpc_free_shared,                 {2, MallocFamily::KmpcAllocShared}},    // OpenMP Offloading RTL free
    {LibFunc_ZdlPvSt11align_val_tRKSt9nothrow_t, {3, MallocFamily::CPPNewAligned}},      // delete(void*, align_val_t, nothrow)
    {LibFunc_ZdaPvSt11align_val_tRKSt9nothrow_t, {3, MallocFamily::CPPNewArrayAligned}}, // delete[](void*, align_val_t, nothrow)
    {LibFunc_ZdlPvjSt11align_val_t,              {3, MallocFamily::CPPNewAligned}},      // delete(void*, unsigned int, align_val_t)
    {LibFunc_ZdlPvmSt11align_val_t,              {3, MallocFamily::CPPNewAligned}},      // delete(void*, unsigned long, align_val_t)
    {LibFunc_ZdaPvjSt11align_val_t,              {3, MallocFamily::CPPNewArrayAligned}}, // delete[](void*, unsigned int, align_val_t)
    {LibFunc_ZdaPvmSt11align_val_t,              {3, MallocFamily::CPPNewArrayAligned}}, // delete[](void*, unsigned long, align_val_t)
};
// clang-format on

Optional<FreeFnsTy> getFreeFunctionDataForFunction(const Function *Callee,
                                                   const LibFunc TLIFn) {
  const auto *Iter =
      find_if(FreeFnData, [TLIFn](const std::pair<LibFunc, FreeFnsTy> &P) {
        return P.first == TLIFn;
      });
  if (Iter == std::end(FreeFnData))
    return None;
  return Iter->second;
}

Optional<StringRef> llvm::getAllocationFamily(const Value *I,
                                              const TargetLibraryInfo *TLI) {
  bool IsNoBuiltin;
  const Function *Callee = getCalledFunction(I, IsNoBuiltin);
  if (Callee == nullptr || IsNoBuiltin)
    return None;
  LibFunc TLIFn;

  if (TLI && TLI->getLibFunc(*Callee, TLIFn) && TLI->has(TLIFn)) {
    // Callee is some known library function.
    const auto AllocData = getAllocationDataForFunction(Callee, AnyAlloc, TLI);
    if (AllocData)
      return mangledNameForMallocFamily(AllocData.value().Family);
    const auto FreeData = getFreeFunctionDataForFunction(Callee, TLIFn);
    if (FreeData)
      return mangledNameForMallocFamily(FreeData.value().Family);
  }
  // Callee isn't a known library function, still check attributes.
  if (checkFnAllocKind(I, AllocFnKind::Free | AllocFnKind::Alloc |
                              AllocFnKind::Realloc)) {
    Attribute Attr = cast<CallBase>(I)->getFnAttr("alloc-family");
    if (Attr.isValid())
      return Attr.getValueAsString();
  }
  return None;
}

/// isLibFreeFunction - Returns true if the function is a builtin free()
bool llvm::isLibFreeFunction(const Function *F, const LibFunc TLIFn) {
  Optional<FreeFnsTy> FnData = getFreeFunctionDataForFunction(F, TLIFn);
  if (!FnData)
    return checkFnAllocKind(F, AllocFnKind::Free);

  // Check free prototype.
  // FIXME: workaround for PR5130, this will be obsolete when a nobuiltin
  // attribute will exist.
  FunctionType *FTy = F->getFunctionType();
  if (!FTy->getReturnType()->isVoidTy())
    return false;
  if (FTy->getNumParams() != FnData->NumParams)
    return false;
  if (FTy->getParamType(0) != Type::getInt8PtrTy(F->getContext()))
    return false;

  return true;
}

Value *llvm::getFreedOperand(const CallBase *CB, const TargetLibraryInfo *TLI) {
  bool IsNoBuiltinCall;
  const Function *Callee = getCalledFunction(CB, IsNoBuiltinCall);
  if (Callee == nullptr || IsNoBuiltinCall)
    return nullptr;

  LibFunc TLIFn;
  if (TLI && TLI->getLibFunc(*Callee, TLIFn) && TLI->has(TLIFn) &&
      isLibFreeFunction(Callee, TLIFn)) {
    // All currently supported free functions free the first argument.
    return CB->getArgOperand(0);
  }

  if (checkFnAllocKind(CB, AllocFnKind::Free))
    return CB->getArgOperandWithAttribute(Attribute::AllocatedPointer);

  return nullptr;
}

//===----------------------------------------------------------------------===//
//  Utility functions to compute size of objects.
//
static APInt getSizeWithOverflow(const SizeOffsetType &Data) {
  if (Data.second.isNegative() || Data.first.ult(Data.second))
    return APInt(Data.first.getBitWidth(), 0);
  return Data.first - Data.second;
}

/// Compute the size of the object pointed by Ptr. Returns true and the
/// object size in Size if successful, and false otherwise.
/// If RoundToAlign is true, then Size is rounded up to the alignment of
/// allocas, byval arguments, and global variables.
bool llvm::getObjectSize(const Value *Ptr, uint64_t &Size, const DataLayout &DL,
                         const TargetLibraryInfo *TLI, ObjectSizeOpts Opts) {
  ObjectSizeOffsetVisitor Visitor(DL, TLI, Ptr->getContext(), Opts);
  SizeOffsetType Data = Visitor.compute(const_cast<Value*>(Ptr));
  if (!Visitor.bothKnown(Data))
    return false;

  Size = getSizeWithOverflow(Data).getZExtValue();
  return true;
}

Value *llvm::lowerObjectSizeCall(IntrinsicInst *ObjectSize,
                                 const DataLayout &DL,
                                 const TargetLibraryInfo *TLI,
                                 bool MustSucceed) {
  return lowerObjectSizeCall(ObjectSize, DL, TLI, /*AAResults=*/nullptr,
                             MustSucceed);
}

Value *llvm::lowerObjectSizeCall(IntrinsicInst *ObjectSize,
                                 const DataLayout &DL,
                                 const TargetLibraryInfo *TLI, AAResults *AA,
                                 bool MustSucceed) {
  assert(ObjectSize->getIntrinsicID() == Intrinsic::objectsize &&
         "ObjectSize must be a call to llvm.objectsize!");

  bool MaxVal = cast<ConstantInt>(ObjectSize->getArgOperand(1))->isZero();
  ObjectSizeOpts EvalOptions;
  EvalOptions.AA = AA;

  // Unless we have to fold this to something, try to be as accurate as
  // possible.
  if (MustSucceed)
    EvalOptions.EvalMode =
        MaxVal ? ObjectSizeOpts::Mode::Max : ObjectSizeOpts::Mode::Min;
  else
    EvalOptions.EvalMode = ObjectSizeOpts::Mode::ExactSizeFromOffset;

  EvalOptions.NullIsUnknownSize =
      cast<ConstantInt>(ObjectSize->getArgOperand(2))->isOne();

  auto *ResultType = cast<IntegerType>(ObjectSize->getType());
  bool StaticOnly = cast<ConstantInt>(ObjectSize->getArgOperand(3))->isZero();
  if (StaticOnly) {
    // FIXME: Does it make sense to just return a failure value if the size won't
    // fit in the output and `!MustSucceed`?
    uint64_t Size;
    if (getObjectSize(ObjectSize->getArgOperand(0), Size, DL, TLI, EvalOptions) &&
        isUIntN(ResultType->getBitWidth(), Size))
      return ConstantInt::get(ResultType, Size);
  } else {
    LLVMContext &Ctx = ObjectSize->getFunction()->getContext();
    ObjectSizeOffsetEvaluator Eval(DL, TLI, Ctx, EvalOptions);
    SizeOffsetEvalType SizeOffsetPair =
        Eval.compute(ObjectSize->getArgOperand(0));

    if (SizeOffsetPair != ObjectSizeOffsetEvaluator::unknown()) {
      IRBuilder<TargetFolder> Builder(Ctx, TargetFolder(DL));
      Builder.SetInsertPoint(ObjectSize);

      // If we've outside the end of the object, then we can always access
      // exactly 0 bytes.
      Value *ResultSize =
          Builder.CreateSub(SizeOffsetPair.first, SizeOffsetPair.second);
      Value *UseZero =
          Builder.CreateICmpULT(SizeOffsetPair.first, SizeOffsetPair.second);
      ResultSize = Builder.CreateZExtOrTrunc(ResultSize, ResultType);
      Value *Ret = Builder.CreateSelect(
          UseZero, ConstantInt::get(ResultType, 0), ResultSize);

      // The non-constant size expression cannot evaluate to -1.
      if (!isa<Constant>(SizeOffsetPair.first) ||
          !isa<Constant>(SizeOffsetPair.second))
        Builder.CreateAssumption(
            Builder.CreateICmpNE(Ret, ConstantInt::get(ResultType, -1)));

      return Ret;
    }
  }

  if (!MustSucceed)
    return nullptr;

  return ConstantInt::get(ResultType, MaxVal ? -1ULL : 0);
}

STATISTIC(ObjectVisitorArgument,
          "Number of arguments with unsolved size and offset");
STATISTIC(ObjectVisitorLoad,
          "Number of load instructions with unsolved size and offset");

APInt ObjectSizeOffsetVisitor::align(APInt Size, MaybeAlign Alignment) {
  if (Options.RoundToAlign && Alignment)
    return APInt(IntTyBits, alignTo(Size.getZExtValue(), *Alignment));
  return Size;
}

ObjectSizeOffsetVisitor::ObjectSizeOffsetVisitor(const DataLayout &DL,
                                                 const TargetLibraryInfo *TLI,
                                                 LLVMContext &Context,
                                                 ObjectSizeOpts Options)
    : DL(DL), TLI(TLI), Options(Options) {
  // Pointer size must be rechecked for each object visited since it could have
  // a different address space.
}

SizeOffsetType ObjectSizeOffsetVisitor::compute(Value *V) {
  unsigned InitialIntTyBits = DL.getIndexTypeSizeInBits(V->getType());

  // Stripping pointer casts can strip address space casts which can change the
  // index type size. The invariant is that we use the value type to determine
  // the index type size and if we stripped address space casts we have to
  // readjust the APInt as we pass it upwards in order for the APInt to match
  // the type the caller passed in.
  APInt Offset(InitialIntTyBits, 0);
  V = V->stripAndAccumulateConstantOffsets(
      DL, Offset, /* AllowNonInbounds */ true, /* AllowInvariantGroup */ true);

  // Later we use the index type size and zero but it will match the type of the
  // value that is passed to computeImpl.
  IntTyBits = DL.getIndexTypeSizeInBits(V->getType());
  Zero = APInt::getZero(IntTyBits);

  bool IndexTypeSizeChanged = InitialIntTyBits != IntTyBits;
  if (!IndexTypeSizeChanged && Offset.isZero())
    return computeImpl(V);

  // We stripped an address space cast that changed the index type size or we
  // accumulated some constant offset (or both). Readjust the bit width to match
  // the argument index type size and apply the offset, as required.
  SizeOffsetType SOT = computeImpl(V);
  if (IndexTypeSizeChanged) {
    if (knownSize(SOT) && !::CheckedZextOrTrunc(SOT.first, InitialIntTyBits))
      SOT.first = APInt();
    if (knownOffset(SOT) && !::CheckedZextOrTrunc(SOT.second, InitialIntTyBits))
      SOT.second = APInt();
  }
  // If the computed offset is "unknown" we cannot add the stripped offset.
  return {SOT.first,
          SOT.second.getBitWidth() > 1 ? SOT.second + Offset : SOT.second};
}

SizeOffsetType ObjectSizeOffsetVisitor::computeImpl(Value *V) {
  if (Instruction *I = dyn_cast<Instruction>(V)) {
    // If we have already seen this instruction, bail out. Cycles can happen in
    // unreachable code after constant propagation.
    if (!SeenInsts.insert(I).second)
      return unknown();

    return visit(*I);
  }
  if (Argument *A = dyn_cast<Argument>(V))
    return visitArgument(*A);
  if (ConstantPointerNull *P = dyn_cast<ConstantPointerNull>(V))
    return visitConstantPointerNull(*P);
  if (GlobalAlias *GA = dyn_cast<GlobalAlias>(V))
    return visitGlobalAlias(*GA);
  if (GlobalVariable *GV = dyn_cast<GlobalVariable>(V))
    return visitGlobalVariable(*GV);
  if (UndefValue *UV = dyn_cast<UndefValue>(V))
    return visitUndefValue(*UV);

  LLVM_DEBUG(dbgs() << "ObjectSizeOffsetVisitor::compute() unhandled value: "
                    << *V << '\n');
  return unknown();
}

bool ObjectSizeOffsetVisitor::CheckedZextOrTrunc(APInt &I) {
  return ::CheckedZextOrTrunc(I, IntTyBits);
}

SizeOffsetType ObjectSizeOffsetVisitor::visitAllocaInst(AllocaInst &I) {
  if (!I.getAllocatedType()->isSized())
    return unknown();

  TypeSize ElemSize = DL.getTypeAllocSize(I.getAllocatedType());
  if (ElemSize.isScalable() && Options.EvalMode != ObjectSizeOpts::Mode::Min)
    return unknown();
  APInt Size(IntTyBits, ElemSize.getKnownMinSize());
  if (!I.isArrayAllocation())
    return std::make_pair(align(Size, I.getAlign()), Zero);

  Value *ArraySize = I.getArraySize();
  if (const ConstantInt *C = dyn_cast<ConstantInt>(ArraySize)) {
    APInt NumElems = C->getValue();
    if (!CheckedZextOrTrunc(NumElems))
      return unknown();

    bool Overflow;
    Size = Size.umul_ov(NumElems, Overflow);
    return Overflow ? unknown()
                    : std::make_pair(align(Size, I.getAlign()), Zero);
  }
  return unknown();
}

SizeOffsetType ObjectSizeOffsetVisitor::visitArgument(Argument &A) {
  Type *MemoryTy = A.getPointeeInMemoryValueType();
  // No interprocedural analysis is done at the moment.
  if (!MemoryTy|| !MemoryTy->isSized()) {
    ++ObjectVisitorArgument;
    return unknown();
  }

  APInt Size(IntTyBits, DL.getTypeAllocSize(MemoryTy));
  return std::make_pair(align(Size, A.getParamAlign()), Zero);
}

SizeOffsetType ObjectSizeOffsetVisitor::visitCallBase(CallBase &CB) {
  if (Optional<APInt> Size = getAllocSize(&CB, TLI))
    return std::make_pair(*Size, Zero);
  return unknown();
}

SizeOffsetType
ObjectSizeOffsetVisitor::visitConstantPointerNull(ConstantPointerNull& CPN) {
  // If null is unknown, there's nothing we can do. Additionally, non-zero
  // address spaces can make use of null, so we don't presume to know anything
  // about that.
  //
  // TODO: How should this work with address space casts? We currently just drop
  // them on the floor, but it's unclear what we should do when a NULL from
  // addrspace(1) gets casted to addrspace(0) (or vice-versa).
  if (Options.NullIsUnknownSize || CPN.getType()->getAddressSpace())
    return unknown();
  return std::make_pair(Zero, Zero);
}

SizeOffsetType
ObjectSizeOffsetVisitor::visitExtractElementInst(ExtractElementInst&) {
  return unknown();
}

SizeOffsetType
ObjectSizeOffsetVisitor::visitExtractValueInst(ExtractValueInst&) {
  // Easy cases were already folded by previous passes.
  return unknown();
}

SizeOffsetType ObjectSizeOffsetVisitor::visitGlobalAlias(GlobalAlias &GA) {
  if (GA.isInterposable())
    return unknown();
  return compute(GA.getAliasee());
}

SizeOffsetType ObjectSizeOffsetVisitor::visitGlobalVariable(GlobalVariable &GV){
  if (!GV.hasDefinitiveInitializer())
    return unknown();

  APInt Size(IntTyBits, DL.getTypeAllocSize(GV.getValueType()));
  return std::make_pair(align(Size, GV.getAlign()), Zero);
}

SizeOffsetType ObjectSizeOffsetVisitor::visitIntToPtrInst(IntToPtrInst&) {
  // clueless
  return unknown();
}

SizeOffsetType ObjectSizeOffsetVisitor::findLoadSizeOffset(
    LoadInst &Load, BasicBlock &BB, BasicBlock::iterator From,
    SmallDenseMap<BasicBlock *, SizeOffsetType, 8> &VisitedBlocks,
    unsigned &ScannedInstCount) {
  constexpr unsigned MaxInstsToScan = 128;

  auto Where = VisitedBlocks.find(&BB);
  if (Where != VisitedBlocks.end())
    return Where->second;

  auto Unknown = [this, &BB, &VisitedBlocks]() {
    return VisitedBlocks[&BB] = unknown();
  };
  auto Known = [&BB, &VisitedBlocks](SizeOffsetType SO) {
    return VisitedBlocks[&BB] = SO;
  };

  do {
    Instruction &I = *From;

    if (I.isDebugOrPseudoInst())
      continue;

    if (++ScannedInstCount > MaxInstsToScan)
      return Unknown();

    if (!I.mayWriteToMemory())
      continue;

    if (auto *SI = dyn_cast<StoreInst>(&I)) {
      AliasResult AR =
          Options.AA->alias(SI->getPointerOperand(), Load.getPointerOperand());
      switch ((AliasResult::Kind)AR) {
      case AliasResult::NoAlias:
        continue;
      case AliasResult::MustAlias:
        if (SI->getValueOperand()->getType()->isPointerTy())
          return Known(compute(SI->getValueOperand()));
        else
          return Unknown(); // No handling of non-pointer values by `compute`.
      default:
        return Unknown();
      }
    }

    if (auto *CB = dyn_cast<CallBase>(&I)) {
      Function *Callee = CB->getCalledFunction();
      // Bail out on indirect call.
      if (!Callee)
        return Unknown();

      LibFunc TLIFn;
      if (!TLI || !TLI->getLibFunc(*CB->getCalledFunction(), TLIFn) ||
          !TLI->has(TLIFn))
        return Unknown();

      // TODO: There's probably more interesting case to support here.
      if (TLIFn != LibFunc_posix_memalign)
        return Unknown();

      AliasResult AR =
          Options.AA->alias(CB->getOperand(0), Load.getPointerOperand());
      switch ((AliasResult::Kind)AR) {
      case AliasResult::NoAlias:
        continue;
      case AliasResult::MustAlias:
        break;
      default:
        return Unknown();
      }

      // Is the error status of posix_memalign correctly checked? If not it
      // would be incorrect to assume it succeeds and load doesn't see the
      // previous value.
      Optional<bool> Checked = isImpliedByDomCondition(
          ICmpInst::ICMP_EQ, CB, ConstantInt::get(CB->getType(), 0), &Load, DL);
      if (!Checked || !*Checked)
        return Unknown();

      Value *Size = CB->getOperand(2);
      auto *C = dyn_cast<ConstantInt>(Size);
      if (!C)
        return Unknown();

      return Known({C->getValue(), APInt(C->getValue().getBitWidth(), 0)});
    }

    return Unknown();
  } while (From-- != BB.begin());

  SmallVector<SizeOffsetType> PredecessorSizeOffsets;
  for (auto *PredBB : predecessors(&BB)) {
    PredecessorSizeOffsets.push_back(findLoadSizeOffset(
        Load, *PredBB, BasicBlock::iterator(PredBB->getTerminator()),
        VisitedBlocks, ScannedInstCount));
    if (!bothKnown(PredecessorSizeOffsets.back()))
      return Unknown();
  }

  if (PredecessorSizeOffsets.empty())
    return Unknown();

  return Known(std::accumulate(PredecessorSizeOffsets.begin() + 1,
                               PredecessorSizeOffsets.end(),
                               PredecessorSizeOffsets.front(),
                               [this](SizeOffsetType LHS, SizeOffsetType RHS) {
                                 return combineSizeOffset(LHS, RHS);
                               }));
}

SizeOffsetType ObjectSizeOffsetVisitor::visitLoadInst(LoadInst &LI) {
  if (!Options.AA) {
    ++ObjectVisitorLoad;
    return unknown();
  }

  SmallDenseMap<BasicBlock *, SizeOffsetType, 8> VisitedBlocks;
  unsigned ScannedInstCount = 0;
  SizeOffsetType SO =
      findLoadSizeOffset(LI, *LI.getParent(), BasicBlock::iterator(LI),
                         VisitedBlocks, ScannedInstCount);
  if (!bothKnown(SO))
    ++ObjectVisitorLoad;
  return SO;
}

SizeOffsetType ObjectSizeOffsetVisitor::combineSizeOffset(SizeOffsetType LHS,
                                                          SizeOffsetType RHS) {
  if (!bothKnown(LHS) || !bothKnown(RHS))
    return unknown();

  switch (Options.EvalMode) {
  case ObjectSizeOpts::Mode::Min:
    return (getSizeWithOverflow(LHS).slt(getSizeWithOverflow(RHS))) ? LHS : RHS;
  case ObjectSizeOpts::Mode::Max:
    return (getSizeWithOverflow(LHS).sgt(getSizeWithOverflow(RHS))) ? LHS : RHS;
  case ObjectSizeOpts::Mode::ExactSizeFromOffset:
    return (getSizeWithOverflow(LHS).eq(getSizeWithOverflow(RHS))) ? LHS
                                                                   : unknown();
  case ObjectSizeOpts::Mode::ExactUnderlyingSizeAndOffset:
    return LHS == RHS && LHS.second.eq(RHS.second) ? LHS : unknown();
  }
  llvm_unreachable("missing an eval mode");
}

SizeOffsetType ObjectSizeOffsetVisitor::visitPHINode(PHINode &PN) {
  auto IncomingValues = PN.incoming_values();
  return std::accumulate(IncomingValues.begin() + 1, IncomingValues.end(),
                         compute(*IncomingValues.begin()),
                         [this](SizeOffsetType LHS, Value *VRHS) {
                           return combineSizeOffset(LHS, compute(VRHS));
                         });
}

SizeOffsetType ObjectSizeOffsetVisitor::visitSelectInst(SelectInst &I) {
  return combineSizeOffset(compute(I.getTrueValue()),
                           compute(I.getFalseValue()));
}

SizeOffsetType ObjectSizeOffsetVisitor::visitUndefValue(UndefValue&) {
  return std::make_pair(Zero, Zero);
}

SizeOffsetType ObjectSizeOffsetVisitor::visitInstruction(Instruction &I) {
  LLVM_DEBUG(dbgs() << "ObjectSizeOffsetVisitor unknown instruction:" << I
                    << '\n');
  return unknown();
}

ObjectSizeOffsetEvaluator::ObjectSizeOffsetEvaluator(
    const DataLayout &DL, const TargetLibraryInfo *TLI, LLVMContext &Context,
    ObjectSizeOpts EvalOpts)
    : DL(DL), TLI(TLI), Context(Context),
      Builder(Context, TargetFolder(DL),
              IRBuilderCallbackInserter(
                  [&](Instruction *I) { InsertedInstructions.insert(I); })),
      EvalOpts(EvalOpts) {
  // IntTy and Zero must be set for each compute() since the address space may
  // be different for later objects.
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::compute(Value *V) {
  // XXX - Are vectors of pointers possible here?
  IntTy = cast<IntegerType>(DL.getIndexType(V->getType()));
  Zero = ConstantInt::get(IntTy, 0);

  SizeOffsetEvalType Result = compute_(V);

  if (!bothKnown(Result)) {
    // Erase everything that was computed in this iteration from the cache, so
    // that no dangling references are left behind. We could be a bit smarter if
    // we kept a dependency graph. It's probably not worth the complexity.
    for (const Value *SeenVal : SeenVals) {
      CacheMapTy::iterator CacheIt = CacheMap.find(SeenVal);
      // non-computable results can be safely cached
      if (CacheIt != CacheMap.end() && anyKnown(CacheIt->second))
        CacheMap.erase(CacheIt);
    }

    // Erase any instructions we inserted as part of the traversal.
    for (Instruction *I : InsertedInstructions) {
      I->replaceAllUsesWith(PoisonValue::get(I->getType()));
      I->eraseFromParent();
    }
  }

  SeenVals.clear();
  InsertedInstructions.clear();
  return Result;
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::compute_(Value *V) {
  ObjectSizeOffsetVisitor Visitor(DL, TLI, Context, EvalOpts);
  SizeOffsetType Const = Visitor.compute(V);
  if (Visitor.bothKnown(Const))
    return std::make_pair(ConstantInt::get(Context, Const.first),
                          ConstantInt::get(Context, Const.second));

  V = V->stripPointerCasts();

  // Check cache.
  CacheMapTy::iterator CacheIt = CacheMap.find(V);
  if (CacheIt != CacheMap.end())
    return CacheIt->second;

  // Always generate code immediately before the instruction being
  // processed, so that the generated code dominates the same BBs.
  BuilderTy::InsertPointGuard Guard(Builder);
  if (Instruction *I = dyn_cast<Instruction>(V))
    Builder.SetInsertPoint(I);

  // Now compute the size and offset.
  SizeOffsetEvalType Result;

  // Record the pointers that were handled in this run, so that they can be
  // cleaned later if something fails. We also use this set to break cycles that
  // can occur in dead code.
  if (!SeenVals.insert(V).second) {
    Result = unknown();
  } else if (GEPOperator *GEP = dyn_cast<GEPOperator>(V)) {
    Result = visitGEPOperator(*GEP);
  } else if (Instruction *I = dyn_cast<Instruction>(V)) {
    Result = visit(*I);
  } else if (isa<Argument>(V) ||
             (isa<ConstantExpr>(V) &&
              cast<ConstantExpr>(V)->getOpcode() == Instruction::IntToPtr) ||
             isa<GlobalAlias>(V) ||
             isa<GlobalVariable>(V)) {
    // Ignore values where we cannot do more than ObjectSizeVisitor.
    Result = unknown();
  } else {
    LLVM_DEBUG(
        dbgs() << "ObjectSizeOffsetEvaluator::compute() unhandled value: " << *V
               << '\n');
    Result = unknown();
  }

  // Don't reuse CacheIt since it may be invalid at this point.
  CacheMap[V] = Result;
  return Result;
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::visitAllocaInst(AllocaInst &I) {
  if (!I.getAllocatedType()->isSized())
    return unknown();

  // must be a VLA
  assert(I.isArrayAllocation());

  // If needed, adjust the alloca's operand size to match the pointer size.
  // Subsequent math operations expect the types to match.
  Value *ArraySize = Builder.CreateZExtOrTrunc(
      I.getArraySize(), DL.getIntPtrType(I.getContext()));
  assert(ArraySize->getType() == Zero->getType() &&
         "Expected zero constant to have pointer type");

  Value *Size = ConstantInt::get(ArraySize->getType(),
                                 DL.getTypeAllocSize(I.getAllocatedType()));
  Size = Builder.CreateMul(Size, ArraySize);
  return std::make_pair(Size, Zero);
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::visitCallBase(CallBase &CB) {
  Optional<AllocFnsTy> FnData = getAllocationSize(&CB, TLI);
  if (!FnData)
    return unknown();

  // Handle strdup-like functions separately.
  if (FnData->AllocTy == StrDupLike) {
    // TODO: implement evaluation of strdup/strndup
    return unknown();
  }

  Value *FirstArg = CB.getArgOperand(FnData->FstParam);
  FirstArg = Builder.CreateZExtOrTrunc(FirstArg, IntTy);
  if (FnData->SndParam < 0)
    return std::make_pair(FirstArg, Zero);

  Value *SecondArg = CB.getArgOperand(FnData->SndParam);
  SecondArg = Builder.CreateZExtOrTrunc(SecondArg, IntTy);
  Value *Size = Builder.CreateMul(FirstArg, SecondArg);
  return std::make_pair(Size, Zero);
}

SizeOffsetEvalType
ObjectSizeOffsetEvaluator::visitExtractElementInst(ExtractElementInst&) {
  return unknown();
}

SizeOffsetEvalType
ObjectSizeOffsetEvaluator::visitExtractValueInst(ExtractValueInst&) {
  return unknown();
}

SizeOffsetEvalType
ObjectSizeOffsetEvaluator::visitGEPOperator(GEPOperator &GEP) {
  SizeOffsetEvalType PtrData = compute_(GEP.getPointerOperand());
  if (!bothKnown(PtrData))
    return unknown();

  Value *Offset = EmitGEPOffset(&Builder, DL, &GEP, /*NoAssumptions=*/true);
  Offset = Builder.CreateAdd(PtrData.second, Offset);
  return std::make_pair(PtrData.first, Offset);
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::visitIntToPtrInst(IntToPtrInst&) {
  // clueless
  return unknown();
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::visitLoadInst(LoadInst &LI) {
  return unknown();
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::visitPHINode(PHINode &PHI) {
  // Create 2 PHIs: one for size and another for offset.
  PHINode *SizePHI   = Builder.CreatePHI(IntTy, PHI.getNumIncomingValues());
  PHINode *OffsetPHI = Builder.CreatePHI(IntTy, PHI.getNumIncomingValues());

  // Insert right away in the cache to handle recursive PHIs.
  CacheMap[&PHI] = std::make_pair(SizePHI, OffsetPHI);

  // Compute offset/size for each PHI incoming pointer.
  for (unsigned i = 0, e = PHI.getNumIncomingValues(); i != e; ++i) {
    Builder.SetInsertPoint(&*PHI.getIncomingBlock(i)->getFirstInsertionPt());
    SizeOffsetEvalType EdgeData = compute_(PHI.getIncomingValue(i));

    if (!bothKnown(EdgeData)) {
      OffsetPHI->replaceAllUsesWith(PoisonValue::get(IntTy));
      OffsetPHI->eraseFromParent();
      InsertedInstructions.erase(OffsetPHI);
      SizePHI->replaceAllUsesWith(PoisonValue::get(IntTy));
      SizePHI->eraseFromParent();
      InsertedInstructions.erase(SizePHI);
      return unknown();
    }
    SizePHI->addIncoming(EdgeData.first, PHI.getIncomingBlock(i));
    OffsetPHI->addIncoming(EdgeData.second, PHI.getIncomingBlock(i));
  }

  Value *Size = SizePHI, *Offset = OffsetPHI;
  if (Value *Tmp = SizePHI->hasConstantValue()) {
    Size = Tmp;
    SizePHI->replaceAllUsesWith(Size);
    SizePHI->eraseFromParent();
    InsertedInstructions.erase(SizePHI);
  }
  if (Value *Tmp = OffsetPHI->hasConstantValue()) {
    Offset = Tmp;
    OffsetPHI->replaceAllUsesWith(Offset);
    OffsetPHI->eraseFromParent();
    InsertedInstructions.erase(OffsetPHI);
  }
  return std::make_pair(Size, Offset);
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::visitSelectInst(SelectInst &I) {
  SizeOffsetEvalType TrueSide  = compute_(I.getTrueValue());
  SizeOffsetEvalType FalseSide = compute_(I.getFalseValue());

  if (!bothKnown(TrueSide) || !bothKnown(FalseSide))
    return unknown();
  if (TrueSide == FalseSide)
    return TrueSide;

  Value *Size = Builder.CreateSelect(I.getCondition(), TrueSide.first,
                                     FalseSide.first);
  Value *Offset = Builder.CreateSelect(I.getCondition(), TrueSide.second,
                                       FalseSide.second);
  return std::make_pair(Size, Offset);
}

SizeOffsetEvalType ObjectSizeOffsetEvaluator::visitInstruction(Instruction &I) {
  LLVM_DEBUG(dbgs() << "ObjectSizeOffsetEvaluator unknown instruction:" << I
                    << '\n');
  return unknown();
}
