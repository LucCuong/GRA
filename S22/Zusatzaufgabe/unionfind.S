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
    push rbx                                                                                        // rbx: setSize										
    push r12										  // r12: pointer to first element of group index
    push r13										  // r13: pointer to first element of group size 
    push r14                                                                                        // r14: instruction_string                                                                      
    push r15                                                                                        // r15: solution_string
    push rbp
    mov rbp, rsp
    sub rsp, 64
	
    // store paramters in callee-registers
    mov rbx, rdi
    mov r14, rsi
    mov r15, rdx
    mov [rbp - 64], r15
    movups xmm0, [r14]
    movups xmm1, [r15]
    
    
    // calculate memory space and allocate the memory => returned address in rax
    mov rax, 8
    mul rbx
    push rax                                                                                        // store size of array on the stack 
    mov rdi, rax
    call malloc
    mov r12, rax
    movups xmm2, [r12]
    movups xmm4, [r12 + 16]
	
    // allocate for the second array
    pop rdi                                                                                         // get array size from the stack
    call malloc                         
    mov r13, rax
    movups xmm3, [r13]
    movups xmm5, [r13 + 16]
	
    // set up two array for initial values
    mov rcx, 0
.Lsetup_loop:
    cmp rcx, rbx
    je .Lprocessing_data_loop
    
    // store index in array 1
    mov [r12 + rcx*8], rcx
    movups xmm2, [r12]
    movups xmm4, [r12 + 16]
    
    // store size in array 2
    mov qword ptr [r13 + rcx*8], 1
    movups xmm3, [r13]
    movups xmm5, [r13 + 16]
    
    inc rcx
    jmp .Lsetup_loop
    
                                                                                 
.Lprocessing_data_loop:
    // check conditions
    mov al, [r14]
    cmp al, 0
    je end
    inc r14                                                                                         // move the pointer to the next char
    
    // check union or find
    cmp al, 70                                                                                      // 'L'
    je .Lcall_find                                                                                  // Jump to Find_handler
    jne .Lcall_union                                                                                // Jump to Uinon_handler
    


.Lcall_find:
    mov qword ptr [rbp - 24], 0                                                                     // store parameter for print_solution 0=print_find; 1=print_union
    mov rdi, r14
    call getint
    mov r14, rdi                                                                                    // Update the current pointer in instruction_string
    mov [rbp - 32], rax                                                                             // Store the INDEX for the FIND function in stack
    call find
    call print_solution
    jmp .Lprocessing_data_loop
    
find:
    mov r9, 0                                                                                       // r9 stores levels
    mov rdi, [rbp - 32]
    mov [rbp - 16], r9
.Lfind_loop:                                                                                        // rdi: initial index of find function
    mov rcx, [r12 + rdi*8]                                                                          // store index of the father in rcx
    cmp rcx, rdi
    je .Lfind_relink                                                                                // Reach the root
    mov rdi, rcx
    jmp .Lfind_loop
    
.Lfind_relink:                                                                                      // rdi: the index of ROOT
    mov rdx, [rbp - 32]                                                                             // rdx: Pick the initial index 1 from stack
    mov [rbp - 8], rdi                                                                              // Store index of the root in stack
.Lfind_relink_loop:
    cmp rdx, rdi
    je .Lend_find
    
    mov rcx, [r12 + rdx*8]                                                                          // rcx: father index of rdx
    inc r9
    mov [rbp - 16], r9                                                                              // update levels on stack
    mov [r12 + rdx*8], rdi                                                                          // hang the node at the root
    mov rdx, rcx
    movups xmm2, [r12]
    movups xmm4, [r12 + 16]
    jmp .Lfind_relink_loop

.Lend_find:
    ret


    
.Lcall_union:	
    mov rdi, r14
    call getint
    mov [rbp - 32], rax                                                                             // Store the INDEX 1 for the Union function in stack
    inc rdi
    call  getint
    mov r14, rdi
    mov [rbp - 40], rax                                                                             // Store the INDEX 2 for the Union function in stack
    
    call find
    // Store index of root and levels in another stack cells
    mov rdx, [rbp - 8]
    mov [rbp-48], rdx
    mov rdx, [rbp - 16]
    mov [rbp - 56], rdx
    
    // Update the initial index 1 for the next call
    mov rdx, [rbp - 40]
    mov [rbp - 32], rdx
    
    call find
    
    mov qword ptr [rbp - 24], 1                                                                     // store parameter for print_solution 0=print_find; 1=print_union
    // Processing data
    // Sum levels of two finds
    mov rax, [rbp - 56]
    mov rcx, [rbp - 16]
    add rax, rcx
    mov [rbp - 16], rax
    
    // Compare two roots
    mov rax, [rbp - 48]
    cmp rax, [rbp - 8]
    je .Lend_union
    
.Lunion_attach:                                                                                     // two roots are not in the same group
    mov rax, [rbp - 48]                                                                             // rax stores index of the root of the first group
    mov rdi, [r13 + rax*8]                                                                            // rdi stores the size of the first group
    mov rcx, [rbp - 8]                                                                              // rcx stores index of the root of the second group
    mov rsi, [r13 + rcx*8]                                                                            // rsi stores the size of the second group
    cmp rdi, rsi
    jae .Lattach2to1
    
    // attach the first group to the second group
    mov [r12 + rax*8], rcx
    add rsi, rdi
    mov qword ptr [r13 + rax*8], 0
    mov [r13 + rcx*8], rsi
    movups xmm3, [r13]
    movups xmm5, [r13 + 16]
    movups xmm2, [r12]
    movups xmm4, [r12 + 16]
    jmp .Lend_union
    
.Lattach2to1:
    // attach the second group to the first group
    mov [r12 + rcx*8], rax
    add rdi, rsi
    mov qword ptr [r13 + rcx*8], 0
    mov [r13 + rax*8], rdi
    
    // Update values on stack for printing
    mov [rbp - 8], rax

    movups xmm3, [r13]
    movups xmm5, [r13 + 16]
    movups xmm2, [r12]
    movups xmm4, [r12 + 16]
      
.Lend_union:
    call print_solution
    jmp .Lprocessing_data_loop
    
print_solution:                                                                                     
    cmp qword ptr [rbp-24], 0
    je .Lprint_F
    jne .Lprint_U
    
.Lprint_F:
    mov byte ptr [r15], 70                                                                          // write 'F' into solution_string
    inc r15                                                                                         // move the pointer to the next char
    jmp .Lprint_value
    
.Lprint_U:
    mov byte ptr [r15], 85                                                                          // write 'U´' into solution_string
    inc r15                                                                                         // move the pointer to the next char
    
.Lprint_value:
    mov rdi, [rbp-8]                                                                                // copy index of the root to rsi
    mov rsi, r15
    call putint
    mov r15, rax                                                                                    
    mov byte ptr [r15], 76                                                                          // write 'L' into solution_string
    inc r15
    mov rdi, [rbp-16]                                                                               // pick the levels number in rsi
    mov rsi, r15
    call putint                                                                                     
    mov r15, rax
    
    mov rax, [rbp - 64]                                                                                              
    movups xmm1, [rax]
    ret
end:	
    mov al, 0
    mov byte ptr [r15], al
    mov rsp, rbp
    pop rbp
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
