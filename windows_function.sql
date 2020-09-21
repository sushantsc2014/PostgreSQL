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