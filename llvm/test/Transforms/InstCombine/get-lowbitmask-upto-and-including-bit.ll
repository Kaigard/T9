; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare void @use8(i8)

; Basic test
define i8 @t0(i8 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 7, [[X:%.*]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr i8 -1, [[TMP1]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask = shl i8 1, %x
  %lowbitmask = add i8 %bitmask, -1
  %mask = or i8 %lowbitmask, %bitmask
  ret i8 %mask
}

; Same, but different bit width
define i16 @t1(i16 %x) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i16 15, [[X:%.*]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr i16 -1, [[TMP1]]
; CHECK-NEXT:    ret i16 [[MASK]]
;
  %bitmask = shl i16 1, %x
  %lowbitmask = add i16 %bitmask, -1
  %mask = or i16 %lowbitmask, %bitmask
  ret i16 %mask
}

; Vectors
define <2 x i8> @t2_vec(<2 x i8> %x) {
; CHECK-LABEL: @t2_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i8> <i8 7, i8 7>, [[X:%.*]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr <2 x i8> <i8 -1, i8 -1>, [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[MASK]]
;
  %bitmask = shl <2 x i8> <i8 1, i8 1>, %x
  %lowbitmask = add <2 x i8> %bitmask, <i8 -1, i8 -1>
  %mask = or <2 x i8> %lowbitmask, %bitmask
  ret <2 x i8> %mask
}
define <3 x i8> @t3_vec_undef0(<3 x i8> %x) {
; CHECK-LABEL: @t3_vec_undef0(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <3 x i8> <i8 7, i8 7, i8 7>, [[X:%.*]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr <3 x i8> <i8 -1, i8 -1, i8 -1>, [[TMP1]]
; CHECK-NEXT:    ret <3 x i8> [[MASK]]
;
  %bitmask = shl <3 x i8> <i8 1, i8 undef, i8 1>, %x
  %lowbitmask = add <3 x i8> %bitmask, <i8 -1, i8 -1, i8 -1>
  %mask = or <3 x i8> %lowbitmask, %bitmask
  ret <3 x i8> %mask
}
define <3 x i8> @t4_vec_undef1(<3 x i8> %x) {
; CHECK-LABEL: @t4_vec_undef1(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <3 x i8> <i8 7, i8 7, i8 7>, [[X:%.*]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr <3 x i8> <i8 -1, i8 -1, i8 -1>, [[TMP1]]
; CHECK-NEXT:    ret <3 x i8> [[MASK]]
;
  %bitmask = shl <3 x i8> <i8 1, i8 1, i8 1>, %x
  %lowbitmask = add <3 x i8> %bitmask, <i8 -1, i8 undef, i8 -1>
  %mask = or <3 x i8> %lowbitmask, %bitmask
  ret <3 x i8> %mask
}
define <3 x i8> @t5_vec_undef2(<3 x i8> %x) {
; CHECK-LABEL: @t5_vec_undef2(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <3 x i8> <i8 7, i8 7, i8 7>, [[X:%.*]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr <3 x i8> <i8 -1, i8 -1, i8 -1>, [[TMP1]]
; CHECK-NEXT:    ret <3 x i8> [[MASK]]
;
  %bitmask = shl <3 x i8> <i8 1, i8 1, i8 undef>, %x
  %lowbitmask = add <3 x i8> %bitmask, <i8 -1, i8 undef, i8 -1>
  %mask = or <3 x i8> %lowbitmask, %bitmask
  ret <3 x i8> %mask
}

; One-use tests
define i8 @t6_extrause0(i8 %x) {
; CHECK-LABEL: @t6_extrause0(
; CHECK-NEXT:    [[BITMASK:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK]])
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 7, [[X]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr i8 -1, [[TMP1]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask = shl i8 1, %x
  call void @use8(i8 %bitmask)
  %lowbitmask = add i8 %bitmask, -1
  %mask = or i8 %lowbitmask, %bitmask
  ret i8 %mask
}
define i8 @t7_extrause1(i8 %x) {
; CHECK-LABEL: @t7_extrause1(
; CHECK-NEXT:    [[BITMASK:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = add i8 [[BITMASK]], -1
; CHECK-NEXT:    call void @use8(i8 [[LOWBITMASK]])
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[LOWBITMASK]], [[BITMASK]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask = shl i8 1, %x
  %lowbitmask = add i8 %bitmask, -1
  call void @use8(i8 %lowbitmask)
  %mask = or i8 %lowbitmask, %bitmask
  ret i8 %mask
}
define i8 @t8_extrause2(i8 %x) {
; CHECK-LABEL: @t8_extrause2(
; CHECK-NEXT:    [[BITMASK:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK]])
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = add i8 [[BITMASK]], -1
; CHECK-NEXT:    call void @use8(i8 [[LOWBITMASK]])
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[LOWBITMASK]], [[BITMASK]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask = shl i8 1, %x
  call void @use8(i8 %bitmask)
  %lowbitmask = add i8 %bitmask, -1
  call void @use8(i8 %lowbitmask)
  %mask = or i8 %lowbitmask, %bitmask
  ret i8 %mask
}

; Non-CSE'd test
define i8 @t9_nocse(i8 %x) {
; CHECK-LABEL: @t9_nocse(
; CHECK-NEXT:    [[BITMASK1:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    [[NOTMASK:%.*]] = shl nsw i8 -1, [[X]]
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = xor i8 [[NOTMASK]], -1
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[BITMASK1]], [[LOWBITMASK]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  %bitmask1 = shl i8 1, %x
  %lowbitmask = add i8 %bitmask0, -1
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}

; Non-CSE'd extra uses test
define i8 @t10_nocse_extrause0(i8 %x) {
; CHECK-LABEL: @t10_nocse_extrause0(
; CHECK-NEXT:    [[BITMASK0:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK0]])
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 7, [[X]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr i8 -1, [[TMP1]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  call void @use8(i8 %bitmask0)
  %bitmask1 = shl i8 1, %x
  %lowbitmask = add i8 %bitmask0, -1
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}
define i8 @t11_nocse_extrause1(i8 %x) {
; CHECK-LABEL: @t11_nocse_extrause1(
; CHECK-NEXT:    [[BITMASK1:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK1]])
; CHECK-NEXT:    [[NOTMASK:%.*]] = shl nsw i8 -1, [[X]]
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = xor i8 [[NOTMASK]], -1
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[BITMASK1]], [[LOWBITMASK]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  %bitmask1 = shl i8 1, %x
  call void @use8(i8 %bitmask1)
  %lowbitmask = add i8 %bitmask0, -1
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}
define i8 @t12_nocse_extrause2(i8 %x) {
; CHECK-LABEL: @t12_nocse_extrause2(
; CHECK-NEXT:    [[BITMASK1:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    [[NOTMASK:%.*]] = shl nsw i8 -1, [[X]]
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = xor i8 [[NOTMASK]], -1
; CHECK-NEXT:    call void @use8(i8 [[LOWBITMASK]])
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[BITMASK1]], [[LOWBITMASK]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  %bitmask1 = shl i8 1, %x
  %lowbitmask = add i8 %bitmask0, -1
  call void @use8(i8 %lowbitmask)
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}
define i8 @t13_nocse_extrause3(i8 %x) {
; CHECK-LABEL: @t13_nocse_extrause3(
; CHECK-NEXT:    [[BITMASK0:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK0]])
; CHECK-NEXT:    [[BITMASK1:%.*]] = shl i8 1, [[X]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK1]])
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 7, [[X]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr i8 -1, [[TMP1]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  call void @use8(i8 %bitmask0)
  %bitmask1 = shl i8 1, %x
  call void @use8(i8 %bitmask1)
  %lowbitmask = add i8 %bitmask0, -1
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}
define i8 @t14_nocse_extrause4(i8 %x) {
; CHECK-LABEL: @t14_nocse_extrause4(
; CHECK-NEXT:    [[BITMASK0:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK0]])
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = add i8 [[BITMASK0]], -1
; CHECK-NEXT:    call void @use8(i8 [[LOWBITMASK]])
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 7, [[X]]
; CHECK-NEXT:    [[MASK:%.*]] = lshr i8 -1, [[TMP1]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  call void @use8(i8 %bitmask0)
  %bitmask1 = shl i8 1, %x
  %lowbitmask = add i8 %bitmask0, -1
  call void @use8(i8 %lowbitmask)
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}
define i8 @t15_nocse_extrause5(i8 %x) {
; CHECK-LABEL: @t15_nocse_extrause5(
; CHECK-NEXT:    [[BITMASK1:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK1]])
; CHECK-NEXT:    [[NOTMASK:%.*]] = shl nsw i8 -1, [[X]]
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = xor i8 [[NOTMASK]], -1
; CHECK-NEXT:    call void @use8(i8 [[LOWBITMASK]])
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[BITMASK1]], [[LOWBITMASK]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  %bitmask1 = shl i8 1, %x
  call void @use8(i8 %bitmask1)
  %lowbitmask = add i8 %bitmask0, -1
  call void @use8(i8 %lowbitmask)
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}
define i8 @t16_nocse_extrause6(i8 %x) {
; CHECK-LABEL: @t16_nocse_extrause6(
; CHECK-NEXT:    [[BITMASK0:%.*]] = shl i8 1, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK0]])
; CHECK-NEXT:    [[BITMASK1:%.*]] = shl i8 1, [[X]]
; CHECK-NEXT:    call void @use8(i8 [[BITMASK1]])
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = add i8 [[BITMASK0]], -1
; CHECK-NEXT:    call void @use8(i8 [[LOWBITMASK]])
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[LOWBITMASK]], [[BITMASK1]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x
  call void @use8(i8 %bitmask0)
  %bitmask1 = shl i8 1, %x
  call void @use8(i8 %bitmask1)
  %lowbitmask = add i8 %bitmask0, -1
  call void @use8(i8 %lowbitmask)
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}

; Non-CSE'd test with mismatching X's.
define i8 @t17_nocse_mismatching_x(i8 %x0, i8 %x1) {
; CHECK-LABEL: @t17_nocse_mismatching_x(
; CHECK-NEXT:    [[BITMASK1:%.*]] = shl i8 1, [[X1:%.*]]
; CHECK-NEXT:    [[NOTMASK:%.*]] = shl nsw i8 -1, [[X0:%.*]]
; CHECK-NEXT:    [[LOWBITMASK:%.*]] = xor i8 [[NOTMASK]], -1
; CHECK-NEXT:    [[MASK:%.*]] = or i8 [[BITMASK1]], [[LOWBITMASK]]
; CHECK-NEXT:    ret i8 [[MASK]]
;
  %bitmask0 = shl i8 1, %x0
  %bitmask1 = shl i8 1, %x1
  %lowbitmask = add i8 %bitmask0, -1
  %mask = or i8 %lowbitmask, %bitmask1
  ret i8 %mask
}
