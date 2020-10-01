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

--1.
select store_id, product_id, sum(quantity) over (partition by store_id) from production.stocks

101	1549	146
101	1537	146
101	1149	146
101	1005	146
101	1289	146
101	1245	146
---------------
102	1549	480
102	1537	480
102	1149	480
102	1005	480
102	1289	480
102	1245	480
---------------
103	1549	291
103	1537	291
103	1149	291
103	1005	291
103	1245	291
103	1289	291
---------------
/*and so on....for all store ids*/


/*
Difference between Windows function and Group by clause

Both methods grouo together a property say Store_ID or bike types etc. 
But other aggregate function operated on multiple ros and return one single row. But use of windows function does not cause rows to become grouped into a single output row.

For example, below query will give error
select store_id, product_id, sum(quantity) from production.stocks group by store_id order by store_id

ERROR:  column "stocks.product_id" must appear in the GROUP BY clause or be used in an aggregate function
LINE 1: select store_id, product_id, sum(quantity) from production.s...

And same can be accomplished by GROUP BY like below but for group of store id, there in single row for each group memenr.

select store_id, sum(quantity) from production.stocks group by store_id order by store_id
101	146
102	480
103	291
104	586
105	736
106	119
107	367
108	380
109	519
110	568
*/

--2.
select store_id, state, rank() over (partition by state order by store_id) from sales.stores

104	 "Gujrat"		1
105	 "Gujrat"		2
106	 "Gujrat"		3
---------------------
108	 "Haryana"		1
110	 "Haryana"		2
---------------------
101	 "Maharashtra"	1
102	 "Maharashtra"	2
103	 "Maharashtra"	3
---------------------
107	 "Panjab"		1
109	 "Panjab"		2

--3.
select store_id, product_id, quantity, rank() over (partition by store_id order by quantity desc) from production.stocks

101	1005	61	1
101	1149	25	2
101	1245	20	3 -->3
101	1549	20	3 -->3
101	1537	10	5 -->4
101	1289	10	5 -->4
-----------------
102	1005	170	1
102	1537	150	2
102	1289	100	3
102	1149	32	4
102	1549	20	5
102	1245	8	6
-----------------
103	1005	100	1
103	1549	70	2
103	1149	56	3
103	1289	50	4
103	1245	10	5
103	1537	5	6
-----------------
104	1005	200	1
104	1289	180	2
104	1537	126	3
104	1549	40	4
104	1149	27	5
104	1245	13	6
-----------------
107	1549		1
107	1537		1
107	1005	170	3 -->2
107	1289	125	4 -->3
107	1245	40	5 -->4
107	1149	32	6 -->5

/*RESULT NOT AS EXPECTED. NEED TO CHECK*/

/* Use dense_rank() function*/

--4. From each store bike with 2nd highest quantity

select * from
(select store_id,product_id, quantity, dense_rank() over (partition by store_id order by quantity desc) from production.stocks) as foo
where dense_rank=2

101	1149	25	2
102	1537	150	2
103	1549	70	2
104	1289	180	2
105	1537	189	2
106	1149	25	2
107	1005	170	2
108	1245	80	2
109	1005	300	2
110	1549	170	2



/*Result as expected with below query*/
select store_id,product_id, quantity, dense_rank() over (partition by store_id order by quantity desc) from production.stocks
where quantity is not null

101	1005	61	1
101	1149	25	2
101	1549	20	3
101	1245	20	3
101	1289	10	4
101	1537	10	4
-----------------
102	1005	170	1
102	1537	150	2
102	1289	100	3
102	1149	32	4
102	1549	20	5
102	1245	8	6
-----------------
103	1005	100	1
103	1549	70	2
103	1149	56	3
103	1289	50	4
103	1245	10	5
103	1537	5	6
-----------------
107	1005	170	1
107	1289	125	2
107	1245	40	3
107	1149	32	4
-----------------


/* More on windows function*/

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

select 
 production_id,
 product_name,
 price,
 avg(price) over (),
 max(price) over (),
 min(price) over ()
from production.products

1245	"Yamaha YZF R-15"	150000.00	64166.666666666667	150000.00	30000.00
1289	"Bajaj Platina"		45000.00	64166.666666666667	150000.00	30000.00
1549	"Honda Unicorn"		65000.00	64166.666666666667	150000.00	30000.00
1537	"Honda Activa"		40000.00	64166.666666666667	150000.00	30000.00
1149	"Yamaha RX-100"		30000.00	64166.666666666667	150000.00	30000.00
1005	"Hero Splendor"		55000.00	64166.666666666667	150000.00	30000.00


select 
 store_id,
 product_id,
 quantity,
 ceil(avg(quantity) over (partition by store_id)),
 max(quantity) over (partition by store_id),
 min(quantity) over (partition by store_id)
from production.stocks order by store_id

101	1549	20	25	61	10
101	1537	10	25	61	10
101	1149	25	25	61	10
101	1005	61	25	61	10
101	1289	10	25	61	10
101	1245	20	25	61	10
--------------------------
102	1549	20	80	170	8
102	1537	150	80	170	8
102	1149	32	80	170	8
102	1005	170	80	170	8
102	1289	100	80	170	8
102	1245	8	80	170	8
-------------------------
103	1549	70	49	100	5
103	1537	5	49	100	5
103	1149	56	49	100	5
103	1005	100	49	100	5
103	1245	10	49	100	5
103	1289	50	49	100	5
-------------------------
106	1289	26	20	26	10
106	1245	20	20	26	10
106	1549	20	20	26	10
106	1537	18	20	26	10
106	1149	25	20	26	10
106	1005	10	20	26	10
--------------------------
107	1549		92	170	32
107	1537		92	170	32
107	1149	32	92	170	32
107	1005	170	92	170	32
107	1289	125	92	170	32
107	1245	40	92	170	32