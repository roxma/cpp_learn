#!/bin/bash

name=roxma

msg="
hello, my name is $name
Nice to meet you.
"
echo "$msg"

msg='
Hello, my name is $name
Nice to meet you.
'
echo "$msg"

msg='
Hello, my name is '"$name"'
Nice to meet you.
'
echo "$msg"

msg='
Hello, my name is '"'$name'"'
Nice to meet you.
'
echo "$msg"
