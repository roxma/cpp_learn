#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>

#include <cxxabi.h>

#include <string.h>
#include <algorithm>

#include <string>

int BackTraceCaller(const size_t level,std::string& caller)
{
  size_t frames = level + 2; // frames need to trace

  void *preArray[32];
  void **array =  preArray;
  if ( frames > sizeof(preArray)/sizeof(preArray[0]) ){
    array = (void **)malloc(sizeof(void*)*frames);
  }
  if ( array == NULL ) {
    return __LINE__;
  }
  struct ArrayCleanup{
    void ** &m_array;
    void ** m_compare;
    ArrayCleanup(void **& array, void** compare):m_array(array),m_compare(compare){}
    ~ArrayCleanup(){
      if(m_array != m_compare){
        free(m_array);
        m_array = NULL;
      }
    }
  }arrayCleanup(array,preArray);
 
  size_t tracedFrames = backtrace (array, frames);
  if(tracedFrames != frames){
    return __LINE__;
  }


  // Get the symbol from the desired stack frame
  char * symbol;
  char **strings = backtrace_symbols (&(array[tracedFrames-1]), 1);
  if(strings == NULL){
    return __LINE__;
  }
  struct AutoFree{
    void * m_ptr;
    AutoFree(void * ptr):m_ptr(ptr){}
    ~AutoFree() { free(m_ptr); }
  }stringsAutoFree(strings);
  symbol = strings[0];

  const char* const left = "(";
  const char* const right = "+";
  char* begin = std::find_first_of(symbol,symbol+strlen(symbol),left,left+1) + 1;
  char* end = std::find_first_of(symbol,symbol+strlen(symbol),right,right+1);
  if( (begin>=symbol+strlen(symbol)) || (end>=symbol+strlen(symbol)) || (begin>=end) ) {
    return __LINE__;
  }

  *end = '\0';
  char * mangled = begin;

  int status;
  char* demangled = abi::__cxa_demangle(mangled,NULL,NULL,&status);
  AutoFree freeDemangled(demangled);

  if( (status!=0) && (status!=-2) ){
    return __LINE__;
  }
  
  if(status==-2){
    caller = mangled;
  }else{
    caller = demangled;
  }
  
  return 0;
}
     
#include <iostream>

/* A dummy function to make the backtrace more interesting. */
void dummy_function (void)
{
  std::string name;
  BackTraceCaller(0,name);
  std::cout<<name<<std::endl;
}
     
int main (int argc, char** argv)
{
  dummy_function ();
  return 0;
}
