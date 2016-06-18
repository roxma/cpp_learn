#!/bin/bash

str="a;b;c"

# printf "%s\n" "$str"  | awk -F";" '{
# 	for(i=0; i<NF; ++i){
# 		print $i
# 	}
# }'

# readarray -d ";" arr <<< "$str"

# printf "%s" "$str" | while read -d ";" element ; do
# 	echo $element
# done


IFS=";" read -a arr <<< "$str"
echo $IFS # test

for i in ${arr[@]}; do echo $i; done

