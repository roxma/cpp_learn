#!/bin/bash

echo "test 1:"
awk '{ print $1,$2,$3 }' data

echo ; echo "test 2:"
awk '{ print "$1,$2,$3" }' data

echo ; echo "test 3:"
awk '{ print ""$1","$2","$3"" }' data

echo ; echo "test 4: printf"
awk '{ printf "%-8s%-4s%3s\n", $1,$2,$3 }' data

