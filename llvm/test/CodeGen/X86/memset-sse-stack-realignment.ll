; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Make sure that we realign the stack. Mingw32 uses 4 byte stack alignment, we
; need 16 bytes for SSE and 32 bytes for AVX.

; RUN: llc < %s -mtriple=i386-pc-mingw32 -mcpu=pentium2 | FileCheck %s --check-prefix=NOSSE
; RUN: llc < %s -mtriple=i386-pc-mingw32 -mcpu=pentium3 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=i386-pc-mingw32 -mcpu=yonah | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=i386-pc-mingw32 -mcpu=corei7-avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=i386-pc-mingw32 -mcpu=core-avx2 | FileCheck %s --check-prefix=AVX

define void @test1(i32 %t) nounwind {
; NOSSE-LABEL: test1:
; NOSSE:       # %bb.0:
; NOSSE-NEXT:    pushl %ebp
; NOSSE-NEXT:    movl %esp, %ebp
; NOSSE-NEXT:    subl $32, %esp
; NOSSE-NEXT:    movl 8(%ebp), %eax
; NOSSE-NEXT:    movl $0, -4(%ebp)
; NOSSE-NEXT:    movl $0, -8(%ebp)
; NOSSE-NEXT:    movl $0, -12(%ebp)
; NOSSE-NEXT:    movl $0, -16(%ebp)
; NOSSE-NEXT:    movl $0, -20(%ebp)
; NOSSE-NEXT:    movl $0, -24(%ebp)
; NOSSE-NEXT:    movl $0, -28(%ebp)
; NOSSE-NEXT:    movl $0, -32(%ebp)
; NOSSE-NEXT:    addl $3, %eax
; NOSSE-NEXT:    andl $-4, %eax
; NOSSE-NEXT:    calll __alloca
; NOSSE-NEXT:    movl %esp, %eax
; NOSSE-NEXT:    pushl %eax
; NOSSE-NEXT:    calll _dummy
; NOSSE-NEXT:    movl %ebp, %esp
; NOSSE-NEXT:    popl %ebp
; NOSSE-NEXT:    retl
;
; SSE-LABEL: test1:
; SSE:       # %bb.0:
; SSE-NEXT:    pushl %ebp
; SSE-NEXT:    movl %esp, %ebp
; SSE-NEXT:    pushl %esi
; SSE-NEXT:    andl $-16, %esp
; SSE-NEXT:    subl $48, %esp
; SSE-NEXT:    movl %esp, %esi
; SSE-NEXT:    movl 8(%ebp), %eax
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movaps %xmm0, 16(%esi)
; SSE-NEXT:    movaps %xmm0, (%esi)
; SSE-NEXT:    addl $3, %eax
; SSE-NEXT:    andl $-4, %eax
; SSE-NEXT:    calll __alloca
; SSE-NEXT:    movl %esp, %eax
; SSE-NEXT:    pushl %eax
; SSE-NEXT:    calll _dummy
; SSE-NEXT:    leal -4(%ebp), %esp
; SSE-NEXT:    popl %esi
; SSE-NEXT:    popl %ebp
; SSE-NEXT:    retl
;
; AVX-LABEL: test1:
; AVX:       # %bb.0:
; AVX-NEXT:    pushl %ebp
; AVX-NEXT:    movl %esp, %ebp
; AVX-NEXT:    pushl %esi
; AVX-NEXT:    andl $-32, %esp
; AVX-NEXT:    subl $64, %esp
; AVX-NEXT:    movl %esp, %esi
; AVX-NEXT:    movl 8(%ebp), %eax
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovaps %ymm0, (%esi)
; AVX-NEXT:    addl $3, %eax
; AVX-NEXT:    andl $-4, %eax
; AVX-NEXT:    calll __alloca
; AVX-NEXT:    movl %esp, %eax
; AVX-NEXT:    pushl %eax
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    calll _dummy
; AVX-NEXT:    leal -4(%ebp), %esp
; AVX-NEXT:    popl %esi
; AVX-NEXT:    popl %ebp
; AVX-NEXT:    retl
  %tmp1210 = alloca i8, i32 32, align 4
  call void @llvm.memset.p0.i64(ptr align 4 %tmp1210, i8 0, i64 32, i1 false)
  %x = alloca i8, i32 %t
  call void @dummy(ptr %x)
  ret void
}

define void @test2(i32 %t) nounwind {
; NOSSE-LABEL: test2:
; NOSSE:       # %bb.0:
; NOSSE-NEXT:    pushl %ebp
; NOSSE-NEXT:    movl %esp, %ebp
; NOSSE-NEXT:    subl $16, %esp
; NOSSE-NEXT:    movl 8(%ebp), %eax
; NOSSE-NEXT:    movl $0, -4(%ebp)
; NOSSE-NEXT:    movl $0, -8(%ebp)
; NOSSE-NEXT:    movl $0, -12(%ebp)
; NOSSE-NEXT:    movl $0, -16(%ebp)
; NOSSE-NEXT:    addl $3, %eax
; NOSSE-NEXT:    andl $-4, %eax
; NOSSE-NEXT:    calll __alloca
; NOSSE-NEXT:    movl %esp, %eax
; NOSSE-NEXT:    pushl %eax
; NOSSE-NEXT:    calll _dummy
; NOSSE-NEXT:    movl %ebp, %esp
; NOSSE-NEXT:    popl %ebp
; NOSSE-NEXT:    retl
;
; SSE-LABEL: test2:
; SSE:       # %bb.0:
; SSE-NEXT:    pushl %ebp
; SSE-NEXT:    movl %esp, %ebp
; SSE-NEXT:    pushl %esi
; SSE-NEXT:    andl $-16, %esp
; SSE-NEXT:    subl $32, %esp
; SSE-NEXT:    movl %esp, %esi
; SSE-NEXT:    movl 8(%ebp), %eax
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movaps %xmm0, (%esi)
; SSE-NEXT:    addl $3, %eax
; SSE-NEXT:    andl $-4, %eax
; SSE-NEXT:    calll __alloca
; SSE-NEXT:    movl %esp, %eax
; SSE-NEXT:    pushl %eax
; SSE-NEXT:    calll _dummy
; SSE-NEXT:    leal -4(%ebp), %esp
; SSE-NEXT:    popl %esi
; SSE-NEXT:    popl %ebp
; SSE-NEXT:    retl
;
; AVX-LABEL: test2:
; AVX:       # %bb.0:
; AVX-NEXT:    pushl %ebp
; AVX-NEXT:    movl %esp, %ebp
; AVX-NEXT:    pushl %esi
; AVX-NEXT:    andl $-16, %esp
; AVX-NEXT:    subl $32, %esp
; AVX-NEXT:    movl %esp, %esi
; AVX-NEXT:    movl 8(%ebp), %eax
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovaps %xmm0, (%esi)
; AVX-NEXT:    addl $3, %eax
; AVX-NEXT:    andl $-4, %eax
; AVX-NEXT:    calll __alloca
; AVX-NEXT:    movl %esp, %eax
; AVX-NEXT:    pushl %eax
; AVX-NEXT:    calll _dummy
; AVX-NEXT:    leal -4(%ebp), %esp
; AVX-NEXT:    popl %esi
; AVX-NEXT:    popl %ebp
; AVX-NEXT:    retl
  %tmp1210 = alloca i8, i32 16, align 4
  call void @llvm.memset.p0.i64(ptr align 4 %tmp1210, i8 0, i64 16, i1 false)
  %x = alloca i8, i32 %t
  call void @dummy(ptr %x)
  ret void
}

declare void @dummy(ptr)

declare void @llvm.memset.p0.i64(ptr nocapture, i8, i64, i1) nounwind
