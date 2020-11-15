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