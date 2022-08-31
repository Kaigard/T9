; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: asserts
; RUN: opt -loop-vectorize -S -mtriple=aarch64 -mattr=+sve -debug-only=loop-vectorize \
; RUN:   -prefer-predicate-over-epilogue=scalar-epilogue < %s 2>&1 | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; CHECK-LABEL:  LV: Checking a loop in 'pointer_induction_used_as_vector'
; CHECK-NOT:    LV: Found {{.*}} scalar instruction:   %ptr.iv.2.next = getelementptr inbounds i8, i8* %ptr.iv.2, i64 1
;
; CHECK:        VPlan 'Initial VPlan for VF={vscale x 2},UF>=1' {
; CHECK-NEXT:   Live-in vp<[[VEC_TC:%.+]]> = vector-trip-count
; CHECK-EMPTY:
; CHECK-NEXT: vector.ph:
; CHECK-NEXT: Successor(s): vector loop
; CHECK-EMPTY:
; CHECK-NEXT:   <x1> vector loop: {
; CHECK-NEXT:   vector.body:
; CHECK-NEXT:     EMIT vp<[[CAN_IV:%.+]]> = CANONICAL-INDUCTION
; CHECK-NEXT:     EMIT ir<%ptr.iv.1> = WIDEN-POINTER-INDUCTION ir<%start.1>, 1
; CHECK-NEXT:     EMIT ir<%ptr.iv.2> = WIDEN-POINTER-INDUCTION ir<%start.2>, 1
; CHECK-NEXT:     WIDEN-GEP Var[Inv] ir<%ptr.iv.2.next> = getelementptr ir<%ptr.iv.2>, ir<1>
; CHECK-NEXT:     WIDEN store ir<%ptr.iv.1>, ir<%ptr.iv.2.next>
; CHECK-NEXT:     WIDEN ir<%lv> = load ir<%ptr.iv.2>
; CHECK-NEXT:     WIDEN ir<%add> = add ir<%lv>, ir<1>
; CHECK-NEXT:     WIDEN store ir<%ptr.iv.2>, ir<%add>
; CHECK-NEXT:     EMIT vp<[[CAN_IV_NEXT:%.+]]> = VF * UF +(nuw) vp<[[CAN_IV]]>
; CHECK-NEXT:     EMIT branch-on-count vp<[[CAN_IV_NEXT]]> vp<[[VEC_TC]]>
; CHECK-NEXT:   No successors
; CHECK-NEXT:   }

; In the test below the pointer phi %ptr.iv.2 is used as
;  1. As a uniform address for the load, and
;  2. Non-uniform use by the getelementptr which is stored. This requires the
;     vector value.
define void @pointer_induction_used_as_vector(i8** noalias %start.1, i8* noalias %start.2, i64 %N) {
; CHECK-LABEL: @pointer_induction_used_as_vector(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 2
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], [[TMP1]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 2
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = getelementptr i8*, i8** [[START_1:%.*]], i64 [[N_VEC]]
; CHECK-NEXT:    [[IND_END2:%.*]] = getelementptr i8, i8* [[START_2:%.*]], i64 [[N_VEC]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[POINTER_PHI:%.*]] = phi i8* [ [[START_2]], [[VECTOR_PH]] ], [ [[PTR_IND:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i8*, i8** [[START_1]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 2
; CHECK-NEXT:    [[TMP7:%.*]] = mul i64 [[TMP6]], 1
; CHECK-NEXT:    [[TMP8:%.*]] = mul i64 1, [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = mul i64 [[TMP6]], 0
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 2 x i64> poison, i64 [[TMP9]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 2 x i64> [[DOTSPLATINSERT]], <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = call <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
; CHECK-NEXT:    [[TMP11:%.*]] = add <vscale x 2 x i64> [[DOTSPLAT]], [[TMP10]]
; CHECK-NEXT:    [[VECTOR_GEP:%.*]] = mul <vscale x 2 x i64> [[TMP11]], shufflevector (<vscale x 2 x i64> insertelement (<vscale x 2 x i64> poison, i64 1, i32 0), <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr i8, i8* [[POINTER_PHI]], <vscale x 2 x i64> [[VECTOR_GEP]]
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i8, <vscale x 2 x i8*> [[TMP12]], i64 1
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr i8*, i8** [[NEXT_GEP]], i32 0
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast i8** [[TMP14]] to <vscale x 2 x i8*>*
; CHECK-NEXT:    store <vscale x 2 x i8*> [[TMP13]], <vscale x 2 x i8*>* [[TMP15]], align 8
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <vscale x 2 x i8*> [[TMP12]], i32 0
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr i8, i8* [[TMP16]], i32 0
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i8* [[TMP17]] to <vscale x 2 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x i8>, <vscale x 2 x i8>* [[TMP18]], align 1
; CHECK-NEXT:    [[TMP19:%.*]] = add <vscale x 2 x i8> [[WIDE_LOAD]], shufflevector (<vscale x 2 x i8> insertelement (<vscale x 2 x i8> poison, i8 1, i32 0), <vscale x 2 x i8> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast i8* [[TMP17]] to <vscale x 2 x i8>*
; CHECK-NEXT:    store <vscale x 2 x i8> [[TMP19]], <vscale x 2 x i8>* [[TMP20]], align 1
; CHECK-NEXT:    [[TMP21:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP22:%.*]] = mul i64 [[TMP21]], 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP22]]
; CHECK-NEXT:    [[PTR_IND]] = getelementptr i8, i8* [[POINTER_PHI]], i64 [[TMP8]]
; CHECK-NEXT:    [[TMP23:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP23]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i8** [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[START_1]], [[ENTRY]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL3:%.*]] = phi i8* [ [[IND_END2]], [[MIDDLE_BLOCK]] ], [ [[START_2]], [[ENTRY]] ]
; CHECK-NEXT:    br label [[LOOP_BODY:%.*]]
; CHECK:       loop.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_BODY]] ]
; CHECK-NEXT:    [[PTR_IV_1:%.*]] = phi i8** [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ], [ [[PTR_IV_1_NEXT:%.*]], [[LOOP_BODY]] ]
; CHECK-NEXT:    [[PTR_IV_2:%.*]] = phi i8* [ [[BC_RESUME_VAL3]], [[SCALAR_PH]] ], [ [[PTR_IV_2_NEXT:%.*]], [[LOOP_BODY]] ]
; CHECK-NEXT:    [[PTR_IV_1_NEXT]] = getelementptr inbounds i8*, i8** [[PTR_IV_1]], i64 1
; CHECK-NEXT:    [[PTR_IV_2_NEXT]] = getelementptr inbounds i8, i8* [[PTR_IV_2]], i64 1
; CHECK-NEXT:    store i8* [[PTR_IV_2_NEXT]], i8** [[PTR_IV_1]], align 8
; CHECK-NEXT:    [[LV:%.*]] = load i8, i8* [[PTR_IV_2]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[LV]], 1
; CHECK-NEXT:    store i8 [[ADD]], i8* [[PTR_IV_2]], align 1
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i64 [[IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[C]], label [[LOOP_BODY]], label [[EXIT]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;


entry:
  br label %loop.body

loop.body:                                    ; preds = %loop.body, %entry
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.body ]
  %ptr.iv.1 = phi i8** [ %start.1, %entry ], [ %ptr.iv.1.next, %loop.body ]
  %ptr.iv.2 = phi i8* [ %start.2, %entry ], [ %ptr.iv.2.next, %loop.body ]
  %ptr.iv.1.next = getelementptr inbounds i8*, i8** %ptr.iv.1, i64 1
  %ptr.iv.2.next = getelementptr inbounds i8, i8* %ptr.iv.2, i64 1
  store i8* %ptr.iv.2.next, i8** %ptr.iv.1, align 8
  %lv = load i8, i8* %ptr.iv.2, align 1
  %add = add i8 %lv, 1
  store i8 %add, i8* %ptr.iv.2, align 1
  %iv.next = add nuw i64 %iv, 1
  %c = icmp ne i64 %iv.next, %N
  br i1 %c, label %loop.body, label %exit, !llvm.loop !0

exit:                            ; preds = %loop.body
  ret void
}

define void @pointer_induction(i8* noalias %start, i64 %N) {
; CHECK-LABEL: @pointer_induction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP2:%.*]] = mul i64 [[TMP1]], 2
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[TMP0]], [[TMP2]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP3:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP3]], 2
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[TMP0]], [[TMP4]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[TMP0]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = getelementptr i8, i8* [[START:%.*]], i64 [[N_VEC]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX2:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[INDEX2]], 0
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i8, i8* [[START]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i8, i8* [[NEXT_GEP]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i8* [[TMP6]] to <vscale x 2 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x i8>, <vscale x 2 x i8>* [[TMP7]], align 1
; CHECK-NEXT:    [[TMP8:%.*]] = add <vscale x 2 x i8> [[WIDE_LOAD]], shufflevector (<vscale x 2 x i8> insertelement (<vscale x 2 x i8> poison, i8 1, i32 0), <vscale x 2 x i8> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i8* [[TMP6]] to <vscale x 2 x i8>*
; CHECK-NEXT:    store <vscale x 2 x i8> [[TMP8]], <vscale x 2 x i8>* [[TMP9]], align 1
; CHECK-NEXT:    [[TMP10:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP11:%.*]] = mul i64 [[TMP10]], 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX2]], [[TMP11]]
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP0]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8* [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[START]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PTR_PHI:%.*]] = phi i8* [ [[PTR_PHI_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ [[INDEX_NXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INDEX_NXT]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP13:%.*]] = load i8, i8* [[PTR_PHI]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[TMP13]], 1
; CHECK-NEXT:    store i8 [[ADD]], i8* [[PTR_PHI]], align 1
; CHECK-NEXT:    [[PTR_PHI_NEXT]] = getelementptr inbounds i8, i8* [[PTR_PHI]], i64 1
; CHECK-NEXT:    [[CMP_I_NOT:%.*]] = icmp eq i8* [[PTR_PHI_NEXT]], [[START]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[INDEX]], [[N]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[END]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %ptr.phi = phi i8* [ %ptr.phi.next, %for.body ], [ %start, %entry ]
  %index = phi i64 [ %index_nxt, %for.body ], [ 0, %entry ]
  %index_nxt = add i64 %index, 1
  %0 = load i8, i8* %ptr.phi, align 1
  %add = add i8 %0, 1
  store i8 %add, i8* %ptr.phi
  %ptr.phi.next = getelementptr inbounds i8, i8* %ptr.phi, i64 1
  %cmp.i.not = icmp eq i8* %ptr.phi.next, %start
  %cmp = icmp ult i64 %index, %N
  br i1 %cmp, label %for.body, label %end, !llvm.loop !0

end:
  ret void
}

attributes #0 = {"target-features"="+sve"}

!0 = distinct !{!0, !1, !2, !3}
!1 = !{!"llvm.loop.interleave.count", i32 1}
!2 = !{!"llvm.loop.vectorize.width", i32 2}
!3 = !{!"llvm.loop.vectorize.scalable.enable", i1 true}
!4 = !{ !5 }
!5 = distinct !{ !5, !6 }
!6 = distinct !{ !7 }
!7 = distinct !{ !7, !6 }
