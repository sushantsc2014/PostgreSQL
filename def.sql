set search_path to schema_1_trial

select * from schema_1_trial.employee

alter table employee add project varchar(10) references schema_2.project(project_code)

update employee set project='P3' where emp_id in (105, 106, 107)
select * from computer

select max(salary), round(avg(salary)), project from employee group by project

select emp_id, name, dept, e.comp_id, c.make, e.project, client from employee e 
inner join schema_2.project p on e.project=p.project_code
inner join computer c on e.comp_id=c.comp_id

select current_date, current_time
and (dept='ETA' or dept='CCD')

create schema schema_2

set search_path to schema_2

create table project(
project_code varchar(10) primary key,
client varchar(10) NOT NULL,
Emp_map integer references schema_1_trial.employee(emp_id),
location varchar(10))

select * from schema_2.project

insert into project values ('P1', 'CITI', 103, 'UK')

alter table  project drop location
