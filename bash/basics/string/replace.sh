#!/bin/sh

echo "1. Postfix remved:"
message="Hello world"
echo "${message/%world/}"

echo "2. Prefix remved:"
message="Hello world"
echo "${message/#Hello/}"

echo "3. replace:"
message="Hello, my name is my_name, nice to meet you"
echo "${message/my_name/roxma}"

