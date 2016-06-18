#!/bin/bash

SubFoo(){
	print "pwd: "
	pwd
	echo "\$0: $0"
	echo "\$_: $_"
	echo "\$BASH_SOURCE: $BASH_SOURCE"
}
