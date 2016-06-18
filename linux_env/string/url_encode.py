#!/usr/bin/env python2
# -*- coding: utf-8 -*-

def Entry():
	
	from urllib import quote
	import sys
	if len(sys.argv)>1:
		sys.stdout.write(quote(sys.argv[1]))
	else:
		sys.stdout.write(quote(sys.stdin.read()))

Entry()
