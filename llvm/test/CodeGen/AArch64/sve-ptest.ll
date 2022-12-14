; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve %s -o - | FileCheck %s


; Ensure that the inactive lanes of p1 aren't zeroed, since the FP compare should do that for free.

define i32 @fcmpeq_nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fcmpeq_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmeq p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    ptest p0, p1.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %1 = tail call <vscale x 4 x i1> @llvm.aarch64.sve.fcmpeq.nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.any.nxv4i1(<vscale x 4 x i1> %pg, <vscale x 4 x i1> %1)
  %conv = zext i1 %2 to i32
  ret i32 %conv
}

define i32 @fcmpne_nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fcmpne_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmne p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    ptest p0, p1.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %1 = tail call <vscale x 4 x i1> @llvm.aarch64.sve.fcmpne.nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.any.nxv4i1(<vscale x 4 x i1> %pg, <vscale x 4 x i1> %1)
  %conv = zext i1 %2 to i32
  ret i32 %conv
}

define i32 @fcmpge_nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fcmpge_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmge p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    ptest p0, p1.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %1 = tail call <vscale x 4 x i1> @llvm.aarch64.sve.fcmpge.nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.any.nxv4i1(<vscale x 4 x i1> %pg, <vscale x 4 x i1> %1)
  %conv = zext i1 %2 to i32
  ret i32 %conv
}

define i32 @fcmpgt_nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fcmpgt_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmgt p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    ptest p0, p1.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %1 = tail call <vscale x 4 x i1> @llvm.aarch64.sve.fcmpgt.nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.any.nxv4i1(<vscale x 4 x i1> %pg, <vscale x 4 x i1> %1)
  %conv = zext i1 %2 to i32
  ret i32 %conv
}

define i32 @fcmpuo_nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fcmpuo_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmuo p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    ptest p0, p1.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %1 = tail call <vscale x 4 x i1> @llvm.aarch64.sve.fcmpuo.nxv4f32(<vscale x 4 x i1> %pg, <vscale x 4 x float> %a, <vscale x 4 x float> %b)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.any.nxv4i1(<vscale x 4 x i1> %pg, <vscale x 4 x i1> %1)
  %conv = zext i1 %2 to i32
  ret i32 %conv
}

declare <vscale x 4 x i1> @llvm.aarch64.sve.fcmpeq.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.fcmpne.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.fcmpge.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.fcmpgt.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.fcmpuo.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)

declare <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32)

declare i1 @llvm.aarch64.sve.ptest.any.nxv4i1(<vscale x 4 x i1>, <vscale x 4 x i1>)

declare <vscale x 4 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1>)
declare <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 4 x i1>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 4 x i1>)
