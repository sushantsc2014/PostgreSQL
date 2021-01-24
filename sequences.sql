create sequence employee.seq_trail_1 start with 1 maxvalue 20 minvalue 1 increment by 4 cycle;

/*
max vaue:it will reach upto 20
min value: minimun values for sequence 1
start with: First number (can not be less that min number in acesnding sequence)
cycle: It will repeat
*/

select nextval('employee.seq_trail_1')

select * from employee.seq_trail_1

create table employee.seq_trial_tab (roll_no int default nextval('employee.seq_trail_1'), student_name varchar(10))

insert into employee.seq_trial_tab (student_name) values ('Raj'),('Mit'),('Jassi'),('Naman')
insert into employee.seq_trial_tab (student_name) values ('Yeti'), ('Roy'),('Nadda')

select * from employee.seq_trial_tab
1	"Raj"
5	"Mit"
9	"Jassi"
13	"Naman"
17	"Yeti"
1	"Roy"
5	"Nadda"



/*
ERROR:  START value (1) cannot be less than MINVALUE (3)
SQL state: 22023
*/

alter sequence employee.seq_trail_1 start with 2 maxvalue 20 minvalue 1 increment by 4 cycle;

insert into employee.seq_trial_tab (student_name) values ('Raj'),('Mit'),('Jassi'),('Naman')
insert into employee.seq_trial_tab (student_name) values ('Yeti'), ('Roy'),('Nadda')

select * from employee.seq_trial_tab
2	"Raj"
6	"Mit"
10	"Jassi"
14	"Naman"
18	"Yeti"
1	"Roy"
5	"Nadda"

/* If you observer, after completig CYCLE, sqequence will start with "MINVALUE" and not with "START WITH" value mentioned */


---------------------

create sequence employee.seq_trail_1 start with 4 maxvalue 20 minvalue 3 increment by 4 cycle;
/* inserting same records */


4	"Raj"
8	"Mit"
12	"Jassi"
16	"Naman"
20	"Yeti"
3	"Roy"  -----> sequence will re-start with MINVALUE
7	"Nadda"



----------------------Descending sequence-------------------------

create sequence employee.seq_trail_1 start with 20 maxvalue 20 minvalue 2 increment by -4 cycle;

select * from employee.seq_trial_tab
20	"Raj"
16	"Mit"
12	"Jassi"
8	"Naman"
4	"Yeti"
20	"Roy"
16	"Nadda"

-----------------

/* Another way of assigning sequence to coulumn */

create table employee.seq_trial_tab (roll_no int, student_name varchar(10))

create sequence employee.seq_trail_1 start with 20 maxvalue 20 minvalue 2 increment by -4 cycle owned by employee.seq_trial_tab.roll_no;

/* owner- giving <schema_name>.<table_name>.<column_name>, it will assign dequence to column in table */

insert into employee.seq_trial_tab (roll_no, student_name) values (nextval('employee.seq_trail_1'),'Raj'),
(nextval('employee.seq_trail_1'),'Simmi'),
(nextval('employee.seq_trail_1'),'Yeto'),
(nextval('employee.seq_trail_1'),'Roy')


select * from employee.seq_trial_tab
20	"Raj"
16	"Simmi"
12	"Yeto"
8	"Roy"

---------------------------------------------

/* Alpha-numeric sequence */

create sequence trial_seq start with 1 increment by 2

create table t1(id varchar(5) default 'A00'||nextval('trial_seq'),
				emp_name text)
				
insert into t1 (emp_name) values ('Sushant')

select * from t1
"A007"	"Sushant"