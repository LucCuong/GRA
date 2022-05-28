.intel_syntax noprefix
.global unionfind


.section .rodata
.align 16

.section .text


// setSize: rdi
// instruction_string: rsi
// solution_string: rdx

unionfind:
	// save callee-register
	push rbx
	push rbp
	push rsp
	push r12
	push r13
	push r14
	push r15
	
	// store setSize in rbx
	mov rbx, rdi
	
	// calculate memory space and allocate the memory
	mov rax, 8
	mul rdi
	mov rdi, rax
	call malloc
	
	
end:	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rsp
	pop rbp
	pop rbx
	ret
