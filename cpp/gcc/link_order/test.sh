
g++ -c Foo.cpp -o Foo.o
ar rvs libfoo.a Foo.o

set -x

g++ main.cpp libfoo.a # success
g++ libfoo.a main.cpp # error

g++ main.cpp Foo.cpp	# success
g++ Foo.cpp main.cpp	# success

rm -f Foo.o libfoo.a a.out

