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

/* Trigeer on BikeStore DATABASE' STOCK table*/

--Requirement: Whenever quantity for certain bike goes down below decided amount, it should go to stock check table. Suppose, if Patina stocks goes below 20 units, it will go to table quantity_tracl and will show store_id and quantity to fill up.



create table production.quantity_track(store_id int, product_id int, quantity_to_fill int)


create or replace function production.quamtity_track_in_store()
	returns trigger
as $$
	begin
		CASE
			when product_id='1245' and new.quantity<=10 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when product_id='1289' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when product_id='1549' and new.quantity<=15 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);				
			when product_id='1537' and new.quantity<=2 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when product_id='1149' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when product_id='1005' and new.quantity<=60 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
		END CASE;
	return new;
END
$$ language plpgsql;


create trigger stock_tracker_trigger
after update of quantity on production.stocks
for each row
execute procedure production.quamtity_track_in_store()

select * from stocks where product_id='1245' and store_id=102
102	  1245	 40

select * from production.quantity_track
--EMPTY--

/*

ERROR--------->
update production.stocks set quantity='8' where product_id='1245' and store_id='102'

sql state: 42703 postgresql (42703	UNDEFINED COLUMN	undefined_column)

I had to modify create function slightly.

create or replace function production.quamtity_track_in_store()
	returns trigger
as $$
	begin
		CASE
			when old.product_id='1245' and new.quantity<=10 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when old.product_id='1289' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when old.product_id='1549' and new.quantity<=15 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);				
			when old.product_id='1537' and new.quantity<=2 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when old.product_id='1149' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
			when old.product_id='1005' and new.quantity<=60 then
				insert into production.quantity_track values (old.store_id,old.product_id,old.quantity-new.quantity);
		END CASE;
	return new;
END
$$ language plpgsql;

(/// Have to mention old.product_id ---- only product_id coulumn would be ambiguous)
*/

update production.stocks set quantity='8' where product_id='1245' and store_id='102'

select * from production.stocks where product_id='1245' and store_id='102'
102	  1245	 8

select * from production.quantity_track
102	  1245	 32

/*
I again did something wrong. Quantity to fill would be threshold-new_quantity
*/
create or replace function production.quamtity_track_in_store()
	returns trigger
as $$
	begin
		CASE
			when old.product_id='1245' and new.quantity<=10 then
				insert into production.quantity_track values (old.store_id,old.product_id,10-new.quantity);
			when old.product_id='1289' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,20-new.quantity);
			when old.product_id='1549' and new.quantity<=15 then
				insert into production.quantity_track values (old.store_id,old.product_id,15-new.quantity);				
			when old.product_id='1537' and new.quantity<=2 then
				insert into production.quantity_track values (old.store_id,old.product_id,2-new.quantity);
			when old.product_id='1149' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,20-new.quantity);
			when old.product_id='1005' and new.quantity<=60 then
				insert into production.quantity_track values (old.store_id,old.product_id,60-new.quantity);
			else null;	
		END CASE;
	return new;
END
$$ language plpgsql;

/*
update production.stocks set quantity='40' where product_id='1245' and store_id='102'

When I tried to again update quantity back to 40 (above threshold), it should go through ELSE block, whch was missing.

ERROR:  case not found
HINT:  CASE statement is missing ELSE part.
CONTEXT:  PL/pgSQL function production.quamtity_track_in_store() line 3 at CASE
SQL state: 20000


ERROR:  EXIT cannot be used outside a loop, unless it has a label
LINE 19:     exit;
             ^
SQL state: 42601
Character: 1028

(else null;)
*/

update production.stocks set quantity='40' where product_id='1245' and store_id='102'

select * from production.stocks where product_id='1245' and store_id='102'

102	  1245	 40

update production.stocks set quantity='8' where product_id='1245' and store_id='102'

select * from production.stocks where product_id='1245' and store_id='102'

102	1245	8

--now, this should trigger our function as quanitty is less than 10 for product_id 1245--

select * from production.quantity_track

102	  1245	 32  --ignore this 1st row, as it it for previoys transaction---
102	  1245	 2  

--this trigger function should not have any effect if quantity is updated to any value to or above threshold value. For example, for product_id 1005 threshold is 60. I'll update quanitty in oneof the store to 61. So, though trigger function will invoked, but ELSE block in CASE statement will ignore this.

select store_id, product_id, quantity from production.stocks where product_id='1005' and store_id='101'

101	 1005	110

update production.stocks set quantity='61' where product_id='1005' and store_id='101'

select store_id, product_id, quantity from production.stocks where product_id='1005' and store_id='101'

101	 1005	61

select * from production.quantity_track  --no row was created beacuse of last update on quantity of product_id 1005
102	1245	32
102	1245	2

=========================================================================================
=========================================================================================

/* Requirement: When new order is placed, shoud check customer city and store city where order is placd. If match, then okay. If not, should notify. i.e. Customer from Sangli should place order in Sangli store only.*/

create table trigger_tables.order_city_check(order_id int, customer_id int, store_id int, customer_city varchar(20), placed_store_city varchar(20), suggested_store int)


create or replace function sales.order_city_check()
	returns trigger
as $$
declare
	city_1 varchar(20) default (select city from sales.customer where customer_id=new.customer_id);
	city_2 varchar(20) default (select city from sales.stores where store_id=new.store_id);
	store_id_1 int default (select store_id from sales.stores where city=city_1); 	
	begin
		if city_1<>city_2 then
			insert into trigger_tables.order_city_check values (new.order_id, new.customer_id, new.store_id, city_1, city_2, store_id_1);
		end if;
	return new;
END
$$ language plpgsql;


create trigger order_city_check_trigger
before insert on sales.orders
for each row
execute procedure sales.order_city_check()


select * from trigger_tables.order_city_check;
--empty--

insert into sales.orders (customer_id, order_status, order_date, store_id) values (1102, 'Pending', to_date('20-09-2020', 'DD-MM-YYYY'), 110)
update sales.orders set product_id=1549 where order_id=23

select * from sales.orders where order_date=current_date
23	1102	"Pending"	"2020-09-20"	110	1549

/*Cust id-1102; cust city- Sangli
  Store_id-110; store_city- Panchkula
*/

select order_id, customer_id, store_id, customer_city, palced_store_city, suggested_store from trigger_tables.order_city_check
 
          23	    1102	    110	       "Sangli"	       "Panchkula"	         101

/*So our trigger is working as expected. When I inserted order from cutsomer based in Sangli, MH and placed order in store_id 110 which is based in Panchkula, Haryana
it inserted new row in new table giving information and also suggestion for STORE_ID where order should be diverted.*/

================================================================================================
================================================================================================

/* RAISE EXCEPTION TRIGGER*/

CREATE OR REPLACE FUNCTION model_year_check() 
RETURNS trigger AS $$
BEGIN 
  IF NEW.model_year < 2009 THEN 
    RAISE EXCEPTION 'cannot have this olb bike'; 
  END IF; 
  return new; 
END;
$$
LANGUAGE plpgsql;

create trigger model_year_check_trig before insert on production.products for each row execute procedure model_year_check()

/* Inserting bike with model year 2008, that should raise an exception*/
insert into production.products values (1289,'Bajaj Platina', 2008, 45000)

ERROR:  cannot have this olb bike
CONTEXT:  PL/pgSQL function production.model_year_check() line 4 at RAISE

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

/*
Something I didn't know.
do $$
begin
if '3' < '5' then
	raise info 'information message %', now() ;
end if;
end $$;

*/	
