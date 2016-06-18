
##
# Read ssh password from std input
function scpex(){

		read -p "password: " password

        local expectCmd='

		# read password
		# send_user "password:\ "
		# expect_user -re "(.*)\n"
		# set password  "$expect_out(0,string)"

		set password "'"$password"'"
		set password_sent 0

        set timeout 30
        spawn scp '"$@"'

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

		expect eof

        '

        expect  -c "$expectCmd"  -f /dev/null
}

