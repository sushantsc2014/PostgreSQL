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