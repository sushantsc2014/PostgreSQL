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

---------------------

create table trial (seq int, value int)

insert into trial values (1,23),(2, 444), (2, 4448)

create unique index on trial (seq) --error
/*
ERROR:  could not create unique index "trial_seq_idx"
DETAIL:  Key (seq)=(2) is duplicated.
SQL state: 23505
*/

delete from trial where value=4448

insert into trial values (3, 4448),(4,978)

select * from trials
1	23
2	444
3	4448
4	978

create unique index on trial (seq)

select * from pg_indexes where tablename='trial'
"public"	"trial"	"trial_seq_idx"		"CREATE UNIQUE INDEX trial_seq_idx ON public.trial USING btree (seq)"


insert into trial values (3,999)
/*
ERROR:  duplicate key value violates unique constraint "trial_seq_idx"
DETAIL:  Key (seq)=(3) already exists.
SQL state: 23505
*/