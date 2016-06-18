#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys
import socket


TCP_IP = '127.0.0.1'
TCP_PORT = 5005
BUFFER_SIZE = 200000  # Normally 1024, but we want fast response

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((TCP_IP, TCP_PORT))
s.listen(1)

conn, addr = s.accept()
# sys.stderr.write('Connection address: %s\n' % (addr) )

while 1:
	data = conn.recv(BUFFER_SIZE)
	if not data: break
	sys.stdout.write(data)
	sys.stderr.write("received %s bytes\n" % (len(data)) )

	break

conn.send('ok')
sys.stderr.write("response sent")

conn.close()

