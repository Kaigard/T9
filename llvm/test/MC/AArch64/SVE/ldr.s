// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:   | llvm-objdump -d --mattr=-sve - | FileCheck %s --check-prefix=CHECK-UNKNOWN

ldr     z0, [x0]
// CHECK-INST: ldr     z0, [x0]
// CHECK-ENCODING: [0x00,0x40,0x80,0x85]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 85804000 <unknown>

ldr     z31, [sp, #-256, mul vl]
// CHECK-INST: ldr     z31, [sp, #-256, mul vl]
// CHECK-ENCODING: [0xff,0x43,0xa0,0x85]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 85a043ff <unknown>

ldr     z23, [x13, #255, mul vl]
// CHECK-INST: ldr     z23, [x13, #255, mul vl]
// CHECK-ENCODING: [0xb7,0x5d,0x9f,0x85]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 859f5db7 <unknown>

ldr     p0, [x0]
// CHECK-INST: ldr     p0, [x0]
// CHECK-ENCODING: [0x00,0x00,0x80,0x85]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 85800000 <unknown>

ldr     p7, [x13, #-256, mul vl]
// CHECK-INST: ldr     p7, [x13, #-256, mul vl]
// CHECK-ENCODING: [0xa7,0x01,0xa0,0x85]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 85a001a7 <unknown>

ldr     p5, [x10, #255, mul vl]
// CHECK-INST: ldr     p5, [x10, #255, mul vl]
// CHECK-ENCODING: [0x45,0x1d,0x9f,0x85]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 859f1d45 <unknown>
