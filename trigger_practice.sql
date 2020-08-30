set search_path to trigger_practice;

select pg_get_serial_sequence('student','std_id');

select pg_get_serial_sequence('student_audit','id');

select currval(pg_get_serial_sequence('student_audit','id'));
select currval(pg_get_serial_sequence('student','std_id'));

select * from student;
select * from student_audit;

insert into student (first_name,last_name) values ('Shri','Yadav');




CREATE FUNCTION trigger_practice.log_last_name_change()
    RETURNS trigger
AS $$
	begin
		if new.last_name<>old.last_name then
			insert into student_audit(student_id, last_name, time_of_change)
			values (old.std_id,old.last_name,current_timestamp);
		end if;
	return new;
	end;
$$ language plpgsql;

CREATE TRIGGER last_name_change
    BEFORE UPDATE 
    ON trigger_practice.student
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_practice.log_last_name_change();
	

select * from student;

create table student_delete_audit(
deleted_std_id integer,
time timestamp with time zone);

-------------------Function to return trigger when delete opweration is performed on studen ttable----------

create or replace function delete_studenr()
returns trigger
as $$
begin
	insert into student_delete_audit values (old.std_id, current_timestamp);
	return old;
end;
$$ language plpgsql;


-----trigger to insert deleted student id----------

create trigger student_delete
after delete
on student
for each row
execute procedure delete_studenr();

select * from student;
select * from student_delete_audit;

delete from student where std_id=109;



**********************************************************************************************

**********************************************************************************************
-------TRIGGER FUNCTION AFTER INSERT-----------------

create table student_insert_log(
sr_no serial primary key,
std_id integer,
first_name text,
last_name text,
time_of_log timestamp with time zone)


create or replace function student_insert_audit()
returns trigger
as $$
begin
	insert into student_insert_log (std_id, first_name, last_name, time_of_log) values (new.std_id, new.first_name,new.last_name, now());
	return new;
end;
$$ language plpgsql;

create trigger student_insert_trigger
after insert on student
for each row
execute procedure student_insert_audit()

select * from student;
select * from student_insert_log;

insert into student values (111, 'xyz','heff');
insert into student (first_name, last_name) values ('abc','qwe');


select pg_get_serial_sequence('student_insert_log','sr_no');
select currval(pg_get_serial_sequence('student_insert_log','sr_no'));

select pg_get_serial_sequence('student','std_id');
select currval(pg_get_serial_sequence('student','std_id'));

alter sequence student_std_id_seq restart with 112;
**********************************************************************************************

**********************************************************************************************

ALTER TABLE employees
DISABLE TRIGGER log_last_name_changes;

**********************************************************************************************

**********************************************************************************************

---------------------Trigger to insert deatils in another table if salary if greaer that 10000-------------------

set search_path to schema_1_trial;

select * from employee;

create table trigger_practice.employee_track_credit_card(
employee_id integer,
name varchar(10),
dept varchar(10),
salary integer)

create or replace function trigger_practice.employee_track_credit_card_func()
returns trigger
as $$
	begin
		if new.salary>10000 then
			insert into trigger_practice.employee_track_credit_card values (new.emp_id,new.name,new.dept,new.salary);
		end if;
	return new;
	end;
$$ language plpgsql;


show search_path;

create trigger employee_track_credit_card_trigger
after insert on employee
for each row
execute procedure trigger_practice.employee_track_credit_card_func()

set search_path to schema_1_trial;

select * from employee;

insert into employee values (107, 'HBU', 'HOUSKEP', 11000)

select * from trigger_practice.employee_track_credit_card;

**********************************************************************************************

**********************************************************************************************
	
