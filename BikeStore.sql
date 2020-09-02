>create database bikeStore;

>create user store_admin with password '*******';

>create tablespace bike_store_space owner store_admin location 'F:\Postgres';

>grant all privileges on database Bikestore to store_admin;
>grant connect on database Bikestore to store_admin;



>alter database Bikestore set tablespace bike_store_space;

----ERROR:  database "bikestore" is being accessed by other users
----DETAIL:  There is 1 other session using the database



-----after logging in as storeadmin
>bikestore=> alter database bikestore set tablespace bike_store_space;
-----ERROR:  must be owner of database bikestore

alter database bikestore owner to store_admin;  ---- as a superuser

>Sushant=# alter database bikestore set tablespace bike_store_space;
ALTER DATABASE

--It worked this time, I don't know how. 

==========================================================================================================

--Loged in as store_admin and created belw schema 


>create schema Sales;
>create schema Production;
>\dn   --to check avilable schemas



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
				   
				   



