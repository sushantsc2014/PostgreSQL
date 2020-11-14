/* When PRIMARY KEY is defined */

create table zoo (animal_id serial primary key, animal_name varchar(15))

select * from zoo

1	"lion"
2	"lion"
3	"tiger"
4	"tiger"
5	"tiger"
6	"dove"


delete from zoo z1 using zoo z2 where z1.animal_name=z2.animal_name and z1.animal_id>z2.animal_id

select * from zoo

1	"lion"
3	"tiger"
6	"dove"

/* When PRIMARY KEY is NOT defined */

create table zoo (animal_id int, animal_name varchar(15))
select * from zoo
1	"lion"
1	"lion"
2	"Tiger"
2	"Tiger"
8	"Elephant"

select animal_id, animal_name, count(*) from zoo group by 1,2
1	"lion"	2
2	"Tiger"	2
8	"Elephant"	1

select ctid, * from zoo
"(0,1)"	 1	"lion"
"(0,2)"	 1	"lion"
"(0,3)"	 2	"Tiger"
"(0,4)"	 2	"Tiger"
"(0,5)"	 8	"Elephant"

/* ctid : SYSTEM COLUMN: automatically created whenever you define table. There are a few system column created. https://www.postgresql.org/docs/9.3/ddl-system-columns.html */

delete from zoo z1 using zoo z2 where z1=z2 and z1.ctid>z2.ctid


select ctid, * from zoo
"(0,1)"	1	"lion"
"(0,3)"	2	"Tiger"
"(0,5)"	8	"Elephant"