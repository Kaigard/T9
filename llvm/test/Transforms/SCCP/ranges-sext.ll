; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=sccp -S %s -o -| FileCheck %s

define i64 @test1_sext_op_can_be_undef(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test1_sext_op_can_be_undef(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[TRUE_1:%.*]], label [[FALSE:%.*]]
; CHECK:       true.1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[TRUE_2:%.*]], label [[EXIT:%.*]]
; CHECK:       true.2:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       false:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[TRUE_1]] ], [ 1, [[TRUE_2]] ], [ undef, [[FALSE]] ]
; CHECK-NEXT:    [[EXT:%.*]] = sext i32 [[P]] to i64
; CHECK-NEXT:    ret i64 [[EXT]]
;
  br i1 %c.1, label %true.1, label %false

true.1:
  br i1 %c.2, label %true.2, label %exit

true.2:
  br label %exit

false:
  br label %exit

exit:
  %p = phi i32 [ 0, %true.1 ], [ 1, %true.2], [ undef, %false ]
  %ext = sext i32 %p to i64
  ret i64 %ext
}

define i64 @test1_sext_op_can_be_undef_but_frozen(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test1_sext_op_can_be_undef_but_frozen(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[TRUE_1:%.*]], label [[FALSE:%.*]]
; CHECK:       true.1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[TRUE_2:%.*]], label [[EXIT:%.*]]
; CHECK:       true.2:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       false:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[TRUE_1]] ], [ 1, [[TRUE_2]] ], [ undef, [[FALSE]] ]
; CHECK-NEXT:    [[P_FR:%.*]] = freeze i32 [[P]]
; CHECK-NEXT:    [[EXT:%.*]] = sext i32 [[P_FR]] to i64
; CHECK-NEXT:    ret i64 [[EXT]]
;
  br i1 %c.1, label %true.1, label %false

true.1:
  br i1 %c.2, label %true.2, label %exit

true.2:
  br label %exit

false:
  br label %exit

exit:
  %p = phi i32 [ 0, %true.1 ], [ 1, %true.2], [ undef, %false ]
  %p.fr = freeze i32 %p
  %ext = sext i32 %p.fr to i64
  ret i64 %ext
}

define i64 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[P:%.*]] = and i32 [[X:%.*]], 15
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[P]] to i64
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %p = and i32 %x, 15
  %ext = sext i32 %p to i64
  ret i64 %ext
}

define i64 @test3(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[TRUE_1:%.*]], label [[FALSE:%.*]]
; CHECK:       true.1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[TRUE_2:%.*]], label [[EXIT:%.*]]
; CHECK:       true.2:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       false:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[TRUE_1]] ], [ 1, [[TRUE_2]] ], [ 3, [[FALSE]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[P]] to i64
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  br i1 %c.1, label %true.1, label %false

true.1:
  br i1 %c.2, label %true.2, label %exit

true.2:
  br label %exit

false:
  br label %exit

exit:
  %p = phi i32 [ 0, %true.1 ], [ 1, %true.2], [ 3, %false ]
  %ext = sext i32 %p to i64
  ret i64 %ext
}
