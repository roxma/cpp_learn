#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>

#include <cxxabi.h>

#include <string.h>
#include <algorithm>

int outputFd = 0;

/* Obtain a backtrace and print it to stdout. */
void print_trace (void)
{
  void *array[10];
  size_t size;
  char **strings;
  size_t i;
 
  size = backtrace (array, 10);
  strings = backtrace_symbols (array, size);


  // Find the first mangled function name
  char mangled[256] = {0};
  char* firstTrace = (char*)(strings[0]);
  const char* left = "(";
  const char* right = "+";
  char* begin = std::find_first_of(firstTrace,firstTrace+strlen(firstTrace),left,left+1) + 1;
  char* end = std::find_first_of(firstTrace,firstTrace+strlen(firstTrace),right,right+1) ;
  memcpy(mangled,begin,end-begin);

  printf("firstTrace: %s\nbegin: %s\nmangled: %s\n",firstTrace,begin,mangled);

  const char * mangled_name = NULL;
  size_t length = 1024;
  int status = 0;
 
  char* demangled = abi::__cxa_demangle(mangled,NULL,&length,&status);
  printf("mangled [%s]  length [%zu]  status [%i] demangled [%s]\n",mangled,length,status,demangled);
  
  free (demangled);

  free (strings);
}
     
/* A dummy function to make the backtrace more interesting. */
void dummy_function (void)
{
  print_trace ();
}
     
int main (int argc, char** argv)
{
  dummy_function ();
  return 0;
}
