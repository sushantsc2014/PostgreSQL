/* https://www.techbeamers.com/sql-query-questions-answers-for-practice/ */
/* Q-50. Write an SQL query to fetch the names of workers who earn the highest salary.*/

select count(*) from worker where salary=(select max(salary) from worker)
2

select first_name from worker where salary=(select max(salary) from worker)
"Amitabh"
"Vivek"

/* Q-49 Write an SQL query to fetch departments along with the total salaries paid for each of them. */
select DEPARTMENT, sum(salary) from worker group by 1
"Admin"		1170000
"Account"	275000
"HR"		400000

/* Q-48. Write an SQL query to fetch nth max salaries from a table. */

with rank_salary as
(select salary, dense_rank() over(order by salary desc) from worker)
select salary where dense_rank=n

/* Q-45. Write an SQL query to print the name of employees having the highest salary in each department. */
with temp_table as
(select first_name, salary, department, dense_rank() over(partition by department order by salary desc) from worker)
select first_name from temp_table  where dense_rank=1
"Vipul"
"Vivek"
"Amitabh"
"Vishal"

/* Q-44. Write an SQL query to fetch the last 3 records from a worker table. */

select * from worker order by worker_id desc limit 3
8	"Geetika"	"Chauhan"	90000	"2011-04-14"	"Admin"
7	"Satish"	"Kumar"		75000	"2020-01-14"	"Account"
6	"Vipul"		"Diwan"		200000	"2011-06-14"	"Account"

/* Q-43, 42. Write an SQL query to show the first, last record from a table. */

select * from worker order by worker_id limit 1
select * from worker where worker_id=(select min(worker_id) from worker)
1	"Monika"	"Arora"	100000	"2020-02-14"	"HR"

select * from worker order by worker_id desc limit 1
select * from worker where worker_id=(select max(worker_id) from worker)
8	"Geetika"	"Chauhan"	90000	"2011-04-14"	"Admin"

/* Q-39. Write an SQL query to fetch the first 50% records from a table. */

select * from worker where worker_id<=(select count(worker_id)/2 from worker)


/* Q-37. Write an SQL query to show one row twice in results from a table. */
select * from worker where department='HR'
union all
select * from worker where department='HR'
1	"Monika"	"Arora"		100000	"2020-02-14"	"HR"
3	"Vishal"	"Singhal"	300000	"2020-02-14"	"HR"
1	"Monika"	"Arora"		100000	"2020-02-14"	"HR"
3	"Vishal"	"Singhal"	300000	"2020-02-14"	"HR"

/* Write an SQL query to show the second highest salary from a table. */

with ABC as
(select salary, dense_rank() over(order by salary desc) from worker)
select salary from ABC where dense_rank=2
300000

select max(salary) from worker where salary not in (select max(salary) from worker)
300000

/* Q-35. Write an SQL query to fetch the list of employees with the same salary. */
select w1.WORKER_ID from worker w1, worker w2 where w1.SALARY=w2.SALARY and  w1.WORKER_ID<> w2.WORKER_ID
4
5

/* Q-28. Write an SQL query to clone a new table from another table. */

select * into <<new_table>> from table_1