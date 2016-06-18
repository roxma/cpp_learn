#!/bin/sh

# build directory
mkdir dir
touch dir/file
mkdir dir/subdir
touch dir/subdir/foo

# chmod recursively
chmod -R 777 ./dir

# show result
ll $(find dir -type d)

# clean
echo begin clean ...
rm -r dir

