#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# This program send a udp packet and then exit

def Entry():

	import sys
	if len(sys.argv)==1:
		sys.stderr.write('''
options:
  -h Host
  -p Port
  -d Data to be sent. If this option is not present, data will be read from stdin. If you want to send binary data, You could use the printf command, for example:
		printf "\x01" | udpsend -h localhost -p 12345
  -f File to be sent.
  -r Wait until a response package is read, the readed content will be outupt to stdout. Note that the debug information of this tool is output to stderr.
''')
		exit(0)

	# get opts and args
	import getopt, sys 
	if sys.platform == 'win32':  # write binary data to stdout
		import os, msvcrt
		msvcrt.setmode(sys.stdout.fileno(), os.O_BINARY)

	try:
		opts, args = getopt.getopt(sys.argv[1:], ':h:p:d:f:r')
	except getopt.GetoptError, err:
		# print help information and exit:
		sys.stderr.write(repr(err)+'\n') # will print something like 'option -a not recognized'
		exit(2)

	content = ''
	host = ''
	port = 0
	dataOptionSet = False
	waitResponse = False
	
	for o, a in opts:
		if o == '-h':
			host = a
		elif o == '-p':
			port = int(a)
		elif o == '-d':
			dataOptionSet = True
			content = a
		elif o == '-f':
			dataOptionSet = True
			fileName = a
			f = open(fileName, 'rb')
			content = f.read()
			f.close()
		elif o == '-r':
			waitResponse = True

	if not dataOptionSet:
		content = sys.stdin.read()
	
	sys.stderr.write('options: %s\n' % opts)

	# check host port
	if host=='':
		raise Exception('host should be specified')
	if port == 0:
		raise Exception('port should be specified')

	address = (host,port)

	import time
	beginMilliseconds = int(round(time.time() * 1000))

	import socket
	tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	tcp.connect(address)
	totalSent = 0
	while totalSent < len(content):
		sendRet = tcp.send(content[totalSent:])
		if sendRet == 0:
			raise RuntimeError("send data error")
		totalSent += sendRet

	sys.stderr.write("send complete, %s bytes.\n" % len(content))

	if waitResponse:
		sys.stderr.write("receivint......\n")
		receiveData = []
		chunk = 'dummy'
		while chunk != '':
			chunk = tcp.recv(2048)
			receiveData.append(chunk)
                        sys.stdout.write(chunk)
                        sys.stdout.flush()
		sys.stderr.write( "\n%d bytes recieved.\n" % len(receiveData))
		import pprint
		sys.stderr.write( pprint.pformat(receiveData) + '\n')

	tcp.close()

	import time
	endMilliseconds = int(round(time.time() * 1000))
	sys.stderr.write('\n%s ms.\n' % (endMilliseconds-beginMilliseconds))

	exit(0)

Entry()

