use php_learn;

drop table if exists appointment_issue ;
create table appointment_issue(
	  issue_id		bigint				primary key auto_increment
	, s_creator		varchar(255)					not null
	, s_name		varchar(1024)					not null
	, s_desc		varchar(10000)		default ""	not null
	, d_create_time	datetime						not null
	, i_next_sub_id	bigint				default 1	not null
)engine = INNODB charset=utf8;

drop table if exists appointment_sub_issue;
create table appointment_sub_issue(
	  issue_id		bigint							not null
	, sub_issue_id	bigint							not null
	, s_name		varchar(1024)					not null
	, s_desc		varchar(10000)		default ""	not null
	, i_cur_request	bigint				default 0	not null
	, i_max_request	bigint							not null
	, s_field_list_json	varchar(10000)					not null
	, d_create_time	datetime						not null
	, primary key(issue_id,sub_issue_id)
);

drop table if exists appointment_request;
create table appointment_request(
	  issue_id		bigint							not null
	, sub_issue_id	bigint							not null
	, s_mail		varchar(255)					not null			
	, d_create_time	datetime						not null
	, s_fields_json	varchar(10000)					not null
	, i_mail_sended	int					default 0	not null
	, i_validated	int					default 0	not null
	, s_validate_key	varchar(64)					not null
	, primary key(issue_id,sub_issue_id,s_mail)
);

replace into common_singleton set s_name="appointment/send_validate_mail.php";
