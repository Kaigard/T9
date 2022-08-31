; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=i686 -mattr=+sse | FileCheck %s
; RUN: llc < %s -mcpu=i686 -mattr=-sse 2>&1 | FileCheck --check-prefix NOSSE %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32"
target triple = "i386-unknown-linux-gnu"
@f = external dso_local global float
@d = external dso_local global double

define void @test() nounwind {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subl $12, %esp
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    movss %xmm0, (%esp)
; CHECK-NEXT:    calll foo1@PLT
; CHECK-NEXT:    fstps f
; CHECK-NEXT:    fldl d
; CHECK-NEXT:    fstpl (%esp)
; CHECK-NEXT:    calll foo2@PLT
; CHECK-NEXT:    fstpl d
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    movss %xmm0, (%esp)
; CHECK-NEXT:    calll foo3@PLT
; CHECK-NEXT:    fstps f
; CHECK-NEXT:    fldl d
; CHECK-NEXT:    fstpl (%esp)
; CHECK-NEXT:    calll foo4@PLT
; CHECK-NEXT:    fstpl d
; CHECK-NEXT:    addl $12, %esp
; CHECK-NEXT:    retl
;
; NOSSE-LABEL: test:
; NOSSE:       # %bb.0: # %entry
; NOSSE-NEXT:    subl $12, %esp
; NOSSE-NEXT:    flds f
; NOSSE-NEXT:    fstps (%esp)
; NOSSE-NEXT:    calll foo1@PLT
; NOSSE-NEXT:    fstps f
; NOSSE-NEXT:    fldl d
; NOSSE-NEXT:    fstpl (%esp)
; NOSSE-NEXT:    calll foo2@PLT
; NOSSE-NEXT:    fstpl d
; NOSSE-NEXT:    flds f
; NOSSE-NEXT:    fstps (%esp)
; NOSSE-NEXT:    calll foo3@PLT
; NOSSE-NEXT:    fstps f
; NOSSE-NEXT:    fldl d
; NOSSE-NEXT:    fstpl (%esp)
; NOSSE-NEXT:    calll foo4@PLT
; NOSSE-NEXT:    fstpl d
; NOSSE-NEXT:    addl $12, %esp
; NOSSE-NEXT:    retl
entry:
  %0 = load float, ptr @f, align 4
  %1 = tail call inreg float @foo1(float inreg %0) nounwind
  store float %1, ptr @f, align 4
  %2 = load double, ptr @d, align 8
  %3 = tail call inreg double @foo2(double inreg %2) nounwind
  store double %3, ptr @d, align 8
  %4 = load float, ptr @f, align 4
  %5 = tail call inreg float @foo3(float inreg %4) nounwind
  store float %5, ptr @f, align 4
  %6 = load double, ptr @d, align 8
  %7 = tail call inreg double @foo4(double inreg %6) nounwind
  store double %7, ptr @d, align 8
  ret void
}

declare inreg float @foo1(float inreg)

declare inreg double @foo2(double inreg)

declare inreg float @foo3(float inreg)

declare inreg double @foo4(double inreg)
