#include <stdio.h>

extern double regula_falsi(double(* fn)(double), double a, double b, unsigned n);

double fn(double x){
	return x - 5;
}
int main (int argc, char** argv){
	double a = -2.0;
	double b = 6.0;
	unsigned n = 15;
	double result = regula_falsi(fn, a, b, n);
	printf("the result is %4.10lf \n", result);
}

