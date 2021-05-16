create table customers (id integer, cust_name text, cust_age integer) partition by range(cust_age)

create table kids_customer partition of customers for values from (1) to (18)
create table adults_customer partition of customers for values from (19) to (40)

insert into customers values (1, 'Raj', 15),(2, 'Joy', 30)

select * from customers
1	"Raj"	15
2	"Joy"	30


insert into customers values (1, 'Neha',45)  --> No partition is defined for thsi AGE, hence error.
/*
ERROR:  no partition of relation "customers" found for row
DETAIL:  Partition key of the failing row contains (cust_age) = (45).
SQL state: 23514
*/

--We can create DEFAULT partition for this


create table old_customer partition of customers for values from (60) to (100)
create table other_customer partition of customers default;   ---> default aprtition for all other values

insert into customers values (1, 'Neha',45)

select * from customers
1	"Raj"	15
2	"Joy"	30
1	"Neha"	45


SELECT tableoid::regclass, * FROM customers
"kids_customer"		1	"Raj"	15
"adults_customer"	2	"Joy"	30
"other_customer"	1	"Neha"	45

--------------------------

/* LIST partitioning */

create table dept_info (dept_id integer,
					    dept_name varchar(10),
					    emp_name text,
					    salary integer) partition by list(dept_name)


create table dept_info_accnt partition of dept_info for values in ('Account')
create table dept_info_hr partition of dept_info for values in ('HR')
create table dept_info_sales partition of dept_info for values in ('Sales')
create table dept_info_other partition of dept_info default

select * from dept_info
select * from dept_info_accnt
SELECT tableoid::regclass, * FROM dept_info

insert into dept_info values (12, 'HR', 'Edward', 16000),(10, 'Account', 'Jay', 10000),(15, 'Sales', 'Smith',1000),(17, 'Delivery', 'Jessi', 8000)

