# A C/C++'s Implementation of Coroutine



## Introduction ##

Days ago I learned the basic concept of coroutine. It is very interesting bacause I can use only one thread to implement an efficient multi-thread like program. Using a coroutine architecture rather than multi-threading, you don't need to worry about any automic problems and those memory barriers issues, because you have only one thread, and the routine switch context by its own.

I've encountered some coroutine implementations. Without the native support in C/C++, most of them use ASM code to create and switch between context, some others use the standard C's [`setjmp` and `longjmp`](http://en.wikipedia.org/wiki/Setjmp.h) but require the routine to use static local variable to store its local data. However, I hate both writing ASM code and using static local variables so much that I come up with a slightly more elegant and tricky implementation, **without any ASM code and static local variables or macros**. This article is devoted to presenting you the basic idea and its implementation.



## The Basic Idea ##

The main difficulties for C/C++ are creating, storing and restoring the execution context, which envolve management of routine's stack, access of the CPU's registers for storing and restoring executing context. However, both the routine's stack and CPU's registers are not defined in standared C/C++. Therefore, it's impossible for us to present a pure cross-platform implementation in C/C++. But it's still possible to avoid ASM code with the operating system's API, the remaining of this article will shows you how to use POSIX's [pthread](https://computing.llnl.gov/tutorials/pthreads/) to implement a simple coroutine framework.

For creating the routine's execution context, we could call [`pthread_create`](https://computing.llnl.gov/tutorials/pthreads/man/pthread_create.txt) to create a real thread so that the operating system creates an execution context (initializes CPU's registers and the program's stack frame) for us. Then the thread starts, uses the C's `setjmp` function to store its execution context (it means registers here) into an external buffer. After that, the thread is of no use and we should just terminate the thread. However, note that when creating the thread, we should call [`pthread_attr_setstack`](https://computing.llnl.gov/tutorials/pthreads/man/pthread_attr_setstack.txt) to explicitly specify the stack so that it won't be automatically destroyed by the system when the thread exits. Apperantly, in this case, the `longjmp` function could be used to restoring execution's context. 



## Creating the Context ##

Here's the definition of our routines info. To make this article shorter, all error handling code are deleted to become the demonstration version. The source code of the original version is in the `coroutine.cpp`, the demostration version is `coroutime_demonstration.cpp`.

``` cplusplus
typedef void * (*RoutineHandler)(void*);

struct RoutineInfo{
	void * param;
	RoutineHandler handler;
	void * ret;
	bool stopped;

	jmp_buf buf;
	
	void *stackbase;
	size_t stacksize;
	
	pthread_attr_t attr;
	
	// size: the stack size
	RoutineInfo(size_t size){
		param = NULL;
		handler = NULL;
		ret = NULL;
		stopped = false;

		stackbase = malloc(size);
		stacksize = size;

		pthread_attr_init(&attr);
		if(stacksize)
			pthread_attr_setstack(&attr,stackbase,stacksize);
	}
	
	~RoutineInfo(){
		pthread_attr_destroy(&attr);
		free(stackbase);
	}
};
```

Also, we need a global list to store our RoutineInfo objects.

``` cplusplus
std::list<RoutineInfo*> InitRoutines(){
	std::list<RoutineInfo*> list;
	RoutineInfo *main = new RoutineInfo(0);
	list.push_back(main);
	return list;
}
std::list<RoutineInfo*> routines = InitRoutines();
```

Here's how a coroutine gets created. Notice that when the created thread exits, the stack may be damaged, so we need the `stackBackup` as a buffer to store and restore the stack.

``` cplusplus
void *stackBackup = NULL;
void *CoroutineStart(void *pRoutineInfo);

int CreateCoroutine(RoutineHandler handler,void* param ){
	RoutineInfo* info = new RoutineInfo(PTHREAD_STACK_MIN+ 0x4000);

	info->param = param;
	info->handler = handler;

	pthread_t thread;
	int ret = pthread_create( &thread, &(info->attr), CoroutineStart, info);

	void* status;
	pthread_join(thread,&status);

	memcpy(info->stackbase,stackBackup,info->stacksize); 	// restore the stack

	routines.push_back(info); 	// add the routine to the end of the list
	
	return 0;
}
```

Now comes to the CoroutineStart handler. When the created thread enters the `CoroutineStart` funciton, it use `setjmp` to store context, and then backup its own stack. and then exit execution.

``` cplusplus
void Switch();

void *CoroutineStart(void *pRoutineInfo){

	RoutineInfo& info = *(RoutineInfo*)pRoutineInfo;

	if( !setjmp(info.buf)){	
		// back up the stack, and then exit
		stackBackup = realloc(stackBackup,info.stacksize);
		memcpy(stackBackup,info.stackbase, info.stacksize);

		pthread_exit(NULL);

		return (void*)0;
	}

	info.ret = info.handler(info.param);
	
	info.stopped = true;
	Switch(); // never return
	
	return (void*)0; // suppress compiler warning
}
```



## Switching between Contexts ##

A routine calls the `Switch()` function to swtich to another routine by itself.

``` cplusplus
std::list<RoutineInfo*> stoppedRoutines = std::list<RoutineInfo*>();

void Switch(){
	RoutineInfo* current = routines.front();
	routines.pop_front();
	
	if(current->stopped){
		// The stack is stored in the RoutineInfo object, 
		// delete the object later, now know
		stoppedRoutines.push_back(current);
		longjmp( (*routines.begin())->buf ,1);
	}
	
	routines.push_back(current);		// adjust the routines to the end of list
	
	if( !setjmp(current->buf) ){
		longjmp( (*routines.begin())->buf ,1);
	}
	
	if(stoppedRoutines.size()){
		delete stoppedRoutines.front();
		stoppedRoutines.pop_front();
	}
}
```



## Demonstration ##

The user code is pretty simple, its almost like using a threading library. In coroutines, the routine calls the `Switch()` function to give CPU time to another routine by itself.

``` cplusplus
#include <iostream>
using namespace std;

#include <sys/wait.h>

void* foo(void*){
	for(int i=0; i<2; ++i){
		cout<<"foo: "<<i<<endl;
		sleep(1);
		Switch();
	}
}

int main(){
	CreateCoroutine(foo,NULL);
	for(int i=0; i<6; ++i){
		cout<<"main: "<<i<<endl;
		sleep(1);
		Switch();
	}
}
```

Remomber to link the program with `-lpthread` flag. Our program result is as follows:

    [roxma@VM_6_207_centos coroutine]$ g++ coroutime_demonstration.cpp -lpthread -o a.out
    [roxma@VM_6_207_centos coroutine]$ ls
    a.out  coroutime.cpp  coroutime_demonstration.cpp  README.md
    [roxma@VM_6_207_centos coroutine]$ ./a.out
    main: 0
    foo: 0
    main: 1
    foo: 1
    main: 2
    main: 3
    main: 4
    main: 5
