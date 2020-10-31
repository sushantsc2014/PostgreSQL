 /* Inheritance in PostgreSQL */

alter schema schema_2 rename to inheritance_schema

set search_path to inheritance_schema

/* Cities are also capitals. We will define table 'city'. And we will inherit columns of 'citi' in table 'capitals'.*/

CREATE TABLE cities
(
 name text,
 population integer
)


CREATE TABLE capitals
(
-- Inherited from table cities: name 
-- Inherited from table cities: population
state varchar(10)
) INHERITS (cities)

alter table capitals alter column state type varchar(30)

/*INSERT values into above table*/

insert into cities values ('Sangli',500000)
insert into cities values ('Kolhapur',1500000)
insert into cities values ('Pune',3120000)
insert into cities values ('Panchkula',200000)
insert into cities values ('Bhatinda',1390000)

insert into capitals values ('Mumbai',12500000,'Maharashtra')
insert into capitals values ('Chandigarh',1060000,'Haryana & Panjab') /**/


/*Now query select from CITIES table and see result. So if you observe, though Mumbai and Chandigarh cities are capitals and we added into table CAPITALS, still they show is result when we select from CITIES*/

select * from cities

"Sangli"		500000
"Kolhapur"		1500000
"Pune"			3120000
"Panchkula"		200000
"Bhatinda"		1390000
"Mumbai"		12500000
"Chandigarh"	1060000

/*We need to use ONLY clause if we need result only from CITIES table. This will exclude entries from CAPITALS table*/

select * from ONLY cities

"Sangli"	500000
"Kolhapur"	1500000
"Pune"		3120000
"Panchkula"	200000
"Bhatinda"	1390000

/*Now query CAPITALS table*/

select * from capitals

"Mumbai"		12500000	"Maharashtra"
"Chandigarh"	1060000		"Haryana & Panjab"

================================================================================================
/*Added one more city in CITIES table, and later, it became CAPITAL CITY as well.*/

insert into cities values ('Amaravati',150000)

/*Checked possibility of converting this row to CAPITALS table, could not find method. So we need to insert same row again with state into CAPITALS and then we delete from CITIES*/

insert into capitals values ('Amaravati',150000,'Andhra Pradesh')

/*Now AMARAVATI will appear two times if we query CITIES table*/

select * from cities

"Sangli"		500000
"Kolhapur"		1500000
"Pune"			3120000
"Panchkula"		200000
"Bhatinda"		1390000
"Amaravati"		150000  ---- one entry from CITIES table present already
"Mumbai"		12500000
"Chandigarh"	1060000	
"Amaravati"		150000	---- one entry from CAPITAL table

select * from only cities /*For ONLY clause it will appear once*/

"Sangli"	500000
"Kolhapur"	1500000
"Pune"		3120000
"Panchkula"	200000
"Bhatinda"	1390000
"Amaravati"	150000 --- this entry is from CITIES table only.

delete from only cities where name='Amaravati' --- this will delete entry from CITIES table only.

select * from cities

"Sangli"		500000
"Kolhapur"		1500000
"Pune"			3120000
"Panchkula"		200000
"Bhatinda"		1390000
"Mumbai"		12500000
"Chandigarh"	1060000	
"Amaravati"		150000 --- Only one entry for Amaravati, this is from CAPITALS table and not from CITIES table beacuse we deleted entry from CITIES table for Amaravati.

/*
More about inheritance_schema
https://www.linuxtopia.org/online_books/database_guides/Practical_PostgreSQL_database/PostgreSQL_x13546_002.htm
*/

----With multiple tables

create table gift_shop.inheritance(
additional_column text)
inherits(gift_shop.customer, gift_shop.gift)

select * from gift_shop.inheritance
drop table gift_shop.inheritance

------------------

select * from trial
seq value
1	23
2	444
3	4448
4	978
create table t1 (pointer_name text)
insert into t1 values ('abc'),('def')


create table child(extra_col int) inherits(trial,t1)


insert into child values (6,567,'opq',99)


select * from trial
1	23
2	444
3	4448
4	978
6	567

select * from t1
"abc"
"def"
"opq"

----------------
insert into child values (00)
insert into child values (00,456)

select * from child
6	567	"opq"	99
0	NULL NULL   NULL		
0	456	 NULL   NULL


select * from trial

1	23
2	444
3	4448
4	978
6	567
0	NULL  -- remeber we ahd unique index created on Trial (seq) column, but here we were able to insert duplicate rows as a part of CHILD table
0	456	  -- duplicate row


-----------

create table foreign_table (seq_foregein int references trial(seq))  -- a table created with column refering to SEQ column of trial table

select * from only trial
1	23
2	444
3	4448
4	978

insert into foreign_table values (3),(6),(0)  --- will fail because entry 6, 0 is not there in TRIAL table....its there but it is as part of CHILD table
/*
ERROR:  insert or update on table "foreign_table" violates foreign key constraint "foreign_table_seq_foregein_fkey"
DETAIL:  Key (seq_foregein)=(6) is not present in table "trial".
SQL state: 23503
*/

insert into foreign_table values (3)

select t.seq, value, ft.seq_foregein from trial t, foreign_table ft where t.seq=ft.seq_foregein
3	4448	3