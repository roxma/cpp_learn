
create table found_rows_test(value int);

insert into found_rows_test(value) values(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

# example
select SQL_CALC_FOUND_ROWS * from found_rows_test limit 0,5;
select found_rows();


select * from found_rows_test limit 0,5; # error
select found_rows();

drop table found_rows_test;
