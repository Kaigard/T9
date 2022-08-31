; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=aarch64-linux-gnu -mattr=+sve | FileCheck %s

define void @fixed() {
; CHECK-LABEL: 'fixed'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i8 = call <2 x i8> @llvm.masked.load.v2i8.p0v2i8(<2 x i8>* undef, i32 8, <2 x i1> undef, <2 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 25 for instruction: %v4i8 = call <4 x i8> @llvm.masked.load.v4i8.p0v4i8(<4 x i8>* undef, i32 8, <4 x i1> undef, <4 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 53 for instruction: %v8i8 = call <8 x i8> @llvm.masked.load.v8i8.p0v8i8(<8 x i8>* undef, i32 8, <8 x i1> undef, <8 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 109 for instruction: %v16i8 = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* undef, i32 8, <16 x i1> undef, <16 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i16 = call <2 x i16> @llvm.masked.load.v2i16.p0v2i16(<2 x i16>* undef, i32 8, <2 x i1> undef, <2 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 25 for instruction: %v4i16 = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>* undef, i32 8, <4 x i1> undef, <4 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 53 for instruction: %v8i16 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* undef, i32 8, <8 x i1> undef, <8 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i32 = call <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>* undef, i32 8, <2 x i1> undef, <2 x i32> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 25 for instruction: %v4i32 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* undef, i32 8, <4 x i1> undef, <4 x i32> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i64 = call <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>* undef, i32 8, <2 x i1> undef, <2 x i64> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2f16 = call <2 x half> @llvm.masked.load.v2f16.p0v2f16(<2 x half>* undef, i32 8, <2 x i1> undef, <2 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 25 for instruction: %v4f16 = call <4 x half> @llvm.masked.load.v4f16.p0v4f16(<4 x half>* undef, i32 8, <4 x i1> undef, <4 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 53 for instruction: %v8f16 = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* undef, i32 8, <8 x i1> undef, <8 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2f32 = call <2 x float> @llvm.masked.load.v2f32.p0v2f32(<2 x float>* undef, i32 8, <2 x i1> undef, <2 x float> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 25 for instruction: %v4f32 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* undef, i32 8, <4 x i1> undef, <4 x float> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2f64 = call <2 x double> @llvm.masked.load.v2f64.p0v2f64(<2 x double>* undef, i32 8, <2 x i1> undef, <2 x double> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %v4i64 = call <4 x i64> @llvm.masked.load.v4i64.p0v4i64(<4 x i64>* undef, i32 8, <4 x i1> undef, <4 x i64> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 212 for instruction: %v32f16 = call <32 x half> @llvm.masked.load.v32f16.p0v32f16(<32 x half>* undef, i32 8, <32 x i1> undef, <32 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
entry:
  ; Legal fixed-width integer types
  %v2i8 = call <2 x i8> @llvm.masked.load.v2i8.p0v2i8(<2 x i8> *undef, i32 8, <2 x i1> undef, <2 x i8> undef)
  %v4i8 = call <4 x i8> @llvm.masked.load.v4i8.p0v4i8(<4 x i8> *undef, i32 8, <4 x i1> undef, <4 x i8> undef)
  %v8i8 = call <8 x i8> @llvm.masked.load.v8i8.p0v8i8(<8 x i8> *undef, i32 8, <8 x i1> undef, <8 x i8> undef)
  %v16i8 = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8> *undef, i32 8, <16 x i1> undef, <16 x i8> undef)
  %v2i16 = call <2 x i16> @llvm.masked.load.v2i16.p0v2i16(<2 x i16> *undef, i32 8, <2 x i1> undef, <2 x i16> undef)
  %v4i16 = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16> *undef, i32 8, <4 x i1> undef, <4 x i16> undef)
  %v8i16 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16> *undef, i32 8, <8 x i1> undef, <8 x i16> undef)
  %v2i32 = call <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32> *undef, i32 8, <2 x i1> undef, <2 x i32> undef)
  %v4i32 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32> *undef, i32 8, <4 x i1> undef, <4 x i32> undef)
  %v2i64 = call <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64> *undef, i32 8, <2 x i1> undef, <2 x i64> undef)

  ; Legal fixed-width floating point types
  %v2f16 = call <2 x half> @llvm.masked.load.v2f16.p0v2f16(<2 x half> *undef, i32 8, <2 x i1> undef, <2 x half> undef)
  %v4f16 = call <4 x half> @llvm.masked.load.v4f16.p0v4f16(<4 x half> *undef, i32 8, <4 x i1> undef, <4 x half> undef)
  %v8f16 = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half> *undef, i32 8, <8 x i1> undef, <8 x half> undef)
  %v2f32 = call <2 x float> @llvm.masked.load.v2f32.p0v2f32(<2 x float> *undef, i32 8, <2 x i1> undef, <2 x float> undef)
  %v4f32 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float> *undef, i32 8, <4 x i1> undef, <4 x float> undef)
  %v2f64 = call <2 x double> @llvm.masked.load.v2f64.p0v2f64(<2 x double> *undef, i32 8, <2 x i1> undef, <2 x double> undef)

  ; A couple of examples of illegal fixed-width types
  %v4i64 = call <4 x i64> @llvm.masked.load.v4i64.p0v4i64(<4 x i64> *undef, i32 8, <4 x i1> undef, <4 x i64> undef)
  %v32f16 = call <32 x half> @llvm.masked.load.v32f16.p0v32f16(<32 x half> *undef, i32 8, <32 x i1> undef, <32 x half> undef)

  ret void
}


define void @scalable() {
; CHECK-LABEL: 'scalable'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv2i8 = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8.p0nxv2i8(<vscale x 2 x i8>* undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv4i8 = call <vscale x 4 x i8> @llvm.masked.load.nxv4i8.p0nxv4i8(<vscale x 4 x i8>* undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv8i8 = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8.p0nxv8i8(<vscale x 8 x i8>* undef, i32 8, <vscale x 8 x i1> undef, <vscale x 8 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv16i8 = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8.p0nxv16i8(<vscale x 16 x i8>* undef, i32 8, <vscale x 16 x i1> undef, <vscale x 16 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv2i16 = call <vscale x 2 x i16> @llvm.masked.load.nxv2i16.p0nxv2i16(<vscale x 2 x i16>* undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv4i16 = call <vscale x 4 x i16> @llvm.masked.load.nxv4i16.p0nxv4i16(<vscale x 4 x i16>* undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv8i16 = call <vscale x 8 x i16> @llvm.masked.load.nxv8i16.p0nxv8i16(<vscale x 8 x i16>* undef, i32 8, <vscale x 8 x i1> undef, <vscale x 8 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv2i32 = call <vscale x 2 x i32> @llvm.masked.load.nxv2i32.p0nxv2i32(<vscale x 2 x i32>* undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i32> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv4i32 = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>* undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i32> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv2i64 = call <vscale x 2 x i64> @llvm.masked.load.nxv2i64.p0nxv2i64(<vscale x 2 x i64>* undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i64> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv2f16 = call <vscale x 2 x half> @llvm.masked.load.nxv2f16.p0nxv2f16(<vscale x 2 x half>* undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv4f16 = call <vscale x 4 x half> @llvm.masked.load.nxv4f16.p0nxv4f16(<vscale x 4 x half>* undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv8f16 = call <vscale x 8 x half> @llvm.masked.load.nxv8f16.p0nxv8f16(<vscale x 8 x half>* undef, i32 8, <vscale x 8 x i1> undef, <vscale x 8 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv2f32 = call <vscale x 2 x float> @llvm.masked.load.nxv2f32.p0nxv2f32(<vscale x 2 x float>* undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x float> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv4f32 = call <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0nxv4f32(<vscale x 4 x float>* undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x float> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %nxv2f64 = call <vscale x 2 x double> @llvm.masked.load.nxv2f64.p0nxv2f64(<vscale x 2 x double>* undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x double> undef)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %nxv1i64 = call <vscale x 1 x i64> @llvm.masked.load.nxv1i64.p0nxv1i64(<vscale x 1 x i64>* undef, i32 8, <vscale x 1 x i1> undef, <vscale x 1 x i64> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %nxv4i64 = call <vscale x 4 x i64> @llvm.masked.load.nxv4i64.p0nxv4i64(<vscale x 4 x i64>* undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i64> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %nxv32f16 = call <vscale x 32 x half> @llvm.masked.load.nxv32f16.p0nxv32f16(<vscale x 32 x half>* undef, i32 8, <vscale x 32 x i1> undef, <vscale x 32 x half> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
entry:
  ; Legal scalable integer types
  %nxv2i8 = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8.p0nxv2i8(<vscale x 2 x i8> *undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i8> undef)
  %nxv4i8 = call <vscale x 4 x i8> @llvm.masked.load.nxv4i8.p0nxv4i8(<vscale x 4 x i8> *undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i8> undef)
  %nxv8i8 = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8.p0nxv8i8(<vscale x 8 x i8> *undef, i32 8, <vscale x 8 x i1> undef, <vscale x 8 x i8> undef)
  %nxv16i8 = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8.p0nxv16i8(<vscale x 16 x i8> *undef, i32 8, <vscale x 16 x i1> undef, <vscale x 16 x i8> undef)
  %nxv2i16 = call <vscale x 2 x i16> @llvm.masked.load.nxv2i16.p0nxv2i16(<vscale x 2 x i16> *undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i16> undef)
  %nxv4i16 = call <vscale x 4 x i16> @llvm.masked.load.nxv4i16.p0nxv4i16(<vscale x 4 x i16> *undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i16> undef)
  %nxv8i16 = call <vscale x 8 x i16> @llvm.masked.load.nxv8i16.p0nxv8i16(<vscale x 8 x i16> *undef, i32 8, <vscale x 8 x i1> undef, <vscale x 8 x i16> undef)
  %nxv2i32 = call <vscale x 2 x i32> @llvm.masked.load.nxv2i32.p0nxv2i32(<vscale x 2 x i32> *undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i32> undef)
  %nxv4i32 = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32> *undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i32> undef)
  %nxv2i64 = call <vscale x 2 x i64> @llvm.masked.load.nxv2i64.p0nxv2i64(<vscale x 2 x i64> *undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x i64> undef)

  ; Legal scalable floating point types
  %nxv2f16 = call <vscale x 2 x half> @llvm.masked.load.nxv2f16.p0nxv2f16(<vscale x 2 x half> *undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x half> undef)
  %nxv4f16 = call <vscale x 4 x half> @llvm.masked.load.nxv4f16.p0nxv4f16(<vscale x 4 x half> *undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x half> undef)
  %nxv8f16 = call <vscale x 8 x half> @llvm.masked.load.nxv8f16.p0nxv8f16(<vscale x 8 x half> *undef, i32 8, <vscale x 8 x i1> undef, <vscale x 8 x half> undef)
  %nxv2f32 = call <vscale x 2 x float> @llvm.masked.load.nxv2f32.p0nxv2f32(<vscale x 2 x float> *undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x float> undef)
  %nxv4f32 = call <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0nxv4f32(<vscale x 4 x float> *undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x float> undef)
  %nxv2f64 = call <vscale x 2 x double> @llvm.masked.load.nxv2f64.p0nxv2f64(<vscale x 2 x double> *undef, i32 8, <vscale x 2 x i1> undef, <vscale x 2 x double> undef)

  ; A couple of examples of illegal scalable types
  %nxv1i64 = call <vscale x 1 x i64> @llvm.masked.load.nxv1i64.p0nxv1i64(<vscale x 1 x i64> *undef, i32 8, <vscale x 1 x i1> undef, <vscale x 1 x i64> undef)
  %nxv4i64 = call <vscale x 4 x i64> @llvm.masked.load.nxv4i64.p0nxv4i64(<vscale x 4 x i64> *undef, i32 8, <vscale x 4 x i1> undef, <vscale x 4 x i64> undef)
  %nxv32f16 = call <vscale x 32 x half> @llvm.masked.load.nxv32f16.p0nxv32f16(<vscale x 32 x half> *undef, i32 8, <vscale x 32 x i1> undef, <vscale x 32 x half> undef)

  ret void
}

declare <2 x i8> @llvm.masked.load.v2i8.p0v2i8(<2 x i8>*, i32, <2 x i1>, <2 x i8>)
declare <4 x i8> @llvm.masked.load.v4i8.p0v4i8(<4 x i8>*, i32, <4 x i1>, <4 x i8>)
declare <8 x i8> @llvm.masked.load.v8i8.p0v8i8(<8 x i8>*, i32, <8 x i1>, <8 x i8>)
declare <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>*, i32, <16 x i1>, <16 x i8>)
declare <2 x i16> @llvm.masked.load.v2i16.p0v2i16(<2 x i16>*, i32, <2 x i1>, <2 x i16>)
declare <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>*, i32, <4 x i1>, <4 x i16>)
declare <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>*, i32, <8 x i1>, <8 x i16>)
declare <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>*, i32, <2 x i1>, <2 x i32>)
declare <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>*, i32, <4 x i1>, <4 x i32>)
declare <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>*, i32, <2 x i1>, <2 x i64>)
declare <4 x i64> @llvm.masked.load.v4i64.p0v4i64(<4 x i64>*, i32, <4 x i1>, <4 x i64>)
declare <2 x half> @llvm.masked.load.v2f16.p0v2f16(<2 x half>*, i32, <2 x i1>, <2 x half>)
declare <4 x half> @llvm.masked.load.v4f16.p0v4f16(<4 x half>*, i32, <4 x i1>, <4 x half>)
declare <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>*, i32, <8 x i1>, <8 x half>)
declare <32 x half> @llvm.masked.load.v32f16.p0v32f16(<32 x half>*, i32, <32 x i1>, <32 x half>)
declare <2 x float> @llvm.masked.load.v2f32.p0v2f32(<2 x float>*, i32, <2 x i1>, <2 x float>)
declare <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>*, i32, <4 x i1>, <4 x float>)
declare <2 x double> @llvm.masked.load.v2f64.p0v2f64(<2 x double>*, i32, <2 x i1>, <2 x double>)


declare <vscale x 2 x i8> @llvm.masked.load.nxv2i8.p0nxv2i8(<vscale x 2 x i8>*, i32, <vscale x 2 x i1>, <vscale x 2 x i8>)
declare <vscale x 4 x i8> @llvm.masked.load.nxv4i8.p0nxv4i8(<vscale x 4 x i8>*, i32, <vscale x 4 x i1>, <vscale x 4 x i8>)
declare <vscale x 8 x i8> @llvm.masked.load.nxv8i8.p0nxv8i8(<vscale x 8 x i8>*, i32, <vscale x 8 x i1>, <vscale x 8 x i8>)
declare <vscale x 16 x i8> @llvm.masked.load.nxv16i8.p0nxv16i8(<vscale x 16 x i8>*, i32, <vscale x 16 x i1>, <vscale x 16 x i8>)
declare <vscale x 2 x i16> @llvm.masked.load.nxv2i16.p0nxv2i16(<vscale x 2 x i16>*, i32, <vscale x 2 x i1>, <vscale x 2 x i16>)
declare <vscale x 4 x i16> @llvm.masked.load.nxv4i16.p0nxv4i16(<vscale x 4 x i16>*, i32, <vscale x 4 x i1>, <vscale x 4 x i16>)
declare <vscale x 8 x i16> @llvm.masked.load.nxv8i16.p0nxv8i16(<vscale x 8 x i16>*, i32, <vscale x 8 x i1>, <vscale x 8 x i16>)
declare <vscale x 2 x i32> @llvm.masked.load.nxv2i32.p0nxv2i32(<vscale x 2 x i32>*, i32, <vscale x 2 x i1>, <vscale x 2 x i32>)
declare <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>*, i32, <vscale x 4 x i1>, <vscale x 4 x i32>)
declare <vscale x 2 x i64> @llvm.masked.load.nxv2i64.p0nxv2i64(<vscale x 2 x i64>*, i32, <vscale x 2 x i1>, <vscale x 2 x i64>)
declare <vscale x 4 x i64> @llvm.masked.load.nxv4i64.p0nxv4i64(<vscale x 4 x i64>*, i32, <vscale x 4 x i1>, <vscale x 4 x i64>)
declare <vscale x 1 x i64> @llvm.masked.load.nxv1i64.p0nxv1i64(<vscale x 1 x i64>*, i32, <vscale x 1 x i1>, <vscale x 1 x i64>)
declare <vscale x 2 x half> @llvm.masked.load.nxv2f16.p0nxv2f16(<vscale x 2 x half>*, i32, <vscale x 2 x i1>, <vscale x 2 x half>)
declare <vscale x 4 x half> @llvm.masked.load.nxv4f16.p0nxv4f16(<vscale x 4 x half>*, i32, <vscale x 4 x i1>, <vscale x 4 x half>)
declare <vscale x 8 x half> @llvm.masked.load.nxv8f16.p0nxv8f16(<vscale x 8 x half>*, i32, <vscale x 8 x i1>, <vscale x 8 x half>)
declare <vscale x 32 x half> @llvm.masked.load.nxv32f16.p0nxv32f16(<vscale x 32 x half>*, i32, <vscale x 32 x i1>, <vscale x 32 x half>)
declare <vscale x 2 x float> @llvm.masked.load.nxv2f32.p0nxv2f32(<vscale x 2 x float>*, i32, <vscale x 2 x i1>, <vscale x 2 x float>)
declare <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0nxv4f32(<vscale x 4 x float>*, i32, <vscale x 4 x i1>, <vscale x 4 x float>)
declare <vscale x 2 x double> @llvm.masked.load.nxv2f64.p0nxv2f64(<vscale x 2 x double>*, i32, <vscale x 2 x i1>, <vscale x 2 x double>)
