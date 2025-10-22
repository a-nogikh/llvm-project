// RUN: %clang_cc1 -triple x86_64-linux-gnu -emit-llvm %s -o - | FileCheck %s 

int *Mem;
void dealloc(int*);

typedef struct {
  void *p;
  int size;
} sized_ptr;

__attribute__((malloc)) int *MallocFunc(){ return Mem;}
// CHECK: define[[BEFORE:.*]] noalias[[AFTER:.*]]@MallocFunc
__attribute__((malloc)) sized_ptr MallocFunc2(){ return (sized_ptr){ .p = Mem };}
// CHECK: define[[BEFORE]] { ptr, i32 } @MallocFunc2() #[[ATTR_ID:[0-9]+]]
// Ensure these two do not generate noalias here.
__attribute__((malloc(dealloc))) int *MallocFunc3(){ return Mem;}
// CHECK: define[[BEFORE]][[AFTER]]@MallocFunc3
__attribute__((malloc(dealloc, 1))) int *MallocFunc4(){ return Mem;}
// CHECK: define[[BEFORE]][[AFTER]]@MallocFunc4
// CHECK: attributes #[[ATTR_ID]] = {{.*}} "returns_noalias_field"="0" {{.*}}
