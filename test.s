	.file	"test.c"
	.globl	from
	.bss
	.align 8
	.type	from, @object
	.size	from, 8
from:
	.zero	8
	.section .rodata
.LC0:
	.string "%ld"
.LC1:
	.string "%Xh"
.LC2:
	.string "%s"
.LC3:
	.string	"aa is Max\n"
.LC4:
	.string	"b is Max\n"
.LC5:
	.string	"c is Max\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	subq	$8, %rsp
	movq	$1, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	movq	%rax, -8(%rbp)
	subq	$8, %rsp
	movq	%rax, (%rsp)
	subq	$8, %rsp
	movq	$4, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	movq	%rax, (%rsp)
	subq	$8, %rsp
	movq	$2, %rax
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	-16(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	-8(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	subq	(%rsp), %rax
	movq	%rax, (%rsp)
	cmpq	$0, (%rsp)
	jl	.L0
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	-8(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	subq	(%rsp), %rax
	movq	%rax, (%rsp)
	cmpq	$0, (%rsp)
	jl	.L1
	movl	$.LC3, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	pushq	%rcx
	call	printf
	popq	%rcx
.L1:
	addq	$8, %rsp
.L0:
	addq	$8, %rsp
	movq	-8(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	-16(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	subq	(%rsp), %rax
	movq	%rax, (%rsp)
	cmpq	$0, (%rsp)
	jl	.L2
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	-16(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	subq	(%rsp), %rax
	movq	%rax, (%rsp)
	cmpq	$0, (%rsp)
	jl	.L3
	movl	$.LC4, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	pushq	%rcx
	call	printf
	popq	%rcx
.L3:
	addq	$8, %rsp
.L2:
	addq	$8, %rsp
	movq	-8(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	subq	(%rsp), %rax
	movq	%rax, (%rsp)
	cmpq	$0, (%rsp)
	jl	.L4
	movq	-16(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movq	%rax, (%rsp)
	movq	(%rsp), %rax
	addq	$8, %rsp
	subq	(%rsp), %rax
	movq	%rax, (%rsp)
	cmpq	$0, (%rsp)
	jl	.L5
	movl	$.LC5, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	pushq	%rcx
	call	printf
	popq	%rcx
.L5:
	addq	$8, %rsp
.L4:
	addq	$8, %rsp
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size main, .-main
