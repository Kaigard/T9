; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji < %s | FileCheck -check-prefixes=GCN,GFX8 %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 < %s | FileCheck -check-prefixes=GFX10PLUS,GFX10 %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 < %s | FileCheck -check-prefixes=GFX10PLUS,GFX11 %s
; FIXME: promotion not handled without f16 insts

define half @v_constained_fsub_f16_fpexcept_strict(half %x, half %y) #0 {
; GCN-LABEL: v_constained_fsub_f16_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f16_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10PLUS-LABEL: v_constained_fsub_f16_fpexcept_strict:
; GFX10PLUS:       ; %bb.0:
; GFX10PLUS-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10PLUS-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10PLUS-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX10PLUS-NEXT:    s_setpc_b64 s[30:31]
  %val = call half @llvm.experimental.constrained.fsub.f16(half %x, half %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %val
}

define half @v_constained_fsub_f16_fpexcept_ignore(half %x, half %y) #0 {
; GCN-LABEL: v_constained_fsub_f16_fpexcept_ignore:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f16_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10PLUS-LABEL: v_constained_fsub_f16_fpexcept_ignore:
; GFX10PLUS:       ; %bb.0:
; GFX10PLUS-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10PLUS-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10PLUS-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX10PLUS-NEXT:    s_setpc_b64 s[30:31]
  %val = call half @llvm.experimental.constrained.fsub.f16(half %x, half %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret half %val
}

define half @v_constained_fsub_f16_fpexcept_maytrap(half %x, half %y) #0 {
; GCN-LABEL: v_constained_fsub_f16_fpexcept_maytrap:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f16_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10PLUS-LABEL: v_constained_fsub_f16_fpexcept_maytrap:
; GFX10PLUS:       ; %bb.0:
; GFX10PLUS-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10PLUS-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10PLUS-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX10PLUS-NEXT:    s_setpc_b64 s[30:31]
  %val = call half @llvm.experimental.constrained.fsub.f16(half %x, half %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret half %val
}

define <2 x half> @v_constained_fsub_v2f16_fpexcept_strict(<2 x half> %x, <2 x half> %y) #0 {
; GFX9-LABEL: v_constained_fsub_v2f16_fpexcept_strict:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_f16_sdwa v2, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX9-NEXT:    v_lshl_or_b32 v0, v2, 16, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_constained_fsub_v2f16_fpexcept_strict:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_f16_sdwa v2, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX8-NEXT:    v_or_b32_e32 v0, v0, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v2f16_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f16_e32 v2, v0, v1
; GFX10-NEXT:    v_sub_f16_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_and_b32_e32 v1, 0xffff, v2
; GFX10-NEXT:    v_lshl_or_b32 v0, v0, 16, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: v_constained_fsub_v2f16_fpexcept_strict:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    v_lshrrev_b32_e32 v2, 16, v1
; GFX11-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX11-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX11-NEXT:    v_sub_f16_e32 v1, v3, v2
; GFX11-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX11-NEXT:    v_lshl_or_b32 v0, v1, 16, v0
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %x, <2 x half> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %val
}

define <2 x half> @v_constained_fsub_v2f16_fpexcept_ignore(<2 x half> %x, <2 x half> %y) #0 {
; GFX9-LABEL: v_constained_fsub_v2f16_fpexcept_ignore:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_f16_sdwa v2, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX9-NEXT:    v_lshl_or_b32 v0, v2, 16, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_constained_fsub_v2f16_fpexcept_ignore:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_f16_sdwa v2, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX8-NEXT:    v_or_b32_e32 v0, v0, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v2f16_fpexcept_ignore:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f16_e32 v2, v0, v1
; GFX10-NEXT:    v_sub_f16_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_and_b32_e32 v1, 0xffff, v2
; GFX10-NEXT:    v_lshl_or_b32 v0, v0, 16, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: v_constained_fsub_v2f16_fpexcept_ignore:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    v_lshrrev_b32_e32 v2, 16, v1
; GFX11-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX11-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX11-NEXT:    v_sub_f16_e32 v1, v3, v2
; GFX11-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX11-NEXT:    v_lshl_or_b32 v0, v1, 16, v0
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %x, <2 x half> %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret <2 x half> %val
}

define <2 x half> @v_constained_fsub_v2f16_fpexcept_maytrap(<2 x half> %x, <2 x half> %y) #0 {
; GFX9-LABEL: v_constained_fsub_v2f16_fpexcept_maytrap:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_f16_sdwa v2, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX9-NEXT:    v_lshl_or_b32 v0, v2, 16, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_constained_fsub_v2f16_fpexcept_maytrap:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_f16_sdwa v2, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX8-NEXT:    v_or_b32_e32 v0, v0, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v2f16_fpexcept_maytrap:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f16_e32 v2, v0, v1
; GFX10-NEXT:    v_sub_f16_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_and_b32_e32 v1, 0xffff, v2
; GFX10-NEXT:    v_lshl_or_b32 v0, v0, 16, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: v_constained_fsub_v2f16_fpexcept_maytrap:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    v_lshrrev_b32_e32 v2, 16, v1
; GFX11-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX11-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX11-NEXT:    v_sub_f16_e32 v1, v3, v2
; GFX11-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX11-NEXT:    v_lshl_or_b32 v0, v1, 16, v0
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %x, <2 x half> %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret <2 x half> %val
}

define <3 x half> @v_constained_fsub_v3f16_fpexcept_strict(<3 x half> %x, <3 x half> %y) #0 {
; GFX9-LABEL: v_constained_fsub_v3f16_fpexcept_strict:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_f16_sdwa v4, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_sub_f16_e32 v0, v0, v2
; GFX9-NEXT:    v_lshl_or_b32 v0, v4, 16, v0
; GFX9-NEXT:    v_sub_f16_e32 v1, v1, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_constained_fsub_v3f16_fpexcept_strict:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_f16_sdwa v4, v0, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_f16_e32 v0, v0, v2
; GFX8-NEXT:    v_or_b32_e32 v0, v0, v4
; GFX8-NEXT:    v_sub_f16_e32 v1, v1, v3
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v3f16_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f16_e32 v4, v0, v2
; GFX10-NEXT:    v_sub_f16_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_sub_f16_e32 v1, v1, v3
; GFX10-NEXT:    v_and_b32_e32 v2, 0xffff, v4
; GFX10-NEXT:    v_lshl_or_b32 v0, v0, 16, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: v_constained_fsub_v3f16_fpexcept_strict:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    v_lshrrev_b32_e32 v4, 16, v2
; GFX11-NEXT:    v_lshrrev_b32_e32 v5, 16, v0
; GFX11-NEXT:    v_sub_f16_e32 v0, v0, v2
; GFX11-NEXT:    v_sub_f16_e32 v1, v1, v3
; GFX11-NEXT:    v_sub_f16_e32 v2, v5, v4
; GFX11-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX11-NEXT:    v_lshl_or_b32 v0, v2, 16, v0
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %val = call <3 x half> @llvm.experimental.constrained.fsub.v3f16(<3 x half> %x, <3 x half> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <3 x half> %val
}

; FIXME: Scalarized
define <4 x half> @v_constained_fsub_v4f16_fpexcept_strict(<4 x half> %x, <4 x half> %y) #0 {
; GFX9-LABEL: v_constained_fsub_v4f16_fpexcept_strict:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_f16_sdwa v4, v1, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_sub_f16_sdwa v5, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_sub_f16_e32 v1, v1, v3
; GFX9-NEXT:    v_sub_f16_e32 v0, v0, v2
; GFX9-NEXT:    v_lshl_or_b32 v0, v5, 16, v0
; GFX9-NEXT:    v_lshl_or_b32 v1, v4, 16, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_constained_fsub_v4f16_fpexcept_strict:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_f16_sdwa v4, v1, v3 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_f16_sdwa v5, v0, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_f16_e32 v1, v1, v3
; GFX8-NEXT:    v_sub_f16_e32 v0, v0, v2
; GFX8-NEXT:    v_or_b32_e32 v0, v0, v5
; GFX8-NEXT:    v_or_b32_e32 v1, v1, v4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v4f16_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f16_e32 v4, v0, v2
; GFX10-NEXT:    v_sub_f16_e32 v5, v1, v3
; GFX10-NEXT:    v_sub_f16_sdwa v1, v1, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_sub_f16_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_and_b32_e32 v2, 0xffff, v4
; GFX10-NEXT:    v_and_b32_e32 v3, 0xffff, v5
; GFX10-NEXT:    v_lshl_or_b32 v0, v0, 16, v2
; GFX10-NEXT:    v_lshl_or_b32 v1, v1, 16, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: v_constained_fsub_v4f16_fpexcept_strict:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    v_lshrrev_b32_e32 v4, 16, v3
; GFX11-NEXT:    v_lshrrev_b32_e32 v5, 16, v1
; GFX11-NEXT:    v_lshrrev_b32_e32 v6, 16, v2
; GFX11-NEXT:    v_lshrrev_b32_e32 v7, 16, v0
; GFX11-NEXT:    v_sub_f16_e32 v0, v0, v2
; GFX11-NEXT:    v_sub_f16_e32 v1, v1, v3
; GFX11-NEXT:    v_sub_f16_e32 v2, v5, v4
; GFX11-NEXT:    v_sub_f16_e32 v3, v7, v6
; GFX11-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX11-NEXT:    v_and_b32_e32 v1, 0xffff, v1
; GFX11-NEXT:    v_lshl_or_b32 v0, v3, 16, v0
; GFX11-NEXT:    v_lshl_or_b32 v1, v2, 16, v1
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %val = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %x, <4 x half> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %val
}

define amdgpu_ps half @s_constained_fsub_f16_fpexcept_strict(half inreg %x, half inreg %y) #0 {
; GCN-LABEL: s_constained_fsub_f16_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    v_mov_b32_e32 v0, s3
; GCN-NEXT:    v_sub_f16_e32 v0, s2, v0
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10PLUS-LABEL: s_constained_fsub_f16_fpexcept_strict:
; GFX10PLUS:       ; %bb.0:
; GFX10PLUS-NEXT:    v_sub_f16_e64 v0, s2, s3
; GFX10PLUS-NEXT:    ; return to shader part epilog
  %val = call half @llvm.experimental.constrained.fsub.f16(half %x, half %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %val
}

define amdgpu_ps <2 x half> @s_constained_fsub_v2f16_fpexcept_strict(<2 x half> inreg %x, <2 x half> inreg %y) #0 {
; GFX9-LABEL: s_constained_fsub_v2f16_fpexcept_strict:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_lshr_b32 s0, s3, 16
; GFX9-NEXT:    s_lshr_b32 s1, s2, 16
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    v_mov_b32_e32 v1, s3
; GFX9-NEXT:    v_sub_f16_e32 v0, s1, v0
; GFX9-NEXT:    v_sub_f16_e32 v1, s2, v1
; GFX9-NEXT:    v_lshl_or_b32 v0, v0, 16, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_constained_fsub_v2f16_fpexcept_strict:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_lshr_b32 s0, s3, 16
; GFX8-NEXT:    s_lshr_b32 s1, s2, 16
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_sub_f16_sdwa v0, v1, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    v_sub_f16_e32 v1, s2, v1
; GFX8-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10PLUS-LABEL: s_constained_fsub_v2f16_fpexcept_strict:
; GFX10PLUS:       ; %bb.0:
; GFX10PLUS-NEXT:    v_sub_f16_e64 v0, s2, s3
; GFX10PLUS-NEXT:    s_lshr_b32 s0, s3, 16
; GFX10PLUS-NEXT:    s_lshr_b32 s1, s2, 16
; GFX10PLUS-NEXT:    v_sub_f16_e64 v1, s1, s0
; GFX10PLUS-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX10PLUS-NEXT:    v_lshl_or_b32 v0, v1, 16, v0
; GFX10PLUS-NEXT:    ; return to shader part epilog
  %val = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %x, <2 x half> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %val
}

declare half @llvm.experimental.constrained.fsub.f16(half, half, metadata, metadata) #1
declare <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half>, <2 x half>, metadata, metadata) #1
declare <3 x half> @llvm.experimental.constrained.fsub.v3f16(<3 x half>, <3 x half>, metadata, metadata) #1
declare <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half>, <4 x half>, metadata, metadata) #1

attributes #0 = { strictfp }
attributes #1 = { inaccessiblememonly nounwind willreturn }
