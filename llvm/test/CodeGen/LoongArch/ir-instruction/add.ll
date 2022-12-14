; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s --check-prefix=LA64

;; Exercise the 'add' LLVM IR: https://llvm.org/docs/LangRef.html#add-instruction

define i1 @add_i1(i1 %x, i1 %y) {
; LA32-LABEL: add_i1:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i1:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i1 %x, %y
  ret i1 %add
}

define i8 @add_i8(i8 %x, i8 %y) {
; LA32-LABEL: add_i8:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i8:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i8 %x, %y
  ret i8 %add
}

define i16 @add_i16(i16 %x, i16 %y) {
; LA32-LABEL: add_i16:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i16:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i16 %x, %y
  ret i16 %add
}

define i32 @add_i32(i32 %x, i32 %y) {
; LA32-LABEL: add_i32:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i32 %x, %y
  ret i32 %add
}

;; Match the pattern:
;; def : PatGprGpr_32<add, ADD_W>;
define signext i32 @add_i32_sext(i32 %x, i32 %y) {
; LA32-LABEL: add_i32_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    add.w $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i32 %x, %y
  ret i32 %add
}

define i64 @add_i64(i64 %x, i64 %y) {
; LA32-LABEL: add_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a1, $a1, $a3
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i64 %x, %y
  ret i64 %add
}

define i1 @add_i1_3(i1 %x) {
; LA32-LABEL: add_i1_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i1_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 1
; LA64-NEXT:    ret
  %add = add i1 %x, 3
  ret i1 %add
}

define i8 @add_i8_3(i8 %x) {
; LA32-LABEL: add_i8_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i8_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i8 %x, 3
  ret i8 %add
}

define i16 @add_i16_3(i16 %x) {
; LA32-LABEL: add_i16_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i16_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i16 %x, 3
  ret i16 %add
}

define i32 @add_i32_3(i32 %x) {
; LA32-LABEL: add_i32_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i32 %x, 3
  ret i32 %add
}

;; Match the pattern:
;; def : PatGprImm_32<add, ADDI_W, simm12>;
define signext i32 @add_i32_3_sext(i32 %x) {
; LA32-LABEL: add_i32_3_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_3_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.w $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i32 %x, 3
  ret i32 %add
}

define i64 @add_i64_3(i64 %x) {
; LA32-LABEL: add_i64_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a2, $a0, 3
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i64 %x, 3
  ret i64 %add
}
