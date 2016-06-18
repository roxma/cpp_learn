#!/usr/bin/env python2
# -*- coding: utf-8 -*-

def Entry():
	
	from urllib import urlencode, unquote
	import sys
	if len(sys.argv)>1:
		sys.stdout.write(unquote(sys.argv[1]))
	else:
		sys.stdout.write(unquote(sys.stdin.read()))

Entry()

