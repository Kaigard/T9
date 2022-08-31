; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='dse' -S %s | FileCheck %s

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

; Test case from PR50220.
define i32 @other_value_escapes_before_call() {
; CHECK-LABEL: @other_value_escapes_before_call(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V1:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[V2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 0, i32* [[V1]], align 4
; CHECK-NEXT:    call void @escape(i32* nonnull [[V1]])
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 [[CALL]], i32* [[V2]], align 4
; CHECK-NEXT:    call void @escape(i32* nonnull [[V2]])
; CHECK-NEXT:    [[LOAD_V2:%.*]] = load i32, i32* [[V2]], align 4
; CHECK-NEXT:    [[LOAD_V1:%.*]] = load i32, i32* [[V1]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[LOAD_V2]], [[LOAD_V1]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %v1 = alloca i32, align 4
  %v2 = alloca i32, align 4
  store i32 0, i32* %v1, align 4
  call void @escape(i32* nonnull %v1)
  store i32 55555, i32* %v2, align 4
  %call = call i32 @getval()
  store i32 %call, i32* %v2, align 4
  call void @escape(i32* nonnull %v2)
  %load.v2 = load i32, i32* %v2, align 4
  %load.v1 = load i32, i32* %v1, align 4
  %add = add nsw i32 %load.v2, %load.v1
  ret i32 %add
}

declare void @escape(i32*)

declare i32 @getval()

declare void @escape_and_clobber(i32*)
declare void @escape_writeonly(i32*) writeonly
declare void @clobber()

define i32 @test_not_captured_before_call_same_bb() {
; CHECK-LABEL: @test_not_captured_before_call_same_bb(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  call void @escape_and_clobber(i32* %a)
  ret i32 %r
}

define i32 @test_not_captured_before_call_same_bb_escape_unreachable_block() {
; CHECK-LABEL: @test_not_captured_before_call_same_bb_escape_unreachable_block(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 [[R]]
; CHECK:       unreach:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 0
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  call void @escape_and_clobber(i32* %a)
  ret i32 %r

unreach:
  call void @escape_and_clobber(i32* %a)
  ret i32 0
}

define i32 @test_captured_and_clobbered_after_load_same_bb_2() {
; CHECK-LABEL: @test_captured_and_clobbered_after_load_same_bb_2(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  call void @escape_and_clobber(i32* %a)
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %r
}

define i32 @test_captured_after_call_same_bb_2_clobbered_later() {
; CHECK-LABEL: @test_captured_after_call_same_bb_2_clobbered_later(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  call void @escape_writeonly(i32* %a)
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %r
}

define i32 @test_captured_sibling_path_to_call_other_blocks_1(i1 %c.1) {
; CHECK-LABEL: @test_captured_sibling_path_to_call_other_blocks_1(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[R]], [[ELSE]] ]
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[P]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br i1 %c.1, label %then, label %else

then:
  call void @escape_writeonly(i32* %a)
  br label %exit

else:
  %r = call i32 @getval()
  br label %exit

exit:
  %p = phi i32 [ 0, %then ], [ %r, %else ]
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %p
}

define i32 @test_captured_before_call_other_blocks_2(i1 %c.1) {
; CHECK-LABEL: @test_captured_before_call_other_blocks_2(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[R]], [[ELSE]] ]
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[P]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br i1 %c.1, label %then, label %else

then:
  br label %exit

else:
  call void @escape_and_clobber(i32* %a)
  %r = call i32 @getval()
  br label %exit

exit:
  %p = phi i32 [ 0, %then ], [ %r, %else ]
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %p
}

define i32 @test_captured_before_call_other_blocks_4(i1 %c.1) {
; CHECK-LABEL: @test_captured_before_call_other_blocks_4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[R]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[P]]
;
entry:
  %a = alloca i32, align 4
  store i32 55, i32* %a
  call void @escape_writeonly(i32* %a)
  %r = call i32 @getval()
  br i1 %c.1, label %then, label %exit

then:
  call void @escape_writeonly(i32* %a)
  br label %exit

exit:
  %p = phi i32 [ 0, %then ], [ %r, %entry ]
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %p
}

define i32 @test_captured_before_call_other_blocks_5(i1 %c.1) {
; CHECK-LABEL: @test_captured_before_call_other_blocks_5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br i1 %c.1, label %then, label %exit

then:
  call void @escape_writeonly(i32* %a)
  br label %exit

exit:
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %r
}

define i32 @test_captured_before_call_other_blocks_6(i1 %c.1) {
; CHECK-LABEL: @test_captured_before_call_other_blocks_6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br i1 %c.1, label %then, label %exit

then:
  call void @escape_writeonly(i32* %a)
  br label %exit

exit:
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  call void @escape_writeonly(i32* %a)
  call void @clobber()
  ret i32 %r
}

define i32 @test_not_captured_before_call_other_blocks_1(i1 %c.1) {
; CHECK-LABEL: @test_not_captured_before_call_other_blocks_1(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  br i1 %c.1, label %then, label %else

then:
  br label %exit

else:
  br label %exit

exit:
  call void @escape_and_clobber(i32* %a)
  ret i32 %r
}

define i32 @test_not_captured_before_call_other_blocks_2(i1 %c.1) {
; CHECK-LABEL: @test_not_captured_before_call_other_blocks_2(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  br i1 %c.1, label %then, label %else

then:
  call void @escape_and_clobber(i32* %a)
  br label %exit

else:
  call void @escape_and_clobber(i32* %a)
  br label %exit

exit:
  ret i32 %r
}

define i32 @test_not_captured_before_call_other_blocks_3(i1 %c.1) {
; CHECK-LABEL: @test_not_captured_before_call_other_blocks_3(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  br i1 %c.1, label %then, label %else

then:
  call void @escape_and_clobber(i32* %a)
  br label %exit

else:
  br label %exit

exit:
  ret i32 %r
}

define i32 @test_not_captured_before_call_other_blocks_4(i1 %c.1) {
; CHECK-LABEL: @test_not_captured_before_call_other_blocks_4(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[R]], [[ELSE]] ]
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[P]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br i1 %c.1, label %then, label %else

then:
  br label %exit

else:
  %r = call i32 @getval()
  call void @escape_writeonly(i32* %a)
  br label %exit

exit:
  %p = phi i32 [ 0, %then ], [ %r, %else ]
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %p
}

define i32 @test_not_captured_before_call_other_blocks_5(i1 %c.1) {
; CHECK-LABEL: @test_not_captured_before_call_other_blocks_5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ [[R]], [[THEN]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[P]]
;
entry:
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br i1 %c.1, label %then, label %exit

then:
  %r = call i32 @getval()
  call void @escape_writeonly(i32* %a)
  br label %exit

exit:
  %p = phi i32 [ %r, %then ], [ 0, %entry ]
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %p
}

define i32 @test_not_captured_before_call_other_blocks_6(i1 %c.1) {
; CHECK-LABEL: @test_not_captured_before_call_other_blocks_6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ [[R]], [[THEN]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[P]]
;
entry:
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br i1 %c.1, label %then, label %exit

then:
  %r = call i32 @getval()
  call void @escape_writeonly(i32* %a)
  br label %exit

exit:
  %p = phi i32 [ %r, %then ], [ 0, %entry ]
  store i32 99, i32* %a, align 4
  call void @escape_writeonly(i32* %a)
  call void @clobber()
  ret i32 %p
}

define i32 @test_not_captured_before_call_other_blocks_7(i1 %c.1) {
; CHECK-LABEL: @test_not_captured_before_call_other_blocks_7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[R]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret i32 [[P]]
;
entry:
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  call void @escape_writeonly(i32* %a)
  br i1 %c.1, label %then, label %exit

then:
  call void @escape_writeonly(i32* %a)
  br label %exit

exit:
  %p = phi i32 [ 0, %then ], [ %r, %entry ]
  store i32 99, i32* %a, align 4
  call void @clobber()
  ret i32 %p
}

define i32 @test_not_captured_before_call_same_bb_but_read() {
; CHECK-LABEL: @test_not_captured_before_call_same_bb_but_read(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    [[LV:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[R]], [[LV]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  %r = call i32 @getval()
  %lv = load i32, i32* %a
  store i32 99, i32* %a, align 4
  call void @escape_and_clobber(i32* %a)
  %res = add i32 %r, %lv
  ret i32 %res
}

define i32 @test_captured_after_loop(i1 %c.1) {
; CHECK-LABEL: @test_captured_after_loop(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br label %loop

loop:
  %r = call i32 @getval()
  store i32 99, i32* %a, align 4
  br i1 %c.1, label %loop, label %exit

exit:
  call void @escape_and_clobber(i32* %a)
  ret i32 %r
}

define i32 @test_captured_in_loop(i1 %c.1) {
; CHECK-LABEL: @test_captured_in_loop(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 55, i32* [[A]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval()
; CHECK-NEXT:    call void @escape_writeonly(i32* [[A]])
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = alloca i32, align 4
  store i32 55, i32* %a
  br label %loop

loop:
  %r = call i32 @getval()
  call void @escape_writeonly(i32* %a)
  store i32 99, i32* %a, align 4
  br i1 %c.1, label %loop, label %exit

exit:
  call void @escape_and_clobber(i32* %a)
  ret i32 %r
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
define void @test_escaping_store_removed(i8* %src, i64** %escape) {
; CHECK-LABEL: @test_escaping_store_removed(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[A:%.*]] = alloca i64, align 8
; CHECK-NEXT:    [[EXT_A:%.*]] = bitcast i64* [[A]] to i8*
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[EXT_A]], i8* [[SRC:%.*]], i64 8, i1 false)
; CHECK-NEXT:    store i64* [[A]], i64** [[ESCAPE:%.*]], align 8
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    store i64 99, i64* [[A]], align 8
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret void
;
bb:
  %a = alloca i64, align 8
  %ext.a = bitcast i64* %a to i8*
  store i64 0, i64* %a
  call void @clobber()
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %ext.a, i8* %src, i64 8, i1 false)
  store i64* %a, i64** %escape, align 8
  store i64* %a, i64** %escape, align 8
  call void @clobber()
  store i64 99, i64* %a
  call void @clobber()
  ret void
}


define void @test_invoke_captures() personality i8* undef {
; CHECK-LABEL: @test_invoke_captures(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    invoke void @clobber()
; CHECK-NEXT:    to label [[BB2:%.*]] unwind label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 0, i32* [[A]], align 8
; CHECK-NEXT:    invoke void @escape(i32* [[A]])
; CHECK-NEXT:    to label [[BB9:%.*]] unwind label [[BB10:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    ret void
; CHECK:       bb5:
; CHECK-NEXT:    [[LP_1:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    ret void
; CHECK:       bb9:
; CHECK-NEXT:    ret void
; CHECK:       bb10:
; CHECK-NEXT:    [[LP_2:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    unreachable
;
bb:
  %a = alloca i32
  store i32 99, i32* %a
  invoke void @clobber()
  to label %bb2 unwind label %bb5

bb2:
  store i32 0, i32* %a, align 8
  invoke void @escape(i32* %a)
  to label %bb9 unwind label %bb10

bb4:
  ret void

bb5:
  %lp.1 = landingpad { i8*, i32 }
  cleanup
  ret void

bb9:
  ret void

bb10:
  %lp.2 = landingpad { i8*, i32 }
  cleanup
  unreachable
}

declare noalias i32* @alloc() nounwind
declare i32 @getval_nounwind() nounwind

define i32 @test_not_captured_before_load_same_bb_noalias_call() {
; CHECK-LABEL: @test_not_captured_before_load_same_bb_noalias_call(
; CHECK-NEXT:    [[A:%.*]] = call i32* @alloc()
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval_nounwind()
; CHECK-NEXT:    store i32 99, i32* [[A]], align 4
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = call i32* @alloc()
  store i32 55, i32* %a
  %r = call i32 @getval_nounwind()
  store i32 99, i32* %a, align 4
  call void @escape_and_clobber(i32* %a)
  ret i32 %r
}

define i32 @test_not_captured_before_load_same_bb_noalias_arg(i32* noalias %a) {
; CHECK-LABEL: @test_not_captured_before_load_same_bb_noalias_arg(
; CHECK-NEXT:    [[R:%.*]] = call i32 @getval_nounwind()
; CHECK-NEXT:    store i32 99, i32* [[A:%.*]], align 4
; CHECK-NEXT:    call void @escape_and_clobber(i32* [[A]])
; CHECK-NEXT:    ret i32 [[R]]
;
  store i32 55, i32* %a
  %r = call i32 @getval_nounwind()
  store i32 99, i32* %a, align 4
  call void @escape_and_clobber(i32* %a)
  ret i32 %r
}
