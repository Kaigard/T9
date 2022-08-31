; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

; Check indexed and unindexed, sext, zext and anyext loads

define dso_local i64 @lb(i8 *%a) nounwind {
; RV64I-LABEL: lb:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lb a1, 1(a0)
; RV64I-NEXT:    lb a0, 0(a0)
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    ret
  %1 = getelementptr i8, i8* %a, i32 1
  %2 = load i8, i8* %1
  %3 = sext i8 %2 to i64
  ; the unused load will produce an anyext for selection
  %4 = load volatile i8, i8* %a
  ret i64 %3
}

define dso_local i64 @lh(i16 *%a) nounwind {
; RV64I-LABEL: lh:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lh a1, 4(a0)
; RV64I-NEXT:    lh a0, 0(a0)
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    ret
  %1 = getelementptr i16, i16* %a, i32 2
  %2 = load i16, i16* %1
  %3 = sext i16 %2 to i64
  ; the unused load will produce an anyext for selection
  %4 = load volatile i16, i16* %a
  ret i64 %3
}

define dso_local i64 @lw(i32 *%a) nounwind {
; RV64I-LABEL: lw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lw a1, 12(a0)
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    ret
  %1 = getelementptr i32, i32* %a, i32 3
  %2 = load i32, i32* %1
  %3 = sext i32 %2 to i64
  ; the unused load will produce an anyext for selection
  %4 = load volatile i32, i32* %a
  ret i64 %3
}

define dso_local i64 @lbu(i8 *%a) nounwind {
; RV64I-LABEL: lbu:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lbu a1, 4(a0)
; RV64I-NEXT:    lbu a0, 0(a0)
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
  %1 = getelementptr i8, i8* %a, i32 4
  %2 = load i8, i8* %1
  %3 = zext i8 %2 to i64
  %4 = load volatile i8, i8* %a
  %5 = zext i8 %4 to i64
  %6 = add i64 %3, %5
  ret i64 %6
}

define dso_local i64 @lhu(i16 *%a) nounwind {
; RV64I-LABEL: lhu:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lhu a1, 10(a0)
; RV64I-NEXT:    lhu a0, 0(a0)
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
  %1 = getelementptr i16, i16* %a, i32 5
  %2 = load i16, i16* %1
  %3 = zext i16 %2 to i64
  %4 = load volatile i16, i16* %a
  %5 = zext i16 %4 to i64
  %6 = add i64 %3, %5
  ret i64 %6
}

define dso_local i64 @lwu(i32 *%a) nounwind {
; RV64I-LABEL: lwu:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lwu a1, 24(a0)
; RV64I-NEXT:    lwu a0, 0(a0)
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
  %1 = getelementptr i32, i32* %a, i32 6
  %2 = load i32, i32* %1
  %3 = zext i32 %2 to i64
  %4 = load volatile i32, i32* %a
  %5 = zext i32 %4 to i64
  %6 = add i64 %3, %5
  ret i64 %6
}

; Check indexed and unindexed stores

define dso_local void @sb(i8 *%a, i8 %b) nounwind {
; RV64I-LABEL: sb:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sb a1, 0(a0)
; RV64I-NEXT:    sb a1, 7(a0)
; RV64I-NEXT:    ret
  store i8 %b, i8* %a
  %1 = getelementptr i8, i8* %a, i32 7
  store i8 %b, i8* %1
  ret void
}

define dso_local void @sh(i16 *%a, i16 %b) nounwind {
; RV64I-LABEL: sh:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sh a1, 0(a0)
; RV64I-NEXT:    sh a1, 16(a0)
; RV64I-NEXT:    ret
  store i16 %b, i16* %a
  %1 = getelementptr i16, i16* %a, i32 8
  store i16 %b, i16* %1
  ret void
}

define dso_local void @sw(i32 *%a, i32 %b) nounwind {
; RV64I-LABEL: sw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sw a1, 0(a0)
; RV64I-NEXT:    sw a1, 36(a0)
; RV64I-NEXT:    ret
  store i32 %b, i32* %a
  %1 = getelementptr i32, i32* %a, i32 9
  store i32 %b, i32* %1
  ret void
}

; 64-bit loads and stores

define dso_local i64 @ld(i64 *%a) nounwind {
; RV64I-LABEL: ld:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ld a1, 80(a0)
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    ret
  %1 = getelementptr i64, i64* %a, i32 10
  %2 = load i64, i64* %1
  %3 = load volatile i64, i64* %a
  ret i64 %2
}

define dso_local void @sd(i64 *%a, i64 %b) nounwind {
; RV64I-LABEL: sd:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sd a1, 0(a0)
; RV64I-NEXT:    sd a1, 88(a0)
; RV64I-NEXT:    ret
  store i64 %b, i64* %a
  %1 = getelementptr i64, i64* %a, i32 11
  store i64 %b, i64* %1
  ret void
}

; Check load and store to an i1 location
define dso_local i64 @load_sext_zext_anyext_i1(i1 *%a) nounwind {
; RV64I-LABEL: load_sext_zext_anyext_i1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lbu a1, 1(a0)
; RV64I-NEXT:    lbu a2, 2(a0)
; RV64I-NEXT:    lb a0, 0(a0)
; RV64I-NEXT:    sub a0, a2, a1
; RV64I-NEXT:    ret
  ; sextload i1
  %1 = getelementptr i1, i1* %a, i32 1
  %2 = load i1, i1* %1
  %3 = sext i1 %2 to i64
  ; zextload i1
  %4 = getelementptr i1, i1* %a, i32 2
  %5 = load i1, i1* %4
  %6 = zext i1 %5 to i64
  %7 = add i64 %3, %6
  ; extload i1 (anyext). Produced as the load is unused.
  %8 = load volatile i1, i1* %a
  ret i64 %7
}

define dso_local i16 @load_sext_zext_anyext_i1_i16(i1 *%a) nounwind {
; RV64I-LABEL: load_sext_zext_anyext_i1_i16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lbu a1, 1(a0)
; RV64I-NEXT:    lbu a2, 2(a0)
; RV64I-NEXT:    lb a0, 0(a0)
; RV64I-NEXT:    sub a0, a2, a1
; RV64I-NEXT:    ret
  ; sextload i1
  %1 = getelementptr i1, i1* %a, i32 1
  %2 = load i1, i1* %1
  %3 = sext i1 %2 to i16
  ; zextload i1
  %4 = getelementptr i1, i1* %a, i32 2
  %5 = load i1, i1* %4
  %6 = zext i1 %5 to i16
  %7 = add i16 %3, %6
  ; extload i1 (anyext). Produced as the load is unused.
  %8 = load volatile i1, i1* %a
  ret i16 %7
}

; Check load and store to a global
@G = dso_local global i64 0

define dso_local i64 @ld_sd_global(i64 %a) nounwind {
; RV64I-LABEL: ld_sd_global:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, %hi(G)
; RV64I-NEXT:    ld a1, %lo(G)(a2)
; RV64I-NEXT:    addi a3, a2, %lo(G)
; RV64I-NEXT:    sd a0, %lo(G)(a2)
; RV64I-NEXT:    ld a2, 72(a3)
; RV64I-NEXT:    sd a0, 72(a3)
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    ret
  %1 = load volatile i64, i64* @G
  store i64 %a, i64* @G
  %2 = getelementptr i64, i64* @G, i64 9
  %3 = load volatile i64, i64* %2
  store i64 %a, i64* %2
  ret i64 %1
}

define i64 @lw_near_local(i64* %a)  {
; RV64I-LABEL: lw_near_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 2047
; RV64I-NEXT:    ld a0, 9(a0)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 257
  %2 = load volatile i64, i64* %1
  ret i64 %2
}

define void @st_near_local(i64* %a, i64 %b)  {
; RV64I-LABEL: st_near_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 2047
; RV64I-NEXT:    sd a1, 9(a0)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 257
  store i64 %b, i64* %1
  ret void
}

define i64 @lw_sw_near_local(i64* %a, i64 %b)  {
; RV64I-LABEL: lw_sw_near_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, a0, 2047
; RV64I-NEXT:    ld a0, 9(a2)
; RV64I-NEXT:    sd a1, 9(a2)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 257
  %2 = load volatile i64, i64* %1
  store i64 %b, i64* %1
  ret i64 %2
}

define i64 @lw_far_local(i64* %a)  {
; RV64I-LABEL: lw_far_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 8
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ld a0, -8(a0)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 4095
  %2 = load volatile i64, i64* %1
  ret i64 %2
}

define void @st_far_local(i64* %a, i64 %b)  {
; RV64I-LABEL: st_far_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 8
; RV64I-NEXT:    add a0, a0, a2
; RV64I-NEXT:    sd a1, -8(a0)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 4095
  store i64 %b, i64* %1
  ret void
}

define i64 @lw_sw_far_local(i64* %a, i64 %b)  {
; RV64I-LABEL: lw_sw_far_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 8
; RV64I-NEXT:    add a2, a0, a2
; RV64I-NEXT:    ld a0, -8(a2)
; RV64I-NEXT:    sd a1, -8(a2)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 4095
  %2 = load volatile i64, i64* %1
  store i64 %b, i64* %1
  ret i64 %2
}

; Make sure we don't fold the addiw into the load offset. The sign extend of the
; addiw is required.
define i64 @lw_really_far_local(i64* %a)  {
; RV64I-LABEL: lw_really_far_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    addiw a1, a1, -2048
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 268435200
  %2 = load volatile i64, i64* %1
  ret i64 %2
}

; Make sure we don't fold the addiw into the store offset. The sign extend of
; the addiw is required.
define void @st_really_far_local(i64* %a, i64 %b)  {
; RV64I-LABEL: st_really_far_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    addiw a2, a2, -2048
; RV64I-NEXT:    add a0, a0, a2
; RV64I-NEXT:    sd a1, 0(a0)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 268435200
  store i64 %b, i64* %1
  ret void
}

; Make sure we don't fold the addiw into the load/store offset. The sign extend
; of the addiw is required.
define i64 @lw_sw_really_far_local(i64* %a, i64 %b)  {
; RV64I-LABEL: lw_sw_really_far_local:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    addiw a2, a2, -2048
; RV64I-NEXT:    add a2, a0, a2
; RV64I-NEXT:    ld a0, 0(a2)
; RV64I-NEXT:    sd a1, 0(a2)
; RV64I-NEXT:    ret
  %1 = getelementptr inbounds i64, i64* %a, i64 268435200
  %2 = load volatile i64, i64* %1
  store i64 %b, i64* %1
  ret i64 %2
}

%struct.quux = type { i32, [0 x i8] }

; Make sure we don't remove the addi and fold the C from
; (add (addi FrameIndex, C), X) into the store address.
; FrameIndex cannot be the operand of an ADD. We must keep the ADDI.
define void @addi_fold_crash(i64 %arg) nounwind {
; RV64I-LABEL: addi_fold_crash:
; RV64I:       # %bb.0: # %bb
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, sp, 4
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    sb zero, 0(a0)
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    call snork@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
bb:
  %tmp = alloca %struct.quux, align 4
  %tmp1 = getelementptr inbounds %struct.quux, %struct.quux* %tmp, i64 0, i32 1
  %tmp2 = getelementptr inbounds %struct.quux, %struct.quux* %tmp, i64 0, i32 1, i64 %arg
  store i8 0, i8* %tmp2, align 1
  call void @snork([0 x i8]* %tmp1)
  ret void
}

declare void @snork([0 x i8]*)
