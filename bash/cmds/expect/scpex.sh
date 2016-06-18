#!/bin/bash

# set password 

function scpex(){ 
	
	read -p "password: " password

	local expectCmd='

	set timeout 10

	spawn scp '"$@"'
	expect {
		"*yes/no" { send "yes\r" }
		"*password" {
			send "'"$password"'\r"
			exp_continue
		}
	}
	'
	
	expect -c "$expectCmd"
	
}
