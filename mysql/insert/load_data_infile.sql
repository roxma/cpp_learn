
/* 
mysql> source load_data_infile.sql
*/


create table load_data_infile_test(str_val varchar(4096) not null default "" )engine=Innodb, charset=utf8;

load data LOCAL infile "duplicate_key.sql" into table load_data_infile_test FIELDS  TERMINATED  BY "_______" LINES TERMINATED BY "___EOF___";

select * from load_data_infile_test \G

drop table load_data_infile_test;

