; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -interleaved-load-combine -S -verify-memoryssa %s | FileCheck %s

target triple = "arm64-apple-darwin"

declare void @clobber(<2 x double>)

define void @rename_uses(ptr %src, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @rename_uses(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[OUTER_LATCH:%.*]], label [[INNER]]
; CHECK:       outer.latch:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[EXIT:%.*]], label [[OUTER_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    [[GEP_0:%.*]] = getelementptr inbounds [12 x double], ptr [[SRC:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[GEP_4:%.*]] = getelementptr [12 x double], ptr [[SRC]], i64 0, i64 4
; CHECK-NEXT:    [[INTERLEAVED_WIDE_LOAD:%.*]] = load <8 x double>, ptr [[GEP_0]], align 8
; CHECK-NEXT:    [[L_0:%.*]] = load <4 x double>, ptr [[GEP_0]], align 8
; CHECK-NEXT:    [[L_4:%.*]] = load <4 x double>, ptr [[GEP_4]], align 8
; CHECK-NEXT:    [[INTERLEAVED_SHUFFLE:%.*]] = shufflevector <8 x double> [[INTERLEAVED_WIDE_LOAD]], <8 x double> poison, <2 x i32> <i32 0, i32 4>
; CHECK-NEXT:    [[S_0:%.*]] = shufflevector <4 x double> [[L_0]], <4 x double> [[L_4]], <2 x i32> <i32 0, i32 4>
; CHECK-NEXT:    [[INTERLEAVED_SHUFFLE1:%.*]] = shufflevector <8 x double> [[INTERLEAVED_WIDE_LOAD]], <8 x double> poison, <2 x i32> <i32 1, i32 5>
; CHECK-NEXT:    [[S_1:%.*]] = shufflevector <4 x double> [[L_0]], <4 x double> [[L_4]], <2 x i32> <i32 1, i32 5>
; CHECK-NEXT:    [[INTERLEAVED_SHUFFLE2:%.*]] = shufflevector <8 x double> [[INTERLEAVED_WIDE_LOAD]], <8 x double> poison, <2 x i32> <i32 2, i32 6>
; CHECK-NEXT:    [[S_2:%.*]] = shufflevector <4 x double> [[L_0]], <4 x double> [[L_4]], <2 x i32> <i32 2, i32 6>
; CHECK-NEXT:    [[INTERLEAVED_SHUFFLE3:%.*]] = shufflevector <8 x double> [[INTERLEAVED_WIDE_LOAD]], <8 x double> poison, <2 x i32> <i32 3, i32 7>
; CHECK-NEXT:    [[S_3:%.*]] = shufflevector <4 x double> [[L_0]], <4 x double> [[L_4]], <2 x i32> <i32 3, i32 7>
; CHECK-NEXT:    call void @clobber(<2 x double> [[INTERLEAVED_SHUFFLE]])
; CHECK-NEXT:    call void @clobber(<2 x double> [[INTERLEAVED_SHUFFLE1]])
; CHECK-NEXT:    call void @clobber(<2 x double> [[INTERLEAVED_SHUFFLE2]])
; CHECK-NEXT:    call void @clobber(<2 x double> [[INTERLEAVED_SHUFFLE3]])
; CHECK-NEXT:    ret void
;
bb:
  br label %outer.header

outer.header:
  br label %inner

inner:
  br i1 %c.1, label %outer.latch, label %inner

outer.latch:
  br i1 %c.2, label %exit, label %outer.header

exit:
  %gep.0 = getelementptr inbounds [ 12 x double ], ptr %src, i64 0, i64 0
  %gep.4 = getelementptr [ 12 x double ], ptr %src, i64 0, i64 4
  %l.0 = load <4 x double>, ptr %gep.0, align 8
  %l.4 = load <4 x double>, ptr %gep.4, align 8
  %s.0 = shufflevector <4 x double> %l.0, <4 x double> %l.4, <2 x i32> <i32 0, i32 4>
  %s.1 = shufflevector <4 x double> %l.0, <4 x double> %l.4, <2 x i32> <i32 1, i32 5>
  %s.2 = shufflevector <4 x double> %l.0, <4 x double> %l.4, <2 x i32> <i32 2, i32 6>
  %s.3 = shufflevector <4 x double> %l.0, <4 x double> %l.4, <2 x i32> <i32 3, i32 7>
  call void @clobber(<2 x double> %s.0)
  call void @clobber(<2 x double> %s.1)
  call void @clobber(<2 x double> %s.2)
  call void @clobber(<2 x double> %s.3)
  ret void
}
