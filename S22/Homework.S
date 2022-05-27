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
												----------------------------- Circ -------------------------------