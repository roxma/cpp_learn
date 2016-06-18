#include <stdio.h>

int some_external_function();

int add(int a, int b) {
	some_external_function(); // call an external function
	return a+b;
}
