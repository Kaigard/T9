; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv64 -mattr=+m | FileCheck %s

declare i15 @llvm.ctlz.i15(i15, i1)

define i15 @foo(i15 %x) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    slli a1, a0, 49
; CHECK-NEXT:    srli a2, a1, 49
; CHECK-NEXT:    beqz a2, .LBB0_2
; CHECK-NEXT:  # %bb.1: # %cond.false
; CHECK-NEXT:    srli a1, a1, 50
; CHECK-NEXT:    or a0, a0, a1
; CHECK-NEXT:    slli a1, a0, 49
; CHECK-NEXT:    srli a1, a1, 51
; CHECK-NEXT:    or a0, a0, a1
; CHECK-NEXT:    slli a1, a0, 49
; CHECK-NEXT:    srli a1, a1, 53
; CHECK-NEXT:    or a0, a0, a1
; CHECK-NEXT:    slli a1, a0, 49
; CHECK-NEXT:    srli a1, a1, 57
; CHECK-NEXT:    or a0, a0, a1
; CHECK-NEXT:    not a0, a0
; CHECK-NEXT:    slli a0, a0, 49
; CHECK-NEXT:    srli a0, a0, 49
; CHECK-NEXT:    lui a1, %hi(.LCPI0_0)
; CHECK-NEXT:    ld a1, %lo(.LCPI0_0)(a1)
; CHECK-NEXT:    lui a2, %hi(.LCPI0_1)
; CHECK-NEXT:    ld a2, %lo(.LCPI0_1)(a2)
; CHECK-NEXT:    srli a3, a0, 1
; CHECK-NEXT:    and a1, a3, a1
; CHECK-NEXT:    sub a0, a0, a1
; CHECK-NEXT:    and a1, a0, a2
; CHECK-NEXT:    srli a0, a0, 2
; CHECK-NEXT:    and a0, a0, a2
; CHECK-NEXT:    add a0, a1, a0
; CHECK-NEXT:    lui a1, %hi(.LCPI0_2)
; CHECK-NEXT:    ld a1, %lo(.LCPI0_2)(a1)
; CHECK-NEXT:    lui a2, %hi(.LCPI0_3)
; CHECK-NEXT:    ld a2, %lo(.LCPI0_3)(a2)
; CHECK-NEXT:    srli a3, a0, 4
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:    and a0, a0, a1
; CHECK-NEXT:    mul a0, a0, a2
; CHECK-NEXT:    srli a0, a0, 56
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    li a0, 15
; CHECK-NEXT:    ret
  %a = call i15 @llvm.ctlz.i15(i15 %x, i1 false)
  ret i15 %a
}
