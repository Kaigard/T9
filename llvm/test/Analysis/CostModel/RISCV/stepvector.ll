; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; Check stepvector for scalable vector
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -S -mtriple=riscv64 -mattr=+v | FileCheck %s

define void @stepvector() {
; CHECK-LABEL: 'stepvector'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zero = call <vscale x 1 x i8> @llvm.experimental.stepvector.nxv1i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = call <vscale x 2 x i8> @llvm.experimental.stepvector.nxv2i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = call <vscale x 4 x i8> @llvm.experimental.stepvector.nxv4i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %3 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %4 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %5 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %7 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %8 = call <vscale x 16 x i8> @llvm.experimental.stepvector.nxv16i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %9 = call <vscale x 32 x i8> @llvm.experimental.stepvector.nxv32i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %10 = call <vscale x 64 x i8> @llvm.experimental.stepvector.nxv64i8()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %11 = call <vscale x 1 x i16> @llvm.experimental.stepvector.nxv1i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %12 = call <vscale x 2 x i16> @llvm.experimental.stepvector.nxv2i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %13 = call <vscale x 4 x i16> @llvm.experimental.stepvector.nxv4i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %14 = call <vscale x 8 x i16> @llvm.experimental.stepvector.nxv8i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %15 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %16 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %17 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %18 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %19 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %20 = call <vscale x 32 x i16> @llvm.experimental.stepvector.nxv32i16()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %21 = call <vscale x 1 x i32> @llvm.experimental.stepvector.nxv1i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %22 = call <vscale x 2 x i32> @llvm.experimental.stepvector.nxv2i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %23 = call <vscale x 4 x i32> @llvm.experimental.stepvector.nxv4i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %24 = call <vscale x 8 x i32> @llvm.experimental.stepvector.nxv8i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %25 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %26 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %27 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %28 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %29 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %30 = call <vscale x 1 x i64> @llvm.experimental.stepvector.nxv1i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %31 = call <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %32 = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %33 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %34 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %35 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %36 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %37 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %38 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %39 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %40 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %41 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %42 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %43 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %44 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %zero = call <vscale x 1 x i8> @llvm.experimental.stepvector.nxv1i8()
  %1 = call <vscale x 2 x i8> @llvm.experimental.stepvector.nxv2i8()
  %2 = call <vscale x 4 x i8> @llvm.experimental.stepvector.nxv4i8()
  %3 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
  %4 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
  %5 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
  %6 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
  %7 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
  %8 = call <vscale x 16 x i8> @llvm.experimental.stepvector.nxv16i8()
  %9 = call <vscale x 32 x i8> @llvm.experimental.stepvector.nxv32i8()
  %10 = call <vscale x 64 x i8> @llvm.experimental.stepvector.nxv64i8()
  %11 = call <vscale x 1 x i16> @llvm.experimental.stepvector.nxv1i16()
  %12 = call <vscale x 2 x i16> @llvm.experimental.stepvector.nxv2i16()
  %13 = call <vscale x 4 x i16> @llvm.experimental.stepvector.nxv4i16()
  %14 = call <vscale x 8 x i16> @llvm.experimental.stepvector.nxv8i16()
  %15 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
  %16 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
  %17 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
  %18 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
  %19 = call <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
  %20 = call <vscale x 32 x i16> @llvm.experimental.stepvector.nxv32i16()
  %21 = call <vscale x 1 x i32> @llvm.experimental.stepvector.nxv1i32()
  %22 = call <vscale x 2 x i32> @llvm.experimental.stepvector.nxv2i32()
  %23 = call <vscale x 4 x i32> @llvm.experimental.stepvector.nxv4i32()
  %24 = call <vscale x 8 x i32> @llvm.experimental.stepvector.nxv8i32()
  %25 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
  %26 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
  %27 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
  %28 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
  %29 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
  %30 = call <vscale x 1 x i64> @llvm.experimental.stepvector.nxv1i64()
  %31 = call <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
  %32 = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %33 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
  %34 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
  %35 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
  %36 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
  %37 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
  %38 = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
  %39 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
  %40 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
  %41 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
  %42 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
  %43 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
  %44 = call <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
  ret void
}


declare <vscale x 1 x i8> @llvm.experimental.stepvector.nxv1i8()
declare <vscale x 2 x i8> @llvm.experimental.stepvector.nxv2i8()
declare <vscale x 4 x i8> @llvm.experimental.stepvector.nxv4i8()
declare <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
declare <vscale x 16 x i8> @llvm.experimental.stepvector.nxv16i8()
declare <vscale x 32 x i8> @llvm.experimental.stepvector.nxv32i8()
declare <vscale x 64 x i8> @llvm.experimental.stepvector.nxv64i8()
declare <vscale x 1 x i16> @llvm.experimental.stepvector.nxv1i16()
declare <vscale x 2 x i16> @llvm.experimental.stepvector.nxv2i16()
declare <vscale x 4 x i16> @llvm.experimental.stepvector.nxv4i16()
declare <vscale x 8 x i16> @llvm.experimental.stepvector.nxv8i16()
declare <vscale x 16 x i16> @llvm.experimental.stepvector.nxv16i16()
declare <vscale x 32 x i16> @llvm.experimental.stepvector.nxv32i16()
declare <vscale x 1 x i32> @llvm.experimental.stepvector.nxv1i32()
declare <vscale x 2 x i32> @llvm.experimental.stepvector.nxv2i32()
declare <vscale x 4 x i32> @llvm.experimental.stepvector.nxv4i32()
declare <vscale x 8 x i32> @llvm.experimental.stepvector.nxv8i32()
declare <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
declare <vscale x 1 x i64> @llvm.experimental.stepvector.nxv1i64()
declare <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
declare <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
declare <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
declare <vscale x 16 x i64> @llvm.experimental.stepvector.nxv16i64()
