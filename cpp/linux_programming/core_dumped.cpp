#include <iostream>

using namespace std;

int dummy_function(){
	delete (int*)5;
}

int main(){
	dummy_function();
	return 0;
}
