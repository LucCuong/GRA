#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>


extern void unionfind(uint64_t setSize, char * instruction_string, char * solution_string);
extern uint64_t getint ( char * str );
char * putint ( uint64_t value , char * string );


int main (){
	
	char *testGetInt = "123test";
	uint64_t getInt = getint(testGetInt);
	printf("The result of getint: %ld ---\n",getInt);
	printf("The pointer points to the character: %c ---\n",testGetInt[0]);
	
	char testPutInt[9] = {'t', 'e', 's', 't', 't', 'e', 's', 't', '\0'};
	printf("\nThe original string before putint: %s ---\n",testPutInt);
	char* putInt = putint(0, &testPutInt[2]);
	printf("\nThe original string before putint: %s ---\n",testPutInt);
	printf("The string after using putint: %s ---\n",putInt);

	
	
	char instruction_string [] = "F0F1F2";
	char solution_string[100];
 	printf("\n");
 	unionfind(3, instruction_string, solution_string);
 	printf("instructions: %s\n", instruction_string);
 	printf("result      : %s\n", solution_string);
 	if(!strcmp(solution_string, "F0L0F1L0F2L0")){
 		printf("passed\n");
 	}else{
 		printf("failed, the solution should be F0L0F1L0F2L0\n");
 	}
	
 	char instruction_string2 [] = "U0&1F0F1";
 	char solution_string2[100];
 	printf("\n");
 	unionfind(2, instruction_string2, solution_string2);
 	printf("instructions: %s\n", instruction_string2);
 	printf("result      : %s\n", solution_string2);
 	if(!strcmp(solution_string2, "U0L0F0L0F0L1")){
 		printf("passed\n");
 	}else{
 		printf("failed, the solution should be U0L0F0L0F0L1\n");
 	}
 	
 	
 	char instruction_string3 [] = "U0&1U1&2U3&4U4&2F4F4";
 	char solution_string3[100];
 	printf("\n");
 	unionfind(5, instruction_string3, solution_string3);
 	printf("instructions: %s\n", instruction_string3);
 	printf("result      : %s\n", solution_string3);
 	if(!strcmp(solution_string3, "U0L0U0L1U3L0U0L2F0L2F0L1")){
 		printf("passed\n");
 	}else{
 		printf("failed, the solution should be U0L0U0L1U3L0U0L2F0L2F0L1\n");
 	}
 	
 	
 	
  	char instruction_string4 [] =  "F1337";
  	char solution_string4[100];
 	printf("\n");
 	unionfind(9999, instruction_string4, solution_string4);
 	printf("instructions: %s\n", instruction_string4);
 	printf("result      : %s\n", solution_string4);
 	if(!strcmp(solution_string4, "F1337L0")){
 		printf("passed\n");
 	}else{
 		printf("failed, the solution should be F1337L0\n");
 	}
 	
 	char instruction_string5 [] =  "F0";
  	char solution_string5[100];
 	printf("\n");
 	unionfind(1, instruction_string5, solution_string5);
 	printf("instructions: %s\n", instruction_string5);
 	printf("result      : %s\n", solution_string5);

}

