/* Beofre creating index on column salary */
explain select * from salaries where salary=81025

"Seq Scan on salaries  (cost=0.00..17.81 rows=1 width=16)"
"  Filter: (salary = 81025)"


create index emp_salary_idx on salaries(salary)

select * from pg_indexes where tablename='salaries'
"employee"	"salaries"	"salaries_pkey"		    "CREATE UNIQUE INDEX salaries_pkey ON employee.salaries USING btree (emp_no, from_date)"
"employee"	"salaries"	"emp_salary_idx"		"CREATE INDEX emp_salary_idx ON employee.salaries USING btree (salary)"

/* After creating index on salary column */

explain select * from salaries where salary=81025

"Index Scan using emp_salary_idx on salaries  (cost=0.28..8.29 rows=1 width=16)"
"  Index Cond: (salary = 81025)"