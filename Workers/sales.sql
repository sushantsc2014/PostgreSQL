create table salesman ( salesman_id int primary key, name varchar(15), city varchar(10), commision float)


insert into salesman values (5001,"James Hoog","New York",0.15),(5002,'Nail Knite','Paris',0.13)
insert into salesman values (5005,'Pit Alex','London',0.11),(5006,'Mc Lyon','Paris',0.14),(5007,'Paul Adam','Rome',0.13),(5003,'Lauson Hen','San Jose',0.12)


create table customer ( customer_id int primary key, cust_name varchar(20), city varchar(20), grade int, salesman_id int references salesman(salesman_id))


insert into customer values (3002,'Nick Rimando','New York',100,5001),(3007,'Brad Davis','New York',200,5001),(3005,'Graham Zusi','California',200,5002),
(3008,'Julian Green','London',300,5002),(3004,'Fabian Johnson','Paris',300,5006), (3009,'Geoff Cameron','Berlin' ,100,5003), (3003,'Jozy Altidor','Moscow',200,5007),
(3001,'Brad Guzan','London',NULL,5005)

create table orders (order_no int primary key, purchase_amnt float, order_date date, customer_id int, salesman_id int,
foreign key (customer_id) references customer(customer_id),
foreign key (salesman_id) references salesman(salesman_id))



insert into orders values (70001,150.5,'2012-10-05',3005,5002)
insert into orders values (70009,270.65,'2012-09-10',3001,5005),(70002,65.26,'2012-10-05',3002,5001),(70004,110.5,'2012-08-17',3009 ,5003),(70007,948.5,'2012-09-10',3005,5002),
(70005,2400.6,'2012-07-27',3007,5001),(70008,5760,'2012-09-10',3002,5001),(70010,1983.43,'2012-10-10',3004,5006),(70003,2480.4,'2012-10-10',3009,5003),
(70012,250.45,'2012-06-27',3008,5002),(70011,75.29,'2012-08-17',3003,5007),(70013,3045.6,'2012-04-25',3002,5001)
