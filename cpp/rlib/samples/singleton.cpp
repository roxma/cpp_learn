
#include "rlibns/Singleton.h"

#include <iostream>

class Foo: rlibns::Singleton{
public:
	static Foo* GetInstance(){
		return rlibns::Singleton::GetSingleton<Foo>();
	}
	~Foo(){
		std::cout<<"~Foo"<<std::endl;
	}
};

// // Compiles success, but Foo* cannot be converted to Foo2*, we are still safe in this case
// class Foo2: rlibns::Singleton{
// public:
// 	Foo* GetInstance(){
// 		return rlibns::Singleton::GetSingleton<Foo>();
// 	}
// };

int main(){
	std::cout<<Foo::GetInstance()<<std::endl;
	std::cout<<Foo::GetInstance()<<std::endl;
	return 0;
}

