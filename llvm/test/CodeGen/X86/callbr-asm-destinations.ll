; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-- -verify-machineinstrs < %s | FileCheck %s

define i32 @duplicate_normal_and_indirect_dest(i32 %a) {
; CHECK-LABEL: duplicate_normal_and_indirect_dest:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    addl $4, %eax
; CHECK-NEXT:    #APP
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    jmp .LBB0_1
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:  .LBB0_1: # Block address taken
; CHECK-NEXT:    # %fail
; CHECK-NEXT:    # Label of block must be emitted
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
entry:
  %0 = add i32 %a, 4
  callbr void asm "xorl $0, $0; jmp ${1:l}", "r,!i,~{dirflag},~{fpsr},~{flags}"(i32 %0) to label %fail [label %fail]

fail:
  ret i32 1
}

define i32 @duplicate_indirect_dest(i32 %a) {
; CHECK-LABEL: duplicate_indirect_dest:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    addl $4, %eax
; CHECK-NEXT:    #APP
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    jmp .LBB1_2
; CHECK-NEXT:    jmp .LBB1_2
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:  # %bb.1: # %normal
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB1_2: # Block address taken
; CHECK-NEXT:    # %fail
; CHECK-NEXT:    # Label of block must be emitted
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
entry:
  %0 = add i32 %a, 4
  callbr void asm "xorl $0, $0; jmp ${1:l}; jmp ${2:l}", "r,!i,!i,~{dirflag},~{fpsr},~{flags}"(i32 %0) to label %normal [label %fail, label %fail]

normal:
  ret i32 %0

fail:
  ret i32 1
}
