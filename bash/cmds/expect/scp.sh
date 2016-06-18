#!/bin/bash

function Entry()
{

	# password
	local password=""
	if [[ "$1" == "-p"  ]]
	then
		password="$2"
		shift
		shift
	else
		password="$1"
		password="${password/-p/}"
		shift
	fi

	# timeout
	local timeout=500
	if [[ "$1" == "-t"  ]]
	then
		timeout="$2"
		shift
		shift
	else
		timeout="$1"
		timeout="${timeout/-t/}"
		shift
	fi

	local expParams='set password [lindex $argv 0]
	'
	local expSpawn="set timeout $timeout
	spawn scp "

	local index=0
	while [[ $index -lt "$#" ]]
	do
		expParams="$expParams
			set arg$(($index+2)) [lindex \$argv $(($index+1))]
		"
		expSpawn=$expSpawn' "$arg'$(($index+2))'"'

		index=$(($index+1))

		# argList+=("${!index}")

	done

	local expBody='

	expect {
		"*yes/no" {
			send "yes\r"
			expect "*password" {
					send "$password\r"
					set password_sent 1
			}
		}
		"*assword" {
			send  "$password\r"
			set password_sent 1
		}
	}

	expect {
		eof              {}
		timeout          { 
			exit 5
		}
	}
	catch wait result
	exit [lindex $result 3]
	'

	local expScript="
		$expParams
		$expSpawn
		$expBody
	"

	local expFile="$(mktemp)"
	local ret=$?
	if [[ "$ret" != "0" ]]
	then
		return $ret
	fi

	echo "#!/usr/bin/expect
	$expScript" >$expFile

	chmod +x $expFile

	echo $expFile "$password" "$@"
	$expFile "$password" "$@"
	local ret=$?

	rm $expFile

	return $ret

}


Entry "$@"
exit $?

