
create table duplicate_test(id bigint primary key, cnt bigint not null)engine=Innodb, charset=utf8;

insert into duplicate_test(id, cnt) values(1,1), (2,2), (3, 3);

select * from duplicate_test;

insert into duplicate_test(id, cnt) values(1,5) on duplicate key update cnt=cnt+values(cnt);

insert into duplicate_test(id, cnt) values(2,6),(3,7) on duplicate key update cnt=cnt+values(cnt);

select * from duplicate_test;

drop table duplicate_test;

