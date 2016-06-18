// comment the following include directive,
// You will see a different result.
// The features.h of the glibc is included in every
// header file.
#include "stdint.h"

int test(){
#ifdef __GNU_LIBRARY__
	return __GNU_LIBRARY__;
#else
	return -1;
#endif
}


#include <iostream>

using namespace std;

int main(){
	cout<<test()<<endl;
}

