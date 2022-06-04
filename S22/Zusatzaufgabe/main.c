#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern void unionfind(uint64_t setSize, char * instruction_string, char * solution_string);
extern uint64_t getint ( char * str );
char * putint ( uint64_t value , char * string );


int main (){
	char *testGetInt = "123test";
	uint64_t getInt = getint(testGetInt);
	printf("The result of getint: %ld ---\n",getInt);
	printf("The pointer points to the character: %c ---\n",testGetInt[0]);
	
	char *testPutInt = "testtest";
	char* putInt = putint(123, testPutInt[4]);
	printf("The result of putint: %s ---\n",testPutInt);
	printf("The pointer points to the character: %s ---\n",putInt);
	
 	char instruction_string [] = "F0F1F2";
 	char solution_string [100];
// 	unionfind(3, instruction_string, solution_string);
 	printf("instructions: %s\n", instruction_string);
 	printf("result      : %s\n", solution_string);
}

