select * from computer

999	 "DELL"	    2004
888	 "HP"		2004
777	 "LENOVO"	2010
222	 "ASUS"		2017
444	 "HP"		2018
333	 "SONY"		2020

/* Create view for Comp_id and Make*/
create view view_1 as (select comp_id, make from computer))

select * from view_1
999	"DELL"
888	"HP"
777	"LENOVO"
222	"ASUS"
444	"HP"
333	"SONY"


insert into view_1 values (345,'Alienware')
999	"DELL"
888	"HP"
777	"LENOVO"
222	"ASUS"
444	"HP"
333	"SONY"
345	"Alienware"  ---> New entry in VIEW table

select * from computer
999	"DELL"		2004
888	"HP"		2004
777	"LENOVO"	2010
222	"ASUS"		2017
444	"HP"		2018
333	"SONY"		2020
345	"Alienware"	NULL  ----> Row is inserted into original table as well.

/*INERT, DELETE, UPDATE on original table or on view has effect on other, if we delete from original table, view row will get deleted and vice versa. */


/* VIEW with CHECK OPTION */

--Suppose, due to privacy contraint or something, we want to display end user only computer from 2004 to 2017 model. So my new view will be

create view view_2 as (select * from computer where model between '2004'and '2017')

select * from view_2 ---model between 2004 and 2017
999	"DELL"		2004
888	"HP"		2004
777	"LENOVO"	2010
222	"ASUS"		2017

--Now suppose I run below query--

insert into view_2 values (367,'Acer', 2021)

select * from view_2
999	"DELL"		2004
888	"HP"		2004
777	"LENOVO"	2010
222	"ASUS"		2017  ---But the updated view is not visible in VIEW, and this is not desired. Whoever is granted this ROW, he can mofify,insert in VIEW and shoul be visible

select* from computer
999	"DELL"		2004
888	"HP"		2004
777	"LENOVO"	2010
222	"ASUS"		2017
444	"HP"		2018
333	"SONY"		2020
367	"Acer"		2021 ---> But the inert on view, inerted row in main table, which was not desired.


/*Lets create WITH CHECK OPTION view*/
create view check_view as (select * from computer where model between '2004'and '2017') with check option

select * from check_view
999	"DELL"		2004
888	"HP"		2004
777	"LENOVO"	2010
222	"ASUS"		2017

insert into check_view values (456,'APPLE',2019) 
/*Thsi will throw an error as violation, beacuse it will check view condition*/
/*
ERROR:  new row violates check option for view "check_view"
DETAIL:  Failing row contains (456, APPLE, 2019).
SQL state: 44000
*/

--Now try to insert row with cindition satisfying---

insert into check_view values (456,'APPLE',2017) 

select * from check_view
999	"DELL"		2004
888	"HP"		2004
777	"LENOVO"	2010
222	"ASUS"		2017
456	"APPLE"		2017 -->row inserted in VIEW TABLE

select * from computer
999	"DELL"		2004
888	"HP"		2004
777	"LENOVO"	2010
222	"ASUS"		2017
444	"HP"		2018
333	"SONY"		2020
367	"Acer"		2021
456	"APPLE"		2017  --> ROW INSERTED IN ORIGINAL TABLE AS WELL.
