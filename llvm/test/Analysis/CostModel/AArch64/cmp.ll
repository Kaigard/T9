; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -mtriple=aarch64-- < %s | FileCheck %s --check-prefix=CHECK-THROUGHPUT
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=code-size -mtriple=aarch64-- < %s | FileCheck %s --check-prefix=CHECK-SIZE

define i32 @cmps() {
; CHECK-THROUGHPUT-LABEL: 'cmps'
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a0 = icmp slt i8 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a1 = icmp ult i16 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a2 = icmp sge i32 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a3 = icmp ne i64 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = icmp slt <16 x i8> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a5 = icmp ult <8 x i16> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = icmp sge <4 x i32> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a7 = fcmp oge half undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a8 = fcmp ogt float undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a9 = fcmp ogt double undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 29 for instruction: %a10 = fcmp olt <8 x half> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a11 = fcmp oge <4 x float> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a12 = fcmp oge <2 x double> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; CHECK-SIZE-LABEL: 'cmps'
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a0 = icmp slt i8 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a1 = icmp ult i16 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a2 = icmp sge i32 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a3 = icmp ne i64 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = icmp slt <16 x i8> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a5 = icmp ult <8 x i16> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = icmp sge <4 x i32> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a7 = fcmp oge half undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a8 = fcmp ogt float undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a9 = fcmp ogt double undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a10 = fcmp olt <8 x half> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a11 = fcmp oge <4 x float> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a12 = fcmp oge <2 x double> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %a0 = icmp slt i8 undef, undef
  %a1 = icmp ult i16 undef, undef
  %a2 = icmp sge i32 undef, undef
  %a3 = icmp ne i64 undef, undef
  %a4 = icmp slt <16 x i8> undef, undef
  %a5 = icmp ult <8 x i16> undef, undef
  %a6 = icmp sge <4 x i32> undef, undef
  %a7 = fcmp oge half undef, undef
  %a8 = fcmp ogt float undef, undef
  %a9 = fcmp ogt double undef, undef
  %a10 = fcmp olt <8 x half> undef, undef
  %a11 = fcmp oge <4 x float> undef, undef
  %a12 = fcmp oge <2 x double> undef, undef
  ret i32 undef
}
