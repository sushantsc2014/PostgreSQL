/*  EMPLOYEE Database, schema- Public */
CREATE TABLE Customer(
Customerid Int Primary Key,
Customer_name Varchar(25),
Contact_No Int,
DOB DATE,
Gender varchar(1)  CHECK (Gender IN ( 'F' , 'M' ) ),
Amount_spent Int
)


CREATE TABLE CreditCard(
Cardno varchar(20) Primary key,
Customerid INT,
Cardtype varchar(10),
DOE DATE,
Creditlimit int
)

CREATE TABLE Transaction(
Transactionid  varchar(10),
Cardno Varchar(10),
DOT date,
Tamount Int 
)


INSERT INTO Customer
(Customerid, Customer_name, Contact_No, DOB, Gender, Amount_spent) Values
(1001, 'Ridhima', 986532158, '22-11-1982', 'F', 0),
(1002, 'Anuj', 225568558, '10-08-1977', 'M', 40000),
(1003, 'Arvind', 859696963, '24-03-1989', 'M', 800000),
(1004, 'Antra', 748596123, '07-09-1970', 'F', 0),
(1005, 'Joseph', 986532147, '19-01-1979', 'M', 60000),
(1006, 'Ragini', 932145782, '28-11-1988', 'F', 30000),
(1007, 'Sara', 793625841, '23-01-1990', 'M', 0)


INSERT INTO CreditCard
(	, Customerid, Cardtype, DOE, Creditlimit) Values
('C101', 1002, 'Platinum', '15-08-2016', 40000),
('C102', 1005, 'Gold', '06-10-2016', 25000),
('C103', 1005, 'Platinum', '23-04-2017', 60000),
('C104', 1003, 'Silver', '28-11-2018', 55000),
('C105', 1006, 'Gold', '03-01-2020', 30000),
('C106', 1003, 'Silver', '04-10-2017', 45000),
('C107', 1001, 'Gold', '25-11-2016', 25000),
('C108', 1005, 'Silver', '18-09-2017', 45000),
('C109', 1004, 'Silver', '18-09-2016', 55000)


INSERT INTO Transaction
(Transactionid, Cardno, DOT, Tamount ) Values
('T101', 'C101', '13-03-2014', 40000),
('T102', 'C102', '09-10-2014', 20000),
('T103', 'C104', '10-04-2015', 45000),
('T104', 'C105', '14-04-2015', 20000),
('T105', 'C103', '21-06-2015', 40000),
('T106', 'C105', '24-07-2015', 100000),
('T107', 'C106', '02-11-2015', 35000)


/*
Q1- display customerid , custname , amountspent for those customers whose name contains letter i anywhere and the dob lies beytween nav 1982, dec 1988.
*/

select customerid, customer_name, Amount_spent from customer where customer_name like '%i%' and 
DOB between '01-11-1982' and '31-12-1988';

--sushant
select Customerid, Customer_name, Amount_spent from Customer where Customer_name like '%i%' and DOB
between '01-11-1982' and '31-12-1988'
---

/*
Q2-display concatanation of customername and custid as CUSTDETAILS contactno and gender of male customers who do not have credit card .
*/

select concat(customer_name, '-', customerid)as CUSTDETAILS, contact_No, gender  from customer 
 where gender='M' and customerid not in 
(select c1.customerid from creditcard c1 inner join customer c on c.customerid=c1.customerid);

--sushant
select concat(customer_name, '-', customerid) as CUSTDETAILS, contact_No, gender  from customer where
gender='M' and Customerid not in (select distinct(Customerid) from CreditCard)
--

/*
Q3-display customerid and total credit limit of the customer as "total credit limit" whose total credit limit is more than the average credit lomit of all the creditcards.
*/

select customerid , sum(creditlimit) as "TOTAL CREDIT LIMIT" from creditcard
 group by customerid having sum(creditlimit)>(select avg(creditlimit) from creditcard);
 
 --same---
 
 /*
Q4- display customerid and transactionid of those customers who have done transaction with the same tamout.
*/
select c.Customerid, t1.Transactionid, t1.Cardno, t2.Tamount  from CreditCard c inner join Transaction t1 on c.Cardno=t1.Cardno
inner join Transaction t2
on t1.Tamount=t2.Tamount and t1.Transactionid<>t2.Transactionid

/*
Q5- Details of all customers with card type and transactions made if any
*/

select c.Customerid, coalesce(cc.Cardno,'NA') as Card_Owned, t.Tamount as amount 
from Customer c left join CreditCard cc on c.Customerid=cc.Customerid
left join Transaction t on cc.Cardno=t.Cardno

1002	"C101"	40000
1005	"C102"	20000
1003	"C104"	45000
1006	"C105"	20000
1005	"C103"	40000
1006	"C105"	100000
1003	"C106"	35000
1005	"C108"	
1001	"C107"	
1004	"C109"	
1007	"NA"			

/*
Q6- Customer who has all types of card
*/
select cc.Customerid, c.Customer_name from CreditCard cc inner join Customer c on cc.Customerid=c.Customerid
group by cc.Customerid,c.Customer_name having count(Cardtype)=3

/*
Q7- Cardtype which is used for transaction max. number of times, display cutomer no. of those who are owing this type of credit card.
*/

select c.Customerid, c.Customer_name from Customer c, CreditCard cc where c.Customerid=cc.Customerid and cc.Cardtype= 
(select cc.Cardtype from Transaction t inner join CreditCard cc on t.Cardno=cc.Cardno 
group by cc.Cardtype having count(*)=(select max(a) from (select count(*) a from Transaction t inner join CreditCard cc on t.Cardno=cc.Cardno 
group by cc.Cardtype) foo))


1001	"Ridhima"
1005	"Joseph"
1006	"Ragini"

with ABC as
(select cc.Cardtype, rank() over(partition by cardtype order by t.Transactionid)
from Customer c, CreditCard cc, Transaction t 
where c.Customerid=cc.Customerid and cc.Cardno=t.Cardno)
select  c.Customerid, c.Customer_name from Customer c, CreditCard cc where c.Customerid=cc.Customerid and cc.Cardtype=
(select Cardtype from ABC where rank=(select max(rank) from ABC))

1001	"Ridhima"
1005	"Joseph"
1006	"Ragini"

/*
Q8- Customer ID of male cutomers who have done txn using Platinum card
*/

select cc.Customerid from Customer c, CreditCard cc, Transaction t
where c.Customerid=cc.Customerid and cc.Cardno=t.Cardno and c.Gender='M' and cc.Cardtype='Platinum'

/*
Q9- Total amount spend by GOLD card type
*/

select c.Cardtype,sum(t.Tamount) from CreditCard c, Transaction t where c.Cardno=t.Cardno and c.Cardtype='Gold' group by c.Cardtype
"Gold"	140000

/*
Q10-Cross join card type and transaction
*/

select coalesce(Transactionid,'NA'), c.Cardno from Transaction t full outer join CreditCard c on t.Cardno=c.Cardno

"T101"	"C101"
"T102"	"C102"
"T103"	"C104"
"T104"	"C105"
"T105"	"C103"
"T106"	"C105"
"T107"	"C106"
"NA"	"C108"
"NA"	"C107"
"NA"	"C109"

/*
Q11- Full outer join on all thre tables --this is same as Q5,
*/

select c.Customerid, cc.Cardno, t.Transactionid from Customer c full outer join CreditCard cc on c.Customerid=cc.Customerid
full outer join Transaction t on cc.Cardno=t.Cardno

1002	"C101"					"T101"
1005	"C102"					"T102"
1003	"C104"					"T103"
1006	"C105"					"T104"
1005	"C103"					"T105"
1006	"C105"					"T106"
1003	"C106"					"T107"
1007	"Dont have credit card"	"No transaction made"
1005	"C108"					"No transaction made"
1001	"C107"					"No transaction made"
1004	"C109"					"No transaction made"