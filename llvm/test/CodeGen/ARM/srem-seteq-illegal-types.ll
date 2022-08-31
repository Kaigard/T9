; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv5-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=ARM5
; RUN: llc -mtriple=armv6-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=ARM6
; RUN: llc -mtriple=armv7-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=ARM7
; RUN: llc -mtriple=armv8-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=ARM8
; RUN: llc -mtriple=armv7-unknown-linux-gnu -mattr=+neon < %s | FileCheck %s --check-prefixes=NEON7
; RUN: llc -mtriple=armv8-unknown-linux-gnu -mattr=+neon < %s | FileCheck %s --check-prefixes=NEON8

define i1 @test_srem_odd(i29 %X) nounwind {
; ARM5-LABEL: test_srem_odd:
; ARM5:       @ %bb.0:
; ARM5-NEXT:    ldr r2, .LCPI0_1
; ARM5-NEXT:    ldr r1, .LCPI0_0
; ARM5-NEXT:    mla r3, r0, r2, r1
; ARM5-NEXT:    ldr r2, .LCPI0_2
; ARM5-NEXT:    mov r0, #0
; ARM5-NEXT:    bic r1, r3, #-536870912
; ARM5-NEXT:    cmp r1, r2
; ARM5-NEXT:    movlo r0, #1
; ARM5-NEXT:    bx lr
; ARM5-NEXT:    .p2align 2
; ARM5-NEXT:  @ %bb.1:
; ARM5-NEXT:  .LCPI0_0:
; ARM5-NEXT:    .long 2711469 @ 0x295fad
; ARM5-NEXT:  .LCPI0_1:
; ARM5-NEXT:    .long 526025035 @ 0x1f5a814b
; ARM5-NEXT:  .LCPI0_2:
; ARM5-NEXT:    .long 5422939 @ 0x52bf5b
;
; ARM6-LABEL: test_srem_odd:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldr r2, .LCPI0_1
; ARM6-NEXT:    ldr r1, .LCPI0_0
; ARM6-NEXT:    mla r0, r0, r2, r1
; ARM6-NEXT:    ldr r2, .LCPI0_2
; ARM6-NEXT:    bic r1, r0, #-536870912
; ARM6-NEXT:    mov r0, #0
; ARM6-NEXT:    cmp r1, r2
; ARM6-NEXT:    movlo r0, #1
; ARM6-NEXT:    bx lr
; ARM6-NEXT:    .p2align 2
; ARM6-NEXT:  @ %bb.1:
; ARM6-NEXT:  .LCPI0_0:
; ARM6-NEXT:    .long 2711469 @ 0x295fad
; ARM6-NEXT:  .LCPI0_1:
; ARM6-NEXT:    .long 526025035 @ 0x1f5a814b
; ARM6-NEXT:  .LCPI0_2:
; ARM6-NEXT:    .long 5422939 @ 0x52bf5b
;
; ARM7-LABEL: test_srem_odd:
; ARM7:       @ %bb.0:
; ARM7-NEXT:    movw r1, #24493
; ARM7-NEXT:    movw r2, #33099
; ARM7-NEXT:    movt r1, #41
; ARM7-NEXT:    movt r2, #8026
; ARM7-NEXT:    mla r0, r0, r2, r1
; ARM7-NEXT:    movw r2, #48987
; ARM7-NEXT:    movt r2, #82
; ARM7-NEXT:    bic r1, r0, #-536870912
; ARM7-NEXT:    mov r0, #0
; ARM7-NEXT:    cmp r1, r2
; ARM7-NEXT:    movwlo r0, #1
; ARM7-NEXT:    bx lr
;
; ARM8-LABEL: test_srem_odd:
; ARM8:       @ %bb.0:
; ARM8-NEXT:    movw r1, #24493
; ARM8-NEXT:    movw r2, #33099
; ARM8-NEXT:    movt r1, #41
; ARM8-NEXT:    movt r2, #8026
; ARM8-NEXT:    mla r0, r0, r2, r1
; ARM8-NEXT:    movw r2, #48987
; ARM8-NEXT:    movt r2, #82
; ARM8-NEXT:    bic r1, r0, #-536870912
; ARM8-NEXT:    mov r0, #0
; ARM8-NEXT:    cmp r1, r2
; ARM8-NEXT:    movwlo r0, #1
; ARM8-NEXT:    bx lr
;
; NEON7-LABEL: test_srem_odd:
; NEON7:       @ %bb.0:
; NEON7-NEXT:    movw r1, #24493
; NEON7-NEXT:    movw r2, #33099
; NEON7-NEXT:    movt r1, #41
; NEON7-NEXT:    movt r2, #8026
; NEON7-NEXT:    mla r0, r0, r2, r1
; NEON7-NEXT:    movw r2, #48987
; NEON7-NEXT:    movt r2, #82
; NEON7-NEXT:    bic r1, r0, #-536870912
; NEON7-NEXT:    mov r0, #0
; NEON7-NEXT:    cmp r1, r2
; NEON7-NEXT:    movwlo r0, #1
; NEON7-NEXT:    bx lr
;
; NEON8-LABEL: test_srem_odd:
; NEON8:       @ %bb.0:
; NEON8-NEXT:    movw r1, #24493
; NEON8-NEXT:    movw r2, #33099
; NEON8-NEXT:    movt r1, #41
; NEON8-NEXT:    movt r2, #8026
; NEON8-NEXT:    mla r0, r0, r2, r1
; NEON8-NEXT:    movw r2, #48987
; NEON8-NEXT:    movt r2, #82
; NEON8-NEXT:    bic r1, r0, #-536870912
; NEON8-NEXT:    mov r0, #0
; NEON8-NEXT:    cmp r1, r2
; NEON8-NEXT:    movwlo r0, #1
; NEON8-NEXT:    bx lr
  %srem = srem i29 %X, 99
  %cmp = icmp eq i29 %srem, 0
  ret i1 %cmp
}

define i1 @test_srem_even(i4 %X) nounwind {
; ARM5-LABEL: test_srem_even:
; ARM5:       @ %bb.0:
; ARM5-NEXT:    lsl r1, r0, #28
; ARM5-NEXT:    mov r2, #1
; ARM5-NEXT:    asr r1, r1, #28
; ARM5-NEXT:    add r1, r1, r1, lsl #1
; ARM5-NEXT:    and r2, r2, r1, lsr #7
; ARM5-NEXT:    add r1, r2, r1, lsr #4
; ARM5-NEXT:    add r1, r1, r1, lsl #1
; ARM5-NEXT:    sub r0, r0, r1, lsl #1
; ARM5-NEXT:    and r0, r0, #15
; ARM5-NEXT:    sub r0, r0, #1
; ARM5-NEXT:    clz r0, r0
; ARM5-NEXT:    lsr r0, r0, #5
; ARM5-NEXT:    bx lr
;
; ARM6-LABEL: test_srem_even:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    lsl r1, r0, #28
; ARM6-NEXT:    mov r2, #1
; ARM6-NEXT:    asr r1, r1, #28
; ARM6-NEXT:    add r1, r1, r1, lsl #1
; ARM6-NEXT:    and r2, r2, r1, lsr #7
; ARM6-NEXT:    add r1, r2, r1, lsr #4
; ARM6-NEXT:    add r1, r1, r1, lsl #1
; ARM6-NEXT:    sub r0, r0, r1, lsl #1
; ARM6-NEXT:    and r0, r0, #15
; ARM6-NEXT:    sub r0, r0, #1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    bx lr
;
; ARM7-LABEL: test_srem_even:
; ARM7:       @ %bb.0:
; ARM7-NEXT:    sbfx r1, r0, #0, #4
; ARM7-NEXT:    add r1, r1, r1, lsl #1
; ARM7-NEXT:    ubfx r2, r1, #7, #1
; ARM7-NEXT:    add r1, r2, r1, lsr #4
; ARM7-NEXT:    add r1, r1, r1, lsl #1
; ARM7-NEXT:    sub r0, r0, r1, lsl #1
; ARM7-NEXT:    and r0, r0, #15
; ARM7-NEXT:    sub r0, r0, #1
; ARM7-NEXT:    clz r0, r0
; ARM7-NEXT:    lsr r0, r0, #5
; ARM7-NEXT:    bx lr
;
; ARM8-LABEL: test_srem_even:
; ARM8:       @ %bb.0:
; ARM8-NEXT:    sbfx r1, r0, #0, #4
; ARM8-NEXT:    add r1, r1, r1, lsl #1
; ARM8-NEXT:    ubfx r2, r1, #7, #1
; ARM8-NEXT:    add r1, r2, r1, lsr #4
; ARM8-NEXT:    add r1, r1, r1, lsl #1
; ARM8-NEXT:    sub r0, r0, r1, lsl #1
; ARM8-NEXT:    and r0, r0, #15
; ARM8-NEXT:    sub r0, r0, #1
; ARM8-NEXT:    clz r0, r0
; ARM8-NEXT:    lsr r0, r0, #5
; ARM8-NEXT:    bx lr
;
; NEON7-LABEL: test_srem_even:
; NEON7:       @ %bb.0:
; NEON7-NEXT:    sbfx r1, r0, #0, #4
; NEON7-NEXT:    add r1, r1, r1, lsl #1
; NEON7-NEXT:    ubfx r2, r1, #7, #1
; NEON7-NEXT:    add r1, r2, r1, lsr #4
; NEON7-NEXT:    add r1, r1, r1, lsl #1
; NEON7-NEXT:    sub r0, r0, r1, lsl #1
; NEON7-NEXT:    and r0, r0, #15
; NEON7-NEXT:    sub r0, r0, #1
; NEON7-NEXT:    clz r0, r0
; NEON7-NEXT:    lsr r0, r0, #5
; NEON7-NEXT:    bx lr
;
; NEON8-LABEL: test_srem_even:
; NEON8:       @ %bb.0:
; NEON8-NEXT:    sbfx r1, r0, #0, #4
; NEON8-NEXT:    add r1, r1, r1, lsl #1
; NEON8-NEXT:    ubfx r2, r1, #7, #1
; NEON8-NEXT:    add r1, r2, r1, lsr #4
; NEON8-NEXT:    add r1, r1, r1, lsl #1
; NEON8-NEXT:    sub r0, r0, r1, lsl #1
; NEON8-NEXT:    and r0, r0, #15
; NEON8-NEXT:    sub r0, r0, #1
; NEON8-NEXT:    clz r0, r0
; NEON8-NEXT:    lsr r0, r0, #5
; NEON8-NEXT:    bx lr
  %srem = srem i4 %X, 6
  %cmp = icmp eq i4 %srem, 1
  ret i1 %cmp
}

define i1 @test_srem_pow2_setne(i6 %X) nounwind {
; ARM5-LABEL: test_srem_pow2_setne:
; ARM5:       @ %bb.0:
; ARM5-NEXT:    lsl r1, r0, #26
; ARM5-NEXT:    mov r2, #3
; ARM5-NEXT:    asr r1, r1, #26
; ARM5-NEXT:    and r1, r2, r1, lsr #9
; ARM5-NEXT:    add r1, r0, r1
; ARM5-NEXT:    and r1, r1, #60
; ARM5-NEXT:    sub r0, r0, r1
; ARM5-NEXT:    ands r0, r0, #63
; ARM5-NEXT:    movne r0, #1
; ARM5-NEXT:    bx lr
;
; ARM6-LABEL: test_srem_pow2_setne:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    lsl r1, r0, #26
; ARM6-NEXT:    mov r2, #3
; ARM6-NEXT:    asr r1, r1, #26
; ARM6-NEXT:    and r1, r2, r1, lsr #9
; ARM6-NEXT:    add r1, r0, r1
; ARM6-NEXT:    and r1, r1, #60
; ARM6-NEXT:    sub r0, r0, r1
; ARM6-NEXT:    ands r0, r0, #63
; ARM6-NEXT:    movne r0, #1
; ARM6-NEXT:    bx lr
;
; ARM7-LABEL: test_srem_pow2_setne:
; ARM7:       @ %bb.0:
; ARM7-NEXT:    sbfx r1, r0, #0, #6
; ARM7-NEXT:    ubfx r1, r1, #9, #2
; ARM7-NEXT:    add r1, r0, r1
; ARM7-NEXT:    and r1, r1, #60
; ARM7-NEXT:    sub r0, r0, r1
; ARM7-NEXT:    ands r0, r0, #63
; ARM7-NEXT:    movwne r0, #1
; ARM7-NEXT:    bx lr
;
; ARM8-LABEL: test_srem_pow2_setne:
; ARM8:       @ %bb.0:
; ARM8-NEXT:    sbfx r1, r0, #0, #6
; ARM8-NEXT:    ubfx r1, r1, #9, #2
; ARM8-NEXT:    add r1, r0, r1
; ARM8-NEXT:    and r1, r1, #60
; ARM8-NEXT:    sub r0, r0, r1
; ARM8-NEXT:    ands r0, r0, #63
; ARM8-NEXT:    movwne r0, #1
; ARM8-NEXT:    bx lr
;
; NEON7-LABEL: test_srem_pow2_setne:
; NEON7:       @ %bb.0:
; NEON7-NEXT:    sbfx r1, r0, #0, #6
; NEON7-NEXT:    ubfx r1, r1, #9, #2
; NEON7-NEXT:    add r1, r0, r1
; NEON7-NEXT:    and r1, r1, #60
; NEON7-NEXT:    sub r0, r0, r1
; NEON7-NEXT:    ands r0, r0, #63
; NEON7-NEXT:    movwne r0, #1
; NEON7-NEXT:    bx lr
;
; NEON8-LABEL: test_srem_pow2_setne:
; NEON8:       @ %bb.0:
; NEON8-NEXT:    sbfx r1, r0, #0, #6
; NEON8-NEXT:    ubfx r1, r1, #9, #2
; NEON8-NEXT:    add r1, r0, r1
; NEON8-NEXT:    and r1, r1, #60
; NEON8-NEXT:    sub r0, r0, r1
; NEON8-NEXT:    ands r0, r0, #63
; NEON8-NEXT:    movwne r0, #1
; NEON8-NEXT:    bx lr
  %srem = srem i6 %X, 4
  %cmp = icmp ne i6 %srem, 0
  ret i1 %cmp
}

define <3 x i1> @test_srem_vec(<3 x i33> %X) nounwind {
; ARM5-LABEL: test_srem_vec:
; ARM5:       @ %bb.0:
; ARM5-NEXT:    push {r4, r5, r6, lr}
; ARM5-NEXT:    and r1, r1, #1
; ARM5-NEXT:    mov r5, r3
; ARM5-NEXT:    rsb r1, r1, #0
; ARM5-NEXT:    mov r6, r2
; ARM5-NEXT:    mov r2, #9
; ARM5-NEXT:    mov r3, #0
; ARM5-NEXT:    bl __moddi3
; ARM5-NEXT:    eor r0, r0, #3
; ARM5-NEXT:    mov r2, #9
; ARM5-NEXT:    orrs r4, r0, r1
; ARM5-NEXT:    and r0, r5, #1
; ARM5-NEXT:    rsb r1, r0, #0
; ARM5-NEXT:    mov r0, r6
; ARM5-NEXT:    mov r3, #0
; ARM5-NEXT:    movne r4, #1
; ARM5-NEXT:    bl __moddi3
; ARM5-NEXT:    mov r2, #1
; ARM5-NEXT:    bic r1, r2, r1
; ARM5-NEXT:    mvn r2, #2
; ARM5-NEXT:    eor r0, r0, r2
; ARM5-NEXT:    orrs r5, r0, r1
; ARM5-NEXT:    ldr r0, [sp, #20]
; ARM5-NEXT:    mvn r2, #8
; ARM5-NEXT:    mvn r3, #0
; ARM5-NEXT:    and r0, r0, #1
; ARM5-NEXT:    movne r5, #1
; ARM5-NEXT:    rsb r1, r0, #0
; ARM5-NEXT:    ldr r0, [sp, #16]
; ARM5-NEXT:    bl __moddi3
; ARM5-NEXT:    eor r0, r0, #3
; ARM5-NEXT:    orrs r2, r0, r1
; ARM5-NEXT:    mov r0, r4
; ARM5-NEXT:    movne r2, #1
; ARM5-NEXT:    mov r1, r5
; ARM5-NEXT:    pop {r4, r5, r6, pc}
;
; ARM6-LABEL: test_srem_vec:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r4, r5, r6, lr}
; ARM6-NEXT:    and r1, r1, #1
; ARM6-NEXT:    mov r5, r3
; ARM6-NEXT:    rsb r1, r1, #0
; ARM6-NEXT:    mov r6, r2
; ARM6-NEXT:    mov r2, #9
; ARM6-NEXT:    mov r3, #0
; ARM6-NEXT:    bl __moddi3
; ARM6-NEXT:    eor r0, r0, #3
; ARM6-NEXT:    mov r2, #9
; ARM6-NEXT:    orrs r4, r0, r1
; ARM6-NEXT:    and r0, r5, #1
; ARM6-NEXT:    rsb r1, r0, #0
; ARM6-NEXT:    mov r0, r6
; ARM6-NEXT:    mov r3, #0
; ARM6-NEXT:    movne r4, #1
; ARM6-NEXT:    bl __moddi3
; ARM6-NEXT:    mov r2, #1
; ARM6-NEXT:    bic r1, r2, r1
; ARM6-NEXT:    mvn r2, #2
; ARM6-NEXT:    eor r0, r0, r2
; ARM6-NEXT:    orrs r5, r0, r1
; ARM6-NEXT:    ldr r0, [sp, #20]
; ARM6-NEXT:    mvn r2, #8
; ARM6-NEXT:    mvn r3, #0
; ARM6-NEXT:    and r0, r0, #1
; ARM6-NEXT:    movne r5, #1
; ARM6-NEXT:    rsb r1, r0, #0
; ARM6-NEXT:    ldr r0, [sp, #16]
; ARM6-NEXT:    bl __moddi3
; ARM6-NEXT:    eor r0, r0, #3
; ARM6-NEXT:    orrs r2, r0, r1
; ARM6-NEXT:    mov r0, r4
; ARM6-NEXT:    movne r2, #1
; ARM6-NEXT:    mov r1, r5
; ARM6-NEXT:    pop {r4, r5, r6, pc}
;
; ARM7-LABEL: test_srem_vec:
; ARM7:       @ %bb.0:
; ARM7-NEXT:    push {r4, r5, r6, r7, r11, lr}
; ARM7-NEXT:    vpush {d8, d9}
; ARM7-NEXT:    mov r6, r0
; ARM7-NEXT:    and r0, r3, #1
; ARM7-NEXT:    mov r5, r1
; ARM7-NEXT:    rsb r1, r0, #0
; ARM7-NEXT:    mov r0, r2
; ARM7-NEXT:    mov r2, #9
; ARM7-NEXT:    mov r3, #0
; ARM7-NEXT:    bl __moddi3
; ARM7-NEXT:    mov r7, r0
; ARM7-NEXT:    and r0, r5, #1
; ARM7-NEXT:    mov r4, r1
; ARM7-NEXT:    rsb r1, r0, #0
; ARM7-NEXT:    mov r0, r6
; ARM7-NEXT:    mov r2, #9
; ARM7-NEXT:    mov r3, #0
; ARM7-NEXT:    bl __moddi3
; ARM7-NEXT:    vmov.32 d8[0], r0
; ARM7-NEXT:    ldr r0, [sp, #44]
; ARM7-NEXT:    ldr r2, [sp, #40]
; ARM7-NEXT:    mov r5, r1
; ARM7-NEXT:    and r0, r0, #1
; ARM7-NEXT:    mvn r3, #0
; ARM7-NEXT:    rsb r1, r0, #0
; ARM7-NEXT:    vmov.32 d9[0], r7
; ARM7-NEXT:    mov r0, r2
; ARM7-NEXT:    mvn r2, #8
; ARM7-NEXT:    bl __moddi3
; ARM7-NEXT:    vmov.32 d16[0], r0
; ARM7-NEXT:    adr r0, .LCPI3_0
; ARM7-NEXT:    vmov.32 d9[1], r4
; ARM7-NEXT:    vld1.64 {d18, d19}, [r0:128]
; ARM7-NEXT:    adr r0, .LCPI3_1
; ARM7-NEXT:    vmov.32 d16[1], r1
; ARM7-NEXT:    vmov.32 d8[1], r5
; ARM7-NEXT:    vand q8, q8, q9
; ARM7-NEXT:    vld1.64 {d20, d21}, [r0:128]
; ARM7-NEXT:    adr r0, .LCPI3_2
; ARM7-NEXT:    vand q11, q4, q9
; ARM7-NEXT:    vld1.64 {d18, d19}, [r0:128]
; ARM7-NEXT:    vceq.i32 q10, q11, q10
; ARM7-NEXT:    vceq.i32 q8, q8, q9
; ARM7-NEXT:    vrev64.32 q9, q10
; ARM7-NEXT:    vrev64.32 q11, q8
; ARM7-NEXT:    vand q9, q10, q9
; ARM7-NEXT:    vand q8, q8, q11
; ARM7-NEXT:    vmvn q9, q9
; ARM7-NEXT:    vmvn q8, q8
; ARM7-NEXT:    vmovn.i64 d18, q9
; ARM7-NEXT:    vmovn.i64 d16, q8
; ARM7-NEXT:    vmov.32 r0, d18[0]
; ARM7-NEXT:    vmov.32 r1, d18[1]
; ARM7-NEXT:    vmov.32 r2, d16[0]
; ARM7-NEXT:    vpop {d8, d9}
; ARM7-NEXT:    pop {r4, r5, r6, r7, r11, pc}
; ARM7-NEXT:    .p2align 4
; ARM7-NEXT:  @ %bb.1:
; ARM7-NEXT:  .LCPI3_0:
; ARM7-NEXT:    .long 4294967295 @ 0xffffffff
; ARM7-NEXT:    .long 1 @ 0x1
; ARM7-NEXT:    .long 4294967295 @ 0xffffffff
; ARM7-NEXT:    .long 1 @ 0x1
; ARM7-NEXT:  .LCPI3_1:
; ARM7-NEXT:    .long 3 @ 0x3
; ARM7-NEXT:    .long 0 @ 0x0
; ARM7-NEXT:    .long 4294967293 @ 0xfffffffd
; ARM7-NEXT:    .long 1 @ 0x1
; ARM7-NEXT:  .LCPI3_2:
; ARM7-NEXT:    .long 3 @ 0x3
; ARM7-NEXT:    .long 0 @ 0x0
; ARM7-NEXT:    .long 0 @ 0x0
; ARM7-NEXT:    .long 0 @ 0x0
;
; ARM8-LABEL: test_srem_vec:
; ARM8:       @ %bb.0:
; ARM8-NEXT:    push {r4, r5, r6, r7, r11, lr}
; ARM8-NEXT:    vpush {d8, d9}
; ARM8-NEXT:    mov r6, r0
; ARM8-NEXT:    and r0, r3, #1
; ARM8-NEXT:    mov r5, r1
; ARM8-NEXT:    rsb r1, r0, #0
; ARM8-NEXT:    mov r0, r2
; ARM8-NEXT:    mov r2, #9
; ARM8-NEXT:    mov r3, #0
; ARM8-NEXT:    bl __moddi3
; ARM8-NEXT:    mov r7, r0
; ARM8-NEXT:    and r0, r5, #1
; ARM8-NEXT:    mov r4, r1
; ARM8-NEXT:    rsb r1, r0, #0
; ARM8-NEXT:    mov r0, r6
; ARM8-NEXT:    mov r2, #9
; ARM8-NEXT:    mov r3, #0
; ARM8-NEXT:    bl __moddi3
; ARM8-NEXT:    vmov.32 d8[0], r0
; ARM8-NEXT:    ldr r0, [sp, #44]
; ARM8-NEXT:    ldr r2, [sp, #40]
; ARM8-NEXT:    mov r5, r1
; ARM8-NEXT:    and r0, r0, #1
; ARM8-NEXT:    mvn r3, #0
; ARM8-NEXT:    rsb r1, r0, #0
; ARM8-NEXT:    vmov.32 d9[0], r7
; ARM8-NEXT:    mov r0, r2
; ARM8-NEXT:    mvn r2, #8
; ARM8-NEXT:    bl __moddi3
; ARM8-NEXT:    vmov.32 d16[0], r0
; ARM8-NEXT:    adr r0, .LCPI3_0
; ARM8-NEXT:    vmov.32 d9[1], r4
; ARM8-NEXT:    vld1.64 {d18, d19}, [r0:128]
; ARM8-NEXT:    adr r0, .LCPI3_1
; ARM8-NEXT:    vmov.32 d16[1], r1
; ARM8-NEXT:    vmov.32 d8[1], r5
; ARM8-NEXT:    vand q8, q8, q9
; ARM8-NEXT:    vld1.64 {d20, d21}, [r0:128]
; ARM8-NEXT:    adr r0, .LCPI3_2
; ARM8-NEXT:    vand q11, q4, q9
; ARM8-NEXT:    vld1.64 {d18, d19}, [r0:128]
; ARM8-NEXT:    vceq.i32 q10, q11, q10
; ARM8-NEXT:    vceq.i32 q8, q8, q9
; ARM8-NEXT:    vrev64.32 q9, q10
; ARM8-NEXT:    vrev64.32 q11, q8
; ARM8-NEXT:    vand q9, q10, q9
; ARM8-NEXT:    vand q8, q8, q11
; ARM8-NEXT:    vmvn q9, q9
; ARM8-NEXT:    vmvn q8, q8
; ARM8-NEXT:    vmovn.i64 d18, q9
; ARM8-NEXT:    vmovn.i64 d16, q8
; ARM8-NEXT:    vmov.32 r0, d18[0]
; ARM8-NEXT:    vmov.32 r1, d18[1]
; ARM8-NEXT:    vmov.32 r2, d16[0]
; ARM8-NEXT:    vpop {d8, d9}
; ARM8-NEXT:    pop {r4, r5, r6, r7, r11, pc}
; ARM8-NEXT:    .p2align 4
; ARM8-NEXT:  @ %bb.1:
; ARM8-NEXT:  .LCPI3_0:
; ARM8-NEXT:    .long 4294967295 @ 0xffffffff
; ARM8-NEXT:    .long 1 @ 0x1
; ARM8-NEXT:    .long 4294967295 @ 0xffffffff
; ARM8-NEXT:    .long 1 @ 0x1
; ARM8-NEXT:  .LCPI3_1:
; ARM8-NEXT:    .long 3 @ 0x3
; ARM8-NEXT:    .long 0 @ 0x0
; ARM8-NEXT:    .long 4294967293 @ 0xfffffffd
; ARM8-NEXT:    .long 1 @ 0x1
; ARM8-NEXT:  .LCPI3_2:
; ARM8-NEXT:    .long 3 @ 0x3
; ARM8-NEXT:    .long 0 @ 0x0
; ARM8-NEXT:    .long 0 @ 0x0
; ARM8-NEXT:    .long 0 @ 0x0
;
; NEON7-LABEL: test_srem_vec:
; NEON7:       @ %bb.0:
; NEON7-NEXT:    push {r4, r5, r6, r7, r11, lr}
; NEON7-NEXT:    vpush {d8, d9}
; NEON7-NEXT:    mov r6, r0
; NEON7-NEXT:    and r0, r3, #1
; NEON7-NEXT:    mov r5, r1
; NEON7-NEXT:    rsb r1, r0, #0
; NEON7-NEXT:    mov r0, r2
; NEON7-NEXT:    mov r2, #9
; NEON7-NEXT:    mov r3, #0
; NEON7-NEXT:    bl __moddi3
; NEON7-NEXT:    mov r7, r0
; NEON7-NEXT:    and r0, r5, #1
; NEON7-NEXT:    mov r4, r1
; NEON7-NEXT:    rsb r1, r0, #0
; NEON7-NEXT:    mov r0, r6
; NEON7-NEXT:    mov r2, #9
; NEON7-NEXT:    mov r3, #0
; NEON7-NEXT:    bl __moddi3
; NEON7-NEXT:    vmov.32 d8[0], r0
; NEON7-NEXT:    ldr r0, [sp, #44]
; NEON7-NEXT:    ldr r2, [sp, #40]
; NEON7-NEXT:    mov r5, r1
; NEON7-NEXT:    and r0, r0, #1
; NEON7-NEXT:    mvn r3, #0
; NEON7-NEXT:    rsb r1, r0, #0
; NEON7-NEXT:    vmov.32 d9[0], r7
; NEON7-NEXT:    mov r0, r2
; NEON7-NEXT:    mvn r2, #8
; NEON7-NEXT:    bl __moddi3
; NEON7-NEXT:    vmov.32 d16[0], r0
; NEON7-NEXT:    adr r0, .LCPI3_0
; NEON7-NEXT:    vmov.32 d9[1], r4
; NEON7-NEXT:    vld1.64 {d18, d19}, [r0:128]
; NEON7-NEXT:    adr r0, .LCPI3_1
; NEON7-NEXT:    vmov.32 d16[1], r1
; NEON7-NEXT:    vmov.32 d8[1], r5
; NEON7-NEXT:    vand q8, q8, q9
; NEON7-NEXT:    vld1.64 {d20, d21}, [r0:128]
; NEON7-NEXT:    adr r0, .LCPI3_2
; NEON7-NEXT:    vand q11, q4, q9
; NEON7-NEXT:    vld1.64 {d18, d19}, [r0:128]
; NEON7-NEXT:    vceq.i32 q10, q11, q10
; NEON7-NEXT:    vceq.i32 q8, q8, q9
; NEON7-NEXT:    vrev64.32 q9, q10
; NEON7-NEXT:    vrev64.32 q11, q8
; NEON7-NEXT:    vand q9, q10, q9
; NEON7-NEXT:    vand q8, q8, q11
; NEON7-NEXT:    vmvn q9, q9
; NEON7-NEXT:    vmvn q8, q8
; NEON7-NEXT:    vmovn.i64 d18, q9
; NEON7-NEXT:    vmovn.i64 d16, q8
; NEON7-NEXT:    vmov.32 r0, d18[0]
; NEON7-NEXT:    vmov.32 r1, d18[1]
; NEON7-NEXT:    vmov.32 r2, d16[0]
; NEON7-NEXT:    vpop {d8, d9}
; NEON7-NEXT:    pop {r4, r5, r6, r7, r11, pc}
; NEON7-NEXT:    .p2align 4
; NEON7-NEXT:  @ %bb.1:
; NEON7-NEXT:  .LCPI3_0:
; NEON7-NEXT:    .long 4294967295 @ 0xffffffff
; NEON7-NEXT:    .long 1 @ 0x1
; NEON7-NEXT:    .long 4294967295 @ 0xffffffff
; NEON7-NEXT:    .long 1 @ 0x1
; NEON7-NEXT:  .LCPI3_1:
; NEON7-NEXT:    .long 3 @ 0x3
; NEON7-NEXT:    .long 0 @ 0x0
; NEON7-NEXT:    .long 4294967293 @ 0xfffffffd
; NEON7-NEXT:    .long 1 @ 0x1
; NEON7-NEXT:  .LCPI3_2:
; NEON7-NEXT:    .long 3 @ 0x3
; NEON7-NEXT:    .long 0 @ 0x0
; NEON7-NEXT:    .long 0 @ 0x0
; NEON7-NEXT:    .long 0 @ 0x0
;
; NEON8-LABEL: test_srem_vec:
; NEON8:       @ %bb.0:
; NEON8-NEXT:    push {r4, r5, r6, r7, r11, lr}
; NEON8-NEXT:    vpush {d8, d9}
; NEON8-NEXT:    mov r6, r0
; NEON8-NEXT:    and r0, r3, #1
; NEON8-NEXT:    mov r5, r1
; NEON8-NEXT:    rsb r1, r0, #0
; NEON8-NEXT:    mov r0, r2
; NEON8-NEXT:    mov r2, #9
; NEON8-NEXT:    mov r3, #0
; NEON8-NEXT:    bl __moddi3
; NEON8-NEXT:    mov r7, r0
; NEON8-NEXT:    and r0, r5, #1
; NEON8-NEXT:    mov r4, r1
; NEON8-NEXT:    rsb r1, r0, #0
; NEON8-NEXT:    mov r0, r6
; NEON8-NEXT:    mov r2, #9
; NEON8-NEXT:    mov r3, #0
; NEON8-NEXT:    bl __moddi3
; NEON8-NEXT:    vmov.32 d8[0], r0
; NEON8-NEXT:    ldr r0, [sp, #44]
; NEON8-NEXT:    ldr r2, [sp, #40]
; NEON8-NEXT:    mov r5, r1
; NEON8-NEXT:    and r0, r0, #1
; NEON8-NEXT:    mvn r3, #0
; NEON8-NEXT:    rsb r1, r0, #0
; NEON8-NEXT:    vmov.32 d9[0], r7
; NEON8-NEXT:    mov r0, r2
; NEON8-NEXT:    mvn r2, #8
; NEON8-NEXT:    bl __moddi3
; NEON8-NEXT:    vmov.32 d16[0], r0
; NEON8-NEXT:    adr r0, .LCPI3_0
; NEON8-NEXT:    vmov.32 d9[1], r4
; NEON8-NEXT:    vld1.64 {d18, d19}, [r0:128]
; NEON8-NEXT:    adr r0, .LCPI3_1
; NEON8-NEXT:    vmov.32 d16[1], r1
; NEON8-NEXT:    vmov.32 d8[1], r5
; NEON8-NEXT:    vand q8, q8, q9
; NEON8-NEXT:    vld1.64 {d20, d21}, [r0:128]
; NEON8-NEXT:    adr r0, .LCPI3_2
; NEON8-NEXT:    vand q11, q4, q9
; NEON8-NEXT:    vld1.64 {d18, d19}, [r0:128]
; NEON8-NEXT:    vceq.i32 q10, q11, q10
; NEON8-NEXT:    vceq.i32 q8, q8, q9
; NEON8-NEXT:    vrev64.32 q9, q10
; NEON8-NEXT:    vrev64.32 q11, q8
; NEON8-NEXT:    vand q9, q10, q9
; NEON8-NEXT:    vand q8, q8, q11
; NEON8-NEXT:    vmvn q9, q9
; NEON8-NEXT:    vmvn q8, q8
; NEON8-NEXT:    vmovn.i64 d18, q9
; NEON8-NEXT:    vmovn.i64 d16, q8
; NEON8-NEXT:    vmov.32 r0, d18[0]
; NEON8-NEXT:    vmov.32 r1, d18[1]
; NEON8-NEXT:    vmov.32 r2, d16[0]
; NEON8-NEXT:    vpop {d8, d9}
; NEON8-NEXT:    pop {r4, r5, r6, r7, r11, pc}
; NEON8-NEXT:    .p2align 4
; NEON8-NEXT:  @ %bb.1:
; NEON8-NEXT:  .LCPI3_0:
; NEON8-NEXT:    .long 4294967295 @ 0xffffffff
; NEON8-NEXT:    .long 1 @ 0x1
; NEON8-NEXT:    .long 4294967295 @ 0xffffffff
; NEON8-NEXT:    .long 1 @ 0x1
; NEON8-NEXT:  .LCPI3_1:
; NEON8-NEXT:    .long 3 @ 0x3
; NEON8-NEXT:    .long 0 @ 0x0
; NEON8-NEXT:    .long 4294967293 @ 0xfffffffd
; NEON8-NEXT:    .long 1 @ 0x1
; NEON8-NEXT:  .LCPI3_2:
; NEON8-NEXT:    .long 3 @ 0x3
; NEON8-NEXT:    .long 0 @ 0x0
; NEON8-NEXT:    .long 0 @ 0x0
; NEON8-NEXT:    .long 0 @ 0x0
  %srem = srem <3 x i33> %X, <i33 9, i33 9, i33 -9>
  %cmp = icmp ne <3 x i33> %srem, <i33 3, i33 -3, i33 3>
  ret <3 x i1> %cmp
}
