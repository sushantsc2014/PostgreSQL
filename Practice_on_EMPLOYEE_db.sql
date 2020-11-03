/*
DB: employee
schema: employee
Functions: emp_dept_id( employee_id int ), emp_dept_name( employee_id int )
Tables:
 1. departments (dept_no, dept_name)
					P		
 2. employee (emp_no, birth_date, first_name, last_name, gender, hire_date)
				P
 3. dept_emp (emp_no, dept_no, from_date, to_date)
				p		p
 4. dept_manager (emp_no, dept_no, from_date, to_date)
					p		p
 5. titles (emp_no, title, from_date, to_date)
			   p      p        p
 6. salaries (emp_no, salary, from_date, to_date)
				p                 p				
*/

/* 1. Show DEPT of employess from 10069 to 10074 */

do $$
begin
	for emp_id in 10069..10074 loop
		raise notice 'DEPT of emp id % is % (%)', emp_id, emp_dept_name(emp_id), emp_dept_id( emp_id);
	end loop;
end; $$

NOTICE:  DEPT of emp id 10069 is Production (d004)
NOTICE:  DEPT of emp id 10070 is Research (d008)
NOTICE:  DEPT of emp id 10071 is Human Resources (d003)
NOTICE:  DEPT of emp id 10072 is Development (d005)
NOTICE:  DEPT of emp id 10073 is Quality Management (d006)
NOTICE:  DEPT of emp id 10074 is Development (d005)
DO

/* 2. List out employees Hire between March 1992 and June 1992 */

select emp_no, hire_date from employees where hire_date between '01-03-1992' and '30-06-1992'
-- Date format is DD-MM-YYYY

10046	"1992-06-20"
10049	"1992-05-04"
10055	"1992-04-27"

-- In BETWEEN clause, both values are inclusive. Also, date format can be YYYY-MM-DD
select emp_no, hire_date from employees where hire_date between '1992-03-01' and '1992-06-30'

10046	"1992-06-20"
10049	"1992-05-04"
10055	"1992-04-27"

/* 3. 7th Highest salary for employee in given time period of from_date */

with emp (emp_no, salary, DOJ, rank_no) as
(select emp_no,salary,from_date, dense_rank() over(order by salary desc) from salaries where from_date>'01-01-1992' and from_date<'01-06-1992')
select emp_no,salary,DOJ,rank_no from emp where rank_no=7

10039	62131	"1992-01-18"	7

select * from salaries where from_date>'01-01-1992' and from_date<'01-06-1992' order by salary desc offset 6 rows fetch first row only --not the best option because duplicate salary

10039	62131	"1992-01-18"	"2000-01-16"


/* 4. Second highest salary for each departments */

/*
select d.emp_no, d.dept_no, s.salary from dept_emp d inner join salaries s
on d.emp_no=s.emp_no and d.dept_no='d001' group by d.emp_no, d.dept_no, s.salary

select emp_no, dept_no from dept_emp group by emp_no, dept_no order by dept_no
having from_date=(select max(from_date) from dept_emp group by emp_no, dept_no, from_date)

select emp_no, dept_no, from_date from dept_emp where emp_no=10010 group by emp_no, dept_no, from_date order by from_date desc
*/

--This will become easy once you create below two views (query 5 and 6)  

select d.dept_no, max(s.salary) from current_salary s inner join current_dept d
on s.emp_no=d.emp_no group by d.dept_no
"d001"	99651
"d002"	94868
"d003"	96333
"d004"	96646
"d005"	103672
"d006"	94409
"d007"	113229
"d008"	96322
"d009"	98003

--Anser to: 2nd highest salary for each department at present--
with foo as
(select s.emp_no, s.salary,d.dept_no, dense_rank() over(partition by d.dept_no order by s.salary desc) from current_salary s inner join current_dept d on s.emp_no=d.emp_no)
select foo.dept_no, foo.salary, dense_rank as rank from foo where dense_rank=2

"d001"	90843	2
"d002"	94161	2
"d003"	94692	2
"d004"	93621	2
"d005"	88958	2
"d006"	83254	2
"d007"	102651	2
"d008"	88070	2
"d009"	93188	2
----------------------------------------------will work on above requirement:: Done-----------
	
/* 5. Current salary of all the employees */

create view current_salary as
with emp as
(select *, dense_rank() over(partition by emp_no order by from_date desc) from salaries)
select emp_no,salary,from_date,to_date from emp where dense_rank=1;

select * from current_salary --- 126 rows with each employeed current salary

/* 6. Current department of all the employee */

create view current_dept as
with emp as
(select *, dense_rank() over(partition by emp_no order by from_date desc) from dept_emp)
select emp_no,dept_no,from_date,to_date from emp where dense_rank=1;

/* 7. How many times every employee has got increment */

select emp_no, count(*) from salaries group by emp_no order by 1
10001	8
10002	6
10003	7
10004	5
10005	9
.		.
.		.
.		.

--Max number of salary change 

select emp_no, count(*) from salaries group by emp_no having count(*)=(select max(no_of_incr) from (select count(*) no_of_incr from salaries group by  emp_no) as foo)
10009	18


/* 8. Current title of all the employee */

create view current_title as
with emp as
(select *, dense_rank() over(partition by emp_no order by from_date desc) from titles)
select emp_no,title,from_date,to_date from emp where dense_rank=1;

select * from current_title;


/* 9. Which title is held by the employees the most */

select distinct(title) from titles
"Assistant Engineer"
"Staff"
"Senior Staff"
"Technique Leader"
"Engineer"
"Senior Engineer"

select title, count(emp_no) from titles group by title order by 2 desc ----Overall considering
"Engineer"				51
"Staff"					43
"Senior Engineer"		43
"Senior Staff"			35
"Technique Leader"		9
"Assistant Engineer"	6

select title, count(emp_no) from current_title group by title order by 2 desc  -----Current stats
"Senior Engineer"		43
"Senior Staff"			35
"Engineer"				19
"Staff"					18
"Technique Leader"		9
"Assistant Engineer"	2

with title_held_max as
(select title, dense_rank() over (partition by title order by emp_no) from current_title)
select title,dense_rank from title_held_max where dense_rank=(select max(dense_rank) from title_held_max)
"Senior Engineer"	43


/* 10. List employees who have worked in more than one department */

select emp_no, count(*) from dept_emp group by emp_no having count(*)>1
10060	2
10098	2
10116	2
10080	2
10088	2
10040	2
10108	2
10010	2
10070	2
10050	2
10018	2
10124	2
10029	2

/* 11. Female employees working in d005 as a Senior Engineer*/

select c.emp_no,e.gender,c.dept_no,t.emp_no,t.title from current_dept c 
inner join current_title t on c.emp_no=t.emp_no 
inner join employees e on t.emp_no=e.emp_no 
where c.dept_no='d005' and t.title='Senior Engineer' and e.gender='F'

10006	"F"	"d005"	10006	"Senior Engineer"
10027	"F"	"d005"	10027	"Senior Engineer"
10056	"F"	"d005"	10056	"Senior Engineer"
10057	"F"	"d005"	10057	"Senior Engineer"
10072	"F"	"d005"	10072	"Senior Engineer"
10075	"F"	"d005"	10075	"Senior Engineer"
10076	"F"	"d005"	10076	"Senior Engineer"
10118	"F"	"d005"	10118	"Senior Engineer"

/* No of male, female in d005 as Senior Engineer */

select e.gender, count(*) from current_dept c 
inner join current_title t on c.emp_no=t.emp_no 
inner join employees e on t.emp_no=e.emp_no 
where c.dept_no='d005' and t.title='Senior Engineer' group by e.gender

"F"	8
"M"	10


/* 12. Current departmrnt manager */

create view current_dept_manager as
with emp as
(select *, dense_rank() over(partition by dept_no order by from_date desc) from dept_manager)
select emp_no,dept_no,from_date,to_date from emp where dense_rank=1;

10028	"d001"	"1991-09-11"	"9999-01-01"
10022	"d002"	"1989-12-17"	"9999-01-01"
10014	"d003"	"1992-03-21"	"9999-01-01"
10044	"d004"	"1996-08-30"	"9999-01-01"
10125	"d005"	"1992-04-25"	"9999-01-01"
10086	"d006"	"1994-06-28"	"9999-01-01"
10020	"d007"	"1991-03-07"	"9999-01-01"
10043	"d008"	"1991-04-08"	"9999-01-01"
10091	"d009"	"1996-01-03"	"9999-01-01"

/* 13. Second highest salary (current) for each title */
with title_salary as 
(select s.emp_no, s.salary, t.title, dense_rank() over(partition by title order by salary)
from current_salary s inner join current_title t on s.emp_no=t.emp_no)
select * from title_salary where dense_rank=2

10024	96646	"Assistant Engineer"	2
10022	41348	"Engineer"				2
10027	46145	"Senior Engineer"		2
10049	51326	"Senior Staff"			2
10115	47429	"Staff"					2
10025	57157	"Technique Leader"		2

/* Use of WINDOWS fucntion */

select s.emp_no,d.emp_no,s.salary,d.dept_no, 
sum(salary) over(partition by dept_no),
round(avg(salary) over(partition by dept_no)) as average,
max(salary) over(partition by dept_no),
min(salary) over(partition by dept_no)
from current_salary s inner join current_dept d
on s.emp_no=d.emp_no


10058	10058	72542	"d001"	308700	77175	99651	45664
10017	10017	99651	"d001"	308700	77175	99651	45664
10055	10055	90843	"d001"	308700	77175	99651	45664
10108	10108	45664	"d001"	308700	77175	99651	45664
-------------
10042	10042	94868	"d002"	189029	94515	94868	94161
10059	10059	94161	"d002"	189029	94515	94868	94161
-------------and so on for each deptarment


/* 14. Who as Assistant Engineer has serveed longest */

select *, (to_date-from_date) as term_in_days from titles where title='Assistant Engineer'
10008	"Assistant Engineer"	"1998-03-11"	"2000-07-31"	873
10009	"Assistant Engineer"	"1985-02-18"	"1990-02-18"	1826
10024	"Assistant Engineer"	"1998-06-14"	"9999-01-01"	2922141
10066	"Assistant Engineer"	"1986-02-26"	"1992-02-26"	2191
10102	"Assistant Engineer"	"1995-01-02"	"2002-01-02"	2557
10123	"Assistant Engineer"	"1993-01-15"	"1999-01-15"	2191

/*
So I though, to have to_date as 9999-01-01, update it to today's date.

update current_title set to_date=(select current_date)

ERROR:  cannot update view "current_title"
DETAIL:  Views containing WITH are not automatically updatable.
HINT:  To enable updating the view, provide an INSTEAD OF UPDATE trigger or an unconditional ON UPDATE DO INSTEAD rule.
SQL state: 55000

--So I created INSTEAD OF UPDATE tigger. I thought it will only update entries from current_title and not other entries in titles

CREATE OR REPLACE FUNCTION update_on_current_title_view() 
RETURNS trigger AS $$
BEGIN 
  update titles set to_date=new.to_date;
  return new; 
END;
$$
LANGUAGE plpgsql;

create trigger update_on_title_view
instead of update on current_title
for each row
execute procedure update_on_current_title_view()


update current_title set to_date=(select current_date)
UPDATE 126
---It unfortunately update titles table as well. Went wrong--------

--2nd try
CREATE OR REPLACE FUNCTION update_on_current_title_view() 
RETURNS trigger AS $$
BEGIN 
  if title.to_date='9999-01-01' then
  update titles set to_date=new.to_date;
  end if;
  return new; 
END;
$$
LANGUAGE plpgsql;

ERROR:  missing FROM-clause entry for table "title"
LINE 1: SELECT title.to_date='9999-01-01'
               ^
QUERY:  SELECT title.to_date='9999-01-01'
CONTEXT:  PL/pgSQL function update_on_current_title_view() line 3 at IF
SQL state: 42P01

--3rd try and this one worked. It updated view and main table as expected.
CREATE OR REPLACE FUNCTION update_on_current_title_view() 
RETURNS trigger AS $$
BEGIN 
  update titles set to_date=new.to_date where to_date='9999-01-01';
  return new; 
END;
$$
LANGUAGE plpgsql;
*/

select *, (to_date-from_date) as term_in_days from titles where title='Assistant Engineer';

10008	"Assistant Engineer"	"1998-03-11"	"2000-07-31"	873
10009	"Assistant Engineer"	"1985-02-18"	"1990-02-18"	1826
10066	"Assistant Engineer"	"1986-02-26"	"1992-02-26"	2191
10102	"Assistant Engineer"	"1995-01-02"	"2002-01-02"	2557
10123	"Assistant Engineer"	"1993-01-15"	"1999-01-15"	2191
10024	"Assistant Engineer"	"1998-06-14"	"2020-10-09"	8153

with max_term as
(select *, (to_date-from_date) as term_in_days from titles where title='Assistant Engineer')
select emp_no,term_in_days from max_term where term_in_days=(select max(term_in_days) from max_term)

10024	8153


/* 15. All EMP born in 'May' */

select emp_no from employees where to_char(birth_date, 'mon')='may'
10004 10007 10016 10050 10057 10072 10084 10090 10094 10099 10123 10124

select emp_no from employees where date_part('year', birth_date)=1953
10001 10006 10011 10019 10023 10026 10035 10051 10059 10067 10100 10103

select emp_no from employees where date_part('month', birth_date)=5 --5th Month
10004 10007 10016 10050 10057 10072 10084 10090 10094 10099 10123 10124

select emp_no from employees where date_part('day', birth_date)=5 --5th day
10024 10079 10105

select emp_no from employees where date_part('quarter', birth_date)=4 -- born in 4th quarter
10003 10011 . . . (32 records)

select emp_no from employees where date_part('week', birth_date)=4 -- born in 4th week
10019 10071

select date_part('hour', current_timestamp)
select date_part('minute', current_timestamp)
select date_part('second', current_timestamp)

select age(birth_date) from employees
select age(date_1,date_2)


/* 16. No of employees in d007 as per different title*/

select cd.dept_no, ct.title, count(*) from employees e inner join current_dept cd on e.emp_no=cd.emp_no
inner join current_title ct on e.emp_no=ct.emp_no
inner join current_salary cs on e.emp_no=cs.emp_no
AND dept_no='d005' --AND title='Staff'
group by cd.dept_no, ct.title

"d005"	"Assistant Engineer"	1
"d005"	"Engineer"				9
"d005"	"Senior Engineer"		18
"d005"	"Technique Leader"		5

/*17. Who takes 3rd highest salary in each department */

with rank_salary as
(select d.emp_no, d.dept_no, s.salary , dense_rank() over (partition by dept_no order by salary)
from current_dept d inner join current_salary s on d.emp_no=s.emp_no)
select emp_no, dept_no,salary from rank_salary where dense_rank=3

10055	"d001"	90843
10077	"d003"	54699
10045	"d004"	47581
10027	"d005"	46145
10124	"d006"	58460
10125	"d007"	69518
10116	"d008"	48568
10098	"d009"	56202

/* Department with highest count for any title */

with foo as
(select  d.dept_no,t.title, count(*) as no_of_emp from current_dept d inner join current_title t on d.emp_no=t.emp_no
group by d.dept_no,t.title)
select * from foo where no_of_emp=(select max(no_of_emp) from foo)

"d005"	"Senior Engineer"	18

/* 18. Count number of Male and Female employees in each department  */

--considering current dept of employee

select cd.dept_no, e.gender, count(*) from employees e inner join current_dept cd on e.emp_no=cd.emp_no group by cd.dept_no, e.gender

"d001"	"F"	1
"d001"	"M"	3
"d002"	"F"	2
"d003"	"F"	2
"d003"	"M"	10
"d004"	"F"	10
"d004"	"M"	18
"d005"	"F"	13
"d005"	"M"	20
"d006"	"F"	3
"d006"	"M"	5
"d007"	"F"	9
"d007"	"M"	7
"d008"	"F"	5
"d008"	"M"	9
"d009"	"F"	5
"d009"	"M"	4

select cd.dept_no, e.gender, count(*), dense_rank() over(order by count(*)) from employees e inner join current_dept cd on e.emp_no=cd.emp_no group by cd.dept_no, e.gender

"d001"	"F"	1	1
"d002"	"F"	2	2
"d003"	"F"	2	2
"d006"	"F"	3	3
"d001"	"M"	3	3
"d009"	"M"	4	4
"d008"	"F"	5	5
"d009"	"F"	5	5
"d006"	"M"	5	5
"d007"	"M"	7	6
"d008"	"M"	9	7
"d007"	"F"	9	7
"d003"	"M"	10	8
"d004"	"F"	10	8
"d005"	"F"	13	9
"d004"	"M"	18	10
"d005"	"M"	20	11

--Considering past employees
select d.dept_no, e.gender, count(*) from employees e inner join dept_emp d on e.emp_no=d.emp_no group by d.dept_no, e.gender order by d.dept_no

"d001"	"F"	1
"d001"	"M"	3
"d002"	"M"	2
"d002"	"F"	2
"d003"	"M"	11
"d003"	"F"	2
"d004"	"M"	20
"d004"	"F"	12
"d005"	"M"	21
"d005"	"F"	16
"d006"	"M"	5
"d006"	"F"	3
"d007"	"F"	10
"d007"	"M"	8
"d008"	"M"	9
"d008"	"F"	5
"d009"	"F"	5
"d009"	"M"	4

/* 19. DEPARTMENT, EMPs, and Managaers */
--Employee with more than one dept serverd as Manager

select emp_no, count(*) from dept_manager group by emp_no having count(*)>1
10009	2
10014	2

select * from dept_manager where emp_no in (select emp_no from dept_manager group by emp_no having count(*)>1) order by emp_no

10009	"d001"	"1985-01-01"	"1991-09-11"
10009	"d006"	"1991-09-12"	"1994-06-28"
10014	"d002"	"1985-01-01"	"1989-12-17"
10014	"d003"	"1992-03-21"	"9999-01-01"

--Dept with more than one employee servers as manager

select dept_no, count(*) from dept_manager group by dept_no having count(*)>1
"d006"	4
"d009"	4
"d008"	2
"d005"	2
"d007"	2
"d001"	2
"d003"	2
"d004"	4
"d002"	2

select * from dept_manager where dept_no in (select dept_no from dept_manager group by dept_no having count(*)>1)

/* Number of employees who have never served as Department managers */

select count(emp_no) from employees where emp_no not in (select emp_no from dept_manager)
104
select count(emp_no) from employees where emp_no not in (select distinct(emp_no) from dept_manager)
104

/* Which manager has servered the longest */

select *, age(to_date, from_date) from dept_manager order by age desc

select *, dense_rank() over(order by age(to_date,from_date) desc) from dept_manager


/* 20. Who is the manager for employee number 10042 */

select emp_no as Manager_for_given_emp from current_dept_manager where dept_no=(select dept_no from current_dept where emp_no=10042)
10022

select * from current_dept where emp_no=10042
10042	"d002"	"1993-03-21"	"2000-08-10"

--Using already defined function
select emp_no as Manager_for_given_emp from current_dept_manager where dept_no=emp_dept_id(10042)
select emp_no as Manager_for_given_emp from current_dept_manager where dept_no=(select emp_dept_id(10042))

select cdm.emp_no,cdm.dept_no,e.first_name,e.last_name,e.gender from current_dept_manager cdm inner join employees e on cdm.emp_no=e.emp_no where cdm.dept_no=emp_dept_id(10042)
10022	"d002"	"Shahaf"	"Famili"	"M"

--Defiend new function
select * from employees where emp_no=emp_manager(10090) -- Give manager details for emp no=10090
10125  "Syozo"	"Hiltgen"	"F"

--The management wants to know the various employees that work under the same manager as that of another employee called as Patricio

select cd.emp_no from current_dept cd inner join current_dept_manager cdm on cd.dept_no=cdm.dept_no and
cdm.emp_no=emp_manager((select emp_no from employees where first_name='Patricio'))

10001 10006 10008 10012 10014 10021 ... total 33 records 


/* 21. Create a report to display the manager number and the salary of the lowest paid employee for that manager. Exclude any groups where the minimum salary is 40000 or less. Sort the output in descending order of salary. */

select cd.emp_no, cdm.emp_no as manager_id, cs.salary  from current_dept cd inner join current_dept_manager cdm
on cd.dept_no=cdm.dept_no inner join current_salary cs on cd.emp_no=cs.emp_no 

select cdm.emp_no as manager_id, min(cs.salary) 
	from current_dept cd inner join current_dept_manager cdm on cd.dept_no=cdm.dept_no 
	inner join current_salary cs on cd.emp_no=cs.emp_no 
	group by cdm.emp_no having min(salary)>40000 order by 2 desc
	
10022	94161
10086	56473
10014	53315
10020	53164
10091	47429
10028	45664
10044	43311

---excluding managers themselves 
select cdm.emp_no as manager_id, min(cs.salary)  
	from current_dept cd inner join current_dept_manager cdm on cd.dept_no=cdm.dept_no 
	inner join current_salary cs on cd.emp_no=cs.emp_no and cd.emp_no<>cdm.emp_no 
	group by cdm.emp_no having min(salary)>40000 order by 2 desc

10022	94161
10086	56473
10014	53315
10020	53164
10091	47429
10028	45664
10044	43311	

/* 22. For manager 10014,10020,10043 who takes 3rd highest salary */

select cdm.emp_no as manager_id, cd.emp_no, cs.salary, dense_rank() over(partition by cdm.emp_no order by cs.salary desc) 
	from current_dept cd inner join current_dept_manager cdm on cd.dept_no=cdm.dept_no 
	inner join current_salary cs on cd.emp_no=cs.emp_no and cd.emp_no<>cdm.emp_no and cdm.emp_no in (10014,10020,10043)
	
with manager_emp_rank as
(select cdm.emp_no as manager_id, cd.emp_no, cs.salary, dense_rank() over(partition by cdm.emp_no order by cs.salary desc) 
	from current_dept cd inner join current_dept_manager cdm on cd.dept_no=cdm.dept_no 
	inner join current_salary cs on cd.emp_no=cs.emp_no and cd.emp_no<>cdm.emp_no and cdm.emp_no in (10014,10020,10043))
select * from manager_emp_rank where dense_rank=3

10014	10110	92842	3
10020	10107	101676	3
10043	10094	85225	3

/* 23. Employee with title in each department takes highest salary */

select cd.emp_no, cd.dept_no, ct.title, cs.salary, dense_rank() over(partition by dept_no, title order by salary) from current_dept cd inner join current_title ct on cd.emp_no=ct.emp_no inner join current_salary cs on ct.emp_no=cs.emp_no

with ABC as
(select cd.emp_no, cd.dept_no, ct.title, cs.salary, dense_rank() over(partition by dept_no, title order by salary desc)
from current_dept cd inner join current_title ct on cd.emp_no=ct.emp_no
inner join current_salary cs on ct.emp_no=cs.emp_no)
select emp_no, dept_no,title, salary from ABC where dense_rank=1

10017	"d001"	"Senior Staff"			99651
10055	"d001"	"Staff"					90843
10042	"d002"	"Senior Staff"			94868
10086	"d003"	"Senior Staff"			96333
10105	"d003"	"Staff"					61172
10024	"d004"	"Assistant Engineer"	96646
10123	"d004"	"Engineer"				92601
10084	"d004"	"Senior Engineer"		93621
10069	"d004"	"Technique Leader"		86641
10008	"d005"	"Assistant Engineer"	52668
10103	"d005"	"Engineer"				80061
10066	"d005"	"Senior Engineer"		103672
10021	"d005"	"Technique Leader"		84169
10010	"d006"	"Engineer"				80324
10009	"d006"	"Senior Engineer"		94409
10033	"d006"	"Technique Leader"		60433
10068	"d007"	"Senior Staff"			113229
10087	"d007"	"Staff"					102651
10040	"d008"	"Senior Engineer"		72668
10007	"d008"	"Senior Staff"			88070
10019	"d008"	"Staff"					50032
10070	"d008"	"Technique Leader"		96322
10098	"d009"	"Senior Engineer"		56202
10088	"d009"	"Senior Staff"			98003
10112	"d009"	"Staff"					61070

/* Which titles are not assigned in dept d003 */

select distinct(title) from titles where title not in (select distinct(ct.title) from current_title ct inner join current_dept cd on ct.emp_no=cd.emp_no and dept_no='d003')
"Assistant Engineer"
"Technique Leader"
"Engineer"
"Senior Engineer"

/* 24. List out all emp who takes salary geater than AVG slaary for their department  */

--using WITH, Windows function
with XYZ as
(select cd.emp_no, cd.dept_no, cs.salary, 
round(avg(salary) over(partition by cd.dept_no)) avg_dept_sal
from current_dept cd inner join current_salary cs on cd.emp_no=cs.emp_no)
select * from XYZ where salary>avg_dept_sal

10017	"d001"	99651	77175
10055	"d001"	90843	77175
10042	"d002"	94868	94515
10100	"d003"	74957	70876
10110	"d003"	92842	70876
10005	"d003"	94692	70876
10080	"d003"	72729	70876
10086	"d003"	96333	70876
10047	"d004"	81037	71215
10117	"d004"	75936	71215
10113	"d004"	75209	71215
10018	"d004"	84672	71215
10106	"d004"	82836	71215
10081	"d004"	79351	71215
10123	"d004"	92601	71215
(total 57 rows)

--Using sub-query, co-relate query
select cd_1.emp_no, cd_1.dept_no, cs_1.salary from current_dept cd_1 inner join current_salary cs_1 on cd_1.emp_no=cs_1.emp_no
where cs_1.salary>
(select round(avg(cs.salary)) from current_dept cd inner join current_salary cs on cd.emp_no=cs.emp_no and cd.dept_no=cd_1.dept_no) order by cd_1.dept_no
 
10055	"d001"	90843
10017	"d001"	99651
10042	"d002"	94868
10086	"d003"	96333
10100	"d003"	74957
10110	"d003"	92842
10080	"d003"	72729
10005	"d003"	94692
10030	"d004"	88806
10106	"d004"	82836
10047	"d004"	81037
10123	"d004"	92601
10117	"d004"	75936
(total 57 rows)

--------Analysis-------

explain
(with XYZ as
(select cd.emp_no, cd.dept_no, cs.salary, 
round(avg(salary) over(partition by cd.dept_no)) avg_dept_sal
from current_dept cd inner join current_salary cs on cd.emp_no=cs.emp_no)
select * from XYZ where salary>avg_dept_sal)


--QUERY PLAN--
"Subquery Scan on xyz  (cost=104.85..104.89 rows=1 width=45)"
"  Filter: ((xyz.salary)::numeric > xyz.avg_dept_sal)"
"  ->  WindowAgg  (cost=104.85..104.88 rows=1 width=45)"
"        ->  Sort  (cost=104.85..104.86 rows=1 width=13)"
"              Sort Key: emp.dept_no"
"              ->  Nested Loop  (cost=69.49..104.84 rows=1 width=13)"
"                    Join Filter: (emp.emp_no = emp_1.emp_no)"
"                    ->  Subquery Scan on emp  (cost=7.34..11.86 rows=1 width=17)"
"                          Filter: (emp.dense_rank = 1)"
"                          ->  WindowAgg  (cost=7.34..10.12 rows=139 width=25)"
"                                ->  Sort  (cost=7.34..7.69 rows=139 width=13)"
"                                      Sort Key: dept_emp.emp_no, dept_emp.from_date DESC"
"                                      ->  Seq Scan on dept_emp  (cost=0.00..2.39 rows=139 width=13)"
"                    ->  Subquery Scan on emp_1  (cost=62.15..92.87 rows=5 width=16)"
"                          Filter: (emp_1.dense_rank = 1)"
"                          ->  WindowAgg  (cost=62.15..81.05 rows=945 width=24)"
"                                ->  Sort  (cost=62.15..64.52 rows=945 width=12)"
"                                      Sort Key: salaries.emp_no, salaries.from_date DESC"
"                                      ->  Seq Scan on salaries  (cost=0.00..15.45 rows=945 width=12)"


explain
(select cd_1.emp_no, cd_1.dept_no, cs_1.salary from current_dept cd_1 inner join current_salary cs_1 on cd_1.emp_no=cs_1.emp_no
where cs_1.salary>
(select round(avg(cs.salary)) from current_dept cd inner join current_salary cs on cd.emp_no=cs.emp_no and cd.dept_no=cd_1.dept_no)
order by cd_1.dept_no)

"Sort  (cost=210.04..210.05 rows=1 width=13)"
"  Sort Key: cd_1.dept_no"
"  ->  Hash Join  (cost=74.03..210.03 rows=1 width=13)"
"        Hash Cond: (emp.emp_no = cd_1.emp_no)"
"        Join Filter: ((emp.salary)::numeric > (SubPlan 1))"
"        ->  Subquery Scan on emp  (cost=62.15..92.87 rows=5 width=16)"
"              Filter: (emp.dense_rank = 1)"
"              ->  WindowAgg  (cost=62.15..81.05 rows=945 width=24)"
"                    ->  Sort  (cost=62.15..64.52 rows=945 width=12)"
"                          Sort Key: salaries.emp_no, salaries.from_date DESC"
"                          ->  Seq Scan on salaries  (cost=0.00..15.45 rows=945 width=12)"
"        ->  Hash  (cost=11.87..11.87 rows=1 width=9)"
"              ->  Subquery Scan on cd_1  (cost=7.34..11.87 rows=1 width=9)"
"                    ->  Subquery Scan on emp_1  (cost=7.34..11.86 rows=1 width=17)"
"                          Filter: (emp_1.dense_rank = 1)"
"                          ->  WindowAgg  (cost=7.34..10.12 rows=139 width=25)"
"                                ->  Sort  (cost=7.34..7.69 rows=139 width=13)"
"                                      Sort Key: dept_emp.emp_no, dept_emp.from_date DESC"
"                                      ->  Seq Scan on dept_emp  (cost=0.00..2.39 rows=139 width=13)"
"        SubPlan 1"
"          ->  Aggregate  (cost=105.20..105.21 rows=1 width=32)"
"                ->  Nested Loop  (cost=69.49..105.19 rows=1 width=4)"
"                      Join Filter: (emp_2.emp_no = emp_3.emp_no)"
"                      ->  Subquery Scan on emp_2  (cost=7.34..12.20 rows=1 width=32)"
"                            Filter: ((emp_2.dense_rank = 1) AND (emp_2.dept_no = cd_1.dept_no))"
"                            ->  WindowAgg  (cost=7.34..10.12 rows=139 width=25)"
"                                  ->  Sort  (cost=7.34..7.69 rows=139 width=13)"
"                                        Sort Key: dept_emp_1.emp_no, dept_emp_1.from_date DESC"
"                                        ->  Seq Scan on dept_emp dept_emp_1  (cost=0.00..2.39 rows=139 width=13)"
"                      ->  Subquery Scan on emp_3  (cost=62.15..92.87 rows=5 width=16)"
"                            Filter: (emp_3.dense_rank = 1)"
"                            ->  WindowAgg  (cost=62.15..81.05 rows=945 width=24)"
"                                  ->  Sort  (cost=62.15..64.52 rows=945 width=12)"
"                                        Sort Key: salaries_1.emp_no, salaries_1.from_date DESC"
"                                        ->  Seq Scan on salaries salaries_1  (cost=0.00..15.45 rows=945 width=12)"


---Cost of query for 1st method is less, hence better to use hat one
--COST of query= units of disk page fetches--

/* 25 RANK func and GROUP BY */

--Rank departments as per number of employess

select dept_no, count(emp_no), rank() over(order by count(emp_no) /*desc*/) from current_dept group by dept_no
"d002"	2	1
"d001"	4	2
"d006"	8	3
"d009"	9	4
"d003"	12	5
"d008"	14	6
"d007"	16	7
"d004"	28	8
"d005"	33	9

select title, count(emp_no),rank() over(order by count(emp_no) desc) from current_title group by title
"Senior Engineer"		43	  1
"Senior Staff"			35	  2
"Engineer"				19	  3
"Staff"					18	  4
"Technique Leader"		9	  5
"Assistant Engineer"	2	  6

select title, count(emp_no), sum(count(emp_no)) over(),rank() over(order by count(emp_no) desc) from current_title group by title

select cd.dept_no, ct.title, count(*), sum(count(*)) over(),dense_rank() over(order by count(*) desc) from current_dept cd, current_title ct 
where cd.emp_no=ct.emp_no group by cd.dept_no, ct.title
"d005"	"Senior Engineer"	18	126	1
"d004"	"Senior Engineer"	17	126	2
"d005"	"Engineer"			9	126	3
"d003"	"Senior Staff"		9	126	3
"d007"	"Senior Staff"		9	126	3
"d004"	"Engineer"			8	126	4
"d008"	"Senior Staff"		8	126	4
"d007"	"Staff"				7	126	5
"d005"	"Technique Leader"	5	126	6
"d006"	"Senior Engineer"	5	126	6
"d009"	"Senior Staff"		5	126	6
"d009"	"Staff"				3	126	7
"d003"	"Staff"				3	126	7
"d008"	"Staff"				3	126	7
"d006"	"Engineer"			2	126	8
"d004"	"Technique Leader"	2	126	8
"d008"	"Senior Engineer"	2	126	8
"d002"	"Senior Staff"		2	126	8
"d001"	"Senior Staff"		2	126	8
"d001"	"Staff"				2	126	8
"d006"	"Technique Leader"	1	126	9
"d005"	"Assistant Engineer"1	126	9
"d004"	"Assistant Engineer"1	126	9
"d008"	"Technique Leader"	1	126	9
"d009"	"Senior Engineer"	1	126	9

-- Which dpartment takes 3rd hghest sum of total salary of all employees in that department

select cd.dept_no, sum(salary), rank() over(order by  sum(salary) desc) from current_dept cd, current_salary cs where cd.emp_no=cs.emp_no group by  cd.dept_no
"d005"	2101205	1
"d004"	1994013	2
"d007"	1343603	3
"d008"	921711	4
"d003"	850517	5
"d009"	605535	6
"d006"	567771	7
"d001"	308700	8
"d002"	189029	9

select cd.dept_no, sum(salary), rank() over(order by  sum(salary) desc) from current_dept cd, current_salary cs where cd.emp_no=cs.emp_no 
group by  cd.dept_no having sum(salary)<1343600
"d008"	921711	1
"d003"	850517	2
"d009"	605535	3
"d006"	567771	4
"d001"	308700	5
"d002"	189029	6

/* 26. Self join */

--Employees worked in more than one departments
select x.emp_no,x.dept_no from dept_emp x inner join dept_emp y on x.emp_no=y.emp_no and x.dept_no<>y.dept_no
10010	"d004"
10010	"d006"
10018	"d004"
10018	"d005"
10029	"d004"
10029	"d006"
10040	"d005"
10040	"d008"
10050	"d002"
10050	"d007"
(more records)

--Employees worked in more than one department AND more than one title

select distinct(x.emp_no),x.dept_no, y.title from dept_emp x, dept_emp x1, titles y, titles y1 where
x.emp_no=y.emp_no and x.emp_no=x1.emp_no and y.emp_no=y1.emp_no and (x.dept_no<>x1.dept_no and y.title<>y1.title) order by x.emp_no
																						--AND/OR conditions will make difference
10018	"d004"	"Engineer"
10018	"d004"	"Senior Engineer"
10018	"d005"	"Engineer"
10018	"d005"	"Senior Engineer"
10029	"d004"	"Engineer"
10029	"d004"	"Senior Engineer"
10029	"d006"	"Engineer"
10029	"d006"	"Senior Engineer"
10040	"d005"	"Engineer"
10040	"d005"	"Senior Engineer"
10040	"d008"	"Engineer"
10040	"d008"	"Senior Engineer"
(total 36 rows)

--Employee who as manager for more than more dept

select x.emp_no,x.dept_no,x.from_date,x.to_date from dept_manager x, dept_manager y where x.emp_no=y.emp_no and x.dept_no<>y.dept_no
10009	"d001"	"1985-01-01"	"1991-09-11"
10009	"d006"	"1991-09-12"	"1994-06-28"
10014	"d002"	"1985-01-01"	"1989-12-17"
10014	"d003"	"1992-03-21"	"9999-01-01"

-- Employees as senior engineer currently have served as manager for more than one dept

select x.emp_no,x.dept_no,x.from_date,x.to_date,z.title from dept_manager x, dept_manager y, current_title z where
x.emp_no=y.emp_no and x.emp_no=z.emp_no and x.dept_no<>y.dept_no and z.title='Senior Engineer'
10009	"d001"	"1985-01-01"	"1991-09-11"	"Senior Engineer"
10009	"d006"	"1991-09-12"	"1994-06-28"	"Senior Engineer"

--Employees who drew same salaries at any point
select distinct(x.emp_no), x.salary from salaries x, salaries y where x.salary=y.salary and x.emp_no<>y.emp_no order by x.salary
10037	40000
10020	40000
10054	40000
10003	43466
10064	43466
10058	53869
10056	53869
10085	56905
10124	56905
10032	57110
10025	57110
10035	59291
10112	59291
10013	59571
10047	59571
10067	62607
10092	62607
10009	70889
10016	70889
(48 rows total)	

--Emp born on same day

select x.emp_no, x.birth_date from employees x, employees y where x.birth_date=y.birth_date and x.emp_no<>y.emp_no
10083	"1959-07-23"
10087	"1959-07-23"

--Emp hired on same date

select e.emp_no, e.hire_date from employees e, employees e1 where e.hire_date=e1.hire_date and e.emp_no<>e1.emp_no

10090	"1986-03-14"
10119	"1986-03-14"


/* 27. Who have spent shortest in any department */

select emp_no, (to_date-from_date) time_in_days from dept_emp order by 2

/* 28. Report for each manager 5 employee takes lowest salary */

with XYZ as
(select cdm.emp_no as manager, cd.emp_no, cs.salary, dense_rank() over(partition by cdm.emp_no order by cs.salary) from current_dept cd, current_dept_manager cdm, current_salary cs
where cd.dept_no=cdm.dept_no and cd.emp_no=cs.emp_no)
select  * from XYZ where dense_rank<6

10014	10071	53315	1
10014	10054	53906	2
10014	10077	54699	3
10014	10105	61172	4
10014	10036	63053	5
10020	10034	53164	1
10020	10101	66715	2
10020	10125	69518	3
10020	10002	72527	4
10020	10016	77935	5
10022	10059	94161	1
10022	10042	94868	2
10028	10108	45664	1
10028	10058	72542	2
10028	10055	90843	3
10028	10017	99651	4
10043	10015	40000	1
10043	10064	48454	2
10043	10116	48568	3
10043	10082	48935	4
10043	10019	50032	5
10044	10003	43311	1
10044	10020	47017	2
10044	10045	47581	3
10044	10109	52721	4
10044	10044	58345	5
10086	10073	56473	1
10086	10111	56641	2
10086	10124	58460	3
10086	10033	60433	4
10086	10029	77777	5
10091	10115	47429	1
10091	10049	51326	2
10091	10098	56202	3
10091	10011	56753	4
10091	10112	61070	5
10125	10048	39507	1
10125	10022	41348	2
10125	10027	46145	3
10125	10065	47437	4
10125	10122	48464	5



/* 29. Employess who has 5 highest increment in salary over the years  */

select emp_no, max(salary), min(salary), max(salary)-min(salary) as diff, dense_rank() over (order by (max(salary)-min(salary)) desc) 
from salaries group by emp_no  ---- give condition on dense_rank

10110	92842	46836	46006	1
10070	96322	55999	40323	2
10067	83254	44642	38612	3
10126	77310	40000	37310	4
10083	77186	40000	37186	5


/*
DB: employee
schema: employee
Functions: emp_dept_id( employee_id int ), emp_dept_name( employee_id int ), emp_manager(employee_no int)
Tables:
 1. departments (dept_no, dept_name)
					P		
 2. employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
				P
 3. dept_emp (emp_no, dept_no, from_date, to_date)
				p		p
 4. dept_manager (emp_no, dept_no, from_date, to_date)
					p		p
 5. titles (emp_no, title, from_date, to_date)
			   p      p        p
 6. salaries (emp_no, salary, from_date, to_date)
				p                 p
Views:
current_salary, current_dept, current_title, current_dept_manager

  F    J    W     G        H      S      D        O
  From Join Where Group by Having Select Distinct Order by
 (Frank John's wicked grave hunts several dull owls.)			
*/