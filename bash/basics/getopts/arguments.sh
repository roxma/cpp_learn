#!/bin/bash

# for example: 
# ./flags.sh -a valuea -b valueb
# ./flags.sh -b valueb
 
while getopts ":a:b:" opt; do
	case $opt in
	a)
		echo "option a is triggered, argument: $OPTARG"
		;;
	b)
		echo "option b is triggered, argument: $OPTARG"
		;;
	\?)
		echo "Invalid flag: -$OPTARG" >&2
		;;
	esac
done


