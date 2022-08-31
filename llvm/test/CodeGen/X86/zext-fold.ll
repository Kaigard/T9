; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux -enable-misched=false | FileCheck %s

;; Simple case
define i32 @test1(i8 %x) nounwind readnone {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    andl $-32, %eax
; CHECK-NEXT:    retl
  %A = and i8 %x, -32
  %B = zext i8 %A to i32
  ret i32 %B
}

;; Multiple uses of %x but easily extensible.
define i32 @test2(i8 %x) nounwind readnone {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    andl $-32, %ecx
; CHECK-NEXT:    orl $63, %eax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    retl
  %A = and i8 %x, -32
  %B = zext i8 %A to i32
  %C = or i8 %x, 63
  %D = zext i8 %C to i32
  %E = add i32 %B, %D
  ret i32 %E
}

declare void @use(i32, i8)

;; Multiple uses of %x where we shouldn't extend the load.
define void @test3(i8 %x) nounwind readnone {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subl $12, %esp
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    andl $-32, %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll use@PLT
; CHECK-NEXT:    addl $28, %esp
; CHECK-NEXT:    retl
  %A = and i8 %x, -32
  %B = zext i8 %A to i32
  call void @use(i32 %B, i8 %x)
  ret void
}

