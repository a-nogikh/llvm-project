; RUN: opt < %s -aa-pipeline=basic-aa -passes=aa-eval -print-all-alias-modref-info -disable-output 2>&1 | FileCheck %s

; A span-like type.
%T = type { ptr, i64 }

declare %T @returns_noalias_field_struct() #0

; CHECK-LABEL: test_noalias_field_0
; CHECK: NoAlias:      i32* %extracted_ptr, i32* %other_ptr
define void @test_noalias_field_0(ptr %other_ptr) {
entry:
  %result_struct = call %T @returns_noalias_field_struct()
  %extracted_ptr = extractvalue %T %result_struct, 0
  store i32 1, ptr %extracted_ptr
  %val = load i32, ptr %other_ptr
  ret void
}

declare %T @returns_normal_struct()

; CHECK-LABEL: test_mayalias
; CHECK: MayAlias:     i32* %extracted_ptr, i32* %other_ptr
define void @test_mayalias(ptr %other_ptr) {
entry:
  %result_struct = call %T @returns_normal_struct()
  %extracted_ptr = extractvalue %T %result_struct, 0
  store i32 1, ptr %extracted_ptr
  %val = load i32, ptr %other_ptr
  ret void
}

attributes #0 = { "returns_noalias_field"="0" }