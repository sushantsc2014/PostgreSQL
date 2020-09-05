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
==========================================================================================================
/*
In Production Schema
  1. Products
  2. table Stocks
*/

create table products(production_id int constraint prod_id_pk primary key,
					 product_name varchar(50) not null,
					 model_year int not null,
					 price numeric(9,2) not null)
					 

insert into products values (1245,'Yamaha YZF R-15', 2019, 150000)
insert into products values (1289,'Bajaj Platina', 2020, 45000)
insert into products values (1549,'Honda Unicorn', 2018, 65000)
insert into products values (1537,'Honda Activa', 2018, 40000)
insert into products values (1149,'Yamaha RX-100', 2012, 30000)
insert into products values (1005,'Hero Splendor', 2019, 55000)
					 


create table stocks(store_id int,
				   product_id int,
				   quantity int,
				   foreign key (product_id) references products(production_id),
				   constraint stock_pk primary key (store_id,product_id))
				   
insert into production.stocks values (101, 1245, 20), (101, 1289, 10), (101, 1549, 20), (101, 1537, 10), (101, 1149, 25), (101, 1005, 110)
insert into production.stocks values (102, 1245, 40), (102, 1289, 100), (102, 1549, 20), (102, 1537, 150), (102, 1149, 32), (102, 1005, 170)
insert into production.stocks values (103, 1245, 10), (103, 1289, 50), (103, 1549, 70), (103, 1537, 5), (103, 1149, 56), (103, 1005, 100)
insert into production.stocks values (104, 1245, 13), (104, 1289, 180), (104, 1549, 40), (104, 1537, 126), (104, 1149, 27), (104, 1005, 200)
insert into production.stocks values (105, 1245, 29), (105, 1289, 154), (105, 1549, 79), (105, 1537, 189), (105, 1149, 26), (105, 1005, 259)

insert into production.stocks values (106, 1245, 20), (106, 1289, 26), (106, 1549, 20), (106, 1537, 18), (106, 1149, 25), (106, 1005, 10)
insert into production.stocks values (107, 1245, 40), (107, 1289, 125), (107, 1549, NULL), (107, 1537, NULL), (107, 1149, 32), (107, 1005, 170)
insert into production.stocks values (108, 1245, 80), (108, 1289, 50), (108, 1549, 70), (108, 1537, 24), (108, 1149, 56), (108, 1005, 100)
insert into production.stocks values (109, 1245, 26), (109, 1289, NULL), (109, 1549, 40), (109, 1537, 126), (109, 1149, 27), (109, 1005, 300)
insert into production.stocks values (110, 1245, 29), (110, 1289, 154), (110, 1549, 170), (110, 1537, 189), (110, 1149, 26), (110, 1005, NULL)
				   
===========================================================================================================
/*
In Sales Schema
  1. Stores
  2. Customer
  3. Orders
  4. Oerder_items
*/

set session authorization 'store_admin';


create table stores(store_id int primary key,
				   store_name varchar(20) not null,
				   phone_no varchar(15),
				   city varchar(20),
				   state varchar(20))
				   
alter table production.stocks add foreign key (store_id) references stores(store_id)	----adding contraints on Stocks table in Product schema.

alter table stores alter column city set not null;

alter table stores alter column state set not null;

insert into stores values (101,'Rajashree Bikes', 9856234578, 'Sangli', 'Maharashtra')
insert into stores values (102,'Mohan Bikes', 9856234589, 'Pune', 'Maharashtra')
insert into stores values (103,'Raj Bikes', 9845782145, 'Kolhapur', 'Maharashtra')
insert into stores values (104,'Patel Bieks', 7852634158, 'Vafi', 'Gujrat')
insert into stores values (105,'Chowdhari Bikes', 9987451236, 'Jamnagar', 'Gujrat')
insert into stores values (106,'Kothari Bikes', 9978451258, 'Kutch', 'Gujrat')
insert into stores values (107,'Singh Bikes', 7865894892, 'Bhatinda', 'Panjab')
insert into stores values (108,'Arya Bikes', 8987455578, 'Sonipath', 'Haryana')
insert into stores values (109,'Singla Bikes', 7589689875, 'Jalandhar', 'Panjab')
insert into stores values (110,'KK Bikes', 8987456325, 'Panchkula', 'Haryana')


---------------------------------
/*Taking backup as of now from CMD, execute fron /bin location*/
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
						   
insert into sales.customer (first_name, last_name, phone, email_id, city, state) values ('Sushant','Chavare',9423273722,'sushantsc2014@gmail.com','Sangli','Maharahstra'), ('Shirish','Patil',9423275234,NULL,'Pune','Maharahstra')

insert into sales.customer (first_name, last_name, phone, email_id, city, state) values ('Rohit','Pawar',8956234759,'rohit@hotmail.com','Kolhapur','Maharahstra'), ('Jay','Shah',5423698758,NULL,'Jamnagar','Gujrat'), ('Ibrahim','Katir',7856458963,NULL,'Jalandhar','Panjab'), ('Manpreet','Singh',7895685452,NULL,'Bhatinda','Panjab'), ('Rahe','Goel',568947526,'goel@hfr.com','Panchkula','Haryana'), ('Manjeet','Khattar',7856998526,NULL,'Jalandhar','Panjab')

insert into sales.customer (first_name, last_name, phone, email_id, city, state) values ('Jay','Rahane',4589625363,NULL,'Kolhapur','Maharahstra'), ('Amit','Shah',4589745896,NULL,'Jamnagar','Gujrat'), ('Mohammad','Ali',4589623587,NULL,'Jalandhar','Panjab'), ('Ishpreet','Singh',1256897459,NULL,'Bhatinda','Panjab'), ('Akash','Mehata',2356745891,'akash@hfr.com','Panchkula','Haryana'), ('Simreet','Dhillon',2586321458,NULL,'Jalandhar','Panjab')

/*
E mail ID for first touple was exceeding defined varying lenght 15, hence error
*/

alter table sales.customer alter column email_id type varchar(50)

update sales.customer set email_id='sushantsc204@gmail.com' where first_name='Sushant'
						   
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

--------------------------------------
insert into sales.orders (customer_id, order_status, order_date, store_id) values
(1102, 'Completed', to_date('02-01-2020', 'DD-MM-YYYY'), 101)

insert into sales.orders (customer_id, order_status, order_date, store_id) values
(1103, 'Rejected', to_date('28-01-2020', 'DD-MM-YYYY'), 102),(1104, 'Completed', to_date('02-02-2020', 'DD-MM-YYYY'), 103),
(1105, 'Completed', to_date('04-01-2020', 'DD-MM-YYYY'), 105),(1106, 'Rejected', to_date('12-02-2020', 'DD-MM-YYYY'), 101),
(1107, 'Completed', to_date('12-02-2020', 'DD-MM-YYYY'), 107),(1108, 'Completed', to_date('16-02-2020', 'DD-MM-YYYY'), 110),
(1109, 'Completed', to_date('25-02-2020', 'DD-MM-YYYY'), 109),(1110, 'Completed', to_date('27-02-2020', 'DD-MM-YYYY'), 103),
(1111, 'Completed', to_date('27-02-2020', 'DD-MM-YYYY'), 105),(1112, 'Completed', to_date('06-03-2020', 'DD-MM-YYYY'), 109),
(1113, 'Pending', to_date('28-04-2020', 'DD-MM-YYYY'), 107),(1114, 'Pending', to_date('10-05-2020', 'DD-MM-YYYY'), 110),
(1115, 'Processing', to_date('20-08-2020', 'DD-MM-YYYY'), 109)


/*
'order_id serial primary key' will create sequence. To get these information, exevute below.
*/
select pg_get_serial_sequence('sales.orders','order_id');
select currval(pg_get_serial_sequence('sales.orders','order_id'));
select nextval('sales.orders_order_id_seq')



create table order_items(order_id int references orders(order_id),
						item_id varchar(10),
						product_id int,
						quantity varchar(10) not null,
						price numeric(11,2) not null,
						constraint order_item_id_pk primary key (order_id,item_id),
						constraint fk_prod_id foreign key (product_id) references production.products(production_id))
						
-----------------------------
/*To check indexes*/
select * from pg_indexes where tablename='stores'
-----------------------------
