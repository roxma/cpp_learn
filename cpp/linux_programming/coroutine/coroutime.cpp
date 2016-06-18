#include <limits.h>
#include <string.h>
#include <list>
#include <pthread.h>
#include <setjmp.h>
#include <malloc.h>

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
		stacksize = 0;
		if(stackbase!=NULL)
			stacksize = size;

		pthread_attr_init(&attr);
		if(stacksize){
			if( 0 != pthread_attr_setstack(&attr,stackbase,stacksize) ){
				free(stackbase);
				stackbase = NULL;
				stacksize = 0;
			}
		}
	}
	
	~RoutineInfo(){
		pthread_attr_destroy(&attr);
		free(stackbase);
		stackbase = NULL;
		stacksize = 0;
	}
};

std::list<RoutineInfo*> InitRoutines(){
	std::list<RoutineInfo*> list;
	RoutineInfo *main = new RoutineInfo(0);
	list.push_back(main);
	return list;
}
std::list<RoutineInfo*> routines = InitRoutines();


void *stackBackup = NULL;
void *CoroutineStart(void *pRoutineInfo);

int CreateCoroutine(RoutineHandler handler,void* param ){
	RoutineInfo* info = new RoutineInfo(PTHREAD_STACK_MIN+ 0x4000);
	if(info->stackbase==NULL){
		delete info;
		return __LINE__;
	}

	info->param = param;
	info->handler = handler;

	pthread_t thread;
	int ret = pthread_create( &thread, &(info->attr), CoroutineStart, info);
	if(ret){
		delete info;
		return __LINE__;
	}

	void* status;
	pthread_join(thread,&status);

	if(stackBackup == NULL){ // if we failed to backup the stack
		delete info;
		return __LINE__;
	}

	memcpy(info->stackbase,stackBackup,info->stacksize); 	// restore the stack

	routines.push_back(info); 	// add the routine to the end of the list
	
	return 0;
}

void Switch();

void *CoroutineStart(void *pRoutineInfo){

	RoutineInfo& info = *(RoutineInfo*)pRoutineInfo;

	if( !setjmp(info.buf)){	
		// back up the stack, and then exit
		stackBackup = realloc(stackBackup,info.stacksize);
		if(stackBackup)
			memcpy(stackBackup,info.stackbase, info.stacksize);

		pthread_exit(NULL);

		return (void*)0;
	}

	info.ret = info.handler(info.param);
	
	info.stopped = true;
	Switch(); // never return
	
	return (void*)0; // suppress compiler warning
}

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
	
	if(routines.size()==1) return;	// no other thread
	
	if( !setjmp(current->buf) ){
		longjmp( (*routines.begin())->buf ,1);
	}
	
	if(stoppedRoutines.size()){
		delete stoppedRoutines.front();
		stoppedRoutines.pop_front();
	}
}

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
