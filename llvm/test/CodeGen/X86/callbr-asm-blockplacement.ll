; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

; This test asserted in MachineBlockPlacement during asm-goto bring up.

%struct.wibble = type { %struct.pluto, i32, ptr }
%struct.pluto = type { i32, i32, i32 }

@global = external dso_local global [0 x %struct.wibble]

define i32 @foo(i32 %arg, ptr %arg3) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    movabsq $-2305847407260205056, %rbx # imm = 0xDFFFFC0000000000
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB0_5
; CHECK-NEXT:  # %bb.1: # %bb5
; CHECK-NEXT:    movq %rsi, %r14
; CHECK-NEXT:    movslq %edi, %rbp
; CHECK-NEXT:    leaq (,%rbp,8), %rax
; CHECK-NEXT:    leaq global(%rax,%rax,2), %r15
; CHECK-NEXT:    leaq global+4(%rax,%rax,2), %r12
; CHECK-NEXT:    xorl %r13d, %r13d
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_2: # %bb8
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    movq %rax, %rbx
; CHECK-NEXT:    movq %rax, %rdi
; CHECK-NEXT:    callq *%r14
; CHECK-NEXT:    movq %r15, %rdi
; CHECK-NEXT:    callq hoge@PLT
; CHECK-NEXT:    movq %r12, %rdi
; CHECK-NEXT:    callq hoge@PLT
; CHECK-NEXT:    testb %r13b, %r13b
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # %bb.3: # %bb15
; CHECK-NEXT:    leaq (%rbp,%rbp,2), %rax
; CHECK-NEXT:    movq %rbx, global+16(,%rax,8)
; CHECK-NEXT:    movabsq $-2305847407260205056, %rbx # imm = 0xDFFFFC0000000000
; CHECK-NEXT:    #APP
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:  # %bb.4: # %bb17
; CHECK-NEXT:    callq widget@PLT
; CHECK-NEXT:  .LBB0_5: # Block address taken
; CHECK-NEXT:    # %bb18
; CHECK-NEXT:    # Label of block must be emitted
; CHECK-NEXT:    movw $0, 14(%rbx)
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
bb:
  %tmp = add i64 0, -2305847407260205056
  %tmp4 = sext i32 %arg to i64
  br i1 undef, label %bb18, label %bb5

bb5:                                              ; preds = %bb
  %tmp6 = getelementptr [0 x %struct.wibble], ptr @global, i64 0, i64 %tmp4, i32 0, i32 0
  %tmp7 = getelementptr [0 x %struct.wibble], ptr @global, i64 0, i64 %tmp4, i32 0, i32 1
  br label %bb8

bb8:                                              ; preds = %bb8, %bb5
  %tmp9 = call ptr @bar(i64 undef)
  %tmp10 = call i32 %arg3(ptr nonnull %tmp9)
  %tmp11 = ptrtoint ptr %tmp6 to i64
  call void @hoge(i64 %tmp11)
  %tmp12 = ptrtoint ptr %tmp7 to i64
  %tmp13 = add i64 undef, -2305847407260205056
  call void @hoge(i64 %tmp12)
  %tmp14 = icmp eq i32 0, 0
  br i1 %tmp14, label %bb15, label %bb8

bb15:                                             ; preds = %bb8
  %tmp16 = getelementptr [0 x %struct.wibble], ptr @global, i64 0, i64 %tmp4, i32 2
  store ptr %tmp9, ptr %tmp16
  callbr void asm sideeffect "", "!i"()
          to label %bb17 [label %bb18]

bb17:                                             ; preds = %bb15
  call void @widget()
  br label %bb18

bb18:                                             ; preds = %bb17, %bb15, %bb
  %tmp19 = add i64 %tmp, 14
  %tmp20 = inttoptr i64 %tmp19 to ptr
  store i16 0, ptr %tmp20
  ret i32 undef
}

declare ptr @bar(i64)

declare void @widget()

declare void @hoge(i64)