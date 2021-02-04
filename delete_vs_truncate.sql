/*
DELETE --> You can use WHERE clause and delete perticular row. It is slower operation. It does not re-set sequences on column (example is given below at last)

TRUNCATE --> Can't use WHERE clause and it deletes all data from table. It is faster oepration. We can re-set sequences on column from start (RESTART IDENTITY option)

In postgresql, DELETE and TRUNCATE both can be rolled back.
In oracle, DELETE can be rolled back, but TRUNCAT Ecan not be rolled back.
*/

--Example---


select * from t1
2
3
4
4
4
12
14
44

delete from t1 where emp_no in (12,14,44)
/*
DELETE 3

Query returned successfully in 104 msec. */

rollback;
/*
WARNING:  there is no transaction in progress
ROLLBACK

Query returned successfully in 83 msec.
*/

/* So , no transaction is in progress and also AUTO-COMMIT option is ON. Again insert few rows in table */

begin;  -- this will start a transaction

delete from t1 where emp_no in (12,14,44);
select * from t1;
/*
2
3
4
4
4
*/

rollback;
/*
ROLLBACK

Query returned successfully in 120 msec.
*/

select * from t1 --- So ROWS deleted came back in table due to ROLLBACK 
/*
2
3
4
4
4
12
14
44
*/
end;  -- transaction will END when you will use COMMIT or ROLLBACK...no need to mention END in pgadmin. This END is ised for notepad.

---------------------------------------------


begin;
select * from t1;
/*
2
3
4
4
4
12
14
44
*/

truncate t1;
/*
TRUNCATE TABLE

Query returned successfully in 205 msec.
*/
select * from t1;
--No rows selected---

rollback;

select * from t1;  ----- In POSTGRESQL, truncate can be rolled back. But in ORACLE, it can't be rolled back.
/*
2
3
4
4
4
12
14
44
*/
end;

--========================================================================--

select * from t1
1	"Sushant"
2	"Raj"
3	"Jay"
4	"Smith"

delete from t1 where name='Smith'
select * from t1
1	"Sushant"
2	"Raj"
3	"Jay"

insert into t1 (name) values ('Snith')

select * from t1
1	"Sushant"
2	"Raj"
3	"Jay"
5	"Snith"  ----> if you observe, ID allocated is next value '5' and not 4


delete from t1
select * from t1 --- no rows selected.

insert into t1 (name) values ('Sushant'),('Raj'),('Jay'),('Smith')
--INSERT 0 4

select * from t1
6	"Sushant"
7	"Raj"
8	"Jay"
9	"Smith"   --- If you can observer, ID is auto-incremented.

--SO DELETE statement keeps sequenses or serials AUTO-INCREMENTED---


--=================================----

select * from t1
6	"Sushant"
7	"Raj"
8	"Jay"
9	"Smith" 


truncate table t1
--TRUNCATE TABLE

select * from t1 --- no rows selected.

insert into t1 (name) values ('Sushant'),('Raj'),('Jay'),('Smith')
--INSERT 0 4

10  "sushant"
11	"Raj"
12	"Jay"
13	"Smith"

-- Well, even only TRUNCATE statement does not restart sequence


truncate t1 restart identity; ---- this will set auto-increment values from start
--TRUNCATE TABLE

insert into t1 (name) values ('Sushant'),('Raj'),('Jay'),('Smith')
--INSERT 0 4

select * from t1
1	"Sushant"
2	"Raj"
3	"Jay"
4	"Smith"

/*

RESTART IDENTITY
Automatically restart sequences owned by columns of the truncated table(s).

CONTINUE IDENTITY
Do not change the values of sequences. This is the default in postgresql
   
*/