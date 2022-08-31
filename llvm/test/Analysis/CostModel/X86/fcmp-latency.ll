; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+sse2 | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+sse3 | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+ssse3 | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+sse4.1 | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+sse4.2 | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+avx | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+avx2 | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+avx512f | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mattr=+avx512f,+avx512bw | FileCheck %s
;
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mcpu=slm | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mcpu=goldmont | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-- -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=latency -mcpu=btver2 | FileCheck %s

define i32 @cmp_float_oeq(i32 %arg) {
; CHECK-LABEL: 'cmp_float_oeq'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp oeq float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp oeq <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp oeq <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp oeq <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp oeq <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp oeq double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp oeq <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp oeq <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp oeq <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp oeq <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp oeq float undef, undef
  %V2F32 = fcmp oeq <2 x float> undef, undef
  %V4F32 = fcmp oeq <4 x float> undef, undef
  %V8F32 = fcmp oeq <8 x float> undef, undef
  %V16F32 = fcmp oeq <16 x float> undef, undef

  %F64 = fcmp oeq double undef, undef
  %V2F64 = fcmp oeq <2 x double> undef, undef
  %V4F64 = fcmp oeq <4 x double> undef, undef
  %V8F64 = fcmp oeq <8 x double> undef, undef
  %V16F64 = fcmp oeq <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_one(i32 %arg) {
; CHECK-LABEL: 'cmp_float_one'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp one float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp one <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp one <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp one <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp one <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp one double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp one <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp one <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp one <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp one <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp one float undef, undef
  %V2F32 = fcmp one <2 x float> undef, undef
  %V4F32 = fcmp one <4 x float> undef, undef
  %V8F32 = fcmp one <8 x float> undef, undef
  %V16F32 = fcmp one <16 x float> undef, undef

  %F64 = fcmp one double undef, undef
  %V2F64 = fcmp one <2 x double> undef, undef
  %V4F64 = fcmp one <4 x double> undef, undef
  %V8F64 = fcmp one <8 x double> undef, undef
  %V16F64 = fcmp one <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_ord(i32 %arg) {
; CHECK-LABEL: 'cmp_float_ord'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp ord float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp ord <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp ord <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp ord <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp ord <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp ord double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp ord <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp ord <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp ord <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp ord <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp ord float undef, undef
  %V2F32 = fcmp ord <2 x float> undef, undef
  %V4F32 = fcmp ord <4 x float> undef, undef
  %V8F32 = fcmp ord <8 x float> undef, undef
  %V16F32 = fcmp ord <16 x float> undef, undef

  %F64 = fcmp ord double undef, undef
  %V2F64 = fcmp ord <2 x double> undef, undef
  %V4F64 = fcmp ord <4 x double> undef, undef
  %V8F64 = fcmp ord <8 x double> undef, undef
  %V16F64 = fcmp ord <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_oge(i32 %arg) {
; CHECK-LABEL: 'cmp_float_oge'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp oge float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp oge <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp oge <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp oge <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp oge <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp oge double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp oge <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp oge <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp oge <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp oge <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp oge float undef, undef
  %V2F32 = fcmp oge <2 x float> undef, undef
  %V4F32 = fcmp oge <4 x float> undef, undef
  %V8F32 = fcmp oge <8 x float> undef, undef
  %V16F32 = fcmp oge <16 x float> undef, undef

  %F64 = fcmp oge double undef, undef
  %V2F64 = fcmp oge <2 x double> undef, undef
  %V4F64 = fcmp oge <4 x double> undef, undef
  %V8F64 = fcmp oge <8 x double> undef, undef
  %V16F64 = fcmp oge <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_ogt(i32 %arg) {
; CHECK-LABEL: 'cmp_float_ogt'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp ogt float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp ogt <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp ogt <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp ogt <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp ogt <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp ogt double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp ogt <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp ogt <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp ogt <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp ogt <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp ogt float undef, undef
  %V2F32 = fcmp ogt <2 x float> undef, undef
  %V4F32 = fcmp ogt <4 x float> undef, undef
  %V8F32 = fcmp ogt <8 x float> undef, undef
  %V16F32 = fcmp ogt <16 x float> undef, undef

  %F64 = fcmp ogt double undef, undef
  %V2F64 = fcmp ogt <2 x double> undef, undef
  %V4F64 = fcmp ogt <4 x double> undef, undef
  %V8F64 = fcmp ogt <8 x double> undef, undef
  %V16F64 = fcmp ogt <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_ole(i32 %arg) {
; CHECK-LABEL: 'cmp_float_ole'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp ole float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp ole <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp ole <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp ole <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp ole <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp ole double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp ole <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp ole <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp ole <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp ole <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp ole float undef, undef
  %V2F32 = fcmp ole <2 x float> undef, undef
  %V4F32 = fcmp ole <4 x float> undef, undef
  %V8F32 = fcmp ole <8 x float> undef, undef
  %V16F32 = fcmp ole <16 x float> undef, undef

  %F64 = fcmp ole double undef, undef
  %V2F64 = fcmp ole <2 x double> undef, undef
  %V4F64 = fcmp ole <4 x double> undef, undef
  %V8F64 = fcmp ole <8 x double> undef, undef
  %V16F64 = fcmp ole <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_olt(i32 %arg) {
; CHECK-LABEL: 'cmp_float_olt'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp olt float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp olt <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp olt <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp olt <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp olt <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp olt double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp olt <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp olt <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp olt <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp olt <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp olt float undef, undef
  %V2F32 = fcmp olt <2 x float> undef, undef
  %V4F32 = fcmp olt <4 x float> undef, undef
  %V8F32 = fcmp olt <8 x float> undef, undef
  %V16F32 = fcmp olt <16 x float> undef, undef

  %F64 = fcmp olt double undef, undef
  %V2F64 = fcmp olt <2 x double> undef, undef
  %V4F64 = fcmp olt <4 x double> undef, undef
  %V8F64 = fcmp olt <8 x double> undef, undef
  %V16F64 = fcmp olt <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_ueq(i32 %arg) {
; CHECK-LABEL: 'cmp_float_ueq'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp ueq float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp ueq <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp ueq <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp ueq <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp ueq <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp ueq double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp ueq <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp ueq <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp ueq <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp ueq <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp ueq float undef, undef
  %V2F32 = fcmp ueq <2 x float> undef, undef
  %V4F32 = fcmp ueq <4 x float> undef, undef
  %V8F32 = fcmp ueq <8 x float> undef, undef
  %V16F32 = fcmp ueq <16 x float> undef, undef

  %F64 = fcmp ueq double undef, undef
  %V2F64 = fcmp ueq <2 x double> undef, undef
  %V4F64 = fcmp ueq <4 x double> undef, undef
  %V8F64 = fcmp ueq <8 x double> undef, undef
  %V16F64 = fcmp ueq <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_une(i32 %arg) {
; CHECK-LABEL: 'cmp_float_une'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp une float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp une <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp une <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp une <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp une <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp une double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp une <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp une <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp une <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp une <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp une float undef, undef
  %V2F32 = fcmp une <2 x float> undef, undef
  %V4F32 = fcmp une <4 x float> undef, undef
  %V8F32 = fcmp une <8 x float> undef, undef
  %V16F32 = fcmp une <16 x float> undef, undef

  %F64 = fcmp une double undef, undef
  %V2F64 = fcmp une <2 x double> undef, undef
  %V4F64 = fcmp une <4 x double> undef, undef
  %V8F64 = fcmp une <8 x double> undef, undef
  %V16F64 = fcmp une <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_uno(i32 %arg) {
; CHECK-LABEL: 'cmp_float_uno'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp uno float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp uno <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp uno <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp uno <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp uno <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp uno double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp uno <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp uno <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp uno <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp uno <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp uno float undef, undef
  %V2F32 = fcmp uno <2 x float> undef, undef
  %V4F32 = fcmp uno <4 x float> undef, undef
  %V8F32 = fcmp uno <8 x float> undef, undef
  %V16F32 = fcmp uno <16 x float> undef, undef

  %F64 = fcmp uno double undef, undef
  %V2F64 = fcmp uno <2 x double> undef, undef
  %V4F64 = fcmp uno <4 x double> undef, undef
  %V8F64 = fcmp uno <8 x double> undef, undef
  %V16F64 = fcmp uno <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_uge(i32 %arg) {
; CHECK-LABEL: 'cmp_float_uge'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp uge float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp uge <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp uge <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp uge <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp uge <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp uge double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp uge <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp uge <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp uge <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp uge <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp uge float undef, undef
  %V2F32 = fcmp uge <2 x float> undef, undef
  %V4F32 = fcmp uge <4 x float> undef, undef
  %V8F32 = fcmp uge <8 x float> undef, undef
  %V16F32 = fcmp uge <16 x float> undef, undef

  %F64 = fcmp uge double undef, undef
  %V2F64 = fcmp uge <2 x double> undef, undef
  %V4F64 = fcmp uge <4 x double> undef, undef
  %V8F64 = fcmp uge <8 x double> undef, undef
  %V16F64 = fcmp uge <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_ugt(i32 %arg) {
; CHECK-LABEL: 'cmp_float_ugt'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp ugt float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp ugt <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp ugt <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp ugt <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp ugt <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp ugt double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp ugt <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp ugt <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp ugt <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp ugt <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp ugt float undef, undef
  %V2F32 = fcmp ugt <2 x float> undef, undef
  %V4F32 = fcmp ugt <4 x float> undef, undef
  %V8F32 = fcmp ugt <8 x float> undef, undef
  %V16F32 = fcmp ugt <16 x float> undef, undef

  %F64 = fcmp ugt double undef, undef
  %V2F64 = fcmp ugt <2 x double> undef, undef
  %V4F64 = fcmp ugt <4 x double> undef, undef
  %V8F64 = fcmp ugt <8 x double> undef, undef
  %V16F64 = fcmp ugt <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_ule(i32 %arg) {
; CHECK-LABEL: 'cmp_float_ule'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp ule float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp ule <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp ule <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp ule <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp ule <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp ule double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp ule <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp ule <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp ule <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp ule <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp ule float undef, undef
  %V2F32 = fcmp ule <2 x float> undef, undef
  %V4F32 = fcmp ule <4 x float> undef, undef
  %V8F32 = fcmp ule <8 x float> undef, undef
  %V16F32 = fcmp ule <16 x float> undef, undef

  %F64 = fcmp ule double undef, undef
  %V2F64 = fcmp ule <2 x double> undef, undef
  %V4F64 = fcmp ule <4 x double> undef, undef
  %V8F64 = fcmp ule <8 x double> undef, undef
  %V16F64 = fcmp ule <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_ult(i32 %arg) {
; CHECK-LABEL: 'cmp_float_ult'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp ult float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp ult <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp ult <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp ult <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp ult <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp ult double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp ult <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp ult <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp ult <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp ult <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp ult float undef, undef
  %V2F32 = fcmp ult <2 x float> undef, undef
  %V4F32 = fcmp ult <4 x float> undef, undef
  %V8F32 = fcmp ult <8 x float> undef, undef
  %V16F32 = fcmp ult <16 x float> undef, undef

  %F64 = fcmp ult double undef, undef
  %V2F64 = fcmp ult <2 x double> undef, undef
  %V4F64 = fcmp ult <4 x double> undef, undef
  %V8F64 = fcmp ult <8 x double> undef, undef
  %V16F64 = fcmp ult <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_false(i32 %arg) {
; CHECK-LABEL: 'cmp_float_false'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp false float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp false <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp false <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp false <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp false <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp false double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp false <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp false <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp false <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp false <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp false float undef, undef
  %V2F32 = fcmp false <2 x float> undef, undef
  %V4F32 = fcmp false <4 x float> undef, undef
  %V8F32 = fcmp false <8 x float> undef, undef
  %V16F32 = fcmp false <16 x float> undef, undef

  %F64 = fcmp false double undef, undef
  %V2F64 = fcmp false <2 x double> undef, undef
  %V4F64 = fcmp false <4 x double> undef, undef
  %V8F64 = fcmp false <8 x double> undef, undef
  %V16F64 = fcmp false <16 x double> undef, undef

  ret i32 undef
}

define i32 @cmp_float_true(i32 %arg) {
; CHECK-LABEL: 'cmp_float_true'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = fcmp true float undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F32 = fcmp true <2 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = fcmp true <4 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = fcmp true <8 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = fcmp true <16 x float> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = fcmp true double undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = fcmp true <2 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = fcmp true <4 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = fcmp true <8 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F64 = fcmp true <16 x double> undef, undef
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %F32 = fcmp true float undef, undef
  %V2F32 = fcmp true <2 x float> undef, undef
  %V4F32 = fcmp true <4 x float> undef, undef
  %V8F32 = fcmp true <8 x float> undef, undef
  %V16F32 = fcmp true <16 x float> undef, undef

  %F64 = fcmp true double undef, undef
  %V2F64 = fcmp true <2 x double> undef, undef
  %V4F64 = fcmp true <4 x double> undef, undef
  %V8F64 = fcmp true <8 x double> undef, undef
  %V16F64 = fcmp true <16 x double> undef, undef

  ret i32 undef
}
