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
  
  F    J    W     G        H      S      D        O
  From Join Where Group by Having Select Distinct Order by
 (Frank John's wicked grave hunts several dull owls.)
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

--7 Total number of bikes in earch store, show in order of store id

select sum(quantity), store_id from production.stocks group by store_id order by store_id
195	101
512	102
291	103
586	104
736	105
119	106
367	107
380	108
519	109
568	110

--8 Store with highest quantity

select store_id from production.stocks group by store_id having sum(quantity)=
(select sum(quantity) a from production.stocks group by store_id order by a desc fetch first row only)
105

/*
select sum(quantity) a from production.stocks group by store_id
736
586
568
519
512
380
367
291
195
119

Fetch clause will only shows required rows
*/

OR

select sum(quantity), store_id from production.stocks group by store_id having sum(quantity)=
(select max(a) from (select sum(quantity) a from production.stocks group by store_id) as foo)
736	105

--9 Which bike has highest stocks

select sum(s.quantity), s.product_id, p.product_name from production.stocks s inner join production.products p on s.product_id=p.production_id group by s.product_id,p.product_name having sum(s.quantity)=(select max(a) from (select sum(quantity) a from production.stocks group by product_id) as foo)

1419	1005	"Hero Splendor"

--10 Sale after Lockdown
select * from sales.orders where order_date > to_date('15-03-2020', 'DD-MM-YYYY')
3

--11. List out all customers who own bikes costing more that Rs 60,000.

select c.customer_id,first_name,product_name,price from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id inner join production.products p on o.product_id=p.production_id where p.price>60000

1102	"Sushant"	"Honda Unicorn"		65000.00
1106	"Ibrahim"	"Yamaha YZF R-15"	150000.00
1108	"Rahe"		"Honda Unicorn"		65000.00
1110	"Jay"		"Yamaha YZF R-15"	150000.00
1112	"Mohammad"	"Honda Unicorn"		65000.00
1114	"Akash"		"Yamaha YZF R-15"	150000.00

--12. List customers who have placed orders in different store than their own city. and check status. Should be 'rejected' if not, update the status to rejected.

select c.first_name, c.city customer_city, s.store_id, s.city store_city, o.order_id, o.order_status from customer c inner join orders o on c.customer_id=o.customer_id inner join stores s on o.store_id=s.store_id where c.city<>s.city

"Ibrahim"	"Jalandhar"	101	"Sangli"	7	"Rejected"

--13. Total sale of KK bike

select sum(p.price), s.store_id, s.store_name from sales.orders o inner join sales.stores s on o.store_id=s.store_id inner join production.products p on o.product_id=p.production_id where lower(s.store_name)='kk bikes' group by s.store_name

215000.00	110		"KK Bikes"

/*
BikeStore DB

In Production Schema
  1. Products (production_id, product_name, model_year, price)
  2. Stocks (store_id,product_id, quantity)

In Sales Schema
  1. Stores (store_id, store_name, phone_no, city, state)
  2. Customer (customer_id, first_name, last_name, phone, email_id, city, state)
  3. Orders (order_id, customer_id, order_status, order_date, store_id, product_id)
  4. Oerder_items
  
  F    J    W     G        H      S      D        O
*/

--14 Which store has maximun sale (amount)

select sum(p.price), s.store_id, s.store_name from sales.orders o inner join sales.stores s on o.store_id=s.store_id inner join production.products p on o.product_id=p.production_id
group by s.store_id having sum(p.price)=(select sum(p.price) a from sales.orders o inner join sales.stores s on o.store_id=s.store_id inner join production.products p on o.product_id=p.production_id group by s.store_id order by a desc fetch first row only)

215000.00	110		"KK Bikes"
215000.00	101		"Rajashree Bikes"

--15 Which store has maximum sale(quantity)
/*
Refer 6
*/

--16 Show state wise sale in amount

select s.state, sum(p.price) from sales.stores s inner join sales.orders o on o.store_id=s.store_id inner join production.products p on o.product_id=p.production_id where o.order_status<>'Rejected' group by s.state order by 2 desc

"Maharashtra"	260000.00
"Panjab"		225000.00
"Haryana"		215000.00
"Gujrat"		95000.00

/*
Added new row to orders table-

insert into sales.orders (customer_id, order_status, order_date, store_id) values (1104, 'Completed', to_date('28-08-2020', 'DD-MM-YYYY'), 101, 1245)
*/

--17 List customers who have placed more than one orders.

select count(*) no_of_orders, customer_id from sales.orders where lower(order_status)<>'rejected' group by customer_id having count(*)>1

2	1104

--18 Which bike has 2nd highest price

select * from production.products where price=(select max(price) from production.products where price<>(select max(price) from production.products))

1549	"Honda Unicorn"		2018	65000.00

--19 Bike with 4th highest price

select * from production.products where price=(select min(price) from production.products where price in (select distinct(price) from production.products order by 1 desc fetch first 4 rows only))

1289	"Bajaj Platina"		2020	45000.00

/*
select distinct(price) from production.products order by 1 desc fetch first 4 rows only

above will list out top 4 pices as we have distinct clase and fetch...only clause

select min(price) from production.products where price in (select distinct(price) from production.products order by 1 desc fetch first 4 rows only)

above will give min of 4 prices listed out by 1st query
*/

--20 Bike with N th highest proice

select * from production.products where price=(select min(price) from production.products where price in (select distinct(price) from production.products order by 1 desc fetch first "N" rows only))

--21 Customer who has brough bike which is 4th highest price among all the bikes.

select customer_id, product_name, price from sales.orders o inner join production.products p on o.product_id=p.production_id and price=(select min(price) from production.products where price in (select distinct(price) from production.products order by 1 desc fetch first 4 rows only))

1104	"Bajaj Platina"	 45000.00
1107	"Bajaj Platina"	 45000.00

--22 Stock of Bajaj Platina

select p.product_name, sum(quantity) total_stock from production.stocks s inner join production.products p on s.product_id=p.production_id where p.product_name='Bajaj Platina' group by p.product_name

"Bajaj Platina"	849


--23 Stock of Platina+Splendor in Maharashtra and Gujarat

select p.state, sum(s.quantity) from production.stocks s inner join sales.stores p on s.store_id=p.store_id where s.product_id in (1289,1005) and p.state in ('Maharashtra','Gujrat') group by p.state

"Gujrat"		829
"Maharashtra"	540

--24 Stock of Unicorn and R15 in KK bikes and Mohan Bikes

select p.product_name, sr.store_name, sum(stk.quantity) from sales.stores sr inner join production.stocks stk on sr.store_id=stk.store_id inner join production.products p on stk.product_id=p.production_id where p.product_name in ('Honda Unicorn','Yamaha YZF R-15') and sr.store_name in ('KK Bikes','Mohan Bikes') group by p.product_name, sr.store_name

"Honda Unicorn"		"KK Bikes"		170
"Honda Unicorn"		"Mohan Bikes"	20
"Yamaha YZF R-15"	"KK Bikes"		29
"Yamaha YZF R-15"	"Mohan Bikes"	40

--25 Use lenght, substring functions

select store_name, length(store_name), substring(store_name,3,5) from sales.stores

"Rajashree Bikes"	15	"jashr"
"Mohan Bikes"		11	"han B"
"Raj Bikes"			9	"j Bik"
"Patel Bieks"		11	"tel B"
"Chowdhari Bikes"	15	"owdha"
"Kothari Bikes"		13	"thari"
"Singh Bikes"		11	"ngh B"
"Singla Bikes"		12	"ngla "
"KK Bikes"			8	" Bike"
"Arya Bikes"		10	"ya Bi"

--26 Get average stock of Plantina

select p.product_name,round(avg(s.quantity)) from production.stocks s inner join production.products p on s.product_id=p.production_id and p.product_name like '%Platina%' group by p.product_name

"Bajaj Platina"	 94

--27 List bikes models whoses average stock across stores is greater that 100

select p.product_name,round(avg(s.quantity)) avrg from production.stocks s inner join production.products p on s.product_id=p.production_id group by p.product_name having round(avg(s.quantity))>100

"Hero Splendor"	158

/*
select p.product_name,round(avg(s.quantity)) avrg from production.stocks s inner join production.products p on
s.product_id=p.production_id group by p.product_name having avrg>100

ERROR:  column "avrg" does not exist
LINE 2: ...t_id=p.production_id group by p.product_name having avrg>100

*/

--28 Bike having least average stock 

select p.product_name,round(avg(s.quantity)) avrg from production.stocks s inner join production.products p on s.product_id=p.production_id group by p.product_name order by avrg fetch first 1 row only

"Yamaha YZF R-15"	31

--29	 Number of customers from Maharashta and Panjab whose orders are completed.

select c.state, count(o.order_id) from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id and c.state in ('Maharahstra','Panjab') and order_status='Completed'
group by c.state

"Maharahstra"	4
"Panjab"		3

/*
select c.state, count(o.order_id) from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id and c.state in ('Maharahstra','Panjab') and order_status='Rejected'
group by c.state

"Maharahstra"	1
"Panjab"		1

select c.state, count(o.order_id) from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id and c.state in ('Maharahstra','Panjab') and order_status='Processing'
group by c.state

"Panjab"	1

select c.state, count(o.order_id) from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id and c.state in ('Maharahstra','Panjab') and order_status='Rejected'
group by c.state

"Panjab"	1


select c.state, count(o.order_id) from sales.customer c inner join sales.orders o on c.customer_id=o.customer_id and c.state in ('Maharahstra','Panjab') group by c.state

"Maharahstra"	5
"Panjab"		6
*/


--30 Leading stores in selling bikes by quantity in descending order

select o.store_id, s.store_name,count(*) sold_quantity from sales.orders o inner join sales.stores s on o.store_id=s.store_id and o.order_status<>'Rejected' group by o.store_id, s.store_name order by 3 desc

109	 "Singla Bikes"		3
101	 "Rajashree Bikes"	2
103	 "Raj Bikes"		2
107	 "Singh Bikes"		2
105	 "Chowdhari Bikes"	2
110	 "KK Bikes"			2

/*
select o.store_id, s.store_name, o.order_status, count(*) sold_quantity from sales.orders o inner join sales.stores s on o.store_id=s.store_id 
--and o.order_status<>'Rejected'
group by o.store_id, s.store_name, o.order_status order by 4 desc
105	"Chowdhari Bikes"	"Completed"		2
103	"Raj Bikes"			"Completed"		2
109	"Singla Bikes"		"Completed"		2
101	"Rajashree Bikes"	"Completed"		2
101	"Rajashree Bikes"	"Rejected"		1
107	"Singh Bikes"		"Completed"		1
110	"KK Bikes"			"Pending"		1
110	"KK Bikes"			"Completed"		1
107	"Singh Bikes"		"Pending"		1
102	"Mohan Bikes"		"Rejected"		1
109	"Singla Bikes"		"Processing"	1

select o.store_id, s.store_name, o.order_status, count(*) sold_quantity from sales.orders o inner join sales.stores s on o.store_id=s.store_id and o.order_status<>'Rejected'
group by o.store_id, s.store_name, o.order_status order by 4 desc
103	"Raj Bikes"			"Completed"		2
105	"Chowdhari Bikes"	"Completed"		2
109	"Singla Bikes"		"Completed"		2
101	"Rajashree Bikes"	"Completed"		2
110	"KK Bikes"			"Pending"		1
110	"KK Bikes"			"Completed"		1
107	"Singh Bikes"		"Pending"		1
109	"Singla Bikes"		"Processing"	1
107	"Singh Bikes"		"Completed"		1
*/

--31 Group by on model years

Select model_year, count(*) from production.products group by model_year order by 1 desc

2020	1
2019	2
2018	2
2012	1

--32 Number of customers buying bikes of given model years

select p.model_year, count(o.order_id) from production.products p inner join sales.orders o on p.production_id=o.product_id group by p.model_year order by 1 desc

2020	2
2019	6
2018	6
2012	2

--33 Which model year bikes have sold max

select p.model_year from production.products p inner join sales.orders o on p.production_id=o.product_id group by p.model_year having count(*)=(select count(*) from production.products p inner join sales.orders o on p.production_id=o.product_id group by p.model_year order by 1 desc fetch first row only)

2018
2019

/*
select p.model_year, o.order_status, count(*) from production.products p inner join sales.orders o on p.production_id=o.product_id group by p.model_year, o.order_status order by 1 desc

2020	"Completed"		2
2019	"Completed"		3
2019	"Pending"		1
2019	"Processing"	1
2019	"Rejected"		1
2018	"Completed"		4
2018	"Pending"		1
2018	"Rejected"		1
2012	"Completed"		1
2012	"Pending"		1


select p.model_year, o.order_status, count(*) from production.products p inner join sales.orders o on p.production_id=o.product_id and order_status<>'Rejected' group by p.model_year, o.order_status order by 1 desc

2020	"Completed"		2
2019	"Completed"		3
2019	"Pending"		1
2019	"Processing"	1
2018	"Completed"		4
2018	"Pending"		1
2012	"Completed"		1
2012	"Pending"		1

select count(*) from production.products p inner join sales.orders o on p.production_id=o.product_id and order_status<>'Rejected' group by p.model_year order by 1 desc

2018	5
2019	5
2020	2
2012	2

--more precise query?
select p.model_year from production.products p inner join sales.orders o on p.production_id=o.product_id and order_status<>'Rejected' group by p.model_year having count(*)=(select count(*) from production.products p inner join sales.orders o on p.production_id=o.product_id and order_status<>'Rejected' group by p.model_year order by 1 desc fetch first row only)

2018
2019

Can use distinct for count(*) as well.
*/

/*
BikeStore DB

In Production Schema
  1. Products (production_id, product_name, model_year, price)
  2. Stocks (store_id,product_id, quantity)

In Sales Schema
  1. Stores (store_id, store_name, phone_no, city, state)
  2. Customer (customer_id, first_name, last_name, phone, email_id, city, state)
  3. Orders (order_id, customer_id, order_status, order_date, store_id, product_id)
  4. Oerder_items
  
  F    J    W     G        H      S      D        O
*/

--34 List customers names who have ordered bike models from 2012

select c.first_name, o.order_status,p.product_name,p.model_year from sales.customers c inner join sales.orders o on o.customer_id=c.customer_id 
inner join production.products p on o.product_id=p.production_id and p.model_year=2012 and o.order_status<>'Rejected'

"Manjeet"	 "Completed"	 "Yamaha RX-100"	 2012
"Ishpreet"	 "Pending"	     "Yamaha RX-100"	 2012

--35 List customers whose orders are in pending and bike model year is oldest

select c.first_name, o.order_status,p.product_name,p.model_year from sales.customer c inner join sales.orders o on o.customer_id=c.customer_id inner join production.products p on o.product_id=p.production_id and o.order_status<>'Pending' and p.model_year=(select distinct(model_year) from production.products order by model_year fetch first row only)

"Manjeet"	"Completed"	"Yamaha RX-100"	2012