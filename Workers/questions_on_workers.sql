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