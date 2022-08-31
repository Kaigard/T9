; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+vpu | FileCheck %s

declare void @llvm.masked.store.v256f64.p0v256f64(<256 x double>, <256 x double>*, i32 immarg, <256 x i1>)

define fastcc void @vec_mstore_v256f64(<256 x double>* %P, <256 x double> %V, <256 x i1> %M) {
; CHECK-LABEL: vec_mstore_v256f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vst %v0, 8, %s0
; CHECK-NEXT:    b.l.t (, %s10)
  call void @llvm.masked.store.v256f64.p0v256f64(<256 x double> %V, <256 x double>* %P, i32 16, <256 x i1> %M)
  ret void
}


declare void @llvm.masked.store.v256f32.p0v256f32(<256 x float>, <256 x float>*, i32 immarg, <256 x i1>)

define fastcc void @vec_mstore_v256f32(<256 x float>* %P, <256 x float> %V, <256 x i1> %M) {
; CHECK-LABEL: vec_mstore_v256f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vstu %v0, 4, %s0
; CHECK-NEXT:    b.l.t (, %s10)
  call void @llvm.masked.store.v256f32.p0v256f32(<256 x float> %V, <256 x float>* %P, i32 16, <256 x i1> %M)
  ret void
}


declare void @llvm.masked.store.v256i32.p0v256i32(<256 x i32>, <256 x i32>*, i32 immarg, <256 x i1>)

define fastcc void @vec_mstore_v256i32(<256 x i32>* %P, <256 x i32> %V, <256 x i1> %M) {
; CHECK-LABEL: vec_mstore_v256i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vstl %v0, 4, %s0
; CHECK-NEXT:    b.l.t (, %s10)
  call void @llvm.masked.store.v256i32.p0v256i32(<256 x i32> %V, <256 x i32>* %P, i32 16, <256 x i1> %M)
  ret void
}
