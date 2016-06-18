// Note: please compile and link the program with -rdynamic options

#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>


#include <exception>

static std::terminate_handler prev_handler;

/* Obtain a backtrace and print it to stdout. */
void print_trace (void)
{
  void *array[10];
  size_t size;
  char **strings;
  size_t i;
 
  size = backtrace (array, 10);
  strings = backtrace_symbols (array, size);

  printf ("Obtained %zd stack frames.\n", size);
   
  for (i = 0; i < size; i++)
     printf ("%s\n", strings[i]);

  free (strings);

  prev_handler();
  abort();
}
     
/* A dummy function to make the backtrace more interesting. */
void dummy_function (void)
{
  throw 0;
}
  
   
int main (int argc, char** argv)
{
  prev_handler = std::set_terminate(print_trace);
  dummy_function();
  return 0;
}
