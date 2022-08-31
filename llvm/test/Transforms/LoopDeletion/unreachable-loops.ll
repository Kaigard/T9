; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-deletion -verify-dom-info --pass-remarks-output=%t --pass-remarks-filter=loop-delete -S | FileCheck %s
; RUN: cat %t | FileCheck %s --check-prefix=REMARKS

; Checking that we can delete loops that are never executed.
; We do not change the constant conditional branch statement (where the not-taken target
; is the loop) to an unconditional one.

; delete the infinite loop because it is never executed.
define void @test1(i64 %n, i64 %m) nounwind {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 true, label [[RETURN:%.*]], label [[BB_PREHEADER:%.*]]
; CHECK:       bb.preheader:
; CHECK-NEXT:    br label [[RETURN_LOOPEXIT:%.*]]
; CHECK:       return.loopexit:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
; REMARKS-LABEL: Function: test1
; REMARKS: Loop deleted because it never executes
entry:
  br i1 true, label %return, label %bb

bb:
  %x.0 = phi i64 [ 0, %entry ], [ %t0, %bb ]
  %t0 = add i64 %x.0, 1
  %t1 = icmp slt i64 %x.0, %n
  %t3 = icmp sgt i64 %x.0, %m
  %t4 = and i1 %t1, %t3
  br i1 true, label %bb, label %return

return:
  ret void
}

; FIXME: We can delete this infinite loop. Currently we do not,
; because the infinite loop has no exit block.
define void @test2(i64 %n, i64 %m) nounwind {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 true, label [[RETURN:%.*]], label [[BB_PREHEADER:%.*]]
; CHECK:       bb.preheader:
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[X_0:%.*]] = phi i64 [ [[T0:%.*]], [[BB]] ], [ 0, [[BB_PREHEADER]] ]
; CHECK-NEXT:    [[T0]] = add i64 [[X_0]], 1
; CHECK-NEXT:    [[T1:%.*]] = icmp slt i64 [[X_0]], [[N:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = icmp sgt i64 [[X_0]], [[M:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    br label [[BB]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  br i1 true, label %return, label %bb

bb:
  %x.0 = phi i64 [ 0, %entry ], [ %t0, %bb ]
  %t0 = add i64 %x.0, 1
  %t1 = icmp slt i64 %x.0, %n
  %t3 = icmp sgt i64 %x.0, %m
  %t4 = and i1 %t1, %t3
  br label %bb

return:
  ret void
}

; There are multiple exiting blocks and a single exit block.
; Since it is a never executed loop, we do not care about the values
; from different exiting paths and we can
; delete the loop.
define i64 @test3(i64 %n, i64 %m, i64 %maybe_zero) nounwind {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[BB_PREHEADER:%.*]], label [[RETURN:%.*]]
; CHECK:       bb.preheader:
; CHECK-NEXT:    br label [[RETURN_LOOPEXIT:%.*]]
; CHECK:       return.loopexit:
; CHECK-NEXT:    [[X_LCSSA_PH:%.*]] = phi i64 [ poison, [[BB_PREHEADER]] ]
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[X_LCSSA:%.*]] = phi i64 [ 20, [[ENTRY:%.*]] ], [ [[X_LCSSA_PH]], [[RETURN_LOOPEXIT]] ]
; CHECK-NEXT:    ret i64 [[X_LCSSA]]
;
; REMARKS-LABEL: Function: test3
; REMARKS: Loop deleted because it never executes
entry:
  br i1 false, label %bb, label %return

bb:
  %x.0 = phi i64 [ 0, %entry ], [ %t0, %bb3 ]
  %t0 = add i64 %x.0, 1
  %t1 = icmp slt i64 %x.0, %n
  br i1 %t1, label %bb2, label %return

bb2:
  %t2 = icmp slt i64 %x.0, %m
  %unused1 = udiv i64 42, %maybe_zero
  br i1 %t2, label %bb3, label %return

bb3:
  %t3 = icmp slt i64 %x.0, %m
  %unused2 = sdiv i64 42, %maybe_zero
  br i1 %t3, label %bb, label %return

return:
; the only valid value fo x.lcssa is 20.
  %x.lcssa = phi i64 [ 12, %bb ], [ 14, %bb2 ], [ 16, %bb3 ], [20, %entry ]
  ret i64 %x.lcssa
}

; Cannot delete the loop, since it may be executed at runtime.
define void @test4(i64 %n, i64 %m, i1 %cond) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[LOOPPRED1:%.*]], label [[LOOPPRED2:%.*]]
; CHECK:       looppred1:
; CHECK-NEXT:    br i1 true, label [[RETURN:%.*]], label [[BB_PREHEADER:%.*]]
; CHECK:       looppred2:
; CHECK-NEXT:    br i1 false, label [[RETURN]], label [[BB_PREHEADER]]
; CHECK:       bb.preheader:
; CHECK-NEXT:    [[X_0_PH:%.*]] = phi i64 [ 1, [[LOOPPRED2]] ], [ 0, [[LOOPPRED1]] ]
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[X_0:%.*]] = phi i64 [ [[T0:%.*]], [[BB]] ], [ [[X_0_PH]], [[BB_PREHEADER]] ]
; CHECK-NEXT:    [[T0]] = add i64 [[X_0]], 1
; CHECK-NEXT:    [[T1:%.*]] = icmp slt i64 [[X_0]], [[N:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = icmp sgt i64 [[X_0]], [[M:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    br i1 true, label [[BB]], label [[RETURN_LOOPEXIT:%.*]]
; CHECK:       return.loopexit:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  br i1 %cond, label %looppred1, label %looppred2

looppred1:
  br i1 true, label %return, label %bb

looppred2:
  br i1 false, label %return, label %bb

bb:
  %x.0 = phi i64 [ 0, %looppred1 ], [ 1, %looppred2 ], [ %t0, %bb ]
  %t0 = add i64 %x.0, 1
  %t1 = icmp slt i64 %x.0, %n
  %t3 = icmp sgt i64 %x.0, %m
  %t4 = and i1 %t1, %t3
  br i1 true, label %bb, label %return

return:
  ret void
}

; multiple constant conditional branches with loop not-taken in all cases.
define void @test5(i64 %n, i64 %m, i1 %cond) nounwind {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[LOOPPRED1:%.*]], label [[LOOPPRED2:%.*]]
; CHECK:       looppred1:
; CHECK-NEXT:    br i1 true, label [[RETURN:%.*]], label [[BB_PREHEADER:%.*]]
; CHECK:       looppred2:
; CHECK-NEXT:    br i1 true, label [[RETURN]], label [[BB_PREHEADER]]
; CHECK:       bb.preheader:
; CHECK-NEXT:    [[X_0_PH:%.*]] = phi i64 [ 1, [[LOOPPRED2]] ], [ 0, [[LOOPPRED1]] ]
; CHECK-NEXT:    br label [[RETURN_LOOPEXIT:%.*]]
; CHECK:       return.loopexit:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
; REMARKS-LABEL: Function: test5
; REMARKS: Loop deleted because it never executes
entry:
  br i1 %cond, label %looppred1, label %looppred2

looppred1:
  br i1 true, label %return, label %bb

looppred2:
  br i1 true, label %return, label %bb

bb:
  %x.0 = phi i64 [ 0, %looppred1 ], [ 1, %looppred2 ], [ %t0, %bb ]
  %t0 = add i64 %x.0, 1
  %t1 = icmp slt i64 %x.0, %n
  %t3 = icmp sgt i64 %x.0, %m
  %t4 = and i1 %t1, %t3
  br i1 true, label %bb, label %return

return:
  ret void
}

; Don't delete this infinite loop because the loop
; is executable at runtime.
define void @test6(i64 %n, i64 %m) nounwind {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 true, label [[BB_PREHEADER:%.*]], label [[BB_PREHEADER]]
; CHECK:       bb.preheader:
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[X_0:%.*]] = phi i64 [ [[T0:%.*]], [[BB]] ], [ 0, [[BB_PREHEADER]] ]
; CHECK-NEXT:    [[T0]] = add i64 [[X_0]], 1
; CHECK-NEXT:    [[T1:%.*]] = icmp slt i64 [[X_0]], [[N:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = icmp sgt i64 [[X_0]], [[M:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    br i1 true, label [[BB]], label [[RETURN:%.*]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  br i1 true, label %bb, label %bb

bb:
  %x.0 = phi i64 [ 0, %entry ], [ 0, %entry ], [ %t0, %bb ]
  %t0 = add i64 %x.0, 1
  %t1 = icmp slt i64 %x.0, %n
  %t3 = icmp sgt i64 %x.0, %m
  %t4 = and i1 %t1, %t3
  br i1 true, label %bb, label %return

return:
  ret void
}

declare i64 @foo(i64)
; The loop L2 is never executed and is a subloop, with an
; exit block that branches back to parent loop.
; Here we can delete loop L2, while L1 still exists.
define i64 @test7(i64 %n) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[L1:%.*]]
; CHECK:       L1:
; CHECK-NEXT:    [[Y_NEXT:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[Y_ADD:%.*]], [[L1LATCH:%.*]] ]
; CHECK-NEXT:    br i1 true, label [[L1LATCH]], label [[L2_PREHEADER:%.*]]
; CHECK:       L2.preheader:
; CHECK-NEXT:    br label [[L1LATCH_LOOPEXIT:%.*]]
; CHECK:       L1Latch.loopexit:
; CHECK-NEXT:    [[Y_L2_LCSSA:%.*]] = phi i64 [ poison, [[L2_PREHEADER]] ]
; CHECK-NEXT:    br label [[L1LATCH]]
; CHECK:       L1Latch:
; CHECK-NEXT:    [[Y:%.*]] = phi i64 [ [[Y_NEXT]], [[L1]] ], [ [[Y_L2_LCSSA]], [[L1LATCH_LOOPEXIT]] ]
; CHECK-NEXT:    [[Y_ADD]] = add i64 [[Y]], [[N:%.*]]
; CHECK-NEXT:    [[COND2:%.*]] = icmp eq i64 [[Y_ADD]], 42
; CHECK-NEXT:    br i1 [[COND2]], label [[EXIT:%.*]], label [[L1]]
; CHECK:       exit:
; CHECK-NEXT:    [[Y_ADD_LCSSA:%.*]] = phi i64 [ [[Y_ADD]], [[L1LATCH]] ]
; CHECK-NEXT:    ret i64 [[Y_ADD_LCSSA]]
;
; REMARKS-LABEL: Function: test7
; REMARKS: Loop deleted because it never executes
entry:
  br label %L1

L1:
  %y.next = phi i64 [ 0, %entry ], [ %y.add, %L1Latch ]
  br i1 true, label %L1Latch, label %L2

L2:
  %x = phi i64 [ 0, %L1 ], [ %x.next, %L2 ]
  %x.next = add i64 %x, 1
  %y.L2 = call i64 @foo(i64 %x.next)
  %cond = icmp slt i64 %x.next, %n
  br i1 %cond, label %L2, label %L1Latch

L1Latch:
  %y = phi i64 [ %y.next, %L1 ], [ %y.L2, %L2 ]
  %y.add = add i64 %y, %n
  %cond2 = icmp eq i64 %y.add, 42
  br i1 %cond2, label %exit, label %L1

exit:
  ret i64 %y.add
}


; Show recursive deletion of loops. Since we start with subloops and progress outward
; to parent loop, we first delete the loop L2. Now loop L1 becomes a non-loop since it's backedge
; from L2's preheader to L1's exit block is never taken. So, L1 gets deleted as well.
define void @test8(i64 %n) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
; REMARKS-LABEL: Function: test8
; REMARKS: Loop deleted because it never executes
entry:
  br label %L1

L1:
  br i1 true, label %exit, label %L2

L2:
  %x = phi i64 [ 0, %L1 ], [ %x.next, %L2 ]
  %x.next = add i64 %x, 1
  %y.L2 = call i64 @foo(i64 %x.next)
  %cond = icmp slt i64 %x.next, %n
  br i1 %cond, label %L2, label %L1

exit:
  ret void
}


; Delete a loop (L2) which has subloop (L3).
; Here we delete loop L2, but leave L3 as is.
define void @test9(i64 %n) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
; REMARKS-LABEL: Function: test9
; REMARKS: Loop deleted because it never executes
entry:
  br label %L1

L1:
  br i1 true, label %exit, label %L2

L2:
  %x = phi i64 [ 0, %L1 ], [ %x.next, %L2 ]
  %x.next = add i64 %x, 1
  %y.L2 = call i64 @foo(i64 %x.next)
  %cond = icmp slt i64 %x.next, %n
  br i1 %cond, label %L2, label %L3

L3:
  %cond2 = icmp slt i64 %y.L2, %n
  br i1 %cond2, label %L3, label %L1

exit:
  ret void
}

; We cannot delete L3 because of call within it.
; Since L3 is not deleted, and entirely contained within L2, L2 is also not
; deleted.
define void @test10(i64 %n) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %L1

L1:
  br i1 true, label %exit, label %L2

L2:
  %x = phi i64 [ 0, %L1 ], [ %x.next, %L3 ]
  %x.next = add i64 %x, 1
  %y.L2 = call i64 @foo(i64 %x.next)
  %cond = icmp slt i64 %x.next, %n
  br i1 %cond, label %L1, label %L3

L3:
  %y.L3 = phi i64 [ %y.L2, %L2 ], [ %y.L3.next, %L3 ]
  %y.L3.next = add i64 %y.L3, 1
  %dummy = call i64 @foo(i64 %y.L3.next)
  %cond2 = icmp slt i64 %y.L3, %n
  br i1 %cond2, label %L3, label %L2

exit:
  ret void
}

; same as test10, but L3 does not contain call.
; So, in the first iteration, all statements of L3 are made invariant, and L3 is
; deleted.
; In the next iteration, since L2 is never executed and has no subloops, we delete
; L2 as well. Finally, the outermost loop L1 is deleted.
define void @test11(i64 %n) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
; REMARKS-LABEL: Function: test11
; REMARKS: Loop deleted because it is invariant
; REMARKS-LABEL: Function: test11
; REMARKS: Loop deleted because it never executes
; REMARKS-LABEL: Function: test11
; REMARKS: Loop deleted because it is invariant
entry:
  br label %L1

L1:
  br i1 true, label %exit, label %L2

L2:
  %x = phi i64 [ 0, %L1 ], [ %x.next, %L3 ]
  %x.next = add i64 %x, 1
  %y.L2 = call i64 @foo(i64 %x.next)
  %cond = icmp slt i64 %x.next, %n
  br i1 %cond, label %L1, label %L3

L3:
  %y.L3 = phi i64 [ %y.L2, %L2 ], [ %y.L3.next, %L3 ]
  %y.L3.next = add i64 %y.L3, 1
  %cond2 = icmp slt i64 %y.L3, %n
  br i1 %cond2, label %L3, label %L2

exit:
  ret void
}


; 2 edges from a single exiting block to the exit block.
define i64 @test12(i64 %n){
; CHECK-LABEL: @test12(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 true, label [[EXIT1:%.*]], label [[L1_PREHEADER:%.*]]
; CHECK:       L1.preheader:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i64 42
; CHECK:       exit:
; CHECK-NEXT:    [[Y_PHI:%.*]] = phi i64 [ poison, [[L1_PREHEADER]] ]
; CHECK-NEXT:    ret i64 [[Y_PHI]]
;
; REMARKS-LABEL: Function: test12
; REMARKS: Loop deleted because it never executes

entry:
  br i1 true, label %exit1, label %L1

exit1:
  ret i64 42

L1:                                               ; preds = %L1Latch, %entry
  %y.next = phi i64 [ 0, %entry ], [ %y.add, %L1Latch ]
  br i1 true, label %L1Latch, label %exit

L1Latch:                                          ; preds = %L1
  %y = phi i64 [ %y.next, %L1 ]
  %y.add = add i64 %y, %n
  %cond2 = icmp eq i64 %y.add, 42
  switch i64 %n, label %L1 [
  i64 10, label %exit
  i64 20, label %exit
  ]

exit:                                             ; preds = %L1Latch, %L1Latch
  %y.phi = phi i64 [ 10, %L1Latch ], [ 10, %L1Latch ], [ %y.next, %L1]
  ret i64 %y.phi
}

; multiple edges to exit block from the same exiting blocks
define i64 @test13(i64 %n) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 true, label [[EXIT1:%.*]], label [[L1_PREHEADER:%.*]]
; CHECK:       L1.preheader:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i64 42
; CHECK:       exit:
; CHECK-NEXT:    [[Y_PHI:%.*]] = phi i64 [ poison, [[L1_PREHEADER]] ]
; CHECK-NEXT:    ret i64 [[Y_PHI]]
;
; REMARKS-LABEL: Function: test13
; REMARKS: Loop deleted because it never executes

entry:
  br i1 true, label %exit1, label %L1

exit1:
  ret i64 42

L1:                                               ; preds = %L1Latch, %entry
  %y.next = phi i64 [ 0, %entry ], [ %y.add, %L1Latch ]
  br i1 true, label %L1Block, label %exit

L1Block:                                          ; preds = %L1
  %y = phi i64 [ %y.next, %L1 ]
  %y.add = add i64 %y, %n
  %cond2 = icmp eq i64 %y.add, 42
  switch i64 %n, label %L1Latch [
  i64 10, label %exit
  i64 20, label %exit
  ]

L1Latch:
  switch i64 %n, label %L1 [
  i64 30, label %exit
  i64 40, label %exit
  ]

exit:                                             ; preds = %L1Block, %L1, %L1Latch
  %y.phi = phi i64 [ 10, %L1Block ], [ 10, %L1Block ], [ %y.next, %L1 ], [ 30, %L1Latch ], [ 30, %L1Latch ]
  ret i64 %y.phi
}
