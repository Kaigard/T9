; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.7.0"

; int depth(double *A, int m) {
;   double y0 = 0; double y1 = 1;
;   for (int i=0; i < m; i++) {
;     y0 = A[4];
;     y1 = A[5];
;   }
;   A[8] = y0; A[8+1] = y1;
; }

define i32 @depth(double* nocapture %A, i32 %m) #0 !dbg !4 {
; CHECK-LABEL: @depth(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.dbg.value(metadata double* [[A:%.*]], metadata [[META12:![0-9]+]], metadata !DIExpression()), !dbg [[DBG18:![0-9]+]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[M:%.*]], metadata [[META13:![0-9]+]], metadata !DIExpression()), !dbg [[DBG18]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata double 0.000000e+00, metadata [[META14:![0-9]+]], metadata !DIExpression()), !dbg [[DBG19:![0-9]+]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata double 2.000000e-01, metadata [[META15:![0-9]+]], metadata !DIExpression()), !dbg [[DBG19]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 0, metadata [[META16:![0-9]+]], metadata !DIExpression()), !dbg [[DBG20:![0-9]+]]
; CHECK-NEXT:    [[CMP8:%.*]] = icmp sgt i32 [[M]], 0, !dbg [[DBG20]]
; CHECK-NEXT:    br i1 [[CMP8]], label [[FOR_BODY_LR_PH:%.*]], label [[FOR_END:%.*]], !dbg [[DBG20]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[A]], i64 4, !dbg [[DBG21:![0-9]+]]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast double* [[ARRAYIDX]] to <2 x double>*, !dbg [[DBG21]]
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, <2 x double>* [[TMP0]], align 8, !dbg [[DBG21]]
; CHECK-NEXT:    br label [[FOR_END]], !dbg [[DBG20]]
; CHECK:       for.end:
; CHECK-NEXT:    [[TMP2:%.*]] = phi <2 x double> [ [[TMP1]], [[FOR_BODY_LR_PH]] ], [ <double 0.000000e+00, double 1.000000e+00>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds double, double* [[A]], i64 8, !dbg [[DBG23:![0-9]+]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast double* [[ARRAYIDX2]] to <2 x double>*, !dbg [[DBG23]]
; CHECK-NEXT:    store <2 x double> [[TMP2]], <2 x double>* [[TMP3]], align 8, !dbg [[DBG23]]
; CHECK-NEXT:    ret i32 undef, !dbg [[DBG24:![0-9]+]]
;
entry:
  tail call void @llvm.dbg.value(metadata double* %A, i64 0, metadata !12, metadata !DIExpression()), !dbg !19
  tail call void @llvm.dbg.value(metadata i32 %m, i64 0, metadata !13, metadata !DIExpression()), !dbg !19
  tail call void @llvm.dbg.value(metadata double 0.0, i64 0, metadata !14, metadata !DIExpression()), !dbg !21
  tail call void @llvm.dbg.value(metadata double 0.2, i64 0, metadata !15, metadata !DIExpression()), !dbg !21
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !16, metadata !DIExpression()), !dbg !23
  %cmp8 = icmp sgt i32 %m, 0, !dbg !23
  br i1 %cmp8, label %for.body.lr.ph, label %for.end, !dbg !23

for.body.lr.ph:                                   ; preds = %entry
  %arrayidx = getelementptr inbounds double, double* %A, i64 4, !dbg !24
  %0 = load double, double* %arrayidx, align 8, !dbg !24
  %arrayidx1 = getelementptr inbounds double, double* %A, i64 5, !dbg !29
  %1 = load double, double* %arrayidx1, align 8, !dbg !29
  br label %for.end, !dbg !23

for.end:                                          ; preds = %for.body.lr.ph, %entry
  %y1.0.lcssa = phi double [ %1, %for.body.lr.ph ], [ 1.000000e+00, %entry ]
  %y0.0.lcssa = phi double [ %0, %for.body.lr.ph ], [ 0.000000e+00, %entry ]
  %arrayidx2 = getelementptr inbounds double, double* %A, i64 8, !dbg !30
  store double %y0.0.lcssa, double* %arrayidx2, align 8, !dbg !30
  %arrayidx3 = getelementptr inbounds double, double* %A, i64 9, !dbg !30
  store double %y1.0.lcssa, double* %arrayidx3, align 8, !dbg !30
  ret i32 undef, !dbg !31
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #1

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!18, !32}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang version 3.4 (trunk 187335) (llvm/trunk 187335:187340M)", isOptimized: true, emissionKind: FullDebug, file: !1, enums: !2, retainedTypes: !2, globals: !2, imports: !2)
!1 = !DIFile(filename: "file.c", directory: "/Users/nadav")
!2 = !{}
!4 = distinct !DISubprogram(name: "depth", line: 1, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: true, unit: !0, scopeLine: 1, file: !1, scope: !5, type: !6, retainedNodes: !11)
!5 = !DIFile(filename: "file.c", directory: "/Users/nadav")
!6 = !DISubroutineType(types: !7)
!7 = !{!8, !9, !8}
!8 = !DIBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, baseType: !10)
!10 = !DIBasicType(tag: DW_TAG_base_type, name: "double", size: 64, align: 64, encoding: DW_ATE_float)
!11 = !{!12, !13, !14, !15, !16}
!12 = !DILocalVariable(name: "A", line: 1, arg: 1, scope: !4, file: !5, type: !9)
!13 = !DILocalVariable(name: "m", line: 1, arg: 2, scope: !4, file: !5, type: !8)
!14 = !DILocalVariable(name: "y0", line: 2, scope: !4, file: !5, type: !10)
!15 = !DILocalVariable(name: "y1", line: 2, scope: !4, file: !5, type: !10)
!16 = !DILocalVariable(name: "i", line: 3, scope: !17, file: !5, type: !8)
!17 = distinct !DILexicalBlock(line: 3, column: 0, file: !1, scope: !4)
!18 = !{i32 2, !"Dwarf Version", i32 2}
!19 = !DILocation(line: 1, scope: !4)
!20 = !{double 0.000000e+00}
!21 = !DILocation(line: 2, scope: !4)
!22 = !{double 1.000000e+00}
!23 = !DILocation(line: 3, scope: !17)
!24 = !DILocation(line: 4, scope: !25)
!25 = distinct !DILexicalBlock(line: 3, column: 0, file: !1, scope: !17)
!29 = !DILocation(line: 5, scope: !25)
!30 = !DILocation(line: 7, scope: !4)
!31 = !DILocation(line: 8, scope: !4)
!32 = !{i32 1, !"Debug Info Version", i32 3}
