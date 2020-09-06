/*
BikeStore DB

In Production Schema
  1. Products (production_id, product_name, model_year, price)
  2. table Stocks (store_id,product_id, quantity)

In Sales Schema
  1. Stores (store_id, store_name, phone_no, city, state)
  2. Customer (customer_id, first_name, last_name, phone, email_id, city, state)
  3. Orders (order_id, customer_id, order_status, order_date, store_id, product_id)
  4. Oerder_items
*/

set session authorization "store_admin"

--1. list of all the customer
select customer_id,first_name from sales.customer
1103	"Shirish"                                                  
1102	"Sushant"
1104	"Rohit"
1105	"Jay"
1106	"Ibrahim"
1107	"Manpreet"
1108	"Rahe"
1109	"Manjeet"
1110	"Jay"
1111	"Amit"
1112	"Mohammad"
1113	"Ishpreet"
1114	"Akash"
1115	"Simreet"


--2. Joining three tables Stores, Customer, Orders

select c.customer_id,c.first_name,c.city,o.order_id,o.order_status,o.store_id,s.store_name,s.city from sales.customer c
inner join sales.orders o on c.customer_id=o.customer_id inner join sales.stores s on o.store_id=s.store_id

1102	"Sushant"	"Sangli"	3	"Completed"		101	"Rajashree Bikes"	"Sangli"
1103	"Shirish"	"Pune"		4	"Rejected"		102	"Mohan Bikes"		"Pune"
1104	"Rohit"		"Kolhapur"	5	"Completed"		103	"Raj Bikes"			"Kolhapur"
1105	"Jay"		"Jamnagar"	6	"Completed"		105	"Chowdhari Bikes"	"Jamnagar"
1106	"Ibrahim"	"Jalandhar"	7	"Rejected"		101	"Rajashree Bikes"	"Sangli"
1107	"Manpreet"	"Bhatinda"	8	"Completed"		107	"Singh Bikes"		"Bhatinda"
1108	"Rahe"		"Panchkula"	9	"Completed"		110	"KK Bikes"			"Panchkula"
1109	"Manjeet"	"Jalandhar"	10	"Completed"		109	"Singla Bikes"		"Jalandhar"
1110	"Jay"		"Kolhapur"	11	"Completed"		103	"Raj Bikes"			"Kolhapur"
1111	"Amit"		"Jamnagar"	12	"Completed"		105	"Chowdhari Bikes"	"Jamnagar"
1112	"Mohammad"	"Jalandhar"	13	"Completed"		109	"Singla Bikes"		"Jalandhar"
1113	"Ishpreet"	"Bhatinda"	14	"Pending"		107	"Singh Bikes"		"Bhatinda"
1114	"Akash"		"Panchkula"	15	"Pending"		110	"KK Bikes"			"Panchkula"
1115	"Simreet"	"Jalandhar"	16	"Processing"	109	"Singla Bikes"		"Jalandhar"


--3. List customers belonging to Jalandhar city with rejected order, case insensitive search

select c.customer_id,c.first_name,c.city,o.order_id,o.order_status,o.store_id from sales.customer c
inner join sales.orders o on c.customer_id=o.customer_id where upper(c.city)='JALANDHAR' and upper(o.order_status)='REJECTED'

1106	"Ibrahim"	"Jalandhar"	7	"Rejected"	101

--4. Customers who have brough Honda Unicorn

select production_id from production.products where lower(product_name)='honda unicorn'

select c.customer_id,c.first_name,o.order_status from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id where o.product_id=(select production_id from production.products where lower(product_name)='honda unicorn')

1102	"Sushant"	"Completed"
1108	"Rahe"		"Completed"
1112	"Mohammad"	"Completed"

 --Number of customers who have brough Honda Unicorn
select count(*) from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id where o.product_id=(select production_id from production.products where lower(product_name)='honda unicorn')
3

--5 Sale of Chowdhari Bikes

select count(order_id) from sales.orders where store_id=(select store_id from sales.stores where lower(store_name)='chowdhari bikes')
2

--6 Which store has sold max number of bikes

select store_id, count(*) from sales.orders group by store_id having count(*)=(select max(a) from (select count(*) a from sales.orders group by store_id) as sales)
109	3

/*
select count(*), store_id from sales.orders group by store_id
2	101
2	103
2	105
2	107
1	102
3	109 ----> What we need
2	110

select max(a) from (select count(store_id) a from sales.orders group by store_id)

ERROR:  subquery in FROM must have an alias
LINE 1: select max(a) from (select count(store_id) a, store_id from ...
                           ^
HINT:  For example, FROM (SELECT ...) [AS] foo.
SQL state: 42601
Character: 20

Hence
select max(a) from (select count(store_id) a, store_id from sales.orders group by store_id) as xyz
*/

