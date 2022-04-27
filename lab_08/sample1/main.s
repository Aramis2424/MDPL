	.file	"main.c"
	.intel_syntax noprefix
	.text
	.def	printf;	.scl	3;	.type	32;	.endef
	.seh_proc	printf
printf:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 56
	.seh_stackalloc	56
	lea	rbp, 48[rsp]
	.seh_setframe	rbp, 48
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx
	mov	QWORD PTR 40[rbp], rdx
	mov	QWORD PTR 48[rbp], r8
	mov	QWORD PTR 56[rbp], r9
	lea	rax, 40[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rbx, QWORD PTR -16[rbp]
	mov	ecx, 1
	mov	rax, QWORD PTR __imp___acrt_iob_func[rip]
	call	rax
	mov	r8, rbx
	mov	rdx, QWORD PTR 32[rbp]
	mov	rcx, rax
	call	__mingw_vfprintf
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 56
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.globl	asm_len
	.def	asm_len;	.scl	2;	.type	32;	.endef
	.seh_proc	asm_len
asm_len:
	push	rbp
	.seh_pushreg	rbp
	push	rdi
	.seh_pushreg	rdi
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 16[rsp]
	.seh_setframe	rbp, 16
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 32[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rdx, QWORD PTR -16[rbp]
/APP
 # 12 "main.c" 1
	mov $0, %al
	mov rdx, %rdi
	mov $0xffffffff, %ecx
	repne scasb
	not %ecx
	dec %ecx
	mov %ecx, edx
 # 0 "" 2
/NO_APP
	mov	DWORD PTR -4[rbp], edx
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 24
	pop	rdi
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "String for test: \"%s\"\12Asm_len = %d\12Strlen = %zu\12\0"
	.text
	.globl	tests_for_strlen
	.def	tests_for_strlen;	.scl	2;	.type	32;	.endef
	.seh_proc	tests_for_strlen
tests_for_strlen:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 56
	.seh_stackalloc	56
	lea	rbp, 48[rsp]
	.seh_setframe	rbp, 48
	.seh_endprologue
	mov	DWORD PTR -6[rbp], 875770417
	mov	WORD PTR -2[rbp], 53
	lea	rax, -6[rbp]
	mov	rcx, rax
	call	strlen
	mov	rbx, rax
	lea	rax, -6[rbp]
	mov	rcx, rax
	call	asm_len
	mov	edx, eax
	lea	rax, -6[rbp]
	mov	r9, rbx
	mov	r8d, edx
	mov	rdx, rax
	lea	rax, .LC0[rip]
	mov	rcx, rax
	call	printf
	mov	QWORD PTR -16[rbp], 49
	mov	WORD PTR -8[rbp], 0
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	strlen
	mov	rbx, rax
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	asm_len
	mov	edx, eax
	lea	rax, -16[rbp]
	mov	r9, rbx
	mov	r8d, edx
	mov	rdx, rax
	lea	rax, .LC0[rip]
	mov	rcx, rax
	call	printf
	nop
	add	rsp, 56
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC1:
	.ascii "Test 1 (different source and destination)\12\0"
	.align 8
.LC2:
	.ascii "Data for ests: \12sourse = \"%s\", destination = \"%s\"\12Symbols copied = %d\12\0"
.LC3:
	.ascii "Result: \"%s\"\12\0"
.LC4:
	.ascii "------------------------\12\0"
	.align 8
.LC5:
	.ascii "Test 2 (destination = source + 6)\12\0"
	.align 8
.LC6:
	.ascii "String for tests: \12sourse = \"%s\", destination = \"%s\"\12\0"
	.align 8
.LC7:
	.ascii "Test 3 (source = destination + 4)\12\0"
	.text
	.globl	tests_for_strcopy
	.def	tests_for_strcopy;	.scl	2;	.type	32;	.endef
	.seh_proc	tests_for_strcopy
tests_for_strcopy:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	movabs	rax, 7599113487299999601
	movabs	rdx, 29104504219725935
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	movabs	rax, 3978425819141910832
	mov	edx, 14648
	mov	QWORD PTR -144[rbp], rax
	mov	QWORD PTR -136[rbp], rdx
	mov	QWORD PTR -128[rbp], 0
	mov	QWORD PTR -120[rbp], 0
	mov	QWORD PTR -112[rbp], 0
	mov	QWORD PTR -104[rbp], 0
	mov	QWORD PTR -96[rbp], 0
	mov	QWORD PTR -88[rbp], 0
	mov	QWORD PTR -80[rbp], 0
	mov	QWORD PTR -72[rbp], 0
	mov	QWORD PTR -64[rbp], 0
	mov	QWORD PTR -56[rbp], 0
	mov	DWORD PTR -48[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	lea	rax, .LC1[rip]
	mov	rcx, rax
	call	printf
	mov	DWORD PTR -4[rbp], 4
	mov	ecx, DWORD PTR -4[rbp]
	lea	rdx, -144[rbp]
	lea	rax, -32[rbp]
	mov	r9d, ecx
	mov	r8, rdx
	mov	rdx, rax
	lea	rax, .LC2[rip]
	mov	rcx, rax
	call	printf
	mov	ecx, DWORD PTR -4[rbp]
	lea	rdx, -32[rbp]
	lea	rax, -144[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	strcopy
	lea	rax, -144[rbp]
	mov	rdx, rax
	lea	rax, .LC3[rip]
	mov	rcx, rax
	call	printf
	lea	rax, .LC4[rip]
	mov	rcx, rax
	call	printf
	lea	rax, .LC5[rip]
	mov	rcx, rax
	call	printf
	lea	rax, -32[rbp]
	add	rax, 6
	lea	rdx, -32[rbp]
	mov	r8, rax
	lea	rax, .LC6[rip]
	mov	rcx, rax
	call	printf
	mov	DWORD PTR -4[rbp], 5
	lea	rax, -32[rbp]
	add	rax, 6
	mov	ecx, DWORD PTR -4[rbp]
	lea	rdx, -32[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	strcopy
	lea	rax, -32[rbp]
	mov	rdx, rax
	lea	rax, .LC3[rip]
	mov	rcx, rax
	call	printf
	lea	rax, .LC4[rip]
	mov	rcx, rax
	call	printf
	lea	rax, .LC7[rip]
	mov	rcx, rax
	call	printf
	lea	rax, -32[rbp]
	add	rax, 4
	lea	rdx, -32[rbp]
	mov	r8, rax
	lea	rax, .LC6[rip]
	mov	rcx, rax
	call	printf
	mov	DWORD PTR -4[rbp], 5
	lea	rax, -32[rbp]
	add	rax, 4
	mov	edx, DWORD PTR -4[rbp]
	lea	rcx, -32[rbp]
	mov	r8d, edx
	mov	rdx, rax
	call	strcopy
	lea	rax, -32[rbp]
	mov	rdx, rax
	lea	rax, .LC3[rip]
	mov	rcx, rax
	call	printf
	lea	rax, .LC4[rip]
	mov	rcx, rax
	call	printf
	nop
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC8:
	.ascii "TESTS FOR LEN!!!\12\0"
.LC9:
	.ascii "\12TESTS FOR COPY!!!\12\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	call	__main
	lea	rax, .LC8[rip]
	mov	rcx, rax
	call	printf
	call	tests_for_strlen
	lea	rax, .LC9[rip]
	mov	rcx, rax
	call	printf
	call	tests_for_strcopy
	mov	eax, 0
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.ident	"GCC: (Rev5, Built by MSYS2 project) 11.2.0"
	.def	__mingw_vfprintf;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	strcopy;	.scl	2;	.type	32;	.endef
