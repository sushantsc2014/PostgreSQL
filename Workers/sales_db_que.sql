/*
https://www.w3resource.com/sql-exercises/sql-joins-exercises.php  
*/

/* 1. Write a SQL statement to prepare a list with salesman name, customer name and their cities for the salesmen and customer who belongs to the same city. */
select s.name, c.cust_name, s.city, c.city from salesman s, customer c where s.city=c.city
"James Hoog"	"Brad Davis"		"New York"	"New York"
"James Hoog"	"Nick Rimando"		"New York"	"New York"
"Nail Knite"	"Fabian Johnson"	"Paris"		"Paris"
"Pit Alex"		"Brad Guzan"		"London"	"London"
"Pit Alex"		"Julian Green"		"London"	"London"
"Mc Lyon"		"Fabian Johnson"	"Paris"		"Paris"


/* 4. Write a SQL statement to find the list of customers who appointed a salesman for their jobs who gets a commission from the company is more than 12%. */
select c.customer_id, s.salesman_id, s.commision from salesman s, customer c where c.salesman_id=s.salesman_id
and s.commision>0.12

3002	5001	0.15
3007	5001	0.15
3005	5002	0.13
3008	5002	0.13
3004	5006	0.14
3003	5007	0.13

/* 7. Write a SQL statement to make a join on the tables salesman, customer and orders in such a form that the same column of each table will appear once and only the relational rows will come. */

select * from customer natural join orders natural join salesman

5005	"London"	3001	"Brad Guzan"				70009	270.65	"2012-09-10"	"Pit Alex"		0.11
5001	"New York"	3002	"Nick Rimando"		100		70002	65.26	"2012-10-05"	"James Hoog"	0.15
5001	"New York"	3007	"Brad Davis"		200		70005	2400.6	"2012-07-27"	"James Hoog"	0.15
5001	"New York"	3002	"Nick Rimando"		100		70008	5760	"2012-09-10"	"James Hoog"	0.15
5006	"Paris"	    3004	"Fabian Johnson"	300		70010	1983.43	"2012-10-10"	"Mc Lyon"		0.14
5001	"New York"	3002	"Nick Rimando"		100		70013	3045.6	"2012-04-25"	"James Hoog"	0.15

/* Natural join
Natural join does not use any comparison operator. We can perform a Natural Join only if there is at least one common attribute that exists between two relations. In addition, the attributes must have the same name and domain.
*/

/* 8. Write a SQL statement to make a list in ascending order for the customer who works either through a salesman or by own */

select c.customer_id, c.cust_name, c.salesman_id, s.salesman_id from customer c left join salesman s on c.salesman_id=s.salesman_id
order by 1
3001	"Brad Guzan"		5005	5005
3002	"Nick Rimando"		5001	5001
3003	"Jozy Altidor"		5007	5007
3004	"Fabian Johnson"	5006	5006
3005	"Graham Zusi"		5002	5002
3007	"Brad Davis"		5001	5001
3008	"Julian Green"		5002	5002
3009	"Geoff Cameron"		5003	5003

/* 12. Write a SQL statement to make a list in ascending order for the salesmen who works either for one or more customer or not yet join under any of the customers. */

select s.salesman_id, s.name, c.customer_id, c.cust_name, c.salesman_id  from customer c right join salesman s on c.salesman_id=s.salesman_id
order by 1

5001	"James Hoog"	3007	"Brad Davis"		5001
5001	"James Hoog"	3002	"Nick Rimando"		5001
5002	"Nail Knite"	3005	"Graham Zusi"		5002
5002	"Nail Knite"	3008	"Julian Green"		5002
5003	"Lauson Hen"	3009	"Geoff Cameron"		5003
5005	"Pit Alex"		3001	"Brad Guzan"		5005
5006	"Mc Lyon"		3004	"Fabian Johnson"	5006
5007	"Paul Adam"		3003	"Jozy Altidor"		5007

/* 13. Write a SQL statement to make a list for the salesmen who works either for one or more customer or not yet join under any of the customers who placed either one or more orders or no order to their supplier. */

select c.cust_name, s.salesman_id, s.name, o.order_no from salesman s left outer join orders o on s.salesman_id=o.salesman_id left outer join customer c on
o.customer_id=c.customer_id

"Graham Zusi"		5002	"Nail Knite"	70001
"Brad Guzan"		5005	"Pit Alex"		70009
"Nick Rimando"		5001	"James Hoog"	70002
"Geoff Cameron"		5003	"Lauson Hen"	70004
"Graham Zusi"		5002	"Nail Knite"	70007
"Brad Davis"		5001	"James Hoog"	70005
"Nick Rimando"		5001	"James Hoog"	70008
"Fabian Johnson"	5006	"Mc Lyon"		70010
"Geoff Cameron"		5003	"Lauson Hen"	70003
"Julian Green"		5002	"Nail Knite"	70012
"Jozy Altidor"		5007	"Paul Adam"		70011
"Nick Rimando"		5001	"James Hoog"	70013

/* 14. Write a SQL statement to make a list for the salesmen who either work for one or more customers or yet to join any of the customer. The customer may have placed, either one or more orders on or above order amount 2000 and must have a grade, or he may not have placed any order to the associated supplier.   */

select s.salesman_id, o.purchase_amnt, c.grade from salesman s left outer join customer c on s.salesman_id=c.salesman_id
left outer join orders o on c.customer_id=o.customer_id where (o.purchase_amnt>=2000 and c.grade is not null)

5001	2400.6	200
5001	5760	100
5003	2480.4	100
5001	3045.6	100

/* 15. Write a SQL statement to make a report with customer name, city, order no. order date, purchase amount for those customers from the existing list who placed one or more orders or which order(s) have been placed by the customer who is not on the list.  */

select c.cust_name, c.city, o.order_no, o.purchase_amnt from customer c full outer join orders o on c.customer_id=o.customer_id
"Graham Zusi"	"California"	70001	150.5
"Brad Guzan"	"London"		70009	270.65
"Nick Rimando"	"New York"		70002	65.26
"Geoff Cameron"	"Berlin"		70004	110.5
"Graham Zusi"	"California"	70007	948.5
"Brad Davis"	"New York"		70005	2400.6
"Nick Rimando"	"New York"		70008	5760
"Fabian Johnson"	"Paris"		70010	1983.43
"Geoff Cameron"	"Berlin"		70003	2480.4
"Julian Green"	"London"		70012	250.45
"Jozy Altidor"	"Moscow"		70011	75.29
"Nick Rimando"	"New York"		70013	3045.6
  /* Why FULL OUTER JOIN- 'customers from the existing list' --> All customer, which order(s) have been placed by the customer who is not on the list --> All orders */
  
/* 17. Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa.   */

-- CROSS JOIN 

select * from salesman s, customer c


/* 20. Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa for those salesmen who must belong a city which is not the same as his customer and the customers should have an own grade. */

select * from salesman s, customer c where s.city<>c.city and c.grade is not null

/* Write a query to display all the orders which values are greater than the average order value for 10th October 2012 */

select * from orders where purchase_amnt > (select avg(purchase_amnt) from orders where order_date='2012-10-10')
70005	2400.6	"2012-07-27"	3007	5001
70008	5760	"2012-09-10"	3002	5001
70003	2480.4	"2012-10-10"	3009	5003
70013	3045.6	"2012-04-25"	3002	5001

/* 8. Write a query to count the customers with grades above New York's average. */

select count(customer_id) from customer where grade>(select avg(grade) from customer where city='New York') and
grade is not null
5

select grade, count(customer_id) from customer group by grade having grade>(select avg(grade) from customer where city='New York')
200	3
300	2

/* 9. Write a query to extract the data from the orders table for those salesman who earned the maximum commission */

select * from orders where salesman_id in (select salesman_id from salesman where commision=(select max(commision) from salesman))
70002	65.26	"2012-10-05"	3002	5001
70005	2400.6	"2012-07-27"	3007	5001
70008	5760	"2012-09-10"	3002	5001
70013	3045.6	"2012-04-25"	3002	5001

/* 11. Write a query to find the name and numbers of all salesmen who had more than one customer. */

select c1.customer_id, c1.salesman_id from Customer c1 inner join Customer c2 on c1.salesman_id=c2.salesman_id AND
c1.customer_id<>c2.customer_id
3002	5001
3007	5001
3005	5002
3008	5002

select c1.customer_id, c1.salesman_id from customer c1 where c1.salesman_id in
(select c2.salesman_id from customer c2 where c1.salesman_id=c2.salesman_id and c1.customer_id<>c2.customer_id)
3002	5001
3007	5001
3005	5002
3008	5002

select salesman_id,name from salesman where salesman_id in
(select distinct(c1.salesman_id) from customer c1 where c1.salesman_id in
(select c2.salesman_id from customer c2 where c1.salesman_id=c2.salesman_id and c1.customer_id<>c2.customer_id))
5001	"James Hoog"
5002	"Nail Knite"

