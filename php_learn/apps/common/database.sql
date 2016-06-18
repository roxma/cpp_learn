
CREATE DATABASE php_learn DEFAULT CHARACTER SET utf8;

use php_learn;

drop table if exists common_config ;
create table common_config(
	  s_name		varchar(255)	primary key		not null
	, s_value		varchar(255)	default ""		not null
	, last_modify	timestamp
)engine = INNODB charset=utf8;

drop table if exists common_singleton ;
create table common_singleton(
	  s_name		varchar(255)	primary key		not null
	, s_comment		varchar(1024)					default "" not null
)engine = INNODB charset=utf8;
