#!/bin/bash

echo "Hello world" | cut -d" "  -f 2
echo "Hello  world" | cut -d" "  -f 2

echo "Hello world" | awk -v N=2 '{print $N}'
echo "Hello  world" | awk -v N=2 '{print $N}'

