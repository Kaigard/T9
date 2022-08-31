; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s

; Check that we perform a scalar XOR on i32.

define void @pull_bitcast(ptr %pA, ptr %pB) {
; CHECK-LABEL: pull_bitcast:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl (%rsi), %eax
; CHECK-NEXT:    xorl %eax, (%rdi)
; CHECK-NEXT:    retq
  %A = load <4 x i8>, ptr %pA
  %B = load <4 x i8>, ptr %pB
  %C = xor <4 x i8> %A, %B
  store <4 x i8> %C, ptr %pA
  ret void
}

define <4 x i32> @multi_use_swizzle(ptr %pA, ptr %pB) {
; CHECK-LABEL: multi_use_swizzle:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm0
; CHECK-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,1],mem[1,2]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[1,3,2,2]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,1,0,2]
; CHECK-NEXT:    vxorps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %A = load <4 x i32>, ptr %pA
  %B = load <4 x i32>, ptr %pB
  %S = shufflevector <4 x i32> %A, <4 x i32> %B, <4 x i32> <i32 1, i32 1, i32 5, i32 6>
  %S1 = shufflevector <4 x i32> %S, <4 x i32> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 2>
  %S2 = shufflevector <4 x i32> %S, <4 x i32> undef, <4 x i32> <i32 2, i32 1, i32 0, i32 2>
  %R = xor <4 x i32> %S1, %S2
  ret <4 x i32> %R
}

define <4 x i8> @pull_bitcast2(ptr %pA, ptr %pB, ptr %pC) {
; CHECK-LABEL: pull_bitcast2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl (%rdi), %eax
; CHECK-NEXT:    movl %eax, (%rdx)
; CHECK-NEXT:    xorl (%rsi), %eax
; CHECK-NEXT:    vmovd %eax, %xmm0
; CHECK-NEXT:    movl %eax, (%rdi)
; CHECK-NEXT:    retq
  %A = load <4 x i8>, ptr %pA
  store <4 x i8> %A, ptr %pC
  %B = load <4 x i8>, ptr %pB
  %C = xor <4 x i8> %A, %B
  store <4 x i8> %C, ptr %pA
  ret <4 x i8> %C
}

define <4 x i32> @reverse_1(ptr %pA, ptr %pB) {
; CHECK-LABEL: reverse_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm0
; CHECK-NEXT:    retq
  %A = load <4 x i32>, ptr %pA
  %B = load <4 x i32>, ptr %pB
  %S = shufflevector <4 x i32> %A, <4 x i32> %B, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  %S1 = shufflevector <4 x i32> %S, <4 x i32> undef, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  ret <4 x i32> %S1
}

define <4 x i32> @no_reverse_shuff(ptr %pA, ptr %pB) {
; CHECK-LABEL: no_reverse_shuff:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,2,3]
; CHECK-NEXT:    retq
  %A = load <4 x i32>, ptr %pA
  %B = load <4 x i32>, ptr %pB
  %S = shufflevector <4 x i32> %A, <4 x i32> %B, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  %S1 = shufflevector <4 x i32> %S, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 3, i32 2>
  ret <4 x i32> %S1
}

