; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck %s --check-prefix=GFX900
; RUN: llc -march=amdgcn -mcpu=gfx90a -verify-machineinstrs < %s | FileCheck %s --check-prefix=GFX90A
; RUN: llc -march=amdgcn -mcpu=gfx940 -verify-machineinstrs < %s | FileCheck %s --check-prefix=GFX940
; RUN: llc -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck %s --check-prefix=GFX10
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck %s --check-prefix=GFX900-GISEL

declare void @llvm.amdgcn.global.load.lds(i8 addrspace(1)* nocapture %gptr, i8 addrspace(3)* nocapture %lptr, i32 %size, i32 %offset, i32 %aux)

define amdgpu_ps void @global_load_lds_dword_vaddr(i8 addrspace(1)* nocapture %gptr, i8 addrspace(3)* nocapture %lptr) {
; GFX900-LABEL: global_load_lds_dword_vaddr:
; GFX900:       ; %bb.0: ; %main_body
; GFX900-NEXT:    v_readfirstlane_b32 s0, v2
; GFX900-NEXT:    s_mov_b32 m0, s0
; GFX900-NEXT:    s_nop 0
; GFX900-NEXT:    global_load_dword v[0:1], off offset:16 glc lds
; GFX900-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_load_lds_dword_vaddr:
; GFX90A:       ; %bb.0: ; %main_body
; GFX90A-NEXT:    v_readfirstlane_b32 s0, v2
; GFX90A-NEXT:    s_mov_b32 m0, s0
; GFX90A-NEXT:    s_nop 0
; GFX90A-NEXT:    global_load_dword v[0:1], off offset:16 glc lds
; GFX90A-NEXT:    s_endpgm
;
; GFX940-LABEL: global_load_lds_dword_vaddr:
; GFX940:       ; %bb.0: ; %main_body
; GFX940-NEXT:    v_readfirstlane_b32 s0, v2
; GFX940-NEXT:    s_mov_b32 m0, s0
; GFX940-NEXT:    s_nop 0
; GFX940-NEXT:    global_load_lds_dword v[0:1], off offset:16 sc0
; GFX940-NEXT:    s_endpgm
;
; GFX10-LABEL: global_load_lds_dword_vaddr:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_readfirstlane_b32 s0, v2
; GFX10-NEXT:    s_mov_b32 m0, s0
; GFX10-NEXT:    global_load_dword v[0:1], off offset:16 glc lds
; GFX10-NEXT:    s_endpgm
;
; GFX900-GISEL-LABEL: global_load_lds_dword_vaddr:
; GFX900-GISEL:       ; %bb.0: ; %main_body
; GFX900-GISEL-NEXT:    v_readfirstlane_b32 m0, v2
; GFX900-GISEL-NEXT:    s_nop 4
; GFX900-GISEL-NEXT:    global_load_dword v[0:1], off offset:16 glc lds
; GFX900-GISEL-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.global.load.lds(i8 addrspace(1)* %gptr, i8 addrspace(3)* %lptr, i32 4, i32 16, i32 1)
  ret void
}

define amdgpu_ps void @global_load_lds_dword_saddr(i8 addrspace(1)* nocapture inreg %gptr, i8 addrspace(3)* nocapture %lptr) {
; GFX900-LABEL: global_load_lds_dword_saddr:
; GFX900:       ; %bb.0: ; %main_body
; GFX900-NEXT:    v_readfirstlane_b32 s2, v0
; GFX900-NEXT:    v_mov_b32_e32 v1, 0
; GFX900-NEXT:    s_mov_b32 m0, s2
; GFX900-NEXT:    s_nop 0
; GFX900-NEXT:    global_load_dword v1, s[0:1] offset:32 slc lds
; GFX900-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_load_lds_dword_saddr:
; GFX90A:       ; %bb.0: ; %main_body
; GFX90A-NEXT:    v_readfirstlane_b32 s2, v0
; GFX90A-NEXT:    v_mov_b32_e32 v1, 0
; GFX90A-NEXT:    s_mov_b32 m0, s2
; GFX90A-NEXT:    s_nop 0
; GFX90A-NEXT:    global_load_dword v1, s[0:1] offset:32 slc lds
; GFX90A-NEXT:    s_endpgm
;
; GFX940-LABEL: global_load_lds_dword_saddr:
; GFX940:       ; %bb.0: ; %main_body
; GFX940-NEXT:    v_readfirstlane_b32 s2, v0
; GFX940-NEXT:    v_mov_b32_e32 v1, 0
; GFX940-NEXT:    s_mov_b32 m0, s2
; GFX940-NEXT:    s_nop 0
; GFX940-NEXT:    global_load_lds_dword v1, s[0:1] offset:32 nt
; GFX940-NEXT:    s_endpgm
;
; GFX10-LABEL: global_load_lds_dword_saddr:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_readfirstlane_b32 s2, v0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_mov_b32 m0, s2
; GFX10-NEXT:    global_load_dword v0, s[0:1] offset:32 slc lds
; GFX10-NEXT:    s_endpgm
;
; GFX900-GISEL-LABEL: global_load_lds_dword_saddr:
; GFX900-GISEL:       ; %bb.0: ; %main_body
; GFX900-GISEL-NEXT:    v_readfirstlane_b32 m0, v0
; GFX900-GISEL-NEXT:    v_mov_b32_e32 v0, 0
; GFX900-GISEL-NEXT:    s_nop 3
; GFX900-GISEL-NEXT:    global_load_dword v0, s[0:1] offset:32 slc lds
; GFX900-GISEL-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.global.load.lds(i8 addrspace(1)* %gptr, i8 addrspace(3)* %lptr, i32 4, i32 32, i32 2)
  ret void
}

define amdgpu_ps void @global_load_lds_dword_saddr_and_vaddr(i8 addrspace(1)* nocapture inreg %gptr, i8 addrspace(3)* nocapture %lptr, i32 %voffset) {
; GFX900-LABEL: global_load_lds_dword_saddr_and_vaddr:
; GFX900:       ; %bb.0: ; %main_body
; GFX900-NEXT:    v_readfirstlane_b32 s2, v0
; GFX900-NEXT:    s_mov_b32 m0, s2
; GFX900-NEXT:    s_nop 0
; GFX900-NEXT:    global_load_dword v1, s[0:1] offset:48 lds
; GFX900-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_load_lds_dword_saddr_and_vaddr:
; GFX90A:       ; %bb.0: ; %main_body
; GFX90A-NEXT:    v_readfirstlane_b32 s2, v0
; GFX90A-NEXT:    s_mov_b32 m0, s2
; GFX90A-NEXT:    s_nop 0
; GFX90A-NEXT:    global_load_dword v1, s[0:1] offset:48 scc lds
; GFX90A-NEXT:    s_endpgm
;
; GFX940-LABEL: global_load_lds_dword_saddr_and_vaddr:
; GFX940:       ; %bb.0: ; %main_body
; GFX940-NEXT:    v_readfirstlane_b32 s2, v0
; GFX940-NEXT:    s_mov_b32 m0, s2
; GFX940-NEXT:    s_nop 0
; GFX940-NEXT:    global_load_lds_dword v1, s[0:1] offset:48 sc1
; GFX940-NEXT:    s_endpgm
;
; GFX10-LABEL: global_load_lds_dword_saddr_and_vaddr:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_readfirstlane_b32 s2, v0
; GFX10-NEXT:    s_mov_b32 m0, s2
; GFX10-NEXT:    global_load_dword v1, s[0:1] offset:48 lds
; GFX10-NEXT:    s_endpgm
;
; GFX900-GISEL-LABEL: global_load_lds_dword_saddr_and_vaddr:
; GFX900-GISEL:       ; %bb.0: ; %main_body
; GFX900-GISEL-NEXT:    v_readfirstlane_b32 m0, v0
; GFX900-GISEL-NEXT:    s_nop 4
; GFX900-GISEL-NEXT:    global_load_dword v1, s[0:1] offset:48 lds
; GFX900-GISEL-NEXT:    s_endpgm
main_body:
  %voffset.64 = zext i32 %voffset to i64
  %gep = getelementptr i8, i8 addrspace(1)* %gptr, i64 %voffset.64
  call void @llvm.amdgcn.global.load.lds(i8 addrspace(1)* %gep, i8 addrspace(3)* %lptr, i32 4, i32 48, i32 16)
  ret void
}

define amdgpu_ps void @global_load_lds_ushort_vaddr(i8 addrspace(1)* nocapture %gptr, i8 addrspace(3)* nocapture %lptr) {
; GFX900-LABEL: global_load_lds_ushort_vaddr:
; GFX900:       ; %bb.0: ; %main_body
; GFX900-NEXT:    v_readfirstlane_b32 s0, v2
; GFX900-NEXT:    s_mov_b32 m0, s0
; GFX900-NEXT:    s_nop 0
; GFX900-NEXT:    global_load_ushort v[0:1], off lds
; GFX900-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_load_lds_ushort_vaddr:
; GFX90A:       ; %bb.0: ; %main_body
; GFX90A-NEXT:    v_readfirstlane_b32 s0, v2
; GFX90A-NEXT:    s_mov_b32 m0, s0
; GFX90A-NEXT:    s_nop 0
; GFX90A-NEXT:    global_load_ushort v[0:1], off lds
; GFX90A-NEXT:    s_endpgm
;
; GFX940-LABEL: global_load_lds_ushort_vaddr:
; GFX940:       ; %bb.0: ; %main_body
; GFX940-NEXT:    v_readfirstlane_b32 s0, v2
; GFX940-NEXT:    s_mov_b32 m0, s0
; GFX940-NEXT:    s_nop 0
; GFX940-NEXT:    global_load_lds_ushort v[0:1], off
; GFX940-NEXT:    s_endpgm
;
; GFX10-LABEL: global_load_lds_ushort_vaddr:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_readfirstlane_b32 s0, v2
; GFX10-NEXT:    s_mov_b32 m0, s0
; GFX10-NEXT:    global_load_ushort v[0:1], off dlc lds
; GFX10-NEXT:    s_endpgm
;
; GFX900-GISEL-LABEL: global_load_lds_ushort_vaddr:
; GFX900-GISEL:       ; %bb.0: ; %main_body
; GFX900-GISEL-NEXT:    v_readfirstlane_b32 m0, v2
; GFX900-GISEL-NEXT:    s_nop 4
; GFX900-GISEL-NEXT:    global_load_ushort v[0:1], off lds
; GFX900-GISEL-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.global.load.lds(i8 addrspace(1)* %gptr, i8 addrspace(3)* %lptr, i32 2, i32 0, i32 4)
  ret void
}

define amdgpu_ps void @global_load_lds_ubyte_vaddr(i8 addrspace(1)* nocapture %gptr, i8 addrspace(3)* nocapture %lptr) {
; GFX900-LABEL: global_load_lds_ubyte_vaddr:
; GFX900:       ; %bb.0: ; %main_body
; GFX900-NEXT:    v_readfirstlane_b32 s0, v2
; GFX900-NEXT:    s_mov_b32 m0, s0
; GFX900-NEXT:    s_nop 0
; GFX900-NEXT:    global_load_ubyte v[0:1], off lds
; GFX900-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_load_lds_ubyte_vaddr:
; GFX90A:       ; %bb.0: ; %main_body
; GFX90A-NEXT:    v_readfirstlane_b32 s0, v2
; GFX90A-NEXT:    s_mov_b32 m0, s0
; GFX90A-NEXT:    s_nop 0
; GFX90A-NEXT:    global_load_ubyte v[0:1], off lds
; GFX90A-NEXT:    s_endpgm
;
; GFX940-LABEL: global_load_lds_ubyte_vaddr:
; GFX940:       ; %bb.0: ; %main_body
; GFX940-NEXT:    v_readfirstlane_b32 s0, v2
; GFX940-NEXT:    s_mov_b32 m0, s0
; GFX940-NEXT:    s_nop 0
; GFX940-NEXT:    global_load_lds_ubyte v[0:1], off
; GFX940-NEXT:    s_endpgm
;
; GFX10-LABEL: global_load_lds_ubyte_vaddr:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_readfirstlane_b32 s0, v2
; GFX10-NEXT:    s_mov_b32 m0, s0
; GFX10-NEXT:    global_load_ubyte v[0:1], off lds
; GFX10-NEXT:    s_endpgm
;
; GFX900-GISEL-LABEL: global_load_lds_ubyte_vaddr:
; GFX900-GISEL:       ; %bb.0: ; %main_body
; GFX900-GISEL-NEXT:    v_readfirstlane_b32 m0, v2
; GFX900-GISEL-NEXT:    s_nop 4
; GFX900-GISEL-NEXT:    global_load_ubyte v[0:1], off lds
; GFX900-GISEL-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.global.load.lds(i8 addrspace(1)* %gptr, i8 addrspace(3)* %lptr, i32 1, i32 0, i32 0)
  ret void
}
