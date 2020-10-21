/* DB- EMPLOYEE, Schema- Gift_shop */
CREATE TABLE gift(
giftid varchar(5) PRIMARY KEY,
giftname varchar(20),
category varchar(20),
price int,
discount int,
availability int);

CREATE table customer(
customerid varchar(5) PRIMARY KEY,
customername varchar(20),
location varchar(20));

CREATE TABLE giftorder(
orderid int PRIMARY KEY,
customerid varchar(5) REFERENCES customer1(customerid),
giftid varchar(5) REFERENCES gift(giftid),
quantity int,
shippingcity int);

aletr table giftorder alter column shippingcity type varchar(15)


INSERT INTO gift VALUES
('G101','Dream Catcher','Showpiece',500,10,63),
('G102','Cinnamon Candles','Home Decor',550,5,35),
('G103','Watch Box','Utilities',2000,20,18),
('G104','Music Plant Lamp','Home Decor',1500,15,5),
('G105','Crystal Platter','Utilities',2999,7,10),
('G106','Crystal Chariot','Showpiece',2000,15,32),
('G107','Wood Coaster Set','Utilities',1300,30,30),
('G108','Golden Foil Rose','Showpiece',500,30,30),
('G109','Photo Frames','Home Decor',500,30,30)


INSERT INTO customer VALUES
('C101','Jack','Delhi'),
('C102','John','Bangalore'),
('C103','Sam','Mumbai'),
('C104','Andrew','Bangalore'),
('C105','Anne','Delhi'),
('C106','Maria','Mumbai'),
('C107','Jeny','Bangalore')

INSERT INTO giftorder values
(1001,'C102','G104',2,'Delhi'),
(1002,'C103','G102',5,'Bangalore'),
(1003,'C105','G101',3,'Bangalore'),
(1004,'C102','G104',1,'Bangalore'),
(1005,'C101','G103',9,'Mysore'),
(1006,'C102','G101',8,'Mumbai'),
(1007,'C105','G106',4,'Chennai'),
(1008,'C105','G107',4,'Chennai'),
(1009,'C105','G108',5,'Mumbai'),
(1010,'C106','G105',6,'Mysore')

/* A. Numerick part of gitftid, giftname and discount in amount */

select substring(giftid,2), giftname, (price*discount/100) as pricereduction from gift
"101"	"Dream Catcher"		50
"102"	"Cinnamon Candles"	27
"103"	"Watch Box"			400

/* B. Cust id and gift id of ordered gifts for category other than 'Home decor' */

select g1.customerid,g1.giftid from giftorder g1, gift g where g1.giftid=g.giftid and g.category<>'Home Decor'
"C105"	"G101"
"C101"	"G103"
"C102"	"G101"
"C105"	"G106"
"C105"	"G107"
"C105"	"G108"
"C106"	"G105"

/* C. Display giftID, orderID for all gifts shipped to Mysore. Display NA in orderID, not shipped to Mysore or not orered at all  */
select g.giftid, COALESCE(to_char(o.orderid,'9999'),'NA') from gift g left join giftorder o on g.giftid=o.giftid and shippingcity='Mysore'
"G101"	"NA"
"G102"	"NA"
"G103"	"1005"
"G104"	"NA"
"G105"	"1010"
"G106"	"NA"
"G107"	"NA"
"G108"	"NA"
"G109"	"NA"

/* D. Gifts oerdered twice and more with availablity more than 40 units */
select o.giftid, g.giftname, g.availability, count(*) from gift g inner join giftorder o on g.giftid=o.giftid group by o.giftid, g.giftname, g.availability having count(*)>=2
"G101"	"Dream Catcher"	    63	2
"G104"	"Music Plant Lamp"	5	2

select o.giftid, g.giftname, g.availability, count(*) from gift g inner join giftorder o on g.giftid=o.giftid and g.availability>40 group by o.giftid, g.giftname, g.availability having count(*)>=2
"G101"	"Dream Catcher"	63	2



/* E. Display all Orders and All customers, 'N' where Customer do not belong to Bneglore. 'NA' for order is not palced or order is placd by customer  who do not belong to Benglore */

select coalesce(to_char(o.orderid,'9999'),'NA'), coalesce(c.customerid,'N') from giftorder o full outer join customer c on o.customerid=c.customerid 
and c.location='Bangalore'
		
"1001"	"C102"
"1002"	"N"
"1003"	"N"
"1004"	"C102"
"1005"	"N"
"1006"	"C102"
"1007"	"N"
"1008"	"N"
"1009"	"N"
"1010"	"N"
"NA"	"C104"
"NA"	"C107"
"NA"	"C101"
"NA"	"C106"
"NA"	"C105"
"NA"	"C103"

/* F. Giftorder placed by same customers for Home decor category  */

select distinct(x.orderid), x.customerid, x.giftid, g1.category from giftorder x inner join gift g1 on x.giftid=g1.giftid
inner join giftorder y on x.customerid=y.customerid and g1.category='Home Decor' and x.orderid<>y.orderid
1001	"C102"	"G104"	"Home Decor"
1004	"C102"	"G104"	"Home Decor"

/* G. Highest bill amount, use rank func */

select x.customerid, c.customername, sum((y.price-y.price*y.discount/100)*x.quantity) total_amount from gift y, customer c, giftorder x
where x.giftid=y.giftid and c.customerid=x.customerid group by x.customerid, c.customername
"C105"	"Anne"	13540
"C101"	"Jack"	14400
"C103"	"Sam"	2615
"C102"	"John"	7425
"C106"	"Maria"	16740