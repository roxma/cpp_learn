
mkdir bin

for i in 1 2 3 ; do 

	echo "##############################################"
	echo "### add_${i}"

	gcc -c -fPIC add_${i}.c -o bin/add_${i}.o

	echo + gcc -shared -o bin/libadd_${i}.so bin/add_${i}.o
	gcc -shared -o bin/libadd_${i}.so bin/add_${i}.o

	echo + nm -g bin/libadd_${i}.so
	nm -g bin/libadd_${i}.so
	echo + ldd -r bin/libadd_${i}.so
	ldd -r bin/libadd_${i}.so

	echo + gcc -Wl,--no-undefined -shared -o bin/libadd_checked_${i}.so bin/add_${i}.o
	gcc -Wl,--no-undefined -shared -o bin/libadd_checked_${i}.so bin/add_${i}.o

	echo + nm -g bin/libadd_checked_${i}.so
	nm -g bin/libadd_checked_${i}.so
	echo + ldd -r bin/libadd_checked_${i}.so
	ldd -r bin/libadd_checked_${i}.so

	# ar  rcs libadd_${i}.a      add_${i}.o
	# echo "# nm libadd_${i}.a"
	# nm libadd_${i}.a

	sleep 5
	echo
	echo

done

echo "##############################################"
echo "### add_4"

gcc -c -fPIC add_4.c -o bin/add_4.o
gcc -fPIC -c some_external_function.c -o bin/some_external_function.o 
gcc -shared -o bin/libsome_external_function.so bin/some_external_function.o

echo + gcc -Wl,--no-undefined -shared -o bin/libadd_4.so bin/add_4.o -Lbin -lsome_external_function
gcc -Wl,--no-undefined -shared -o bin/libadd_4.so bin/add_4.o -Lbin -lsome_external_function

echo + LD_LIBRARY_PATH=
LD_LIBRARY_PATH=
export LD_LIBRARY_PATH
echo + ldd -r bin/libadd_4.so
ldd -r bin/libadd_4.so

echo + LD_LIBRARY_PATH=$(readlink -f bin/)
LD_LIBRARY_PATH=$(readlink -f bin/)
export LD_LIBRARY_PATH
echo + ldd -r bin/libadd_4.so
ldd -r bin/libadd_4.so


