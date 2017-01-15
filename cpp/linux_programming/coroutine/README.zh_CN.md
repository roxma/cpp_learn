# 一种协程的 C/C++ 实现 #



## 介绍 ##

在前几天接触到了协程的概念，觉得很有趣。因为我可以使用一个线程来实现一个类似多线程的程序，如果使用协程来替代线程，就可以省去很多原子操作和内存栅栏的麻烦，大大减少与线程同步相关的系统调用。因为我只有一个线程，而且协程之间的切换是可以由函数自己决定的。

我有见过几种协程的实现，因为没有 C/C++ 的原生支持，所以多数的库使用了汇编代码，还[有些](http://www.chiark.greenend.org.uk/~sgtatham/coroutines.html)库利用了 C 语言的 `setjmp` 和 `longjmp` 但是要求函数里面使用 static local  的变量来保存协程内部的数据。我讨厌写汇编和使用 static local 变量，所以想出了一种稍微优雅一点又有点奇技淫巧的实现方法。 这篇文章将向你展示这种方法基本原理和实现。



## 基本原理 ##

用 C/C++ 实现的最大困难就是创建，保存和恢复程序的上下文。因为这涉及到了程序栈的管理，以及 CPU 寄存器的访问，但是这两项内容在 C/C++ 标准里面都没有严格的定义，所以我们是不可能有一个完全跨平台的 C/C++ 实现的。但是利用操作系统提供的 API，我们仍然可以避免使用汇编代码，接下来会向你展示使用 POSIX 的 pthread 实现的一种简单的协程框架。什么！？？Pthread？那你的程序岂不是多线程了？那还叫协程吗！没错，确实是多线程的，不过仅仅是在协程被创建之前的短暂瞬间。

要创建子程序的上下文，我们可以调用 `pthread_create` 函数来创建一个真正的线程，这样操作系统就会帮我们创建上下文（这里包括初始化 CPU 寄存器和程序栈）。然后在线程启动时，使用 C 语言的 `setjmp` 把这些寄存器备份到外部的 buffer 里面。创建完后，这个线程便失去了它的存在价值，所以可以果断干掉它了。不过还需要注意一点，就是在创建线程之前，需要调用 `pthread_attr_setstack` 函数来显式地声明使用的程序栈，这样线程退出的时候，系统就不会自动销毁这个程序栈。至于上下文的恢复，显然就是使用 `longjmp`  函数了。



## 创建上下文 ##

下面是 RoutineInfo 的定义。为了简单起见，所有错误处理代码都被省略了，原版本的代码在 `coroutine.cpp` 文件中，省略版的代码在 `coroutine_demonstration.cpp` 文件中。

```cplusplus
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

然后，我们需要一下全局的列表来保存这些 RoutineInfo 对象。

```cplusplus
std::list<RoutineInfo*> InitRoutines(){
	std::list<RoutineInfo*> list;
	RoutineInfo *main = new RoutineInfo(0);
	list.push_back(main);
	return list;
}
std::list<RoutineInfo*> routines = InitRoutines();
```

接下来是协程的创建，注意当协程的时候，程序栈有可能已经被损坏了，所以需要一个 `stackBack` 作为程序栈的备份，用来做后面的恢复。

```cplusplus
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

然后是 CoroutinneStart 函数。当线程进入这个函数的时候，使用 `setjmp` 保存上下文，然后备份它自己的程序栈，然后直接退出线程。

```cplusplus
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



## 上下文切换 ##

一个协程主动调用 `Switch()` 函数，才切换到另一个协程。

```cplusplus
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



## 演示 ##

用户的代码很简单，就像使用一个线程库一样，一个协程主动调用 `Switch()` 函数主动让出 CPU 时间给另一个协程。

```cplusplus
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

记得在链接的时候加上 `-lpthread` 链接选项。程序的执行结果如下所示：

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

