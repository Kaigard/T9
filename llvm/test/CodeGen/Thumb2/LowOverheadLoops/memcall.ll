; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --arm-memtransfer-tploop=allow -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs -tail-predication=enabled -o - %s | FileCheck %s

define void @test_memcpy(i32* nocapture %x, i32* nocapture readonly %y, i32 %n, i32 %m) {
; CHECK-LABEL: test_memcpy:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    blt .LBB0_5
; CHECK-NEXT:  @ %bb.1: @ %for.body.preheader
; CHECK-NEXT:    lsl.w r12, r3, #2
; CHECK-NEXT:    movs r7, #0
; CHECK-NEXT:    b .LBB0_2
; CHECK-NEXT:  .LBB0_2: @ %for.body
; CHECK-NEXT:    @ =>This Loop Header: Depth=1
; CHECK-NEXT:    @ Child Loop BB0_4 Depth 2
; CHECK-NEXT:    adds r4, r1, r7
; CHECK-NEXT:    adds r5, r0, r7
; CHECK-NEXT:    wlstp.8 lr, r3, .LBB0_3
; CHECK-NEXT:    b .LBB0_4
; CHECK-NEXT:  .LBB0_3: @ %for.body
; CHECK-NEXT:    @ in Loop: Header=BB0_2 Depth=1
; CHECK-NEXT:    add r7, r12
; CHECK-NEXT:    subs r2, #1
; CHECK-NEXT:    beq .LBB0_5
; CHECK-NEXT:    b .LBB0_2
; CHECK-NEXT:  .LBB0_4: @ Parent Loop BB0_2 Depth=1
; CHECK-NEXT:    @ => This Inner Loop Header: Depth=2
; CHECK-NEXT:    vldrb.u8 q0, [r4], #16
; CHECK-NEXT:    vstrb.8 q0, [r5], #16
; CHECK-NEXT:    letp lr, .LBB0_4
; CHECK-NEXT:    b .LBB0_3
; CHECK-NEXT:  .LBB0_5: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.011 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %x.addr.010 = phi i32* [ %add.ptr, %for.body ], [ %x, %entry ]
  %y.addr.09 = phi i32* [ %add.ptr1, %for.body ], [ %y, %entry ]
  %0 = bitcast i32* %x.addr.010 to i8*
  %1 = bitcast i32* %y.addr.09 to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 %m, i1 false)
  %add.ptr = getelementptr inbounds i32, i32* %x.addr.010, i32 %m
  %add.ptr1 = getelementptr inbounds i32, i32* %y.addr.09, i32 %m
  %inc = add nuw nsw i32 %i.011, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

define void @test_memset(i32* nocapture %x, i32 %n, i32 %m) {
; CHECK-LABEL: test_memset:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    cmp r1, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r4, pc}
; CHECK-NEXT:  .LBB1_1: @ %for.body.preheader
; CHECK-NEXT:    lsl.w r12, r2, #2
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    b .LBB1_2
; CHECK-NEXT:  .LBB1_2: @ %for.body
; CHECK-NEXT:    @ =>This Loop Header: Depth=1
; CHECK-NEXT:    @ Child Loop BB1_4 Depth 2
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB1_3
; CHECK-NEXT:    b .LBB1_4
; CHECK-NEXT:  .LBB1_3: @ %for.body
; CHECK-NEXT:    @ in Loop: Header=BB1_2 Depth=1
; CHECK-NEXT:    add r0, r12
; CHECK-NEXT:    subs r1, #1
; CHECK-NEXT:    beq .LBB1_5
; CHECK-NEXT:    b .LBB1_2
; CHECK-NEXT:  .LBB1_4: @ Parent Loop BB1_2 Depth=1
; CHECK-NEXT:    @ => This Inner Loop Header: Depth=2
; CHECK-NEXT:    vstrb.8 q0, [r4], #16
; CHECK-NEXT:    letp lr, .LBB1_4
; CHECK-NEXT:    b .LBB1_3
; CHECK-NEXT:  .LBB1_5: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r4, pc}
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %x.addr.06 = phi i32* [ %add.ptr, %for.body ], [ %x, %entry ]
  %0 = bitcast i32* %x.addr.06 to i8*
  tail call void @llvm.memset.p0i8.i32(i8* align 4 %0, i8 0, i32 %m, i1 false)
  %add.ptr = getelementptr inbounds i32, i32* %x.addr.06, i32 %m
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

define void @test_memmove(i32* nocapture %x, i32* nocapture readonly %y, i32 %n, i32 %m) {
; CHECK-LABEL: test_memmove:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, r9, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, r9, lr}
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    blt .LBB2_3
; CHECK-NEXT:  @ %bb.1: @ %for.body.preheader
; CHECK-NEXT:    mov r8, r3
; CHECK-NEXT:    mov r5, r2
; CHECK-NEXT:    mov r9, r1
; CHECK-NEXT:    mov r7, r0
; CHECK-NEXT:    lsls r4, r3, #2
; CHECK-NEXT:    movs r6, #0
; CHECK-NEXT:  .LBB2_2: @ %for.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    adds r0, r7, r6
; CHECK-NEXT:    add.w r1, r9, r6
; CHECK-NEXT:    mov r2, r8
; CHECK-NEXT:    bl __aeabi_memmove4
; CHECK-NEXT:    add r6, r4
; CHECK-NEXT:    subs r5, #1
; CHECK-NEXT:    bne .LBB2_2
; CHECK-NEXT:  .LBB2_3: @ %for.cond.cleanup
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.011 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %x.addr.010 = phi i32* [ %add.ptr, %for.body ], [ %x, %entry ]
  %y.addr.09 = phi i32* [ %add.ptr1, %for.body ], [ %y, %entry ]
  %0 = bitcast i32* %x.addr.010 to i8*
  %1 = bitcast i32* %y.addr.09 to i8*
  tail call void @llvm.memmove.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 %m, i1 false)
  %add.ptr = getelementptr inbounds i32, i32* %x.addr.010, i32 %m
  %add.ptr1 = getelementptr inbounds i32, i32* %y.addr.09, i32 %m
  %inc = add nuw nsw i32 %i.011, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}


define void @test_memcpy16(i32* nocapture %x, i32* nocapture readonly %y, i32 %n) {
; CHECK-LABEL: test_memcpy16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r4, pc}
; CHECK-NEXT:  .LBB3_1: @ %for.body.preheader
; CHECK-NEXT:    dls lr, r2
; CHECK-NEXT:  .LBB3_2: @ %for.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldm.w r1, {r2, r3, r12}
; CHECK-NEXT:    ldr r4, [r1, #12]
; CHECK-NEXT:    adds r1, #64
; CHECK-NEXT:    stm.w r0, {r2, r3, r12}
; CHECK-NEXT:    str r4, [r0, #12]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    le lr, .LBB3_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r4, pc}
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.09 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %x.addr.08 = phi i32* [ %add.ptr, %for.body ], [ %x, %entry ]
  %y.addr.07 = phi i32* [ %add.ptr1, %for.body ], [ %y, %entry ]
  %0 = bitcast i32* %x.addr.08 to i8*
  %1 = bitcast i32* %y.addr.07 to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull align 4 dereferenceable(16) %0, i8* nonnull align 4 dereferenceable(16) %1, i32 16, i1 false)
  %add.ptr = getelementptr inbounds i32, i32* %x.addr.08, i32 16
  %add.ptr1 = getelementptr inbounds i32, i32* %y.addr.07, i32 16
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

define void @test_memset16(i32* nocapture %x, i32 %n) {
; CHECK-LABEL: test_memset16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r1, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB4_1: @ %for.body.preheader
; CHECK-NEXT:    dls lr, r1
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:  .LBB4_2: @ %for.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    strd r1, r1, [r0]
; CHECK-NEXT:    strd r1, r1, [r0, #8]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    le lr, .LBB4_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %x.addr.05 = phi i32* [ %add.ptr, %for.body ], [ %x, %entry ]
  %0 = bitcast i32* %x.addr.05 to i8*
  tail call void @llvm.memset.p0i8.i32(i8* nonnull align 4 dereferenceable(16) %0, i8 0, i32 16, i1 false)
  %add.ptr = getelementptr inbounds i32, i32* %x.addr.05, i32 16
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

define void @test_memmove16(i32* nocapture %x, i32* nocapture readonly %y, i32 %n) {
; CHECK-LABEL: test_memmove16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r4, pc}
; CHECK-NEXT:  .LBB5_1: @ %for.body.preheader
; CHECK-NEXT:    dls lr, r2
; CHECK-NEXT:  .LBB5_2: @ %for.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldm.w r1, {r2, r3, r12}
; CHECK-NEXT:    ldr r4, [r1, #12]
; CHECK-NEXT:    adds r1, #64
; CHECK-NEXT:    stm.w r0, {r2, r3, r12}
; CHECK-NEXT:    str r4, [r0, #12]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    le lr, .LBB5_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r4, pc}
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.09 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %x.addr.08 = phi i32* [ %add.ptr, %for.body ], [ %x, %entry ]
  %y.addr.07 = phi i32* [ %add.ptr1, %for.body ], [ %y, %entry ]
  %0 = bitcast i32* %x.addr.08 to i8*
  %1 = bitcast i32* %y.addr.07 to i8*
  tail call void @llvm.memmove.p0i8.p0i8.i32(i8* nonnull align 4 dereferenceable(16) %0, i8* nonnull align 4 dereferenceable(16) %1, i32 16, i1 false)
  %add.ptr = getelementptr inbounds i32, i32* %x.addr.08, i32 16
  %add.ptr1 = getelementptr inbounds i32, i32* %y.addr.07, i32 16
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

define void @test_memset_preheader(i8* %x, i8* %y, i32 %n) {
; CHECK-LABEL: test_memset_preheader:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cbz r2, .LBB6_5
; CHECK-NEXT:  @ %bb.1: @ %prehead
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    mov r12, r0
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB6_3
; CHECK-NEXT:  .LBB6_2: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r12], #16
; CHECK-NEXT:    letp lr, .LBB6_2
; CHECK-NEXT:  .LBB6_3: @ %prehead
; CHECK-NEXT:    dls lr, r2
; CHECK-NEXT:    mov r12, r0
; CHECK-NEXT:  .LBB6_4: @ %for.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrb r3, [r12], #1
; CHECK-NEXT:    strb r3, [r1], #1
; CHECK-NEXT:    le lr, .LBB6_4
; CHECK-NEXT:  .LBB6_5: @ %for.cond.cleanup
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB6_7
; CHECK-NEXT:  .LBB6_6: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB6_6
; CHECK-NEXT:  .LBB6_7: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp6 = icmp ne i32 %n, 0
  br i1 %cmp6, label %prehead, label %for.cond.cleanup

prehead:
  call void @llvm.memset.p0i8.i32(i8* %x, i8 0, i32 %n, i1 false)
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.09 = phi i32 [ %inc, %for.body ], [ 0, %prehead ]
  %x.addr.08 = phi i8* [ %add.ptr, %for.body ], [ %x, %prehead ]
  %y.addr.07 = phi i8* [ %add.ptr1, %for.body ], [ %y, %prehead ]
  %add.ptr = getelementptr inbounds i8, i8* %x.addr.08, i32 1
  %add.ptr1 = getelementptr inbounds i8, i8* %y.addr.07, i32 1
  %l = load i8, i8* %x.addr.08
  store i8 %l, i8* %y.addr.07
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  call void @llvm.memset.p0i8.i32(i8* %x, i8 0, i32 %n, i1 false)
  ret void
}



declare void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i32, i1 immarg)
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1 immarg)
declare void @llvm.memmove.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1 immarg)
