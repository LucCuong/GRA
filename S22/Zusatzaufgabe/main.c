#include <stdio.h>

extern void unionfind(uint64_t setSize, char * instruction_string, char * solution_string);


int main (int argc, char** argv){
 	char instruction_string [] = "F0F1F2";
 	char solution_string [100];
 	unionfind(3, instruction_string, solution_string);
 	printf("instructions: %s\n", instruction_string);
 	printf("result      : %s\n", solution_string);
}

