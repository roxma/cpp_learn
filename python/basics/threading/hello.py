#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import Queue
import threading


def TestThread(q, msg):
	q.put(msg)

def Entry():

	count = 5

	q = Queue.Queue()

	for i in range(count):
		t = threading.Thread(target=TestThread, args=(q,"hello %d" % i))
		# t.deamon = True
		t.start()

	for i in range(count):
		s = q.get()
		print "%d:%s" % (i,s)
	s = q.get()


Entry()

