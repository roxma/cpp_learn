#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# This program send a udp packet and then exit

def Entry():
	content = "hello"
	host = "localhost"
	port = 12345
	UdpSendPacket(content, host, port)

def UdpSendPacket(content, host, port):
	import socket
	udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	address = (host,port)
	udp.sendto(content, address)
	udp.close()


Entry()


