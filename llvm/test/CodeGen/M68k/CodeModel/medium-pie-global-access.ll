; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=m68k-linux-gnu -verify-machineinstrs \
; RUN:              -code-model=medium -relocation-model=pic \
; RUN:   | FileCheck %s

; External Linkage
@a = global i32 0, align 4

define i32 @my_access_global_a() #0 {
; CHECK-LABEL: my_access_global_a:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (a@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l (%a0), %d0
; CHECK-NEXT:    rts
entry:
  %0 = load i32, i32* @a, align 4
  ret i32 %0
}

; WeakAny Linkage
@b = weak global i32 0, align 4

define i32 @my_access_global_b() #0 {
; CHECK-LABEL: my_access_global_b:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (b@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l (%a0), %d0
; CHECK-NEXT:    rts
entry:
 %0 = load i32, i32* @b, align 4
 ret i32 %0
}

; Internal Linkage
@c = internal global i32 0, align 4

define i32 @my_access_global_c() #0 {
; CHECK-LABEL: my_access_global_c:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    lea (_GLOBAL_OFFSET_TABLE_@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l #c@GOTOFF, %d0
; CHECK-NEXT:    move.l (0,%a0,%d0), %d0
; CHECK-NEXT:    rts
entry:
 %0 = load i32, i32* @c, align 4
 ret i32 %0
}

; External Linkage, only declaration.
@d = external global i32, align 4

define i32 @my_access_global_load_d() #0 {
; CHECK-LABEL: my_access_global_load_d:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (d@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l (%a0), %d0
; CHECK-NEXT:    rts
entry:
 %0 = load i32, i32* @d, align 4
 ret i32 %0
}

; External Linkage, only declaration, store a value.
define i32 @my_access_global_store_d() #0 {
; CHECK-LABEL: my_access_global_store_d:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (d@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l #2, (%a0)
; CHECK-NEXT:    move.l #0, %d0
; CHECK-NEXT:    rts
entry:
 store i32 2, i32* @d, align 4
 ret i32 0
}

; External Linkage, function pointer access.
declare i32 @access_fp(i32 ()*)
declare i32 @foo()

define i32 @my_access_fp_foo() #0 {
; CHECK-LABEL: my_access_fp_foo:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    suba.l #4, %sp
; CHECK-NEXT:    .cfi_def_cfa_offset -8
; CHECK-NEXT:    move.l (foo@GOTPCREL,%pc), (%sp)
; CHECK-NEXT:    jsr (access_fp@PLT,%pc)
; CHECK-NEXT:    adda.l #4, %sp
; CHECK-NEXT:    rts
entry:
 %call = call i32 @access_fp(i32 ()* @foo)
 ret i32 %call
}

; LinkOnceODR Linkage, function pointer access.

$bar = comdat any

define linkonce_odr i32 @bar() comdat {
; CHECK-LABEL: bar:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.l #0, %d0
; CHECK-NEXT:    rts
entry:
 ret i32 0
}

define i32 @my_access_fp_bar() #0 {
; CHECK-LABEL: my_access_fp_bar:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    suba.l #4, %sp
; CHECK-NEXT:    .cfi_def_cfa_offset -8
; CHECK-NEXT:    move.l (bar@GOTPCREL,%pc), (%sp)
; CHECK-NEXT:    jsr (access_fp@PLT,%pc)
; CHECK-NEXT:    adda.l #4, %sp
; CHECK-NEXT:    rts
entry:
 %call = call i32 @access_fp(i32 ()* @bar)
 ret i32 %call
}

!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"PIC Level", i32 1}
!1 = !{i32 1, !"PIE Level", i32 1}
