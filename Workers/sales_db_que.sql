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