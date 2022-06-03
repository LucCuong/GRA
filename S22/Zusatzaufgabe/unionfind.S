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
    sub rsp, 40
	
    // store paramters in callee-registers
    mov rbx, rdi
    mov r14, rsi
    mov r15, rdx
	
    // calculate memory space and allocate the memory => returned address in rax
    mov rax, 8
    mul rbx
    push rax                                                                                        // store size of array on the stack 
    mov rdi, rax
    call malloc
    mov r12, rax
	
    // allocate for the second array
    pop rdi                                                                                         // get array size from the stack
    call malloc                         
    mov r13, rax
	
    // set up two array for initial values
    mov rcx, 0
.Lsetup_loop:
    cmp rcx, rbx
    je .Lprocessing_data_loop
    
    // store index in array 1
    mov [r12 + rcx*8], rcx
    
    // store size in array 2
    mov [r13 + rcx*8], 1
    
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
    je .Lfind_handler                                                                               // Jump to Find_handler
    jne .Lunion_handler                                                                             // Jump to Uinon_handler
    
.Lfind_handler:
    mov [rbp - 24], 0                                                                               // store parameter for print_solution 0=print_find; 1=print_union
    mov rdi, r14
    call getint
    mov r14, rdi                                                                                    // Update the current pointer in instruction_string
    mov [rbx - 32], rax                                                                             // Store the INDEX for the FIND function in stack
    mov r9, 0                                                                                       // r9 stores levels

.Lfind_loop:                                                                                        // rax stores currently the index of find function
    mov rcx, [r12 + rax]                                                                            // store index of the father in rcx
    cmp rcx, rax
    je .Lfind_relink                                                                                // Reach the root
    mov rax, rcx
    jmp .Lfind_loop
    
.Lfind_relink:                                                                                      // the index of ROOT is stored in rax
    mov rdx, [rbp - 32]                                                                             // Pick the initial index from stack
    mov [rbp - 8], rax                                                                              // Store index of the root in stack
.Lfind_relink_loop:
    mov rcx, [r12 + rdx]                                                                            // relink begins with the index rdx
    cmp rcx, rax
    je .Lfind_print_solution                                                                        // relink reaches the root
    inc r9
    mov [r12 + rdx], rax                                                                            // hang the node at the root
    mov rdx, rcx
    jmp .Lfind_relink_loop

.Lprint_solution:                                                                                   // the levels of find is stored in r9
    mov [rbp-16], r9
    cmp [rbp-24], 0
    je .Lprint_find
    jne .Lprint_union
    
.Lprint_find:
    mov byte ptr [r15], 70                                                                          // write 'F' into solution_string
    inc r15                                                                                         // move the pointer to the next char
    mov rsi, [rbp-8]                                                                                // copy index of the root to rsi
    call putint
    mov r15, rsi                                                                                    
    mov byte ptr [r15], 76                                                                          // write 'L' into solution_string
    inc r15
    mov rsi, [rbp-16]                                                                               // pick the levels number in rsi
    call putint                                                                                     
    mov r15, rsi
    
.Lprint_union:
    mov byte ptr [r15], 85                                                                          // write 'U´' into solution_string
    inc r15                                                                                         // move the pointer to the next char
    mov rsi, [rbp-8]                                                                                // copy index of the root to rsi
    call putint
    mov r15, rsi                                                                                    
    mov byte ptr [r15], 76                                                                          // write 'L' into solution_string
    inc r15
    mov rsi, [rbp-16]                                                                               // pick the levels number in rsi
    call putint                                                                                     
    mov r15, rsi
.Lunion_handler:	
    mov [rbp - 24], 1                                                                               // store parameter for print_solution 0=print_find; 1=print_union
    mov rdi, r14
    call getint
    inc rdi
    mov [rbp - 32], rax                                                                             // Store the INDEX 1 for the Union function in stack
    call  getint
    mov r14, rdi
    mov [rbp - 40], rax                                                                             // Store the INDEX 2 for the Union function in stack
    
end:	
    mov byte ptr [r15], al
    pop rbp
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
