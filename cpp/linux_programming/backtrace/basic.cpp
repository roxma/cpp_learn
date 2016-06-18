// Note: please compile and link the program with -rdynamic options

#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

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

  printf ("Obtained %zd stack frames.\n", size);
   
  for (i = 0; i < size; i++)
     printf ("%s\n", strings[i]);

  // The backtrace_symbols_fd writes the strings, one per line, 
  // to the file descriptor fd.
  // It does not use malloc, and so can be employed in situations
  // where the latter function might fail
  if(outputFd)
    backtrace_symbols_fd(array,size,outputFd);

  free (strings);
}
     
/* A dummy function to make the backtrace more interesting. */
void dummy_function (void)
{
  print_trace ();
}
     
int main (int argc, char** argv)
{
  if(argc>1){
	outputFd = open(argv[1], O_CREAT | O_WRONLY);
  }

  dummy_function ();
  return 0;
}
