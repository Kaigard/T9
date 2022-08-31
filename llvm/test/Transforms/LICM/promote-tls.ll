; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -licm -S < %s | FileCheck %s
; RUN: opt -passes='loop-mssa(licm)' -S %s | FileCheck %s

; If we can prove a local is thread local, we can insert stores during
; promotion which wouldn't be legal otherwise.

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-linux-generic"

@p = external global i8*

declare i8* @malloc(i64)

; Exercise the TLS case
define i32* @test(i32 %n) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MEM:%.*]] = call noalias dereferenceable(16) i8* @malloc(i64 16)
; CHECK-NEXT:    [[ADDR:%.*]] = bitcast i8* [[MEM]] to i32*
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[ADDR_PROMOTED:%.*]] = load i32, i32* [[ADDR]], align 4
; CHECK-NEXT:    br label [[FOR_HEADER:%.*]]
; CHECK:       for.header:
; CHECK-NEXT:    [[NEW1:%.*]] = phi i32 [ [[ADDR_PROMOTED]], [[FOR_BODY_LR_PH]] ], [ [[NEW:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[GUARD:%.*]] = load atomic i8*, i8** @p monotonic, align 8
; CHECK-NEXT:    [[EXITCMP:%.*]] = icmp eq i8* [[GUARD]], null
; CHECK-NEXT:    br i1 [[EXITCMP]], label [[FOR_BODY]], label [[EARLY_EXIT:%.*]]
; CHECK:       early-exit:
; CHECK-NEXT:    [[NEW1_LCSSA:%.*]] = phi i32 [ [[NEW1]], [[FOR_HEADER]] ]
; CHECK-NEXT:    store i32 [[NEW1_LCSSA]], i32* [[ADDR]], align 4
; CHECK-NEXT:    ret i32* null
; CHECK:       for.body:
; CHECK-NEXT:    [[NEW]] = add i32 [[NEW1]], 1
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_02]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_HEADER]], label [[FOR_COND_FOR_END_CRIT_EDGE:%.*]]
; CHECK:       for.cond.for.end_crit_edge:
; CHECK-NEXT:    [[NEW_LCSSA:%.*]] = phi i32 [ [[NEW]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SPLIT:%.*]] = phi i32* [ [[ADDR]], [[FOR_BODY]] ]
; CHECK-NEXT:    store i32 [[NEW_LCSSA]], i32* [[ADDR]], align 4
; CHECK-NEXT:    ret i32* null
;
entry:
  ;; ignore the required null check for simplicity
  %mem = call dereferenceable(16) noalias i8* @malloc(i64 16)
  %addr = bitcast i8* %mem to i32*
  br label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  br label %for.header

for.header:
  %i.02 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %old = load i32, i32* %addr, align 4
  ; deliberate impossible to analyze branch
  %guard = load atomic i8*, i8** @p monotonic, align 8
  %exitcmp = icmp eq i8* %guard, null
  br i1 %exitcmp, label %for.body, label %early-exit

early-exit:
  ret i32* null

for.body:
  %new = add i32 %old, 1
  store i32 %new, i32* %addr, align 4
  %inc = add nsw i32 %i.02, 1
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.header, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  %split = phi i32* [ %addr, %for.body ]
  ret i32* null
}

; Stack allocations can also be thread-local
define i32* @test2(i32 %n) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MEM:%.*]] = alloca i8, i32 16, align 1
; CHECK-NEXT:    [[ADDR:%.*]] = bitcast i8* [[MEM]] to i32*
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[ADDR_PROMOTED:%.*]] = load i32, i32* [[ADDR]], align 4
; CHECK-NEXT:    br label [[FOR_HEADER:%.*]]
; CHECK:       for.header:
; CHECK-NEXT:    [[NEW1:%.*]] = phi i32 [ [[ADDR_PROMOTED]], [[FOR_BODY_LR_PH]] ], [ [[NEW:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[GUARD:%.*]] = load atomic i8*, i8** @p monotonic, align 8
; CHECK-NEXT:    [[EXITCMP:%.*]] = icmp eq i8* [[GUARD]], null
; CHECK-NEXT:    br i1 [[EXITCMP]], label [[FOR_BODY]], label [[EARLY_EXIT:%.*]]
; CHECK:       early-exit:
; CHECK-NEXT:    [[NEW1_LCSSA:%.*]] = phi i32 [ [[NEW1]], [[FOR_HEADER]] ]
; CHECK-NEXT:    store i32 [[NEW1_LCSSA]], i32* [[ADDR]], align 4
; CHECK-NEXT:    ret i32* null
; CHECK:       for.body:
; CHECK-NEXT:    [[NEW]] = add i32 [[NEW1]], 1
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_02]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_HEADER]], label [[FOR_COND_FOR_END_CRIT_EDGE:%.*]]
; CHECK:       for.cond.for.end_crit_edge:
; CHECK-NEXT:    [[NEW_LCSSA:%.*]] = phi i32 [ [[NEW]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SPLIT:%.*]] = phi i32* [ [[ADDR]], [[FOR_BODY]] ]
; CHECK-NEXT:    store i32 [[NEW_LCSSA]], i32* [[ADDR]], align 4
; CHECK-NEXT:    ret i32* null
;
entry:
  %mem = alloca i8, i32 16
  %addr = bitcast i8* %mem to i32*
  br label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  br label %for.header

for.header:
  %i.02 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %old = load i32, i32* %addr, align 4
  ; deliberate impossible to analyze branch
  %guard = load atomic i8*, i8** @p monotonic, align 8
  %exitcmp = icmp eq i8* %guard, null
  br i1 %exitcmp, label %for.body, label %early-exit

early-exit:
  ret i32* null

for.body:
  %new = add i32 %old, 1
  store i32 %new, i32* %addr, align 4
  %inc = add nsw i32 %i.02, 1
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.header, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  %split = phi i32* [ %addr, %for.body ]
  ret i32* null
}

declare noalias i8* @custom_malloc(i64)

; Custom allocation function marked via noalias.
define i32* @test_custom_malloc(i32 %n) {
; CHECK-LABEL: @test_custom_malloc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MEM:%.*]] = call noalias dereferenceable(16) i8* @custom_malloc(i64 16)
; CHECK-NEXT:    [[ADDR:%.*]] = bitcast i8* [[MEM]] to i32*
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[ADDR_PROMOTED:%.*]] = load i32, i32* [[ADDR]], align 4
; CHECK-NEXT:    br label [[FOR_HEADER:%.*]]
; CHECK:       for.header:
; CHECK-NEXT:    [[NEW1:%.*]] = phi i32 [ [[ADDR_PROMOTED]], [[FOR_BODY_LR_PH]] ], [ [[NEW:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[GUARD:%.*]] = load volatile i8*, i8** @p, align 8
; CHECK-NEXT:    [[EXITCMP:%.*]] = icmp eq i8* [[GUARD]], null
; CHECK-NEXT:    br i1 [[EXITCMP]], label [[FOR_BODY]], label [[EARLY_EXIT:%.*]]
; CHECK:       early-exit:
; CHECK-NEXT:    [[NEW1_LCSSA:%.*]] = phi i32 [ [[NEW1]], [[FOR_HEADER]] ]
; CHECK-NEXT:    store i32 [[NEW1_LCSSA]], i32* [[ADDR]], align 4
; CHECK-NEXT:    ret i32* null
; CHECK:       for.body:
; CHECK-NEXT:    [[NEW]] = add i32 [[NEW1]], 1
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_02]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_HEADER]], label [[FOR_COND_FOR_END_CRIT_EDGE:%.*]]
; CHECK:       for.cond.for.end_crit_edge:
; CHECK-NEXT:    [[NEW_LCSSA:%.*]] = phi i32 [ [[NEW]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SPLIT:%.*]] = phi i32* [ [[ADDR]], [[FOR_BODY]] ]
; CHECK-NEXT:    store i32 [[NEW_LCSSA]], i32* [[ADDR]], align 4
; CHECK-NEXT:    ret i32* null
;
entry:
  %mem = call dereferenceable(16) noalias i8* @custom_malloc(i64 16)
  %addr = bitcast i8* %mem to i32*
  br label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  br label %for.header

for.header:
  %i.02 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %old = load i32, i32* %addr, align 4
  ; deliberate impossible to analyze branch
  %guard = load volatile i8*, i8** @p
  %exitcmp = icmp eq i8* %guard, null
  br i1 %exitcmp, label %for.body, label %early-exit

early-exit:
  ret i32* null

for.body:
  %new = add i32 %old, 1
  store i32 %new, i32* %addr, align 4
  %inc = add nsw i32 %i.02, 1
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.header, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  %split = phi i32* [ %addr, %for.body ]
  ret i32* null
}

declare i8* @not_malloc(i64)

; Negative test - not an allocation function.
define i32* @test_neg_not_malloc(i32 %n) {
; CHECK-LABEL: @test_neg_not_malloc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MEM:%.*]] = call dereferenceable(16) i8* @not_malloc(i64 16)
; CHECK-NEXT:    [[ADDR:%.*]] = bitcast i8* [[MEM]] to i32*
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_HEADER:%.*]]
; CHECK:       for.header:
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[OLD:%.*]] = load i32, i32* [[ADDR]], align 4
; CHECK-NEXT:    [[GUARD:%.*]] = load volatile i8*, i8** @p, align 8
; CHECK-NEXT:    [[EXITCMP:%.*]] = icmp eq i8* [[GUARD]], null
; CHECK-NEXT:    br i1 [[EXITCMP]], label [[FOR_BODY]], label [[EARLY_EXIT:%.*]]
; CHECK:       early-exit:
; CHECK-NEXT:    ret i32* null
; CHECK:       for.body:
; CHECK-NEXT:    [[NEW:%.*]] = add i32 [[OLD]], 1
; CHECK-NEXT:    store i32 [[NEW]], i32* [[ADDR]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_02]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_HEADER]], label [[FOR_COND_FOR_END_CRIT_EDGE:%.*]]
; CHECK:       for.cond.for.end_crit_edge:
; CHECK-NEXT:    [[SPLIT:%.*]] = phi i32* [ [[ADDR]], [[FOR_BODY]] ]
; CHECK-NEXT:    ret i32* null
;
entry:
  ;; ignore the required null check for simplicity
  %mem = call dereferenceable(16) i8* @not_malloc(i64 16)
  %addr = bitcast i8* %mem to i32*
  br label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  br label %for.header

for.header:
  %i.02 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %old = load i32, i32* %addr, align 4
  ; deliberate impossible to analyze branch
  %guard = load volatile i8*, i8** @p
  %exitcmp = icmp eq i8* %guard, null
  br i1 %exitcmp, label %for.body, label %early-exit

early-exit:
  ret i32* null

for.body:
  %new = add i32 %old, 1
  store i32 %new, i32* %addr, align 4
  %inc = add nsw i32 %i.02, 1
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.header, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  %split = phi i32* [ %addr, %for.body ]
  ret i32* null
}

; Negative test - can't speculate load since branch
; may control alignment
define i32* @test_neg2(i32 %n) {
; CHECK-LABEL: @test_neg2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MEM:%.*]] = call noalias dereferenceable(16) i8* @malloc(i64 16)
; CHECK-NEXT:    [[ADDR:%.*]] = bitcast i8* [[MEM]] to i32*
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_HEADER:%.*]]
; CHECK:       for.header:
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[GUARD:%.*]] = load volatile i8*, i8** @p, align 8
; CHECK-NEXT:    [[EXITCMP:%.*]] = icmp eq i8* [[GUARD]], null
; CHECK-NEXT:    br i1 [[EXITCMP]], label [[FOR_BODY]], label [[EARLY_EXIT:%.*]]
; CHECK:       early-exit:
; CHECK-NEXT:    ret i32* null
; CHECK:       for.body:
; CHECK-NEXT:    [[OLD:%.*]] = load i32, i32* [[ADDR]], align 4
; CHECK-NEXT:    [[NEW:%.*]] = add i32 [[OLD]], 1
; CHECK-NEXT:    store i32 [[NEW]], i32* [[ADDR]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_02]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_HEADER]], label [[FOR_COND_FOR_END_CRIT_EDGE:%.*]]
; CHECK:       for.cond.for.end_crit_edge:
; CHECK-NEXT:    [[SPLIT:%.*]] = phi i32* [ [[ADDR]], [[FOR_BODY]] ]
; CHECK-NEXT:    ret i32* null
;
entry:
  ;; ignore the required null check for simplicity
  %mem = call dereferenceable(16) noalias i8* @malloc(i64 16)
  %addr = bitcast i8* %mem to i32*
  br label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  br label %for.header

for.header:
  %i.02 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  ; deliberate impossible to analyze branch
  %guard = load volatile i8*, i8** @p
  %exitcmp = icmp eq i8* %guard, null
  br i1 %exitcmp, label %for.body, label %early-exit

early-exit:
  ret i32* null

for.body:
  %old = load i32, i32* %addr, align 4
  %new = add i32 %old, 1
  store i32 %new, i32* %addr, align 4
  %inc = add nsw i32 %i.02, 1
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.header, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  %split = phi i32* [ %addr, %for.body ]
  ret i32* null
}