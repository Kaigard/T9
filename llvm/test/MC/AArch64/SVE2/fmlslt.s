// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2 < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d --mattr=+sve2 - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:   | llvm-objdump -d --mattr=-sve2 - | FileCheck %s --check-prefix=CHECK-UNKNOWN


fmlslt z29.s, z30.h, z31.h
// CHECK-INST: fmlslt z29.s, z30.h, z31.h
// CHECK-ENCODING: [0xdd,0xa7,0xbf,0x64]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 64bfa7dd <unknown>

fmlslt z0.s, z1.h, z7.h[0]
// CHECK-INST: fmlslt	z0.s, z1.h, z7.h[0]
// CHECK-ENCODING: [0x20,0x64,0xa7,0x64]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 64a76420 <unknown>

fmlslt z30.s, z31.h, z7.h[7]
// CHECK-INST: fmlslt z30.s, z31.h, z7.h[7]
// CHECK-ENCODING: [0xfe,0x6f,0xbf,0x64]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 64bf6ffe <unknown>

// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z29, z28
// CHECK-INST: movprfx	z29, z28
// CHECK-ENCODING: [0x9d,0xbf,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bf9d <unknown>

fmlslt z29.s, z30.h, z31.h
// CHECK-INST: fmlslt z29.s, z30.h, z31.h
// CHECK-ENCODING: [0xdd,0xa7,0xbf,0x64]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 64bfa7dd <unknown>

movprfx z21, z28
// CHECK-INST: movprfx	z21, z28
// CHECK-ENCODING: [0x95,0xbf,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bf95 <unknown>

fmlslt z21.s, z1.h, z7.h[7]
// CHECK-INST: fmlslt	z21.s, z1.h, z7.h[7]
// CHECK-ENCODING: [0x35,0x6c,0xbf,0x64]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 64bf6c35 <unknown>
