; RUN: not llvm-as %s -o /dev/null 2>&1 | FileCheck %s

; CHECK: returns_noalias_field attribute requires function to return a struct
define i32 @test_non_struct_ret() #0 {
  ret i32 0
}

; CHECK: returns_noalias_field index is out of bounds for return type
define {ptr} @test_idx_out_of_bounds() #1 {
  ret {ptr} zeroinitializer
}

; CHECK: returns_noalias_field index must refer to a pointer type field
define {i64} @test_field_not_ptr() #2 {
  ret {i64} zeroinitializer
}

attributes #0 = { returns_noalias_field(0) }
attributes #1 = { returns_noalias_field(1) }
attributes #2 = { returns_noalias_field(0) }