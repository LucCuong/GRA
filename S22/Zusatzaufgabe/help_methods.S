.intel_syntax noprefix
.global getint, putint


.section .rodata
.align 16

.section .text

//uint64_t getint ( char * str ) => rdi: *str
getint:
    mov rsi, 10
    mov rax, 0
    mov rcx, 0
.Lgetint_loop:
    mov cl, [rdi]
    cmp cl, 0
    je .Lend_getint
    
    sub cl, 48                                                  // 48 = '0'
    cmp cl, 9
    ja .Lend_getint
    
    mul rsi
    add rax, rcx
    inc rdi
    jmp .Lgetint_loop
    
    
.Lend_getint:
    // Testing calling convention
    mov rcx, -1
    mov rdx, -1
    mov rsi, -1
    mov r8, -1
    mov r9, -1
    mov r10, -1
    mov r11, -1
    ret
    
    //char * putint ( uint64_t value , char * string ) => rdi: value, rsi: *string
putint:
    //count the number of digits
    mov rax, rdi                                                                                // rdi stores value
    mov rcx, 10                                                                                 // rcx stores divisor
    mov r8, 1
    movups xmm0, [rsi]
.Lputint_count_loop:
    mov rdx, 0
    div rcx
    cmp rax, 0
    je .Lputint_prepare
    
    inc r8                                                                                      // r8 stores the current number of digits
    jmp .Lputint_count_loop

.Lputint_prepare:
    mov r11, r8                                                                                 // r11 stores index of the  pointer after using  putint
    dec r8
    mov rax, rdi
.Lputint_loop:
    movups xmm1, [rsi]
    mov rdx, 0
    div rcx                                                         
    add rdx, 48
    mov [rsi + r8], dl                                                                          // rdx stores the digit
    dec r8
    cmp r8, 0
    jl .Lend_putint
    jmp .Lputint_loop
    
    
        
                
.Lend_putint:
    // Testing calling convention
    add rsi, r11
    mov rax, rsi
    mov rcx, -1
    mov rdx, -1
    mov r8, -1
    mov r9, -1
    mov r10, -1
    mov r11, -1
    ret
