use php_learn;

drop table if exists series_update_reminder_config ;
create table series_update_reminder_config(
	  s_name		varchar(255)	primary key		not null
	, s_value		varchar(255)	default ""		not null
	, last_modify	timestamp
)engine = INNODB charset=utf8;

drop table if exists series_update_reminder_rules ;
create table series_update_reminder_rules(
	  id			bigint			primary key auto_increment
	, s_url			varchar(255)					not null
	, s_pattern		varchar(1024)					not null
	, s_pattern_type	varchar(16)	default ""	not null
	, s_last_result text							not null
	, d_last_update	datetime						not null
	, last_modify	timestamp
	, s_creator		varchar(255)					not null
)engine = INNODB charset=utf8;

# If d_last_mail is earlier than the corresponding series_update_reminder_rules.d_last_update
# Then a mail should be sent to the user, imforming the update
create table series_update_reminder_subscribers(
	  i_rule_id		bigint					not null
	, s_subscriber	varchar(255)			not null
	, d_last_mail	datetime				not null
	, primary key(i_rule_id, s_subscriber)
)engine = INNODB charset=utf8;

