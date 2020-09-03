create database bikeStore;

create user store_admin with password '*******';

create tablespace bike_store_space owner store_admin location 'F:\Postgres';

grant all privileges on database Bikestore to store_admin;
grant connect on database Bikestore to store_admin;



alter database Bikestore set tablespace bike_store_space;

----ERROR:  database "bikestore" is being accessed by other users
----DETAIL:  There is 1 other session using the database



-----after logging in as storeadmin
bikestore=> alter database bikestore set tablespace bike_store_space;
-----ERROR:  must be owner of database bikestore

alter database bikestore owner to store_admin;  ---- as a superuser

Sushant=# alter database bikestore set tablespace bike_store_space;
ALTER DATABASE

--It worked this time, I don't know how. 

==========================================================================================================
--Loged in as store_admin and created belw schema 

create schema Sales;
create schema Production;
\dn   --to check avilable schemas
================================================================================================

--In Production Schema
  --1. table Products
  --2. table Stocks

create table products(production_id int constraint prod_id_pk primary key,
					 product_name varchar(50) not null,
					 model_year int not null,
					 price numeric(9,2) not null)
					 


create table stocks(store_id int,
				   product_id int,
				   quantity int,
				   foreign key (product_id) references products(production_id),
				   constraint stock_pk primary key (store_id,product_id))
				   
=================================================================================================

--In Sales Schema

set session authorization 'store_admin';


create table stores(store_id int primary key,
				   store_name varchar(20) not null,
				   phone_no varchar(15),
				   city varchar(20),
				   state varchar(20))
				   
alter table production.stocks add foreign key (store_id) references stores(store_id)	----adding contraints on Stocks table in Product schema.

alter table stores alter column city set not null;

alter table stores alter column state set not null;


---------------------------------
/*Taking backup as of now, execute fron /bin location*/
pg_dump -U store_admin -d bikestore > F:\bikestore_backup.sql -- creates s sql file og all database objects as it is with same state.
---------------------------------

create sequence customer_id_seq start with 1101 increment by 1 maxvalue 9999
select nextval('customer_id_seq')
select * from pg_sequences where sequencename='customer_id_seq';

alter sequence customer_id_seq owner to store_admin;  --- I was logged in as admin user.


create table sales.customer( customer_id int default nextval('customer_id_seq'),
						   first_name varchar(10) not null,
						   last_name varchar(15) not null,
						   phone varchar(10) not null,
						   email_id varchar(15),
						   city varchar(20) not null,
						   state varchar(20) not null)
						   
select * from pg_catalog.pg_constraint;	


create table sales.orders(order_id serial primary key,
				         customer_id int references customer(customer_id),
						 order_status text constraint order_check check(order_status in('Pending','Processing','Rejected','Completed')),
						 order_date date default current_date,
						 store_id int,
						 foreign key (store_id) references stores(store_id))
/*
Above statement threw error like 'there is no unique constraint matching given keys for referenced table "customer"'
I googled, reason was no unique/primary contreiant was defined on coulm cutosmer_id in Customer table.
*/

alter table customer add primary key(customer_id);

/*
----ERROR:  must be owner of table customer
I checked current user and table owner then
*/

select * from pg_tables where tablename='customer';

/* 
Tbale was owned by 'postgres' and not 'store_admin'
*/

alter table customer owner to store_admin  -- as admin user 'postgres', then added primary key contrained and then Order table got created.


/*
'order_id serial primary key' will create sequence. To get these information, exevute below.
*/
select pg_get_serial_sequence('orders','order_id');
select currval(pg_get_serial_sequence('orders','order_id'));
select nextval('orders_order_id_seq')








	   



