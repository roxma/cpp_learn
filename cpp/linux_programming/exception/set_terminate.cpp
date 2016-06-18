#include <iostream>
#include <exception>
#include <cstdlib>

std::terminate_handler prev_handler;

void myterminate () {
  std::cerr << "terminate handler called\n";
  prev_handler();
  std::cerr << "calling abort.\n";
  abort();
}

int main (void) {
  prev_handler = std::set_terminate (myterminate);
  throw 0;  // unhandled exception: calls terminate handler
  return 0;
}
