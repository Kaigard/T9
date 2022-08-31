; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=amdgcn -mcpu=gfx940 -verify-machineinstrs | FileCheck %s -check-prefix=GFX940

declare float @llvm.amdgcn.flat.atomic.fadd.f32.p0f32.f32(float* %ptr, float %data)
declare <2 x half> @llvm.amdgcn.flat.atomic.fadd.v2f16.p0v2f16.v2f16(<2 x half>* %ptr, <2 x half> %data)

; bf16 atomics use v2i16 argument since there is no bf16 data type in the llvm.
declare <2 x i16> @llvm.amdgcn.flat.atomic.fadd.v2bf16.p0v2i16(<2 x i16>* %ptr, <2 x i16> %data)
declare <2 x i16> @llvm.amdgcn.global.atomic.fadd.v2bf16.p1v2i16(<2 x i16> addrspace(1)* %ptr, <2 x i16> %data)
declare <2 x half> @llvm.amdgcn.ds.fadd.v2f16(<2 x half> addrspace(3) * %ptr, <2 x half> %data, i32, i32, i1)
declare <2 x i16> @llvm.amdgcn.ds.fadd.v2bf16(<2 x i16> addrspace(3) * %ptr, <2 x i16> %data)

define amdgpu_kernel void @flat_atomic_fadd_f32_noret(float* %ptr, float %data) {
; GFX940-LABEL: flat_atomic_fadd_f32_noret:
; GFX940:       ; %bb.0:
; GFX940-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX940-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX940-NEXT:    s_waitcnt lgkmcnt(0)
; GFX940-NEXT:    v_mov_b64_e32 v[0:1], s[2:3]
; GFX940-NEXT:    v_mov_b32_e32 v2, s4
; GFX940-NEXT:    flat_atomic_add_f32 v[0:1], v2
; GFX940-NEXT:    s_endpgm
  %ret = call float @llvm.amdgcn.flat.atomic.fadd.f32.p0f32.f32(float* %ptr, float %data)
  ret void
}

define float @flat_atomic_fadd_f32_rtn(float* %ptr, float %data) {
; GFX940-LABEL: flat_atomic_fadd_f32_rtn:
; GFX940:       ; %bb.0:
; GFX940-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX940-NEXT:    flat_atomic_add_f32 v0, v[0:1], v2 sc0
; GFX940-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX940-NEXT:    s_setpc_b64 s[30:31]
  %ret = call float @llvm.amdgcn.flat.atomic.fadd.f32.p0f32.f32(float* %ptr, float %data)
  ret float %ret
}

define amdgpu_kernel void @flat_atomic_fadd_v2f16_noret(<2 x half>* %ptr, <2 x half> %data) {
; GFX940-LABEL: flat_atomic_fadd_v2f16_noret:
; GFX940:       ; %bb.0:
; GFX940-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX940-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX940-NEXT:    s_waitcnt lgkmcnt(0)
; GFX940-NEXT:    v_mov_b64_e32 v[0:1], s[2:3]
; GFX940-NEXT:    v_mov_b32_e32 v2, s4
; GFX940-NEXT:    flat_atomic_pk_add_f16 v[0:1], v2
; GFX940-NEXT:    s_endpgm
  %ret = call <2 x half> @llvm.amdgcn.flat.atomic.fadd.v2f16.p0v2f16.v2f16(<2 x half>* %ptr, <2 x half> %data)
  ret void
}

define <2 x half> @flat_atomic_fadd_v2f16_rtn(<2 x half>* %ptr, <2 x half> %data) {
; GFX940-LABEL: flat_atomic_fadd_v2f16_rtn:
; GFX940:       ; %bb.0:
; GFX940-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX940-NEXT:    flat_atomic_pk_add_f16 v0, v[0:1], v2 sc0
; GFX940-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX940-NEXT:    s_setpc_b64 s[30:31]
  %ret = call <2 x half> @llvm.amdgcn.flat.atomic.fadd.v2f16.p0v2f16.v2f16(<2 x half>* %ptr, <2 x half> %data)
  ret <2 x half> %ret
}

define amdgpu_kernel void @local_atomic_fadd_v2f16_noret(<2 x half> addrspace(3)* %ptr, <2 x half> %data) {
; GFX940-LABEL: local_atomic_fadd_v2f16_noret:
; GFX940:       ; %bb.0:
; GFX940-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX940-NEXT:    s_waitcnt lgkmcnt(0)
; GFX940-NEXT:    v_mov_b32_e32 v0, s0
; GFX940-NEXT:    v_mov_b32_e32 v1, s1
; GFX940-NEXT:    ds_pk_add_f16 v0, v1
; GFX940-NEXT:    s_endpgm
  %ret = call <2 x half> @llvm.amdgcn.ds.fadd.v2f16(<2 x half> addrspace(3)* %ptr, <2 x half> %data, i32 0, i32 0, i1 0)
  ret void
}

define <2 x half> @local_atomic_fadd_v2f16_rtn(<2 x half> addrspace(3)* %ptr, <2 x half> %data) {
; GFX940-LABEL: local_atomic_fadd_v2f16_rtn:
; GFX940:       ; %bb.0:
; GFX940-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX940-NEXT:    ds_pk_add_rtn_f16 v0, v0, v1
; GFX940-NEXT:    s_waitcnt lgkmcnt(0)
; GFX940-NEXT:    s_setpc_b64 s[30:31]
  %ret = call <2 x half> @llvm.amdgcn.ds.fadd.v2f16(<2 x half> addrspace(3)* %ptr, <2 x half> %data, i32 0, i32 0, i1 0)
  ret <2 x half> %ret
}
