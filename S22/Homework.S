####################################################################### Sommer 2022 ################################################################
######################################################################## 1.Week ####################################################################
											------------------------------ factorial ----------------------------------
factorial:
	# prepare register
	push rbx
	mov rax, 1
	mov rdx, 0
	mov rbx, 0
    mov rcx, 0
    mov rsi, 1
	cmp rdi, 0	
	je .Lend
    
    # the result is bigger than 2^128
	cmp rdi, 35
	jae .Lge2x128
.Lloop:
	# Multiply rax with rdi
    #mov rcx, rdx		# Store rdx in rcx
	mul rsi             # rax = rax * rsi
	mov rbx, rax		# Store rax in rbx
	cmp rdx, 0
    jg .Lgt64bit

.Lcontinue:
    # Check and end loop
    inc rsi
    cmp rsi, rdi
    jg .Lend
    jmp .Lloop
    
.Lgt64bit:
	    # Multiply rdx with rdi
    mov rax, rcx 		
	mov rcx, rdx
	mul rsi
	add rcx, rax
    #mov rdx, rcx
    mov rax, rbx
    jmp .Lcontinue
.Lge2x128:
    mov rax, -1
    mov rcx, -1
.Lend:
    pop rbx
    mov rdx, rcx
    ret
	
	
												------------------------------ mul8 ----------------------------------
mult_eight:
  shl rdi, 3
  mov rax, rdi
  ret
  
												------------------------------ gauss ----------------------------------
  
gauss:
  lea rax, [rdi + 1]
  mul rdi
  shl rdx, 63
  shr rax, 1
  or rax, rdx
  ret
  
######################################################################## 2.Week ####################################################################
												----------------------------- Collatz --------------------------------
#include <stdint.h>

uint64_t collatz(uint64_t n) {
  uint64_t counter = 0;
  while(n > 1){
    if(n%2 == 0)
      n = n >> 1;
  	else{
		if(n >= 6148914691236517205)
          return 0;
      	n = n*3 +1;
    }
  counter++;
  }
      
  return counter; // FIXME!
}

												----------------------------- EAN 13 --------------------------------
#include <stdint.h>
int ean13(uint64_t ean) {
  if(ean > 9999999999999)
    return 0;
  int ziffer;
  int sum = 0;
  for(int i = 13; i>0; i--){
  	ziffer = ean %10;
    ean = ean/10;
    sum += i%2==0?ziffer*3:ziffer;
  }
  return sum%10==0?1:0; // FIXME!
}

######################################################################## 3.Week ####################################################################
												----------------------------- Brainfuck --------------------------------
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

// Interpreter state
struct BFState {
  // The array and the size of the array.
  size_t array_len;
  uint8_t* array;

  // Pointer to the current position, points into array..array+array_len.
  uint8_t* cur;
};

int brainfuck(struct BFState* state, const char* program) {
    // TODO: your implementation. :)

    // Prevent warnings about unused parameters.
	int program_index = 0;
	char ch;
	int count;
	while((ch = program[program_index++]) != '\0'){
		switch (ch){
		case '>':
			++state->cur;
			if((long int)state->cur > (long int)(state->array+ state->array_len-1))
				return -1;
			break;
		case '<':
			--state->cur;
			if((long int)state->cur < (long int)state->array)
				return -1;
			break;
		case '+':
			++*state->cur;
			break;
		case '-':
			--*state->cur;
			break;
		case '[':
			count = 1;
			if (*state->cur == 0){
				while(count != 0){
					ch = program[program_index++];
					if(ch == '[') count++;
					if(ch == ']') count--;
					if(ch == '\0') return -1;
				}
				break;
			}
			break;
		case ']':
			//reached here
			count = 1;
			if (*state->cur != 0){
				program_index--;
				while(count != 0){
                  --program_index;
                  if(program_index < 0) return -1;
				ch = program[program_index];
				if(ch == '[') count--;
				if(ch == ']') count++;
				}
				break;
			}
			break;
		default:
			break;

		}

	}
    (void) state, (void) program;

    return 0;
}

												----------------------------- Listsum --------------------------------
#include <stdint.h>
#include <stddef.h>
struct node { struct node* next; unsigned long val; };
uint64_t listsum(const struct node* list) {
  // TODO: your implementation. :)
  uint64_t sum  = 0;
  while(list != NULL){
  	sum += list->val;
    list = list->next;
  }
  return sum;
}												
												
######################################################################## 4.Week ####################################################################
												----------------------------- Map --------------------------------			
map:
	push r12
    push r13
    push r14
    push r15
    sub rsp, 8
    mov r12, 0
    mov r13, rdi
    mov r14, rsi
    mov r15, rdx
    
.Loop:
	cmp r12, r14
    je .Lend
    mov edi, [r15 + r12*4]
    call r13
    mov [r15 + r12*4], eax
    inc r12
    jmp .Loop
    
.Lend:
	add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    
    ret

												----------------------------- Memccpy --------------------------------	
#include <stddef.h>

void* memccpy(void* dest, const void* src, int c, size_t n) {
    // TODO: your code
	char *dest_char = dest;
	const char *src_char = src;
	for(size_t i = 0; i < n; i++){
		dest_char[i]=src_char[i];
		if(src_char[i] == (char)c) return &dest_char[i+1];
	}

    return NULL;
}			
	
######################################################################## 5.Week ####################################################################
												----------------------------- Circ --------------------------------
.section .rodata
.Pi: .double 6.283185307

.section .text
circ:
  movsd xmm1, [rip + .Pi]
  mulsd xmm0, xmm1
  ret
  
												----------------------------- Round --------------------------------
#include <stdbool.h>
#include <stdint.h>


enum RoundMode {
  RM_FLOOR = 1, // Round towards -Infinity
  RM_CEIL,      // Round towards +Infinity
};
// Iff  isflt==false  then  fix  is valid; otherwise  flt  is valid.
struct num { bool isflt; union { int64_t fix; double flt; }; };
struct num num_round(struct num num, enum RoundMode rm) {
  // TODO: round  num  according to  rm.
  int64_t after_comma;
  int64_t exponent;
  int64_t mantisse;
  int move;
  if(num.isflt == false){
  	after_comma = num.fix;
    after_comma = after_comma & 0xffffffff;
    if(after_comma == 0) return num;
    if(rm == RM_CEIL){
    	num.fix = num.fix >> 32;
      	num.fix++;
      	num.fix = num.fix << 32;
    }else{
    	num.fix = num.fix & 0xffffffff00000000;
    }
  }
  else{
	if(num.fix == 0)
		return num;

    exponent = num.fix;
    exponent = exponent >> 52;
    exponent = exponent & 0x7ff;
    exponent -= 1023;
    if(exponent <52){
    	if(exponent >= 0){
    		// exponent > 0
    		move = 52-exponent;
    		mantisse = num.fix;
    		mantisse = mantisse << (exponent +12);
    		mantisse = mantisse >> (exponent +12);
    		if(mantisse == 0)
    			return num;
    		if(rm == RM_CEIL){
    			// round up
    			if(num.flt >0){
    				// float number is positive
    				num.fix = num.fix >> move;
    				num.fix ++;
    				num.fix = num.fix << move;
    				return num;
    			}else{
    				// float number is negative
    				num.fix = num.fix >> move;
    				num.fix = num.fix << move;
    				return num;
    			}
    		}else{
    			// round down FLOOR
    			if(num.flt >0){
    				// float number is positive
    				num.fix = num.fix >> move;
    				num.fix = num.fix << move;
    				return num;
    			}else{
    				// float number is negative
    				num.fix = num.fix >> move;
    				num.fix ++;
    				num.fix = num.fix << move;
    				return num;
    			}
    		}
    	}else{
    		// exponent < 0
    		mantisse = num.fix & 0x7FFFFFFFFFFFFFFF;
    		if(mantisse == 0)
    			return num;
    		if(rm == RM_CEIL){
    			// round up
    			if(num.flt >0){
    				// float number is positive
    				num.fix = 1023;
    				num.fix = num.fix << 52;
    				return num;
    			}else{
    				// float number is negative => -0
    				num.fix = num.fix & 0x8000000000000000;
    				return num;
    			}
    		}else{
    			// round down
    			if(num.flt >0){
    				// float number is positive
    				num.fix = 0;
    				return num;
    			}else{
    				// float number is negative => -1
    				num.fix = 3071;
    				num.fix = num.fix << 52;
    				return num;
    			}
    		}
    	}
    }else
      return num;
  }
  return num;
}
												----------------------------- Numquad --------------------------------
numquad: // double numquad(double(* f)(double), double a, double b, size_t n)
    //(a:xmm0)(b:xmm1)(size:rsi)(pointer: rdi)
    //pxor xmm0, xmm0
    push rdi
    push rax
    push rbx
    push rcx
    push rdx
    cmp rsi, 2
    jl .Less_than_2

	pxor xmm3, xmm3
	movaps xmm4, xmm1							//interval
	subsd xmm4, xmm0
	pxor xmm5, xmm5
	dec rsi
	cvtsi2sd xmm5, rsi							//convert decimal to single precistion
	divsd xmm4, xmm5							//get interval: (b-a) xmm4
	movaps xmm0, xmm1							//pass parameter to xmm0
	mov ecx, 2
	cvtsi2sd xmm7, ecx

//	sub rsp, 0xe0
	call Function_Call							//call function
//	add rsp, 0xe0
	movaps xmm5, xmm0							//f(b): xmm5
.Loop1:



	subsd xmm1, xmm4							//a
	movaps xmm0, xmm1							//pass the parameter


	call Function_Call

	movaps xmm6, xmm0							//f(a): xmm6
	addsd xmm5, xmm6							//f(a) + f(b): xmm5
	mulsd xmm5, xmm4							//(b-a)*(f(a)+f(b))
	divsd xmm5, xmm7							//(b-a)*(f(a)+f(b))/2
	addsd xmm3, xmm5							//sum to result

	dec rsi

	cmp rsi, 0
	je end										//if rsi=1, end the loop

	movaps xmm5, xmm6							//f(a) for the next iteration
	jmp .Loop1

Function_Call:
	sub rsp, 24
	movdqa [rsp], xmm1
	sub rsp, 16
	movaps [rsp], xmm3
	sub rsp, 16
	movaps [rsp], xmm4
	sub rsp, 16
	movaps [rsp], xmm5
	sub rsp, 16
	movaps [rsp], xmm7
	push rsi
	push rdi

	call rdi

	pop rdi
	pop rsi
	movaps xmm7, [rsp]
	add rsp, 16
	movaps xmm5, [rsp]
	add rsp, 16
	movaps xmm4, [rsp]
	add rsp, 16
	movaps xmm3, [rsp]
	add rsp, 16
	movaps xmm1, [rsp]
	add rsp, 24
	ret


.Less_than_2:
	pcmpeqd xmm0,xmm0
	jmp end_evil
end:
	movaps xmm0, xmm3
end_evil:
	pop rdx
	pop rcx
	pop rbx
	pop rax
	pop rdi
    ret
	
######################################################################## 6.Week ####################################################################
												----------------------------- SAXPY -------------------------------
saxpy:
	// (n: rdi), (alpha: xmm0), (x: rsi), (y: rdx)
	push rdi
	push rsi
	push rdx

	//step1: copy the float alpha in every block of xmm0
	shufps xmm0, xmm0, 0x00
Loop1:
	cmp rdi, 4
	jl less_than_4
	movups xmm1, [rsi]
	movups xmm2, [rdx]
	mulps xmm1, xmm0
	addps xmm2, xmm1
	movups [rdx], xmm2

	movups xmm2, [rdx]

	add rsi, 16
	add rdx, 16
	sub rdi, 4
	jmp Loop1
less_than_4:
	cmp rdi, 0
	je end
	movss xmm1, [rsi]
	movss xmm2, [rdx]
	mulss xmm1, xmm0
	addss xmm2, xmm1
	movss [rdx], xmm2
	add rsi, 4
	add rdx, 4
	dec rdi
	jmp less_than_4

end:
	pop rdx
	pop rsi
	pop rdi
    ret
	
												----------------------------- SDOT -------------------------------
												
#include <stddef.h>
#include <immintrin.h>

float sdot(size_t n, const float x[n], const float y[n]) {
  	__m128 sum = _mm_setzero_ps();
	__m128 vx;
	__m128 vy;
	size_t modulo = n%4;
	size_t n_modulo = n - modulo;
	size_t i;
	for(i = 0; i< n_modulo; i+= 4){
		vx = _mm_loadu_ps(x+i);
		vy = _mm_loadu_ps(y+i);
		vy = _mm_mul_ps(vx, vy);
		sum = _mm_add_ps(sum, vy);
	}
	if(modulo != 0){
		while(i<n){
			vx = _mm_load_ss(x+i);
			vy = _mm_load_ss(y+i);
			vy = _mm_mul_ss(vx, vy);
			sum = _mm_add_ss(sum, vy);
			i++;
		}
	}
	vy = _mm_shuffle_ps(sum, vx, _MM_SHUFFLE(0,0,0,0));
	vx = _mm_shuffle_ps(sum, vx, _MM_SHUFFLE(0,0,0,1));
	vy = _mm_add_ss(vy, vx);
	vx = _mm_shuffle_ps(sum, vx, _MM_SHUFFLE(0,0,0,2));
	vy = _mm_add_ss(vy, vx);
	vx = _mm_shuffle_ps(sum, vx, _MM_SHUFFLE(0,0,0,3));
	vy = _mm_add_ss(vy, vx);
    return vy[0];
}

######################################################################## 7.Week ####################################################################
												----------------------------- SAXPY -------------------------------
											
												
######################################################################## Zusatzaufgabe ####################################################################
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
    sub rsp, 72
	
    // store paramters in callee-registers
    mov rbx, rdi
    mov r14, rsi
    mov r15, rdx
    mov [rbp - 64], r15
    //movups xmm0, [r14]
    //movups xmm1, [r15]
    
    
    // calculate memory space and allocate the memory => returned address in rax
    mov rax, 8
    mul rbx
    mov [rbp - 72], rax                                                                                        // store size of array on the stack 
    mov rdi, rax
    call malloc
    mov r12, rax
    //movups xmm2, [r12]
    //movups xmm4, [r12 + 16]
	
    // allocate for the second array
    mov rdi, [rbp - 72]                                                                                         // get array size from the stack
    call malloc                         
    mov r13, rax
    //movups xmm3, [r13]
    //movups xmm5, [r13 + 16]
	
    // set up two array for initial values
    mov rcx, 0
.Lsetup_loop:
    cmp rcx, rbx
    je .Lprocessing_data_loop
    
    // store index in array 1
    mov [r12 + rcx*8], rcx
    //movups xmm2, [r12]
    //movups xmm4, [r12 + 16]
    
    // store size in array 2
    mov qword ptr [r13 + rcx*8], 1
    //movups xmm3, [r13]
    //movups xmm5, [r13 + 16]
    
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
    jmp .Lprint_F
    
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
    //movups xmm2, [r12]
    //movups xmm4, [r12 + 16]
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
    //movups xmm3, [r13]
    //movups xmm5, [r13 + 16]
    //movups xmm2, [r12]
    //movups xmm4, [r12 + 16]
    jmp .Lend_union
    
.Lattach2to1:
    // attach the second group to the first group
    mov [r12 + rcx*8], rax
    add rdi, rsi
    mov qword ptr [r13 + rcx*8], 0
    mov [r13 + rax*8], rdi
    
    // Update values on stack for printing
    mov [rbp - 8], rax

    //movups xmm3, [r13]
    //movups xmm5, [r13 + 16]
    //movups xmm2, [r12]
    //movups xmm4, [r12 + 16]
      
.Lend_union:
    jmp .Lprint_U
    
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
    //movups xmm1, [rax]
    jmp .Lprocessing_data_loop
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