#!/bin/bash

pipe=/tmp/testpipe

trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

while true
do
	cat $pipe
#     if read line <$pipe; then
#         if [[ "$line" == 'quit' ]]; then
#             break
#         fi
#         echo $line
#     fi
done

echo "Reader exiting"
