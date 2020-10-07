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
Views:
current_salary, current_dept, current_title, current_dept_manager			
*/

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