; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -verify-machineinstrs | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown -verify-machineinstrs | FileCheck %s --check-prefix=X86

; This test is targeted at 64-bit mode. It used to crash due to the creation of an EXTRACT_SUBREG after the peephole pass had ran.
define void @f() {
; X64-LABEL: f:
; X64:       # %bb.0: # %BB
; X64-NEXT:    movzbl (%rax), %eax
; X64-NEXT:    cmpb $0, (%rax)
; X64-NEXT:    setne (%rax)
; X64-NEXT:    leaq -{{[0-9]+}}(%rsp), %rax
; X64-NEXT:    movq %rax, (%rax)
; X64-NEXT:    movb $0, (%rax)
; X64-NEXT:    retq
;
; X86-LABEL: f:
; X86:       # %bb.0: # %BB
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    movzbl (%eax), %eax
; X86-NEXT:    cmpb $0, (%eax)
; X86-NEXT:    setne (%eax)
; X86-NEXT:    leal -{{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%eax)
; X86-NEXT:    movb $0, (%eax)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
BB:
  %A30 = alloca i66
  %L17 = load i66, ptr %A30
  %B20 = and i66 %L17, -1
  %G2 = getelementptr i66, ptr %A30, i1 true
  %L10 = load volatile i8, ptr undef
  %L11 = load volatile i8, ptr undef
  %B6 = udiv i8 %L10, %L11
  %C15 = icmp eq i8 %L11, 0
  %B8 = srem i66 0, %B20
  %C2 = icmp ule i66 %B8, %B20
  %B5 = or i8 0, %B6
  %C19 = icmp uge i1 false, %C2
  %C1 = icmp sle i8 undef, %B5
  %B37 = srem i1 %C1, %C2
  %C7 = icmp uge i1 false, %C15
  store i1 %C7, ptr undef
  %G6 = getelementptr i66, ptr %G2, i1 %B37
  store ptr %G6, ptr undef
  %B30 = srem i1 %C19, %C7
  store i1 %B30, ptr undef
  ret void
}

; Similar to above, but bitwidth adjusted to target 32-bit mode. This also shows that we didn't constrain the register class when extracting a subreg.
define void @g() {
; X64-LABEL: g:
; X64:       # %bb.0: # %BB
; X64-NEXT:    movzbl (%rax), %eax
; X64-NEXT:    cmpb $0, (%rax)
; X64-NEXT:    setne (%rax)
; X64-NEXT:    leaq -{{[0-9]+}}(%rsp), %rax
; X64-NEXT:    movq %rax, (%rax)
; X64-NEXT:    movb $0, (%rax)
; X64-NEXT:    retq
;
; X86-LABEL: g:
; X86:       # %bb.0: # %BB
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    movzbl (%eax), %eax
; X86-NEXT:    cmpb $0, (%eax)
; X86-NEXT:    setne (%eax)
; X86-NEXT:    leal -{{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%eax)
; X86-NEXT:    movb $0, (%eax)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
BB:
  %A30 = alloca i34
  %L17 = load i34, ptr %A30
  %B20 = and i34 %L17, -1
  %G2 = getelementptr i34, ptr %A30, i1 true
  %L10 = load volatile i8, ptr undef
  %L11 = load volatile i8, ptr undef
  %B6 = udiv i8 %L10, %L11
  %C15 = icmp eq i8 %L11, 0
  %B8 = srem i34 0, %B20
  %C2 = icmp ule i34 %B8, %B20
  %B5 = or i8 0, %B6
  %C19 = icmp uge i1 false, %C2
  %C1 = icmp sle i8 undef, %B5
  %B37 = srem i1 %C1, %C2
  %C7 = icmp uge i1 false, %C15
  store i1 %C7, ptr undef
  %G6 = getelementptr i34, ptr %G2, i1 %B37
  store ptr %G6, ptr undef
  %B30 = srem i1 %C19, %C7
  store i1 %B30, ptr undef
  ret void
}
