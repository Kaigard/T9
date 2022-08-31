; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -mtriple=aarch64-none-eabi < %s | FileCheck %s --check-prefix=RECIP
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=code-size -mtriple=aarch64-none-eabi < %s | FileCheck %s --check-prefix=SIZE

declare i64        @llvm.sadd.sat.i64(i64, i64)
declare <2 x i64>  @llvm.sadd.sat.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64>  @llvm.sadd.sat.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64>  @llvm.sadd.sat.v8i64(<8 x i64>, <8 x i64>)

declare i32        @llvm.sadd.sat.i32(i32, i32)
declare <2 x i32>  @llvm.sadd.sat.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32>  @llvm.sadd.sat.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32>  @llvm.sadd.sat.v8i32(<8 x i32>, <8 x i32>)
declare <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32>, <16 x i32>)
declare <3 x i32>  @llvm.sadd.sat.v3i32(<3 x i32>, <3 x i32>)

declare i16        @llvm.sadd.sat.i16(i16, i16)
declare <2 x i16>  @llvm.sadd.sat.v2i16(<2 x i16>, <2 x i16>)
declare <4 x i16>  @llvm.sadd.sat.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16>  @llvm.sadd.sat.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16>, <16 x i16>)
declare <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16>, <32 x i16>)

declare i8         @llvm.sadd.sat.i8(i8,  i8)
declare <2 x i8>   @llvm.sadd.sat.v2i8(<2 x i8>, <2 x i8>)
declare <4 x i8>   @llvm.sadd.sat.v4i8(<4 x i8>, <4 x i8>)
declare <8 x i8>   @llvm.sadd.sat.v8i8(<8 x i8>, <8 x i8>)
declare <16 x i8>  @llvm.sadd.sat.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8>  @llvm.sadd.sat.v32i8(<32 x i8>, <32 x i8>)
declare <64 x i8>  @llvm.sadd.sat.v64i8(<64 x i8>, <64 x i8>)

define i32 @add(i32 %arg) {
; RECIP-LABEL: 'add'
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I64 = call i64 @llvm.sadd.sat.i64(i64 undef, i64 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = call <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I64 = call <4 x i64> @llvm.sadd.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I64 = call <8 x i64> @llvm.sadd.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I32 = call i32 @llvm.sadd.sat.i32(i32 undef, i32 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I32 = call <2 x i32> @llvm.sadd.sat.v2i32(<2 x i32> undef, <2 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = call <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I32 = call <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I32 = call <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V3I32 = call <3 x i32> @llvm.sadd.sat.v3i32(<3 x i32> undef, <3 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I16 = call i16 @llvm.sadd.sat.i16(i16 undef, i16 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = call <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16> undef, <2 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I16 = call <4 x i16> @llvm.sadd.sat.v4i16(<4 x i16> undef, <4 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I8 = call i8 @llvm.sadd.sat.i8(i8 undef, i8 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I8 = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = call <4 x i8> @llvm.sadd.sat.v4i8(<4 x i8> undef, <4 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I8 = call <8 x i8> @llvm.sadd.sat.v8i8(<8 x i8> undef, <8 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = call <32 x i8> @llvm.sadd.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = call <64 x i8> @llvm.sadd.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SIZE-LABEL: 'add'
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I64 = call i64 @llvm.sadd.sat.i64(i64 undef, i64 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = call <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I64 = call <4 x i64> @llvm.sadd.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I64 = call <8 x i64> @llvm.sadd.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I32 = call i32 @llvm.sadd.sat.i32(i32 undef, i32 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I32 = call <2 x i32> @llvm.sadd.sat.v2i32(<2 x i32> undef, <2 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = call <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I32 = call <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I32 = call <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V3I32 = call <3 x i32> @llvm.sadd.sat.v3i32(<3 x i32> undef, <3 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I16 = call i16 @llvm.sadd.sat.i16(i16 undef, i16 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = call <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16> undef, <2 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I16 = call <4 x i16> @llvm.sadd.sat.v4i16(<4 x i16> undef, <4 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I8 = call i8 @llvm.sadd.sat.i8(i8 undef, i8 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I8 = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = call <4 x i8> @llvm.sadd.sat.v4i8(<4 x i8> undef, <4 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I8 = call <8 x i8> @llvm.sadd.sat.v8i8(<8 x i8> undef, <8 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = call <32 x i8> @llvm.sadd.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = call <64 x i8> @llvm.sadd.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I64 = call i64 @llvm.sadd.sat.i64(i64 undef, i64 undef)
  %V2I64 = call <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
  %V4I64 = call <4 x i64> @llvm.sadd.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
  %V8I64 = call <8 x i64> @llvm.sadd.sat.v8i64(<8 x i64> undef, <8 x i64> undef)

  %I32 = call i32 @llvm.sadd.sat.i32(i32 undef, i32 undef)
  %V2I32  = call <2 x i32>  @llvm.sadd.sat.v2i32(<2 x i32> undef, <2 x i32> undef)
  %V4I32  = call <4 x i32>  @llvm.sadd.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
  %V8I32  = call <8 x i32>  @llvm.sadd.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
  %V16I32 = call <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
  %V3I32  = call <3 x i32>  @llvm.sadd.sat.v3i32(<3 x i32> undef, <3 x i32> undef)

  %I16 = call i16 @llvm.sadd.sat.i16(i16 undef, i16 undef)
  %V2I16  = call <2 x i16>  @llvm.sadd.sat.v2i16(<2 x i16> undef, <2 x i16> undef)
  %V4I16  = call <4 x i16>  @llvm.sadd.sat.v4i16(<4 x i16> undef, <4 x i16> undef)
  %V8I16  = call <8 x i16>  @llvm.sadd.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
  %V16I16 = call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
  %V32I16 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> undef, <32 x i16> undef)

  %I8 = call i8 @llvm.sadd.sat.i8(i8 undef, i8 undef)
  %V2I8  = call <2 x i8>  @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
  %V4I8  = call <4 x i8>  @llvm.sadd.sat.v4i8(<4 x i8> undef, <4 x i8> undef)
  %V8I8  = call <8 x i8>  @llvm.sadd.sat.v8i8(<8 x i8> undef, <8 x i8> undef)
  %V16I8 = call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
  %V32I8 = call <32 x i8> @llvm.sadd.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
  %V64I8 = call <64 x i8> @llvm.sadd.sat.v64i8(<64 x i8> undef, <64 x i8> undef)

  ret i32 undef
}

declare i64        @llvm.ssub.sat.i64(i64, i64)
declare <2 x i64>  @llvm.ssub.sat.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64>  @llvm.ssub.sat.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64>  @llvm.ssub.sat.v8i64(<8 x i64>, <8 x i64>)

declare i32        @llvm.ssub.sat.i32(i32, i32)
declare <2 x i32>  @llvm.ssub.sat.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32>  @llvm.ssub.sat.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32>  @llvm.ssub.sat.v8i32(<8 x i32>, <8 x i32>)
declare <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32>, <16 x i32>)

declare i16        @llvm.ssub.sat.i16(i16, i16)
declare <2 x i16>  @llvm.ssub.sat.v2i16(<2 x i16>, <2 x i16>)
declare <4 x i16>  @llvm.ssub.sat.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16>  @llvm.ssub.sat.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16>, <16 x i16>)
declare <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16>, <32 x i16>)

declare i8         @llvm.ssub.sat.i8(i8,  i8)
declare <2 x i8>   @llvm.ssub.sat.v2i8(<2 x i8>, <2 x i8>)
declare <4 x i8>   @llvm.ssub.sat.v4i8(<4 x i8>, <4 x i8>)
declare <8 x i8>   @llvm.ssub.sat.v8i8(<8 x i8>, <8 x i8>)
declare <16 x i8>  @llvm.ssub.sat.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8>  @llvm.ssub.sat.v32i8(<32 x i8>, <32 x i8>)
declare <64 x i8>  @llvm.ssub.sat.v64i8(<64 x i8>, <64 x i8>)

define i32 @sub(i32 %arg) {
; RECIP-LABEL: 'sub'
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I64 = call i64 @llvm.ssub.sat.i64(i64 undef, i64 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = call <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I64 = call <4 x i64> @llvm.ssub.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I64 = call <8 x i64> @llvm.ssub.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I32 = call i32 @llvm.ssub.sat.i32(i32 undef, i32 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I32 = call <2 x i32> @llvm.ssub.sat.v2i32(<2 x i32> undef, <2 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = call <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I32 = call <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I32 = call <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I16 = call i16 @llvm.ssub.sat.i16(i16 undef, i16 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = call <2 x i16> @llvm.ssub.sat.v2i16(<2 x i16> undef, <2 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I16 = call <4 x i16> @llvm.ssub.sat.v4i16(<4 x i16> undef, <4 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = call <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I8 = call i8 @llvm.ssub.sat.i8(i8 undef, i8 undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I8 = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = call <4 x i8> @llvm.ssub.sat.v4i8(<4 x i8> undef, <4 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I8 = call <8 x i8> @llvm.ssub.sat.v8i8(<8 x i8> undef, <8 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = call <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = call <32 x i8> @llvm.ssub.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = call <64 x i8> @llvm.ssub.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SIZE-LABEL: 'sub'
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I64 = call i64 @llvm.ssub.sat.i64(i64 undef, i64 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = call <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I64 = call <4 x i64> @llvm.ssub.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I64 = call <8 x i64> @llvm.ssub.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %I32 = call i32 @llvm.ssub.sat.i32(i32 undef, i32 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I32 = call <2 x i32> @llvm.ssub.sat.v2i32(<2 x i32> undef, <2 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = call <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I32 = call <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I32 = call <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I16 = call i16 @llvm.ssub.sat.i16(i16 undef, i16 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = call <2 x i16> @llvm.ssub.sat.v2i16(<2 x i16> undef, <2 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I16 = call <4 x i16> @llvm.ssub.sat.v4i16(<4 x i16> undef, <4 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = call <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %I8 = call i8 @llvm.ssub.sat.i8(i8 undef, i8 undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I8 = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = call <4 x i8> @llvm.ssub.sat.v4i8(<4 x i8> undef, <4 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I8 = call <8 x i8> @llvm.ssub.sat.v8i8(<8 x i8> undef, <8 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = call <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = call <32 x i8> @llvm.ssub.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = call <64 x i8> @llvm.ssub.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I64 = call i64 @llvm.ssub.sat.i64(i64 undef, i64 undef)
  %V2I64 = call <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
  %V4I64 = call <4 x i64> @llvm.ssub.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
  %V8I64 = call <8 x i64> @llvm.ssub.sat.v8i64(<8 x i64> undef, <8 x i64> undef)

  %I32 = call i32 @llvm.ssub.sat.i32(i32 undef, i32 undef)
  %V2I32  = call <2 x i32>  @llvm.ssub.sat.v2i32(<2 x i32> undef, <2 x i32> undef)
  %V4I32  = call <4 x i32>  @llvm.ssub.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
  %V8I32  = call <8 x i32>  @llvm.ssub.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
  %V16I32 = call <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32> undef, <16 x i32> undef)

  %I16 = call i16 @llvm.ssub.sat.i16(i16 undef, i16 undef)
  %V2I16  = call <2 x i16>  @llvm.ssub.sat.v2i16(<2 x i16> undef, <2 x i16> undef)
  %V4I16  = call <4 x i16>  @llvm.ssub.sat.v4i16(<4 x i16> undef, <4 x i16> undef)
  %V8I16  = call <8 x i16>  @llvm.ssub.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
  %V16I16 = call <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
  %V32I16 = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> undef, <32 x i16> undef)

  %I8 = call i8 @llvm.ssub.sat.i8(i8 undef, i8 undef)
  %V2I8  = call <2 x i8>  @llvm.ssub.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
  %V4I8  = call <4 x i8>  @llvm.ssub.sat.v4i8(<4 x i8> undef, <4 x i8> undef)
  %V8I8  = call <8 x i8>  @llvm.ssub.sat.v8i8(<8 x i8> undef, <8 x i8> undef)
  %V16I8 = call <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
  %V32I8 = call <32 x i8> @llvm.ssub.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
  %V64I8 = call <64 x i8> @llvm.ssub.sat.v64i8(<64 x i8> undef, <64 x i8> undef)

  ret i32 undef
}
