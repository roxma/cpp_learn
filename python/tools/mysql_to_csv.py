#!/usr/bin/python2
# -*- coding: utf-8 -*-

import sys

import MySQLdb

import csv

def ShowUsage():
	print "usage: python [this_scripy].py host=[host] port=port user=[user]  passwd=[passwd] db=[db_name] charset=charset execute=[statement] output=[file_name]"

if len(sys.argv) <= 1:
	ShowUsage()
	exit(-1)

# all supported arguments
args={}
args["host"] = "127.0.0.1"
args["port"] = "3306"
args["user"] = "root"
args["passwd"] = ""
args["db"] = "python_learn"
args["charset"] = "utf8"
args["execute"] = ""
args["output"] = "output.csv"

# parse arguments
for index,pairsStr in enumerate(sys.argv):
	if index==0:
		continue
	pairsArr = pairsStr.split("=",1)
	if (len(pairsArr) <=1 ):
		print "ERROR: Undefined argument: " + pairsArr[0]
		ShowUsage()
		exit(-1)
	key = pairsArr[0]
	value = pairsArr[1]
	if key not in args.keys():
		print "ERROR: Argument [",key,"] not supported"
		ShowUsage()
		exit(-1)
	args[key] = value


conn = MySQLdb.connect(host=args["host"],port=int(args["port"]),user=args["user"],passwd=args["passwd"],db=args["db"],charset=args["charset"])

cursor = conn.cursor(MySQLdb.cursors.DictCursor)

cursor.execute(args["execute"])

lines = cursor.fetchall()
header = []

file = open(args["output"],"wb")
writer = csv.writer(file)

for index,value in enumerate(cursor.description):
	header.append(value[0])
writer.writerow(header)

for rowIndex,line in enumerate(lines):
	row = []
	for colIndex,colName in enumerate(header):
		value = line[colName]
		if type(value) is type(u"unicode"):
			value = value.encode("utf8")
			print value
		row.append(value)
	writer.writerow(row)

