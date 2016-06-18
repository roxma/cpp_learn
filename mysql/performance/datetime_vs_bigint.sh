#!/bin/bash


echo '

drop table if exists test_datetime;
drop table if exists test_bigint;

create table test_datetime(
	  report_time		datetime	
	, sum1				bigint
	, sum2				bigint
	, index(report_time)
)engine=Innodb, charset=utf8;

create table test_int(
	  report_time		bigint	
	, sum1				bigint
	, sum2				bigint
	, index(report_time)
)engine=Innodb, charset=utf8;

create table test_bigint(
	  report_time		bigint	
	, sum1				bigint
	, sum2				bigint
	, index(report_time)
)engine=Innodb, charset=utf8;
'

rows=500000

for((i=0; i<$rows; ++i))
do
	timestamp=$( date +'%s')
	random=$RANDOM
	echo "insert into test_bigint set report_time = ($timestamp - $timestamp%300 - ($random*19 - $random*19%300)%(60*60*24*3)) , sum1=$RANDOM , sum2= $RANDOM ;"
done

echo "insert into test_datetime select from_unixtime(report_time), sum1, sum2 from test_bigint ;";
echo "insert into test_int select (report_time), sum1, sum2 from test_bigint ;";

# select 
#     from_unixtime(report_time) as report_time 
#     , sum(sum1)
#     , sum(sum2) 
# from test_bigint where 
#     report_time>unix_timestamp("2014-11-13 09:00:00") 
#     and report_time< unix_timestamp("2014-11-13 12:00:00") 
# group by report_time order by report_time ;
# 
# select 
#     from_unixtime(report_time) as report_time 
#     , sum(sum1)
#     , sum(sum2) 
# from test_int where 
#     report_time>unix_timestamp("2014-11-13 09:00:00") 
#     and report_time< unix_timestamp("2014-11-13 12:00:00") 
# group by report_time order by report_time ;
# select 
#     report_time 
#     , sum(sum1)
#     , sum(sum2) 
# from test_datetime where 
#     report_time>"2014-11-13 09:00:00"
#     and report_time< "2014-11-13 12:00:00"
# group by report_time order by report_time;

