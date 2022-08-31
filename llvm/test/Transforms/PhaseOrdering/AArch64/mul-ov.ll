; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes="default<O3>" -S < %s  | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-unknown"

define i128 @__muloti4(i128 %0, i128 %1, i32* nonnull align 4 %2) {
; CHECK-LABEL: @__muloti4(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[DOTFR:%.*]] = freeze i128 [[TMP1:%.*]]
; CHECK-NEXT:    store i32 0, i32* [[TMP2:%.*]], align 4
; CHECK-NEXT:    [[MUL:%.*]] = tail call { i128, i1 } @llvm.smul.with.overflow.i128(i128 [[TMP0:%.*]], i128 [[DOTFR]])
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i128 [[TMP0]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i128 [[DOTFR]], -170141183460469231731687303715884105728
; CHECK-NEXT:    [[TMP5:%.*]] = and i1 [[TMP3]], [[TMP4]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[THEN7:%.*]], label [[ELSE2:%.*]]
; CHECK:       Else2:
; CHECK-NEXT:    [[MUL_OV:%.*]] = extractvalue { i128, i1 } [[MUL]], 1
; CHECK-NEXT:    br i1 [[MUL_OV]], label [[THEN7]], label [[BLOCK9:%.*]]
; CHECK:       Then7:
; CHECK-NEXT:    store i32 1, i32* [[TMP2]], align 4
; CHECK-NEXT:    br label [[BLOCK9]]
; CHECK:       Block9:
; CHECK-NEXT:    [[MUL_VAL:%.*]] = extractvalue { i128, i1 } [[MUL]], 0
; CHECK-NEXT:    ret i128 [[MUL_VAL]]
;
Entry:
  %3 = alloca i128, align 16
  %4 = alloca i128, align 16
  store i32 0, i32* %2, align 4
  %5 = mul i128 %0, %1
  store i128 %5, i128* %3, align 16
  %6 = icmp slt i128 %0, 0
  br i1 %6, label %Then, label %Else

Then:
  %7 = icmp eq i128 %1, -170141183460469231731687303715884105728
  br label %Block

Else:
  br label %Block

Block:
  %8 = phi i1 [ %7, %Then ], [ false, %Else ]
  br i1 %8, label %Then1, label %Else2

Then1:
  br label %Block6

Else2:
  %9 = icmp ne i128 %0, 0
  br i1 %9, label %Then3, label %Else4

Then3:
  %10 = load i128, i128* %3, align 16
  %11 = sdiv i128 %10, %0
  %12 = icmp ne i128 %11, %1
  br label %Block5

Else4:
  br label %Block5

Block5:
  %13 = phi i1 [ %12, %Then3 ], [ false, %Else4 ]
  br label %Block6

Block6:
  %14 = phi i1 [ true, %Then1 ], [ %13, %Block5 ]
  br i1 %14, label %Then7, label %Else8

Then7:
  store i32 1, i32* %2, align 4
  br label %Block9

Else8:
  br label %Block9

Block9:                                           ; preds = %Else8, %Then7
  %15 = load i128, i128* %3, align 16
  store i128 %15, i128* %4, align 16
  %16 = load i128, i128* %4, align 16
  ret i128 %16
}
