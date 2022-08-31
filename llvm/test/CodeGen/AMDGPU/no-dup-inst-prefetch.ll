; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx1030 -verify-machineinstrs < %s | FileCheck --check-prefix=GFX10 %s

define amdgpu_cs void @_amdgpu_cs_main(float %0, i32 %1) {
; GFX10-LABEL: _amdgpu_cs_main:
; GFX10:       ; %bb.0: ; %branch1_true
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_cmp_ne_u32_e32 vcc_lo, 0, v1
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_mov_b32 s4, 0
; GFX10-NEXT:    s_mov_b32 s1, 0
; GFX10-NEXT:    ; implicit-def: $sgpr2
; GFX10-NEXT:    s_inst_prefetch 0x1
; GFX10-NEXT:    s_branch .LBB0_2
; GFX10-NEXT:    .p2align 6
; GFX10-NEXT:  .LBB0_1: ; %Flow
; GFX10-NEXT:    ; in Loop: Header=BB0_2 Depth=1
; GFX10-NEXT:    s_or_b32 exec_lo, exec_lo, s3
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    s_and_b32 s0, exec_lo, s2
; GFX10-NEXT:    s_or_b32 s1, s0, s1
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_cbranch_execz .LBB0_4
; GFX10-NEXT:  .LBB0_2: ; %bb
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    s_or_b32 s2, s2, exec_lo
; GFX10-NEXT:    s_and_saveexec_b32 s3, vcc_lo
; GFX10-NEXT:    s_cbranch_execz .LBB0_1
; GFX10-NEXT:  ; %bb.3: ; %branch2_merge
; GFX10-NEXT:    ; in Loop: Header=BB0_2 Depth=1
; GFX10-NEXT:    s_mov_b32 s5, s4
; GFX10-NEXT:    s_mov_b32 s6, s4
; GFX10-NEXT:    s_mov_b32 s7, s4
; GFX10-NEXT:    s_mov_b32 s8, s4
; GFX10-NEXT:    s_mov_b32 s9, s4
; GFX10-NEXT:    s_mov_b32 s10, s4
; GFX10-NEXT:    s_mov_b32 s11, s4
; GFX10-NEXT:    s_mov_b32 s12, s4
; GFX10-NEXT:    s_mov_b32 s13, s4
; GFX10-NEXT:    s_mov_b32 s14, s4
; GFX10-NEXT:    s_mov_b32 s15, s4
; GFX10-NEXT:    s_andn2_b32 s2, s2, exec_lo
; GFX10-NEXT:    image_sample_lz v1, [v2, v2, v1], s[8:15], s[4:7] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_fma_f32 v1, v1, v0, 0
; GFX10-NEXT:    v_cmp_le_f32_e64 s0, 0, v1
; GFX10-NEXT:    s_and_b32 s0, s0, exec_lo
; GFX10-NEXT:    s_or_b32 s2, s2, s0
; GFX10-NEXT:    s_branch .LBB0_1
; GFX10-NEXT:  .LBB0_4: ; %loop0_merge
; GFX10-NEXT:    s_inst_prefetch 0x2
; GFX10-NEXT:    s_endpgm
branch1_true:
  br label %bb

bb:                                               ; preds = %branch2_merge, %branch1_true
  %r1.8.vec.insert14.i1 = phi float [ 0.000000e+00, %branch1_true ], [ %0, %branch2_merge ]
  %i = icmp eq i32 %1, 0
  br i1 %i, label %loop0_merge, label %branch2_merge

branch2_merge:                                    ; preds = %bb
  %i2 = call float @llvm.amdgcn.image.sample.lz.3d.f32.f32(i32 1, float 0.000000e+00, float 0.000000e+00, float %r1.8.vec.insert14.i1, <8 x i32> zeroinitializer, <4 x i32> zeroinitializer, i1 false, i32 0, i32 0)
  %i3 = call reassoc nnan nsz arcp contract afn float @llvm.fma.f32(float %i2, float %0, float 0.000000e+00)
  %i4 = fcmp ult float %i3, 0.000000e+00
  br i1 %i4, label %bb, label %loop0_merge

loop0_merge:                                      ; preds = %branch2_merge, %bb
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.fma.f32(float, float, float) #0

; Function Attrs: nounwind readonly willreturn
declare float @llvm.amdgcn.image.sample.lz.3d.f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #1

attributes #0 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { nounwind readonly willreturn }
