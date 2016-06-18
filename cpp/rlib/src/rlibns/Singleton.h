#ifndef RLIBNS_SINGLETON_H
#define RLIBNS_SINGLETON_H

#include <pthread.h>	// pthread_once
#include <stdlib.h>     // atexit
#include <iostream>		// cerr

/**
 * @file rlibns/Singleton.h
 */

namespace rlibns{

class Singleton{

	// Support circular reference detection in the future

protected:
	Singleton(){} 
	virtual ~Singleton(){}

private:	// make client class impossible to be derived
	struct PrivateStruct{};
	virtual void FinalMethod(PrivateStruct) = 0;

protected:	// client class must derived from this class

	template<typename Derived>
	static Derived* GetSingleton(){
		class GrandChild: public Derived{
			virtual void FinalMethod(PrivateStruct){}
		public:
			virtual ~GrandChild(){}
			static Derived** GetPtr(){
				static Derived* ptr = 0;
				return &ptr;
			}
			static void DeInit(){
				delete *GetPtr();
				*GetPtr() = 0;
			}
			static void Init(){
				*GetPtr() = new GrandChild();
				atexit(DeInit);
			}
		};
		static pthread_once_t onceControl = PTHREAD_ONCE_INIT;
		pthread_once(&onceControl, GrandChild::Init);
		Derived* ret = *GrandChild::GetPtr();
		if(!ret){
			std::cerr<<"Dead reference, never expect to happen."<<std::endl;
			abort();
		}
		return ret;
	}

};


} // namespace rlibns


#endif

