; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

define i1 @wrapping_add_unknown_1(i8 %a) {
; CHECK-LABEL: @wrapping_add_unknown_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = add i8 [[A:%.*]], -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[SUB]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %sub = add i8 %a, -1
  %cmp = icmp eq i8 %sub, 0
  ret i1 %cmp
}

define i1 @wrapping_add_known_1(i8 %a) {
; CHECK-LABEL: @wrapping_add_known_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE:%.*]] = icmp eq i8 [[A:%.*]], 1
; CHECK-NEXT:    br i1 [[PRE]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[SUB_1:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i8 [[SUB_1]], 0
; CHECK-NEXT:    ret i1 true
; CHECK:       else:
; CHECK-NEXT:    [[SUB_2:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i8 [[SUB_2]], 0
; CHECK-NEXT:    ret i1 [[C_2]]
;
entry:
  %pre = icmp eq i8 %a, 1
  br i1 %pre, label %then, label %else

then:
  %sub.1 = add i8 %a, -1
  %c.1 = icmp eq i8 %sub.1, 0
  ret i1 %c.1

else:
  %sub.2 = add i8 %a, -1
  %c.2 = icmp eq i8 %sub.2, 0
  ret i1 %c.2
}

define i1 @wrapping_add_unknown_2(i8 %a) {
; CHECK-LABEL: @wrapping_add_unknown_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE:%.*]] = icmp eq i8 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[PRE]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[SUB_1:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i8 [[SUB_1]], 0
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    [[SUB_2:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i8 [[SUB_2]], 0
; CHECK-NEXT:    ret i1 [[C_2]]
;
entry:
  %pre = icmp eq i8 %a, 0
  br i1 %pre, label %then, label %else

then:
  %sub.1 = add i8 %a, -1
  %c.1 = icmp eq i8 %sub.1, 0
  ret i1 %c.1

else:
  %sub.2 = add i8 %a, -1
  %c.2 = icmp eq i8 %sub.2, 0
  ret i1 %c.2
}

; Test from https://github.com/llvm/llvm-project/issues/48253.
define i1 @test_48253_eq_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @test_48253_eq_ne(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp ne i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp eq i8 [[B]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP_1]], [[CMP_2]]
; CHECK-NEXT:    br i1 [[OR]], label [[EXIT_1:%.*]], label [[IF_END:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[SUB_1:%.*]] = add i8 [[B]], -1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[SUB_1]], [[A]]
; CHECK-NEXT:    [[SUB_2:%.*]] = add i8 [[B]], -2
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i8 [[SUB_2]], [[A]]
; CHECK-NEXT:    [[XOR_1:%.*]] = xor i1 true, [[C_2]]
; CHECK-NEXT:    ret i1 [[XOR_1]]
; CHECK:       exit.1:
; CHECK-NEXT:    [[SUB_3:%.*]] = add i8 [[B]], -1
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i8 [[SUB_3]], [[A]]
; CHECK-NEXT:    [[SUB_4:%.*]] = add i8 [[B]], -2
; CHECK-NEXT:    [[C_4:%.*]] = icmp ult i8 [[SUB_4]], [[A]]
; CHECK-NEXT:    [[XOR_2:%.*]] = xor i1 [[C_3]], [[C_4]]
; CHECK-NEXT:    ret i1 [[XOR_2]]
;
entry:
  %cmp.1 = icmp ne i8 %a, %b
  %cmp.2 = icmp eq i8 %b, 0
  %or = or i1 %cmp.1, %cmp.2
  br i1 %or, label %exit.1, label %if.end

if.end:
  %sub.1 = add i8 %b, -1
  %t.1 = icmp ult i8 %sub.1, %a
  %sub.2 = add i8 %b, -2
  %c.2 = icmp ult i8 %sub.2, %a
  %xor.1 = xor i1 %t.1, %c.2
  ret i1 %xor.1

exit.1:
  %sub.3 = add i8 %b, -1
  %c.3 = icmp ult i8 %sub.3, %a
  %sub.4 = add i8 %b, -2
  %c.4 = icmp ult i8 %sub.4, %a
  %xor.2 = xor i1 %c.3, %c.4
  ret i1 %xor.2
}

define i1 @test_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @test_ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge i8 [[A:%.*]], 20
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp ult i8 [[A]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[CMP_1]], [[CMP_2]]
; CHECK-NEXT:    [[SUB_1:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[SUB_2:%.*]] = add i8 [[A]], -2
; CHECK-NEXT:    [[SUB_3:%.*]] = add i8 [[A]], -20
; CHECK-NEXT:    [[SUB_4:%.*]] = add i8 [[A]], 21
; CHECK-NEXT:    [[ADD_1:%.*]] = add i8 [[A]], 1
; CHECK-NEXT:    br i1 [[AND]], label [[IF_END:%.*]], label [[EXIT_1:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[SUB_1]], [[B]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp ult i8 [[SUB_2]], [[B]]
; CHECK-NEXT:    [[XOR_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[T_3:%.*]] = icmp ult i8 [[SUB_3]], [[B]]
; CHECK-NEXT:    [[XOR_2:%.*]] = xor i1 [[XOR_1]], true
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[SUB_4]], [[B]]
; CHECK-NEXT:    [[XOR_3:%.*]] = xor i1 [[XOR_2]], [[C_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i8 [[ADD_1]], [[B]]
; CHECK-NEXT:    [[XOR_4:%.*]] = xor i1 [[XOR_3]], [[C_2]]
; CHECK-NEXT:    ret i1 [[XOR_4]]
; CHECK:       exit.1:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i8 [[SUB_1]], [[B]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp ult i8 [[SUB_2]], [[B]]
; CHECK-NEXT:    [[XOR_5:%.*]] = xor i1 [[C_3]], [[C_4]]
; CHECK-NEXT:    [[C_5:%.*]] = icmp ult i8 [[SUB_3]], [[B]]
; CHECK-NEXT:    [[XOR_6:%.*]] = xor i1 [[XOR_5]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp ult i8 [[SUB_4]], [[B]]
; CHECK-NEXT:    [[XOR_7:%.*]] = xor i1 [[XOR_6]], [[C_6]]
; CHECK-NEXT:    [[C_7:%.*]] = icmp ult i8 [[ADD_1]], [[B]]
; CHECK-NEXT:    [[XOR_8:%.*]] = xor i1 [[XOR_7]], [[C_7]]
; CHECK-NEXT:    ret i1 [[XOR_8]]
;
entry:
  %cmp.1 = icmp uge i8 %a, 20
  %cmp.2 = icmp ult i8 %a, %b
  %and = and i1 %cmp.1, %cmp.2
  %sub.1 = add i8 %a, -1
  %sub.2 = add i8 %a, -2
  %sub.3 = add i8 %a, -20
  %sub.4 = add i8 %a, 21
  %add.1 = add i8 %a, 1
  br i1 %and, label %if.end, label %exit.1

if.end:
  %t.1 = icmp ult i8 %sub.1, %b
  %t.2 = icmp ult i8 %sub.2, %b
  %xor.1 = xor i1 %t.1, %t.2

  %t.3 = icmp ult i8 %sub.3, %b
  %xor.2 = xor i1 %xor.1, %t.3

  %c.1 = icmp ult i8 %sub.4, %b
  %xor.3 = xor i1 %xor.2, %c.1

  %c.2 = icmp ult i8 %add.1, %b
  %xor.4 = xor i1 %xor.3, %c.2
  ret i1 %xor.4

exit.1:
  %c.3 = icmp ult i8 %sub.1, %b
  %c.4 = icmp ult i8 %sub.2, %b
  %xor.5 = xor i1 %c.3, %c.4

  %c.5 = icmp ult i8 %sub.3, %b
  %xor.6 = xor i1 %xor.5, %c.5

  %c.6 = icmp ult i8 %sub.4, %b
  %xor.7 = xor i1 %xor.6, %c.6

  %c.7 = icmp ult i8 %add.1, %b
  %xor.8 = xor i1 %xor.7, %c.7
  ret i1 %xor.8
}

define i1 @test_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @test_slt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp sge i8 [[A:%.*]], 20
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp slt i8 [[A]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[CMP_1]], [[CMP_2]]
; CHECK-NEXT:    [[SUB_1:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[SUB_2:%.*]] = add i8 [[A]], -2
; CHECK-NEXT:    [[SUB_3:%.*]] = add i8 [[A]], -20
; CHECK-NEXT:    [[SUB_4:%.*]] = add i8 [[A]], 21
; CHECK-NEXT:    [[ADD_1:%.*]] = add i8 [[A]], 1
; CHECK-NEXT:    br i1 [[AND]], label [[IF_END:%.*]], label [[EXIT_1:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[T_1:%.*]] = icmp slt i8 [[SUB_1]], [[B]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp slt i8 [[SUB_2]], [[B]]
; CHECK-NEXT:    [[XOR_1:%.*]] = xor i1 [[T_1]], [[T_2]]
; CHECK-NEXT:    [[T_3:%.*]] = icmp slt i8 [[SUB_3]], [[B]]
; CHECK-NEXT:    [[XOR_2:%.*]] = xor i1 [[XOR_1]], [[T_3]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp slt i8 [[SUB_4]], [[B]]
; CHECK-NEXT:    [[XOR_3:%.*]] = xor i1 [[XOR_2]], [[C_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp slt i8 [[ADD_1]], [[B]]
; CHECK-NEXT:    [[XOR_4:%.*]] = xor i1 [[XOR_3]], [[C_2]]
; CHECK-NEXT:    ret i1 [[XOR_4]]
; CHECK:       exit.1:
; CHECK-NEXT:    [[C_3:%.*]] = icmp slt i8 [[SUB_1]], [[B]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i8 [[SUB_2]], [[B]]
; CHECK-NEXT:    [[XOR_5:%.*]] = xor i1 [[C_3]], [[C_4]]
; CHECK-NEXT:    [[C_5:%.*]] = icmp slt i8 [[SUB_3]], [[B]]
; CHECK-NEXT:    [[XOR_6:%.*]] = xor i1 [[XOR_5]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp slt i8 [[SUB_4]], [[B]]
; CHECK-NEXT:    [[XOR_7:%.*]] = xor i1 [[XOR_6]], [[C_6]]
; CHECK-NEXT:    [[C_7:%.*]] = icmp slt i8 [[ADD_1]], [[B]]
; CHECK-NEXT:    [[XOR_8:%.*]] = xor i1 [[XOR_7]], [[C_7]]
; CHECK-NEXT:    ret i1 [[XOR_8]]
;
entry:
  %cmp.1 = icmp sge i8 %a, 20
  %cmp.2 = icmp slt i8 %a, %b
  %and = and i1 %cmp.1, %cmp.2
  %sub.1 = add i8 %a, -1
  %sub.2 = add i8 %a, -2
  %sub.3 = add i8 %a, -20
  %sub.4 = add i8 %a, 21
  %add.1 = add i8 %a, 1
  br i1 %and, label %if.end, label %exit.1

if.end:
  %t.1 = icmp slt i8 %sub.1, %b
  %t.2 = icmp slt i8 %sub.2, %b
  %xor.1 = xor i1 %t.1, %t.2

  %t.3 = icmp slt i8 %sub.3, %b
  %xor.2 = xor i1 %xor.1, %t.3

  %c.1 = icmp slt i8 %sub.4, %b
  %xor.3 = xor i1 %xor.2, %c.1

  %c.2 = icmp slt i8 %add.1, %b
  %xor.4 = xor i1 %xor.3, %c.2
  ret i1 %xor.4

exit.1:
  %c.3 = icmp slt i8 %sub.1, %b
  %c.4 = icmp slt i8 %sub.2, %b
  %xor.5 = xor i1 %c.3, %c.4

  %c.5 = icmp slt i8 %sub.3, %b
  %xor.6 = xor i1 %xor.5, %c.5

  %c.6 = icmp slt i8 %sub.4, %b
  %xor.7 = xor i1 %xor.6, %c.6

  %c.7 = icmp slt i8 %add.1, %b
  %xor.8 = xor i1 %xor.7, %c.7
  ret i1 %xor.8
}
