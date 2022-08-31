; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
;
; Verify that the result of strchr calls used in equality expressions
; with either the first argument or null are optimally folded.

declare i8* @strchr(i8*, i32)


; Fold strchr(s, c) == s to *s == c.

define i1 @fold_strchr_s_c_eq_s(i8* %s, i32 %c) {
; CHECK-LABEL: @fold_strchr_s_c_eq_s(
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[S:%.*]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[C:%.*]] to i8
; CHECK-NEXT:    [[CHAR0CMP:%.*]] = icmp eq i8 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i1 [[CHAR0CMP]]
;
  %p = call i8* @strchr(i8* %s, i32 %c)
  %cmp = icmp eq i8* %p, %s
  ret i1 %cmp
}


; Fold strchr(s, c) != s to *s != c.

define i1 @fold_strchr_s_c_neq_s(i8* %s, i32 %c) {
; CHECK-LABEL: @fold_strchr_s_c_neq_s(
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[S:%.*]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[C:%.*]] to i8
; CHECK-NEXT:    [[CHAR0CMP:%.*]] = icmp ne i8 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i1 [[CHAR0CMP]]
;
  %p = call i8* @strchr(i8* %s, i32 %c)
  %cmp = icmp ne i8* %p, %s
  ret i1 %cmp
}


; Fold strchr(s, '\0') == null to false.  (A string must be nul-terminated,
; otherwise the call would read past the end of the array.)

define i1 @fold_strchr_s_nul_eqz(i8* %s) {
; CHECK-LABEL: @fold_strchr_s_nul_eqz(
; CHECK-NEXT:    ret i1 false
;
  %p = call i8* @strchr(i8* %s, i32 0)
  %cmp = icmp eq i8* %p, null
  ret i1 %cmp
}


; Fold strchr(s, '\0') != null to true.

define i1 @fold_strchr_s_nul_nez(i8* %s) {
; CHECK-LABEL: @fold_strchr_s_nul_nez(
; CHECK-NEXT:    ret i1 true
;
  %p = call i8* @strchr(i8* %s, i32 0)
  %cmp = icmp ne i8* %p, null
  ret i1 %cmp
}


@a5 = constant [5 x i8] c"12345";

; Fold strchr(a5, c) == a5 to *a5 == c.

define i1 @fold_strchr_a_c_eq_a(i32 %c) {
; CHECK-LABEL: @fold_strchr_a_c_eq_a(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[C:%.*]] to i8
; CHECK-NEXT:    [[CHAR0CMP:%.*]] = icmp eq i8 [[TMP1]], 49
; CHECK-NEXT:    ret i1 [[CHAR0CMP]]
;
  %p = getelementptr [5 x i8], [5 x i8]* @a5, i32 0, i32 0
  %q = call i8* @strchr(i8* %p, i32 %c)
  %cmp = icmp eq i8* %q, %p
  ret i1 %cmp
}
