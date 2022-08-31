; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -early-cse -earlycse-debug-hash | FileCheck %s

; Store-to-load forwarding across a @llvm.experimental.noalias.scope.decl.

define float @s2l(ptr %p) {
; CHECK-LABEL: @s2l(
; CHECK-NEXT:    store float 0.000000e+00, ptr [[P:%.*]], align 4
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    ret float 0.000000e+00
;
  store float 0.0, ptr %p
  call void @llvm.experimental.noalias.scope.decl(metadata !0)
  %t = load float, ptr %p
  ret float %t
}

; Redundant load elimination across a @llvm.experimental.noalias.scope.decl.

define float @rle(ptr %p) {
; CHECK-LABEL: @rle(
; CHECK-NEXT:    [[R:%.*]] = load float, ptr [[P:%.*]], align 4
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    [[T:%.*]] = fadd float [[R]], [[R]]
; CHECK-NEXT:    ret float [[T]]
;
  %r = load float, ptr %p
  call void @llvm.experimental.noalias.scope.decl(metadata !0)
  %s = load float, ptr %p
  %t = fadd float %r, %s
  ret float %t
}

declare void @llvm.experimental.noalias.scope.decl(metadata)

!0 = !{ !1 }
!1 = distinct !{ !1, !2 }
!2 = distinct !{ !2 }
