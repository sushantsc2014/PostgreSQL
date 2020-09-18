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









