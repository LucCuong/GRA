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
    jg .Lend_getint
    
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
    mov rax, rdi
    mov rcx, 10
    div rcx
.Lputint_loop:
    
    
.Lend_putint:
    // Testing calling convention
    mov rcx, -1
    mov rdx, -1
    mov r8, -1
    mov r9, -1
    mov r10, -1
    mov r11, -1
    ret
