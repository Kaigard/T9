; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='loop(indvars),loop-vectorize' -S %s | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"

; After indvars, the backedge taken count for %loop2 becomes 1, but SCEV
; retains the cached original BTC, as the loop is in dead code. Make sure
; LV does not crash when trying to select an interleave count for a loop with zero cost.
define void @pr54413(i64* %ptr.base) {
; CHECK-LABEL: @pr54413(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    br i1 true, label [[LOOP1_LATCH:%.*]], label [[LOOP2_PREHEADER:%.*]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    [[PTR_NEXT:%.*]] = getelementptr inbounds i64, i64* [[PTR_BASE:%.*]], i64 1
; CHECK-NEXT:    br i1 true, label [[LOOP2_EXIT:%.*]], label [[LOOP2]]
; CHECK:       loop2.exit:
; CHECK-NEXT:    [[PTR_NEXT_LCSSA:%.*]] = phi i64* [ [[PTR_NEXT]], [[LOOP2]] ]
; CHECK-NEXT:    br label [[LOOP1_LATCH]]
; CHECK:       loop1.latch:
; CHECK-NEXT:    br label [[LOOP1]]
;
entry:
  br label %loop1

loop1:
  br i1 true, label %loop1.latch, label %loop2.preheader

loop2.preheader:
  br label %loop2

loop2:
  %iv = phi i64 [ 0, %loop2.preheader ], [ %iv.next, %loop2 ]
  %ptr = phi i64* [ %ptr.base, %loop2.preheader ], [ %ptr.next, %loop2 ]
  %iv.next = add nuw nsw i64 %iv, 1
  %ptr.next = getelementptr inbounds i64, i64* %ptr, i64 1
  %cmp = icmp eq i64 %iv, 1024
  br i1 %cmp, label %loop2.exit, label %loop2

loop2.exit:
  %ptr.next.lcssa = phi i64* [ %ptr.next, %loop2 ]
  br label %loop1.latch

loop1.latch:
  br label %loop1
}
