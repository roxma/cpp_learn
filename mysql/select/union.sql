
use test;
# Database changed

create temporary table union_test(val1 int)engine=Innodb, charset=utf8;
# Query OK, 0 rows affected (0.01 sec)

create temporary table union_test2(val1 int)engine=Innodb, charset=utf8;
# Query OK, 0 rows affected (0.00 sec)

insert into union_test set val1=1;
# Query OK, 1 row affected (0.00 sec)

insert into union_test2 set val1=1;
# Query OK, 1 row affected (0.01 sec)

insert into union_test2 set val1=2;
# Query OK, 1 row affected (0.01 sec)

select * from union_test union select * from union_test2;
# +------+
# | val1 |
# +------+
# |    1 |
# |    2 |
# +------+
# 2 rows in set (0.00 sec)

select * from union_test union all select * from union_test2;
# +------+
# | val1 |
# +------+
# |    1 |
# |    1 |
# |    2 |
# +------+
# 3 rows in set (0.00 sec)

