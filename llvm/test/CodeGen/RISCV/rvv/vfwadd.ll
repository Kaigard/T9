; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+v,+zfh,+experimental-zvfh \
; RUN:   -verify-machineinstrs -target-abi=ilp32d | FileCheck %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+v,+zfh,+experimental-zvfh \
; RUN:   -verify-machineinstrs -target-abi=lp64d | FileCheck %s
declare <vscale x 1 x float> @llvm.riscv.vfwadd.nxv1f32.nxv1f16.nxv1f16(
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  iXLen);

define <vscale x 1 x float> @intrinsic_vfwadd_vv_nxv1f32_nxv1f16_nxv1f16(<vscale x 1 x half> %0, <vscale x 1 x half> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv1f32_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfwadd.vv v10, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwadd.nxv1f32.nxv1f16.nxv1f16(
    <vscale x 1 x float> undef,
    <vscale x 1 x half> %0,
    <vscale x 1 x half> %1,
    iXLen %2)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwadd.mask.nxv1f32.nxv1f16.nxv1f16(
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  iXLen,
  iXLen);

define <vscale x 1 x float> @intrinsic_vfwadd_mask_vv_nxv1f32_nxv1f16_nxv1f16(<vscale x 1 x float> %0, <vscale x 1 x half> %1, <vscale x 1 x half> %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv1f32_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v9, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwadd.mask.nxv1f32.nxv1f16.nxv1f16(
    <vscale x 1 x float> %0,
    <vscale x 1 x half> %1,
    <vscale x 1 x half> %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwadd.nxv2f32.nxv2f16.nxv2f16(
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  iXLen);

define <vscale x 2 x float> @intrinsic_vfwadd_vv_nxv2f32_nxv2f16_nxv2f16(<vscale x 2 x half> %0, <vscale x 2 x half> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv2f32_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vv v10, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwadd.nxv2f32.nxv2f16.nxv2f16(
    <vscale x 2 x float> undef,
    <vscale x 2 x half> %0,
    <vscale x 2 x half> %1,
    iXLen %2)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwadd.mask.nxv2f32.nxv2f16.nxv2f16(
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  iXLen,
  iXLen);

define <vscale x 2 x float> @intrinsic_vfwadd_mask_vv_nxv2f32_nxv2f16_nxv2f16(<vscale x 2 x float> %0, <vscale x 2 x half> %1, <vscale x 2 x half> %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv2f32_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v9, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwadd.mask.nxv2f32.nxv2f16.nxv2f16(
    <vscale x 2 x float> %0,
    <vscale x 2 x half> %1,
    <vscale x 2 x half> %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwadd.nxv4f32.nxv4f16.nxv4f16(
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  iXLen);

define <vscale x 4 x float> @intrinsic_vfwadd_vv_nxv4f32_nxv4f16_nxv4f16(<vscale x 4 x half> %0, <vscale x 4 x half> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv4f32_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfwadd.vv v10, v8, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwadd.nxv4f32.nxv4f16.nxv4f16(
    <vscale x 4 x float> undef,
    <vscale x 4 x half> %0,
    <vscale x 4 x half> %1,
    iXLen %2)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwadd.mask.nxv4f32.nxv4f16.nxv4f16(
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  iXLen,
  iXLen);

define <vscale x 4 x float> @intrinsic_vfwadd_mask_vv_nxv4f32_nxv4f16_nxv4f16(<vscale x 4 x float> %0, <vscale x 4 x half> %1, <vscale x 4 x half> %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv4f32_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v10, v11, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwadd.mask.nxv4f32.nxv4f16.nxv4f16(
    <vscale x 4 x float> %0,
    <vscale x 4 x half> %1,
    <vscale x 4 x half> %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwadd.nxv8f32.nxv8f16.nxv8f16(
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  iXLen);

define <vscale x 8 x float> @intrinsic_vfwadd_vv_nxv8f32_nxv8f16_nxv8f16(<vscale x 8 x half> %0, <vscale x 8 x half> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv8f32_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfwadd.vv v12, v8, v10
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwadd.nxv8f32.nxv8f16.nxv8f16(
    <vscale x 8 x float> undef,
    <vscale x 8 x half> %0,
    <vscale x 8 x half> %1,
    iXLen %2)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwadd.mask.nxv8f32.nxv8f16.nxv8f16(
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  iXLen,
  iXLen);

define <vscale x 8 x float> @intrinsic_vfwadd_mask_vv_nxv8f32_nxv8f16_nxv8f16(<vscale x 8 x float> %0, <vscale x 8 x half> %1, <vscale x 8 x half> %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv8f32_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v12, v14, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwadd.mask.nxv8f32.nxv8f16.nxv8f16(
    <vscale x 8 x float> %0,
    <vscale x 8 x half> %1,
    <vscale x 8 x half> %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwadd.nxv16f32.nxv16f16.nxv16f16(
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  iXLen);

define <vscale x 16 x float> @intrinsic_vfwadd_vv_nxv16f32_nxv16f16_nxv16f16(<vscale x 16 x half> %0, <vscale x 16 x half> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv16f32_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfwadd.vv v16, v8, v12
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwadd.nxv16f32.nxv16f16.nxv16f16(
    <vscale x 16 x float> undef,
    <vscale x 16 x half> %0,
    <vscale x 16 x half> %1,
    iXLen %2)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwadd.mask.nxv16f32.nxv16f16.nxv16f16(
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  iXLen,
  iXLen);

define <vscale x 16 x float> @intrinsic_vfwadd_mask_vv_nxv16f32_nxv16f16_nxv16f16(<vscale x 16 x float> %0, <vscale x 16 x half> %1, <vscale x 16 x half> %2, <vscale x 16 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv16f32_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v16, v20, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwadd.mask.nxv16f32.nxv16f16.nxv16f16(
    <vscale x 16 x float> %0,
    <vscale x 16 x half> %1,
    <vscale x 16 x half> %2,
    <vscale x 16 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwadd.nxv1f64.nxv1f32.nxv1f32(
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  iXLen);

define <vscale x 1 x double> @intrinsic_vfwadd_vv_nxv1f64_nxv1f32_nxv1f32(<vscale x 1 x float> %0, <vscale x 1 x float> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv1f64_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vv v10, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwadd.nxv1f64.nxv1f32.nxv1f32(
    <vscale x 1 x double> undef,
    <vscale x 1 x float> %0,
    <vscale x 1 x float> %1,
    iXLen %2)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwadd.mask.nxv1f64.nxv1f32.nxv1f32(
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  iXLen,
  iXLen);

define <vscale x 1 x double> @intrinsic_vfwadd_mask_vv_nxv1f64_nxv1f32_nxv1f32(<vscale x 1 x double> %0, <vscale x 1 x float> %1, <vscale x 1 x float> %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv1f64_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v9, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwadd.mask.nxv1f64.nxv1f32.nxv1f32(
    <vscale x 1 x double> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x float> %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwadd.nxv2f64.nxv2f32.nxv2f32(
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  iXLen);

define <vscale x 2 x double> @intrinsic_vfwadd_vv_nxv2f64_nxv2f32_nxv2f32(<vscale x 2 x float> %0, <vscale x 2 x float> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv2f64_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfwadd.vv v10, v8, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwadd.nxv2f64.nxv2f32.nxv2f32(
    <vscale x 2 x double> undef,
    <vscale x 2 x float> %0,
    <vscale x 2 x float> %1,
    iXLen %2)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwadd.mask.nxv2f64.nxv2f32.nxv2f32(
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  iXLen,
  iXLen);

define <vscale x 2 x double> @intrinsic_vfwadd_mask_vv_nxv2f64_nxv2f32_nxv2f32(<vscale x 2 x double> %0, <vscale x 2 x float> %1, <vscale x 2 x float> %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv2f64_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v10, v11, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwadd.mask.nxv2f64.nxv2f32.nxv2f32(
    <vscale x 2 x double> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x float> %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwadd.nxv4f64.nxv4f32.nxv4f32(
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  iXLen);

define <vscale x 4 x double> @intrinsic_vfwadd_vv_nxv4f64_nxv4f32_nxv4f32(<vscale x 4 x float> %0, <vscale x 4 x float> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv4f64_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfwadd.vv v12, v8, v10
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwadd.nxv4f64.nxv4f32.nxv4f32(
    <vscale x 4 x double> undef,
    <vscale x 4 x float> %0,
    <vscale x 4 x float> %1,
    iXLen %2)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwadd.mask.nxv4f64.nxv4f32.nxv4f32(
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  iXLen,
  iXLen);

define <vscale x 4 x double> @intrinsic_vfwadd_mask_vv_nxv4f64_nxv4f32_nxv4f32(<vscale x 4 x double> %0, <vscale x 4 x float> %1, <vscale x 4 x float> %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv4f64_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v12, v14, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwadd.mask.nxv4f64.nxv4f32.nxv4f32(
    <vscale x 4 x double> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x float> %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwadd.nxv8f64.nxv8f32.nxv8f32(
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  iXLen);

define <vscale x 8 x double> @intrinsic_vfwadd_vv_nxv8f64_nxv8f32_nxv8f32(<vscale x 8 x float> %0, <vscale x 8 x float> %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vv_nxv8f64_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfwadd.vv v16, v8, v12
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwadd.nxv8f64.nxv8f32.nxv8f32(
    <vscale x 8 x double> undef,
    <vscale x 8 x float> %0,
    <vscale x 8 x float> %1,
    iXLen %2)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwadd.mask.nxv8f64.nxv8f32.nxv8f32(
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  iXLen,
  iXLen);

define <vscale x 8 x double> @intrinsic_vfwadd_mask_vv_nxv8f64_nxv8f32_nxv8f32(<vscale x 8 x double> %0, <vscale x 8 x float> %1, <vscale x 8 x float> %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vv_nxv8f64_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfwadd.vv v8, v16, v20, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwadd.mask.nxv8f64.nxv8f32.nxv8f32(
    <vscale x 8 x double> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x float> %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 8 x double> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwadd.nxv1f32.nxv1f16.f16(
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  half,
  iXLen);

define <vscale x 1 x float> @intrinsic_vfwadd_vf_nxv1f32_nxv1f16_f16(<vscale x 1 x half> %0, half %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv1f32_nxv1f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfwadd.vf v9, v8, fa0
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwadd.nxv1f32.nxv1f16.f16(
    <vscale x 1 x float> undef,
    <vscale x 1 x half> %0,
    half %1,
    iXLen %2)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwadd.mask.nxv1f32.nxv1f16.f16(
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  half,
  <vscale x 1 x i1>,
  iXLen,
  iXLen);

define <vscale x 1 x float> @intrinsic_vfwadd_mask_vf_nxv1f32_nxv1f16_f16(<vscale x 1 x float> %0, <vscale x 1 x half> %1, half %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv1f32_nxv1f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v9, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwadd.mask.nxv1f32.nxv1f16.f16(
    <vscale x 1 x float> %0,
    <vscale x 1 x half> %1,
    half %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwadd.nxv2f32.nxv2f16.f16(
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  half,
  iXLen);

define <vscale x 2 x float> @intrinsic_vfwadd_vf_nxv2f32_nxv2f16_f16(<vscale x 2 x half> %0, half %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv2f32_nxv2f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vf v9, v8, fa0
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwadd.nxv2f32.nxv2f16.f16(
    <vscale x 2 x float> undef,
    <vscale x 2 x half> %0,
    half %1,
    iXLen %2)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwadd.mask.nxv2f32.nxv2f16.f16(
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  half,
  <vscale x 2 x i1>,
  iXLen,
  iXLen);

define <vscale x 2 x float> @intrinsic_vfwadd_mask_vf_nxv2f32_nxv2f16_f16(<vscale x 2 x float> %0, <vscale x 2 x half> %1, half %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv2f32_nxv2f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v9, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwadd.mask.nxv2f32.nxv2f16.f16(
    <vscale x 2 x float> %0,
    <vscale x 2 x half> %1,
    half %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwadd.nxv4f32.nxv4f16.f16(
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  half,
  iXLen);

define <vscale x 4 x float> @intrinsic_vfwadd_vf_nxv4f32_nxv4f16_f16(<vscale x 4 x half> %0, half %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv4f32_nxv4f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfwadd.vf v10, v8, fa0
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwadd.nxv4f32.nxv4f16.f16(
    <vscale x 4 x float> undef,
    <vscale x 4 x half> %0,
    half %1,
    iXLen %2)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwadd.mask.nxv4f32.nxv4f16.f16(
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  half,
  <vscale x 4 x i1>,
  iXLen,
  iXLen);

define <vscale x 4 x float> @intrinsic_vfwadd_mask_vf_nxv4f32_nxv4f16_f16(<vscale x 4 x float> %0, <vscale x 4 x half> %1, half %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv4f32_nxv4f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v10, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwadd.mask.nxv4f32.nxv4f16.f16(
    <vscale x 4 x float> %0,
    <vscale x 4 x half> %1,
    half %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwadd.nxv8f32.nxv8f16.f16(
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  half,
  iXLen);

define <vscale x 8 x float> @intrinsic_vfwadd_vf_nxv8f32_nxv8f16_f16(<vscale x 8 x half> %0, half %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv8f32_nxv8f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfwadd.vf v12, v8, fa0
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwadd.nxv8f32.nxv8f16.f16(
    <vscale x 8 x float> undef,
    <vscale x 8 x half> %0,
    half %1,
    iXLen %2)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwadd.mask.nxv8f32.nxv8f16.f16(
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  half,
  <vscale x 8 x i1>,
  iXLen,
  iXLen);

define <vscale x 8 x float> @intrinsic_vfwadd_mask_vf_nxv8f32_nxv8f16_f16(<vscale x 8 x float> %0, <vscale x 8 x half> %1, half %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv8f32_nxv8f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v12, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwadd.mask.nxv8f32.nxv8f16.f16(
    <vscale x 8 x float> %0,
    <vscale x 8 x half> %1,
    half %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwadd.nxv16f32.nxv16f16.f16(
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  half,
  iXLen);

define <vscale x 16 x float> @intrinsic_vfwadd_vf_nxv16f32_nxv16f16_f16(<vscale x 16 x half> %0, half %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv16f32_nxv16f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfwadd.vf v16, v8, fa0
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwadd.nxv16f32.nxv16f16.f16(
    <vscale x 16 x float> undef,
    <vscale x 16 x half> %0,
    half %1,
    iXLen %2)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwadd.mask.nxv16f32.nxv16f16.f16(
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  half,
  <vscale x 16 x i1>,
  iXLen,
  iXLen);

define <vscale x 16 x float> @intrinsic_vfwadd_mask_vf_nxv16f32_nxv16f16_f16(<vscale x 16 x float> %0, <vscale x 16 x half> %1, half %2, <vscale x 16 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv16f32_nxv16f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v16, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwadd.mask.nxv16f32.nxv16f16.f16(
    <vscale x 16 x float> %0,
    <vscale x 16 x half> %1,
    half %2,
    <vscale x 16 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwadd.nxv1f64.nxv1f32.f32(
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  float,
  iXLen);

define <vscale x 1 x double> @intrinsic_vfwadd_vf_nxv1f64_nxv1f32_f32(<vscale x 1 x float> %0, float %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv1f64_nxv1f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vf v9, v8, fa0
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwadd.nxv1f64.nxv1f32.f32(
    <vscale x 1 x double> undef,
    <vscale x 1 x float> %0,
    float %1,
    iXLen %2)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwadd.mask.nxv1f64.nxv1f32.f32(
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  float,
  <vscale x 1 x i1>,
  iXLen,
  iXLen);

define <vscale x 1 x double> @intrinsic_vfwadd_mask_vf_nxv1f64_nxv1f32_f32(<vscale x 1 x double> %0, <vscale x 1 x float> %1, float %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv1f64_nxv1f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v9, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwadd.mask.nxv1f64.nxv1f32.f32(
    <vscale x 1 x double> %0,
    <vscale x 1 x float> %1,
    float %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwadd.nxv2f64.nxv2f32.f32(
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  float,
  iXLen);

define <vscale x 2 x double> @intrinsic_vfwadd_vf_nxv2f64_nxv2f32_f32(<vscale x 2 x float> %0, float %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv2f64_nxv2f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfwadd.vf v10, v8, fa0
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwadd.nxv2f64.nxv2f32.f32(
    <vscale x 2 x double> undef,
    <vscale x 2 x float> %0,
    float %1,
    iXLen %2)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwadd.mask.nxv2f64.nxv2f32.f32(
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  float,
  <vscale x 2 x i1>,
  iXLen,
  iXLen);

define <vscale x 2 x double> @intrinsic_vfwadd_mask_vf_nxv2f64_nxv2f32_f32(<vscale x 2 x double> %0, <vscale x 2 x float> %1, float %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv2f64_nxv2f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v10, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwadd.mask.nxv2f64.nxv2f32.f32(
    <vscale x 2 x double> %0,
    <vscale x 2 x float> %1,
    float %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwadd.nxv4f64.nxv4f32.f32(
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  float,
  iXLen);

define <vscale x 4 x double> @intrinsic_vfwadd_vf_nxv4f64_nxv4f32_f32(<vscale x 4 x float> %0, float %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv4f64_nxv4f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfwadd.vf v12, v8, fa0
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwadd.nxv4f64.nxv4f32.f32(
    <vscale x 4 x double> undef,
    <vscale x 4 x float> %0,
    float %1,
    iXLen %2)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwadd.mask.nxv4f64.nxv4f32.f32(
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  float,
  <vscale x 4 x i1>,
  iXLen,
  iXLen);

define <vscale x 4 x double> @intrinsic_vfwadd_mask_vf_nxv4f64_nxv4f32_f32(<vscale x 4 x double> %0, <vscale x 4 x float> %1, float %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv4f64_nxv4f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v12, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwadd.mask.nxv4f64.nxv4f32.f32(
    <vscale x 4 x double> %0,
    <vscale x 4 x float> %1,
    float %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwadd.nxv8f64.nxv8f32.f32(
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  float,
  iXLen);

define <vscale x 8 x double> @intrinsic_vfwadd_vf_nxv8f64_nxv8f32_f32(<vscale x 8 x float> %0, float %1, iXLen %2) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_vf_nxv8f64_nxv8f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfwadd.vf v16, v8, fa0
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwadd.nxv8f64.nxv8f32.f32(
    <vscale x 8 x double> undef,
    <vscale x 8 x float> %0,
    float %1,
    iXLen %2)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwadd.mask.nxv8f64.nxv8f32.f32(
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  float,
  <vscale x 8 x i1>,
  iXLen,
  iXLen);

define <vscale x 8 x double> @intrinsic_vfwadd_mask_vf_nxv8f64_nxv8f32_f32(<vscale x 8 x double> %0, <vscale x 8 x float> %1, float %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwadd_mask_vf_nxv8f64_nxv8f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfwadd.vf v8, v16, fa0, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwadd.mask.nxv8f64.nxv8f32.f32(
    <vscale x 8 x double> %0,
    <vscale x 8 x float> %1,
    float %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 1)

  ret <vscale x 8 x double> %a
}
