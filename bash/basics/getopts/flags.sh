#!/bin/bash

# for example: ./flags.sh -abc

 
while getopts ":ab" opt; do
	case $opt in
	a)
		echo "flag a is triggered"
		;;
	b)
		echo "flag b is triggered"
		;;
	\?)
		echo "Invalid flag: -$OPTARG" >&2
		;;
	esac
done


