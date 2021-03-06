; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -x86-speculative-load-hardening | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -x86-speculative-load-hardening -x86-speculative-load-hardening-lfence | FileCheck %s --check-prefix=X64-LFENCE
;
; FIXME: Add support for 32-bit and other EH ABIs.

declare void @leak(i32 %v1, i32 %v2)

declare void @sink(i32)

define void @test_basic_conditions(i32 %a, i32 %b, i32 %c, i32* %ptr1, i32* %ptr2, i32** %ptr3) nounwind {
; X64-LABEL: test_basic_conditions:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %r15
; X64-NEXT:    pushq %r14
; X64-NEXT:    pushq %rbx
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %rbx
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    jne .LBB0_1
; X64-NEXT:  # %bb.2: # %then1
; X64-NEXT:    cmovneq %rbx, %rax
; X64-NEXT:    testl %esi, %esi
; X64-NEXT:    je .LBB0_4
; X64-NEXT:  .LBB0_1:
; X64-NEXT:    cmoveq %rbx, %rax
; X64-NEXT:  .LBB0_8: # %exit
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    popq %r14
; X64-NEXT:    popq %r15
; X64-NEXT:    retq
; X64-NEXT:  .LBB0_4: # %then2
; X64-NEXT:    movq %r8, %r15
; X64-NEXT:    cmovneq %rbx, %rax
; X64-NEXT:    testl %edx, %edx
; X64-NEXT:    je .LBB0_6
; X64-NEXT:  # %bb.5: # %else3
; X64-NEXT:    cmoveq %rbx, %rax
; X64-NEXT:    movslq (%r9), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    leaq (%r15,%rcx,4), %r14
; X64-NEXT:    movl %ecx, (%r15,%rcx,4)
; X64-NEXT:    jmp .LBB0_7
; X64-NEXT:  .LBB0_6: # %then3
; X64-NEXT:    cmovneq %rbx, %rax
; X64-NEXT:    movl (%rcx), %ecx
; X64-NEXT:    addl (%r15), %ecx
; X64-NEXT:    orl %eax, %ecx
; X64-NEXT:    movslq %ecx, %rdi
; X64-NEXT:    movl (%r15,%rdi,4), %esi
; X64-NEXT:    orl %eax, %esi
; X64-NEXT:    movq (%r9), %r14
; X64-NEXT:    orq %rax, %r14
; X64-NEXT:    addl (%r14), %esi
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    # kill: def $edi killed $edi killed $rdi
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    callq leak
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:  .LBB0_7: # %merge
; X64-NEXT:    movslq (%r14), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    movl $0, (%r15,%rcx,4)
; X64-NEXT:    jmp .LBB0_8
;
; X64-LFENCE-LABEL: test_basic_conditions:
; X64-LFENCE:       # %bb.0: # %entry
; X64-LFENCE-NEXT:    testl %edi, %edi
; X64-LFENCE-NEXT:    jne .LBB0_6
; X64-LFENCE-NEXT:  # %bb.1: # %then1
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    testl %esi, %esi
; X64-LFENCE-NEXT:    je .LBB0_2
; X64-LFENCE-NEXT:  .LBB0_6: # %exit
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    retq
; X64-LFENCE-NEXT:  .LBB0_2: # %then2
; X64-LFENCE-NEXT:    pushq %r14
; X64-LFENCE-NEXT:    pushq %rbx
; X64-LFENCE-NEXT:    pushq %rax
; X64-LFENCE-NEXT:    movq %r8, %rbx
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    testl %edx, %edx
; X64-LFENCE-NEXT:    je .LBB0_3
; X64-LFENCE-NEXT:  # %bb.4: # %else3
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    movslq (%r9), %rax
; X64-LFENCE-NEXT:    leaq (%rbx,%rax,4), %r14
; X64-LFENCE-NEXT:    movl %eax, (%rbx,%rax,4)
; X64-LFENCE-NEXT:    jmp .LBB0_5
; X64-LFENCE-NEXT:  .LBB0_3: # %then3
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    movl (%rcx), %eax
; X64-LFENCE-NEXT:    addl (%rbx), %eax
; X64-LFENCE-NEXT:    movslq %eax, %rdi
; X64-LFENCE-NEXT:    movl (%rbx,%rdi,4), %esi
; X64-LFENCE-NEXT:    movq (%r9), %r14
; X64-LFENCE-NEXT:    addl (%r14), %esi
; X64-LFENCE-NEXT:    # kill: def $edi killed $edi killed $rdi
; X64-LFENCE-NEXT:    callq leak
; X64-LFENCE-NEXT:  .LBB0_5: # %merge
; X64-LFENCE-NEXT:    movslq (%r14), %rax
; X64-LFENCE-NEXT:    movl $0, (%rbx,%rax,4)
; X64-LFENCE-NEXT:    addq $8, %rsp
; X64-LFENCE-NEXT:    popq %rbx
; X64-LFENCE-NEXT:    popq %r14
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    retq
entry:
  %a.cmp = icmp eq i32 %a, 0
  br i1 %a.cmp, label %then1, label %exit

then1:
  %b.cmp = icmp eq i32 %b, 0
  br i1 %b.cmp, label %then2, label %exit

then2:
  %c.cmp = icmp eq i32 %c, 0
  br i1 %c.cmp, label %then3, label %else3

then3:
  %secret1 = load i32, i32* %ptr1
  %secret2 = load i32, i32* %ptr2
  %secret.sum1 = add i32 %secret1, %secret2
  %ptr2.idx = getelementptr i32, i32* %ptr2, i32 %secret.sum1
  %secret3 = load i32, i32* %ptr2.idx
  %secret4 = load i32*, i32** %ptr3
  %secret5 = load i32, i32* %secret4
  %secret.sum2 = add i32 %secret3, %secret5
  call void @leak(i32 %secret.sum1, i32 %secret.sum2)
  br label %merge

else3:
  %secret6 = load i32*, i32** %ptr3
  %cast = ptrtoint i32* %secret6 to i32
  %ptr2.idx2 = getelementptr i32, i32* %ptr2, i32 %cast
  store i32 %cast, i32* %ptr2.idx2
  br label %merge

merge:
  %phi = phi i32* [ %secret4, %then3 ], [ %ptr2.idx2, %else3 ]
  %secret7 = load i32, i32* %phi
  %ptr2.idx3 = getelementptr i32, i32* %ptr2, i32 %secret7
  store i32 0, i32* %ptr2.idx3
  br label %exit

exit:
  ret void
}

define void @test_basic_loop(i32 %a, i32 %b, i32* %ptr1, i32* %ptr2) nounwind {
; X64-LABEL: test_basic_loop:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbp
; X64-NEXT:    pushq %r15
; X64-NEXT:    pushq %r14
; X64-NEXT:    pushq %r12
; X64-NEXT:    pushq %rbx
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %r15
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    je .LBB1_2
; X64-NEXT:  # %bb.1:
; X64-NEXT:    cmoveq %r15, %rax
; X64-NEXT:    jmp .LBB1_5
; X64-NEXT:  .LBB1_2: # %l.header.preheader
; X64-NEXT:    movq %rcx, %r14
; X64-NEXT:    movq %rdx, %r12
; X64-NEXT:    movl %esi, %ebp
; X64-NEXT:    cmovneq %r15, %rax
; X64-NEXT:    xorl %ebx, %ebx
; X64-NEXT:    jmp .LBB1_3
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB1_6: # in Loop: Header=BB1_3 Depth=1
; X64-NEXT:    cmovgeq %r15, %rax
; X64-NEXT:  .LBB1_3: # %l.header
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movslq (%r12), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    movq %rax, %rdx
; X64-NEXT:    orq %r14, %rdx
; X64-NEXT:    movl (%rdx,%rcx,4), %edi
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    callq sink
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    incl %ebx
; X64-NEXT:    cmpl %ebp, %ebx
; X64-NEXT:    jl .LBB1_6
; X64-NEXT:  # %bb.4:
; X64-NEXT:    cmovlq %r15, %rax
; X64-NEXT:  .LBB1_5: # %exit
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    popq %r12
; X64-NEXT:    popq %r14
; X64-NEXT:    popq %r15
; X64-NEXT:    popq %rbp
; X64-NEXT:    retq
;
; X64-LFENCE-LABEL: test_basic_loop:
; X64-LFENCE:       # %bb.0: # %entry
; X64-LFENCE-NEXT:    pushq %rbp
; X64-LFENCE-NEXT:    pushq %r15
; X64-LFENCE-NEXT:    pushq %r14
; X64-LFENCE-NEXT:    pushq %rbx
; X64-LFENCE-NEXT:    pushq %rax
; X64-LFENCE-NEXT:    testl %edi, %edi
; X64-LFENCE-NEXT:    jne .LBB1_3
; X64-LFENCE-NEXT:  # %bb.1: # %l.header.preheader
; X64-LFENCE-NEXT:    movq %rcx, %r14
; X64-LFENCE-NEXT:    movq %rdx, %r15
; X64-LFENCE-NEXT:    movl %esi, %ebp
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    xorl %ebx, %ebx
; X64-LFENCE-NEXT:    .p2align 4, 0x90
; X64-LFENCE-NEXT:  .LBB1_2: # %l.header
; X64-LFENCE-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    movslq (%r15), %rax
; X64-LFENCE-NEXT:    movl (%r14,%rax,4), %edi
; X64-LFENCE-NEXT:    callq sink
; X64-LFENCE-NEXT:    incl %ebx
; X64-LFENCE-NEXT:    cmpl %ebp, %ebx
; X64-LFENCE-NEXT:    jl .LBB1_2
; X64-LFENCE-NEXT:  .LBB1_3: # %exit
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    addq $8, %rsp
; X64-LFENCE-NEXT:    popq %rbx
; X64-LFENCE-NEXT:    popq %r14
; X64-LFENCE-NEXT:    popq %r15
; X64-LFENCE-NEXT:    popq %rbp
; X64-LFENCE-NEXT:    retq
entry:
  %a.cmp = icmp eq i32 %a, 0
  br i1 %a.cmp, label %l.header, label %exit

l.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %l.header ]
  %secret = load i32, i32* %ptr1
  %ptr2.idx = getelementptr i32, i32* %ptr2, i32 %secret
  %leak = load i32, i32* %ptr2.idx
  call void @sink(i32 %leak)
  %i.next = add i32 %i, 1
  %i.cmp = icmp slt i32 %i.next, %b
  br i1 %i.cmp, label %l.header, label %exit

exit:
  ret void
}

define void @test_basic_nested_loop(i32 %a, i32 %b, i32 %c, i32* %ptr1, i32* %ptr2) nounwind {
; X64-LABEL: test_basic_nested_loop:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbp
; X64-NEXT:    pushq %r15
; X64-NEXT:    pushq %r14
; X64-NEXT:    pushq %r13
; X64-NEXT:    pushq %r12
; X64-NEXT:    pushq %rbx
; X64-NEXT:    pushq %rax
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %r12
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    je .LBB2_2
; X64-NEXT:  # %bb.1:
; X64-NEXT:    cmoveq %r12, %rax
; X64-NEXT:    jmp .LBB2_10
; X64-NEXT:  .LBB2_2: # %l1.header.preheader
; X64-NEXT:    movq %r8, %r14
; X64-NEXT:    movq %rcx, %rbx
; X64-NEXT:    movl %edx, %ebp
; X64-NEXT:    movl %esi, %r15d
; X64-NEXT:    cmovneq %r12, %rax
; X64-NEXT:    xorl %r13d, %r13d
; X64-NEXT:    movl %esi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    testl %r15d, %r15d
; X64-NEXT:    jg .LBB2_5
; X64-NEXT:    jmp .LBB2_4
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB2_12:
; X64-NEXT:    cmovgeq %r12, %rax
; X64-NEXT:    testl %r15d, %r15d
; X64-NEXT:    jle .LBB2_4
; X64-NEXT:  .LBB2_5: # %l2.header.preheader
; X64-NEXT:    cmovleq %r12, %rax
; X64-NEXT:    xorl %r15d, %r15d
; X64-NEXT:    jmp .LBB2_6
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB2_11: # in Loop: Header=BB2_6 Depth=1
; X64-NEXT:    cmovgeq %r12, %rax
; X64-NEXT:  .LBB2_6: # %l2.header
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movslq (%rbx), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    movq %rax, %rdx
; X64-NEXT:    orq %r14, %rdx
; X64-NEXT:    movl (%rdx,%rcx,4), %edi
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    callq sink
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    incl %r15d
; X64-NEXT:    cmpl %ebp, %r15d
; X64-NEXT:    jl .LBB2_11
; X64-NEXT:  # %bb.7:
; X64-NEXT:    cmovlq %r12, %rax
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %r15d # 4-byte Reload
; X64-NEXT:    jmp .LBB2_8
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB2_4:
; X64-NEXT:    cmovgq %r12, %rax
; X64-NEXT:  .LBB2_8: # %l1.latch
; X64-NEXT:    movslq (%rbx), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    movq %rax, %rdx
; X64-NEXT:    orq %r14, %rdx
; X64-NEXT:    movl (%rdx,%rcx,4), %edi
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    callq sink
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    incl %r13d
; X64-NEXT:    cmpl %r15d, %r13d
; X64-NEXT:    jl .LBB2_12
; X64-NEXT:  # %bb.9:
; X64-NEXT:    cmovlq %r12, %rax
; X64-NEXT:  .LBB2_10: # %exit
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    addq $8, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    popq %r12
; X64-NEXT:    popq %r13
; X64-NEXT:    popq %r14
; X64-NEXT:    popq %r15
; X64-NEXT:    popq %rbp
; X64-NEXT:    retq
;
; X64-LFENCE-LABEL: test_basic_nested_loop:
; X64-LFENCE:       # %bb.0: # %entry
; X64-LFENCE-NEXT:    pushq %rbp
; X64-LFENCE-NEXT:    pushq %r15
; X64-LFENCE-NEXT:    pushq %r14
; X64-LFENCE-NEXT:    pushq %r13
; X64-LFENCE-NEXT:    pushq %r12
; X64-LFENCE-NEXT:    pushq %rbx
; X64-LFENCE-NEXT:    pushq %rax
; X64-LFENCE-NEXT:    testl %edi, %edi
; X64-LFENCE-NEXT:    jne .LBB2_6
; X64-LFENCE-NEXT:  # %bb.1: # %l1.header.preheader
; X64-LFENCE-NEXT:    movq %r8, %r14
; X64-LFENCE-NEXT:    movq %rcx, %rbx
; X64-LFENCE-NEXT:    movl %edx, %r13d
; X64-LFENCE-NEXT:    movl %esi, %r15d
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    xorl %r12d, %r12d
; X64-LFENCE-NEXT:    .p2align 4, 0x90
; X64-LFENCE-NEXT:  .LBB2_2: # %l1.header
; X64-LFENCE-NEXT:    # =>This Loop Header: Depth=1
; X64-LFENCE-NEXT:    # Child Loop BB2_4 Depth 2
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    testl %r15d, %r15d
; X64-LFENCE-NEXT:    jle .LBB2_5
; X64-LFENCE-NEXT:  # %bb.3: # %l2.header.preheader
; X64-LFENCE-NEXT:    # in Loop: Header=BB2_2 Depth=1
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    xorl %ebp, %ebp
; X64-LFENCE-NEXT:    .p2align 4, 0x90
; X64-LFENCE-NEXT:  .LBB2_4: # %l2.header
; X64-LFENCE-NEXT:    # Parent Loop BB2_2 Depth=1
; X64-LFENCE-NEXT:    # => This Inner Loop Header: Depth=2
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    movslq (%rbx), %rax
; X64-LFENCE-NEXT:    movl (%r14,%rax,4), %edi
; X64-LFENCE-NEXT:    callq sink
; X64-LFENCE-NEXT:    incl %ebp
; X64-LFENCE-NEXT:    cmpl %r13d, %ebp
; X64-LFENCE-NEXT:    jl .LBB2_4
; X64-LFENCE-NEXT:  .LBB2_5: # %l1.latch
; X64-LFENCE-NEXT:    # in Loop: Header=BB2_2 Depth=1
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    movslq (%rbx), %rax
; X64-LFENCE-NEXT:    movl (%r14,%rax,4), %edi
; X64-LFENCE-NEXT:    callq sink
; X64-LFENCE-NEXT:    incl %r12d
; X64-LFENCE-NEXT:    cmpl %r15d, %r12d
; X64-LFENCE-NEXT:    jl .LBB2_2
; X64-LFENCE-NEXT:  .LBB2_6: # %exit
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    addq $8, %rsp
; X64-LFENCE-NEXT:    popq %rbx
; X64-LFENCE-NEXT:    popq %r12
; X64-LFENCE-NEXT:    popq %r13
; X64-LFENCE-NEXT:    popq %r14
; X64-LFENCE-NEXT:    popq %r15
; X64-LFENCE-NEXT:    popq %rbp
; X64-LFENCE-NEXT:    retq
entry:
  %a.cmp = icmp eq i32 %a, 0
  br i1 %a.cmp, label %l1.header, label %exit

l1.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %l1.latch ]
  %b.cmp = icmp sgt i32 %b, 0
  br i1 %b.cmp, label %l2.header, label %l1.latch

l2.header:
  %j = phi i32 [ 0, %l1.header ], [ %j.next, %l2.header ]
  %secret = load i32, i32* %ptr1
  %ptr2.idx = getelementptr i32, i32* %ptr2, i32 %secret
  %leak = load i32, i32* %ptr2.idx
  call void @sink(i32 %leak)
  %j.next = add i32 %j, 1
  %j.cmp = icmp slt i32 %j.next, %c
  br i1 %j.cmp, label %l2.header, label %l1.latch

l1.latch:
  %secret2 = load i32, i32* %ptr1
  %ptr2.idx2 = getelementptr i32, i32* %ptr2, i32 %secret2
  %leak2 = load i32, i32* %ptr2.idx2
  call void @sink(i32 %leak2)
  %i.next = add i32 %i, 1
  %i.cmp = icmp slt i32 %i.next, %b
  br i1 %i.cmp, label %l1.header, label %exit

exit:
  ret void
}

declare i32 @__gxx_personality_v0(...)

declare i8* @__cxa_allocate_exception(i64) local_unnamed_addr

declare void @__cxa_throw(i8*, i8*, i8*) local_unnamed_addr

define void @test_basic_eh(i32 %a, i32* %ptr1, i32* %ptr2) nounwind personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; X64-LABEL: test_basic_eh:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbp
; X64-NEXT:    pushq %r14
; X64-NEXT:    pushq %rbx
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %rcx
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    cmpl $41, %edi
; X64-NEXT:    jg .LBB3_1
; X64-NEXT:  # %bb.2: # %thrower
; X64-NEXT:    movq %rdx, %r14
; X64-NEXT:    movq %rsi, %rbx
; X64-NEXT:    cmovgq %rcx, %rax
; X64-NEXT:    movslq %edi, %rcx
; X64-NEXT:    movl (%rsi,%rcx,4), %ebp
; X64-NEXT:    orl %eax, %ebp
; X64-NEXT:    movl $4, %edi
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    callq __cxa_allocate_exception
; X64-NEXT:    movq %rsp, %rcx
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    movl %ebp, (%rax)
; X64-NEXT:  .Ltmp0:
; X64-NEXT:    xorl %esi, %esi
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movq %rax, %rdi
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    callq __cxa_throw
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:  .Ltmp1:
; X64-NEXT:    jmp .LBB3_3
; X64-NEXT:  .LBB3_1:
; X64-NEXT:    cmovleq %rcx, %rax
; X64-NEXT:  .LBB3_3: # %exit
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    popq %r14
; X64-NEXT:    popq %rbp
; X64-NEXT:    retq
; X64-NEXT:  .LBB3_4: # %lpad
; X64-NEXT:  .Ltmp2:
; X64-NEXT:    movq %rsp, %rcx
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    movl (%rax), %eax
; X64-NEXT:    addl (%rbx), %eax
; X64-NEXT:    orl %ecx, %eax
; X64-NEXT:    cltq
; X64-NEXT:    movl (%r14,%rax,4), %edi
; X64-NEXT:    orl %ecx, %edi
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    callq sink
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    sarq $63, %rax
;
; X64-LFENCE-LABEL: test_basic_eh:
; X64-LFENCE:       # %bb.0: # %entry
; X64-LFENCE-NEXT:    pushq %rbp
; X64-LFENCE-NEXT:    pushq %r14
; X64-LFENCE-NEXT:    pushq %rbx
; X64-LFENCE-NEXT:    cmpl $41, %edi
; X64-LFENCE-NEXT:    jg .LBB3_2
; X64-LFENCE-NEXT:  # %bb.1: # %thrower
; X64-LFENCE-NEXT:    movq %rdx, %r14
; X64-LFENCE-NEXT:    movq %rsi, %rbx
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    movslq %edi, %rax
; X64-LFENCE-NEXT:    movl (%rsi,%rax,4), %ebp
; X64-LFENCE-NEXT:    movl $4, %edi
; X64-LFENCE-NEXT:    callq __cxa_allocate_exception
; X64-LFENCE-NEXT:    movl %ebp, (%rax)
; X64-LFENCE-NEXT:  .Ltmp0:
; X64-LFENCE-NEXT:    xorl %esi, %esi
; X64-LFENCE-NEXT:    xorl %edx, %edx
; X64-LFENCE-NEXT:    movq %rax, %rdi
; X64-LFENCE-NEXT:    callq __cxa_throw
; X64-LFENCE-NEXT:  .Ltmp1:
; X64-LFENCE-NEXT:  .LBB3_2: # %exit
; X64-LFENCE-NEXT:    lfence
; X64-LFENCE-NEXT:    popq %rbx
; X64-LFENCE-NEXT:    popq %r14
; X64-LFENCE-NEXT:    popq %rbp
; X64-LFENCE-NEXT:    retq
; X64-LFENCE-NEXT:  .LBB3_3: # %lpad
; X64-LFENCE-NEXT:  .Ltmp2:
; X64-LFENCE-NEXT:    movl (%rax), %eax
; X64-LFENCE-NEXT:    addl (%rbx), %eax
; X64-LFENCE-NEXT:    cltq
; X64-LFENCE-NEXT:    movl (%r14,%rax,4), %edi
; X64-LFENCE-NEXT:    callq sink
entry:
  %a.cmp = icmp slt i32 %a, 42
  br i1 %a.cmp, label %thrower, label %exit

thrower:
  %badidx = getelementptr i32, i32* %ptr1, i32 %a
  %secret1 = load i32, i32* %badidx
  %e.ptr = call i8* @__cxa_allocate_exception(i64 4)
  %e.ptr.cast = bitcast i8* %e.ptr to i32*
  store i32 %secret1, i32* %e.ptr.cast
  invoke void @__cxa_throw(i8* %e.ptr, i8* null, i8* null)
          to label %exit unwind label %lpad

exit:
  ret void

lpad:
  %e = landingpad { i8*, i32 }
          catch i8* null
  %e.catch.ptr = extractvalue { i8*, i32 } %e, 0
  %e.catch.ptr.cast = bitcast i8* %e.catch.ptr to i32*
  %secret1.catch = load i32, i32* %e.catch.ptr.cast
  %secret2 = load i32, i32* %ptr1
  %secret.sum = add i32 %secret1.catch, %secret2
  %ptr2.idx = getelementptr i32, i32* %ptr2, i32 %secret.sum
  %leak = load i32, i32* %ptr2.idx
  call void @sink(i32 %leak)
  unreachable
}
