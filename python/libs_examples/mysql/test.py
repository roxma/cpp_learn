#!/usr/bin/python2
# -*- coding: utf-8 -*-

import MySQLdb 

db = MySQLdb.connect(host="127.0.0.1",db="python_learn",user="root",passwd="",charset="utf8")

# cur = db.cursor() 
cur = db.cursor(MySQLdb.cursors.DictCursor)

cur.execute("drop table if exists mysql_test")
cur.execute("create table mysql_test(id int, value varchar(1024))ENGINE=innodb DEFAULT CHARSET=utf8")
ret = cur.execute("insert into mysql_test(id,value) values(1,'1234'),(2,'234')")
print "insert ret=",ret

cur.execute("select * from mysql_test")
print cur.fetchall()

db.commit()

db.close()
