; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i8 @vscale_trunc_i32toi8() vscale_range(1, 255) {
; CHECK-LABEL: @vscale_trunc_i32toi8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i8 @llvm.vscale.i8()
; CHECK-NEXT:    ret i8 [[TMP0]]
entry:
  %0 = call i32 @llvm.vscale.i32()
  %1 = trunc i32 %0 to i8
  ret i8 %1
}


define i8 @vscale_trunc_i32toi8_poison() vscale_range(1, 256) {
; CHECK-LABEL: @vscale_trunc_i32toi8_poison(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[TMP0]] to i8
; CHECK-NEXT:    ret i8 [[TMP1]]
  entry:
  %0 = call i32 @llvm.vscale.i32()
  %1 = trunc i32 %0 to i8
  ret i8 %1
}

define i8 @vscale_trunc_i32toi8_noAttr() {
; CHECK-LABEL: @vscale_trunc_i32toi8_noAttr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[TMP0]] to i8
; CHECK-NEXT:    ret i8 [[TMP1]]
  entry:
  %0 = call i32 @llvm.vscale.i32()
  %1 = trunc i32 %0 to i8
  ret i8 %1
}

declare i32 @llvm.vscale.i32()
