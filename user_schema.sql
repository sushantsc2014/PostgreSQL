select current_database();
select current_user;

create schema inherit_practice;

create table father(
propery_id integer primary key,
proprty_name text);

create table son(
son_property_name text) inherits (father);

alter table father set schema inherit_practice;
alter table son set schema inherit_practice;

--------------------------------------------------------------------
--------------------------------------------------------------------


select current_database();
select current_user;
select session_user;

set session authorization 'postgres';

select current_user, session_user;

--------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------

set search_path to schema_1_trial;

create table Employee (
Emp_ID integer primary key,
Name varchar(10) NOT NULL,
Dept varchar(10),
Salary integer)

select * from employee

create table Computer (
comp_id integer primary key,
make varchar(10),
model integer)


select current_date, current_time




create function totalRecords()
returns integer as $total$
declare
       total integer;
begin
	select count(*) into total from project;
	return total;
end;
$total$ language 'plpgsql';

drop function totalRecords();


#######FUNCTION, TRIGGERS -----------------------------------------------------------------------------------------------------------

create table project_audit (
p_code varchar(10),
time timestamp)

create or replace function project_audit_log()
returns trigger
as $$
begin
	insert into project_audit (p_code, time) values (new.project_code, current_timestamp);
	return new;
end;
$$ language plpgsql;



create trigger test_trigger 
after insert on project
for each row
execute procedure project_audit_log();
-------------------------------------------------------------------------------------------------------------------------------------