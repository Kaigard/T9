; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX9-NO-BACKOFF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx90a -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX9-BACKOFF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx940 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX9-BACKOFF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx90a -mattr=-back-off-barrier -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX9-NO-BACKOFF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX10-BACKOFF %s

; Subtargets must wait for outstanding memory instructions before a barrier if
; they cannot back off of the barrier.

define void @back_off_barrier_no_fence(i32* %in, i32* %out) #0 {
; GFX9-NO-BACKOFF-LABEL: back_off_barrier_no_fence:
; GFX9-NO-BACKOFF:       ; %bb.0:
; GFX9-NO-BACKOFF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NO-BACKOFF-NEXT:    flat_load_dword v0, v[0:1]
; GFX9-NO-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-NO-BACKOFF-NEXT:    s_barrier
; GFX9-NO-BACKOFF-NEXT:    flat_store_dword v[2:3], v0
; GFX9-NO-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-NO-BACKOFF-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-BACKOFF-LABEL: back_off_barrier_no_fence:
; GFX9-BACKOFF:       ; %bb.0:
; GFX9-BACKOFF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-BACKOFF-NEXT:    flat_load_dword v0, v[0:1]
; GFX9-BACKOFF-NEXT:    s_barrier
; GFX9-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-BACKOFF-NEXT:    flat_store_dword v[2:3], v0
; GFX9-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-BACKOFF-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-BACKOFF-LABEL: back_off_barrier_no_fence:
; GFX10-BACKOFF:       ; %bb.0:
; GFX10-BACKOFF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-BACKOFF-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-BACKOFF-NEXT:    flat_load_dword v0, v[0:1]
; GFX10-BACKOFF-NEXT:    s_barrier
; GFX10-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-BACKOFF-NEXT:    flat_store_dword v[2:3], v0
; GFX10-BACKOFF-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-BACKOFF-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-BACKOFF-NEXT:    s_setpc_b64 s[30:31]
  %load = load i32, i32* %in
  call void @llvm.amdgcn.s.barrier()
  store i32 %load, i32* %out
  ret void
}

define void @back_off_barrier_with_fence(i32* %in, i32* %out) #0 {
; GFX9-NO-BACKOFF-LABEL: back_off_barrier_with_fence:
; GFX9-NO-BACKOFF:       ; %bb.0:
; GFX9-NO-BACKOFF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NO-BACKOFF-NEXT:    flat_load_dword v0, v[0:1]
; GFX9-NO-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-NO-BACKOFF-NEXT:    s_barrier
; GFX9-NO-BACKOFF-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NO-BACKOFF-NEXT:    flat_store_dword v[2:3], v0
; GFX9-NO-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-NO-BACKOFF-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-BACKOFF-LABEL: back_off_barrier_with_fence:
; GFX9-BACKOFF:       ; %bb.0:
; GFX9-BACKOFF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-BACKOFF-NEXT:    flat_load_dword v0, v[0:1]
; GFX9-BACKOFF-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-BACKOFF-NEXT:    s_barrier
; GFX9-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-BACKOFF-NEXT:    flat_store_dword v[2:3], v0
; GFX9-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX9-BACKOFF-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-BACKOFF-LABEL: back_off_barrier_with_fence:
; GFX10-BACKOFF:       ; %bb.0:
; GFX10-BACKOFF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-BACKOFF-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-BACKOFF-NEXT:    flat_load_dword v0, v[0:1]
; GFX10-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-BACKOFF-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-BACKOFF-NEXT:    s_barrier
; GFX10-BACKOFF-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-BACKOFF-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-BACKOFF-NEXT:    buffer_gl0_inv
; GFX10-BACKOFF-NEXT:    flat_store_dword v[2:3], v0
; GFX10-BACKOFF-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-BACKOFF-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-BACKOFF-NEXT:    s_setpc_b64 s[30:31]
  %load = load i32, i32* %in
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  store i32 %load, i32* %out
  ret void
}

declare void @llvm.amdgcn.s.barrier()

attributes #0 = { nounwind }
