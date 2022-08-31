; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -relocation-model=pic < %s \
; RUN:     | FileCheck -check-prefix=RV32-PIC %s
; RUN: llc -mtriple=riscv64 -relocation-model=pic < %s \
; RUN:     | FileCheck -check-prefix=RV64-PIC %s
; RUN: llc -mtriple=riscv32 < %s | FileCheck -check-prefix=RV32-NOPIC %s
; RUN: llc -mtriple=riscv64 < %s | FileCheck -check-prefix=RV64-NOPIC %s

; Check that TLS symbols are lowered correctly based on the specified
; model. Make sure they're external to avoid them all being optimised to Local
; Exec for the executable.

@unspecified = external thread_local global i32
@ld = external thread_local(localdynamic) global i32
@ie = external thread_local(initialexec) global i32
@le = external thread_local(localexec) global i32


; No model specified

define i32* @f1() nounwind {
; RV32-PIC-LABEL: f1:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:    addi sp, sp, -16
; RV32-PIC-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-PIC-NEXT:  .Lpcrel_hi0:
; RV32-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(unspecified)
; RV32-PIC-NEXT:    addi a0, a0, %pcrel_lo(.Lpcrel_hi0)
; RV32-PIC-NEXT:    call __tls_get_addr@plt
; RV32-PIC-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-PIC-NEXT:    addi sp, sp, 16
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f1:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:    addi sp, sp, -16
; RV64-PIC-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-PIC-NEXT:  .Lpcrel_hi0:
; RV64-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(unspecified)
; RV64-PIC-NEXT:    addi a0, a0, %pcrel_lo(.Lpcrel_hi0)
; RV64-PIC-NEXT:    call __tls_get_addr@plt
; RV64-PIC-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-PIC-NEXT:    addi sp, sp, 16
; RV64-PIC-NEXT:    ret
;
; RV32-NOPIC-LABEL: f1:
; RV32-NOPIC:       # %bb.0: # %entry
; RV32-NOPIC-NEXT:  .Lpcrel_hi0:
; RV32-NOPIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(unspecified)
; RV32-NOPIC-NEXT:    lw a0, %pcrel_lo(.Lpcrel_hi0)(a0)
; RV32-NOPIC-NEXT:    add a0, a0, tp
; RV32-NOPIC-NEXT:    ret
;
; RV64-NOPIC-LABEL: f1:
; RV64-NOPIC:       # %bb.0: # %entry
; RV64-NOPIC-NEXT:  .Lpcrel_hi0:
; RV64-NOPIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(unspecified)
; RV64-NOPIC-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi0)(a0)
; RV64-NOPIC-NEXT:    add a0, a0, tp
; RV64-NOPIC-NEXT:    ret
entry:
  ret i32* @unspecified
}


; localdynamic specified

define i32* @f2() nounwind {
; RV32-PIC-LABEL: f2:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:    addi sp, sp, -16
; RV32-PIC-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-PIC-NEXT:  .Lpcrel_hi1:
; RV32-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(ld)
; RV32-PIC-NEXT:    addi a0, a0, %pcrel_lo(.Lpcrel_hi1)
; RV32-PIC-NEXT:    call __tls_get_addr@plt
; RV32-PIC-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-PIC-NEXT:    addi sp, sp, 16
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f2:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:    addi sp, sp, -16
; RV64-PIC-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-PIC-NEXT:  .Lpcrel_hi1:
; RV64-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(ld)
; RV64-PIC-NEXT:    addi a0, a0, %pcrel_lo(.Lpcrel_hi1)
; RV64-PIC-NEXT:    call __tls_get_addr@plt
; RV64-PIC-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-PIC-NEXT:    addi sp, sp, 16
; RV64-PIC-NEXT:    ret
;
; RV32-NOPIC-LABEL: f2:
; RV32-NOPIC:       # %bb.0: # %entry
; RV32-NOPIC-NEXT:  .Lpcrel_hi1:
; RV32-NOPIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ld)
; RV32-NOPIC-NEXT:    lw a0, %pcrel_lo(.Lpcrel_hi1)(a0)
; RV32-NOPIC-NEXT:    add a0, a0, tp
; RV32-NOPIC-NEXT:    ret
;
; RV64-NOPIC-LABEL: f2:
; RV64-NOPIC:       # %bb.0: # %entry
; RV64-NOPIC-NEXT:  .Lpcrel_hi1:
; RV64-NOPIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ld)
; RV64-NOPIC-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi1)(a0)
; RV64-NOPIC-NEXT:    add a0, a0, tp
; RV64-NOPIC-NEXT:    ret
entry:
  ret i32* @ld
}


; initialexec specified

define i32* @f3() nounwind {
; RV32-PIC-LABEL: f3:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:  .Lpcrel_hi2:
; RV32-PIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ie)
; RV32-PIC-NEXT:    lw a0, %pcrel_lo(.Lpcrel_hi2)(a0)
; RV32-PIC-NEXT:    add a0, a0, tp
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f3:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:  .Lpcrel_hi2:
; RV64-PIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ie)
; RV64-PIC-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi2)(a0)
; RV64-PIC-NEXT:    add a0, a0, tp
; RV64-PIC-NEXT:    ret
;
; RV32-NOPIC-LABEL: f3:
; RV32-NOPIC:       # %bb.0: # %entry
; RV32-NOPIC-NEXT:  .Lpcrel_hi2:
; RV32-NOPIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ie)
; RV32-NOPIC-NEXT:    lw a0, %pcrel_lo(.Lpcrel_hi2)(a0)
; RV32-NOPIC-NEXT:    add a0, a0, tp
; RV32-NOPIC-NEXT:    ret
;
; RV64-NOPIC-LABEL: f3:
; RV64-NOPIC:       # %bb.0: # %entry
; RV64-NOPIC-NEXT:  .Lpcrel_hi2:
; RV64-NOPIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ie)
; RV64-NOPIC-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi2)(a0)
; RV64-NOPIC-NEXT:    add a0, a0, tp
; RV64-NOPIC-NEXT:    ret
entry:
  ret i32* @ie
}


; localexec specified

define i32* @f4() nounwind {
; RV32-PIC-LABEL: f4:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:    lui a0, %tprel_hi(le)
; RV32-PIC-NEXT:    add a0, a0, tp, %tprel_add(le)
; RV32-PIC-NEXT:    addi a0, a0, %tprel_lo(le)
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f4:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:    lui a0, %tprel_hi(le)
; RV64-PIC-NEXT:    add a0, a0, tp, %tprel_add(le)
; RV64-PIC-NEXT:    addi a0, a0, %tprel_lo(le)
; RV64-PIC-NEXT:    ret
;
; RV32-NOPIC-LABEL: f4:
; RV32-NOPIC:       # %bb.0: # %entry
; RV32-NOPIC-NEXT:    lui a0, %tprel_hi(le)
; RV32-NOPIC-NEXT:    add a0, a0, tp, %tprel_add(le)
; RV32-NOPIC-NEXT:    addi a0, a0, %tprel_lo(le)
; RV32-NOPIC-NEXT:    ret
;
; RV64-NOPIC-LABEL: f4:
; RV64-NOPIC:       # %bb.0: # %entry
; RV64-NOPIC-NEXT:    lui a0, %tprel_hi(le)
; RV64-NOPIC-NEXT:    add a0, a0, tp, %tprel_add(le)
; RV64-NOPIC-NEXT:    addi a0, a0, %tprel_lo(le)
; RV64-NOPIC-NEXT:    ret
entry:
  ret i32* @le
}
