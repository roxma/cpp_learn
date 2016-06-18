
function ShowParameters()
{
	echo "parameter count:$#"
	local index=1
	while [[ "$#" != 0 ]]
	do
		echo "parameter $index: [$1]"
		index=$(($index+1))
		shift
	done
}

echo "1"
ShowParameters one two       three

echo "2"
ShowParameters "one two       three"

echo "3"
ShowParameters *

echo "4"
ShowParameters "*"

echo "5"
ShowParameters $(echo "one space[              ]")

echo "6"
ShowParameters "$(echo "one space[              ]")"


echo "7"
param=$(echo $'more spaces\n\\n[              ]')
ShowParameters "$param"
ShowParameters $param


echo "8"
param=`echo $'more spaces\n\\n${tmp}[              ]'`
ShowParameters "$param"
ShowParameters $param

