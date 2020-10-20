/* DB- Employee, Schema- Train */

CREATE TABLE Customer(
	Customerid VarChar(10) Primary Key,
	Name Char(10),
	Mobile Int,
	Email Char(30), 
	Points Int)

CREATE TABLE Train(
	Trainid Varchar(10),
	Source Varchar(10),
	Destination Varchar(10),
	Stops Int CHECK  (Stops >='0' and Stops <='3'),
	Acquota Int,
	Nonacquota Int,
	Ticketprice Int)
		
CREATE TABLE Booking(
	Bookingid VarChar(10),
	Customerid VarChar(10),
	Trainid VarChar(10),
	Bookedon Date,
	Bookedfor Date,
	Amount Int)
	
INSERT INTO Customer
(Customerid, Customer_Na , Mobile, Email, Points) Values
('C001', 'Manoj Ram', 222245, 'rajva@ab.com', 1000),
('C002', 'Raj Varsh', 222222, 'rajvarsh@abc.com', NULL),
('C003', 'Gary Manu', 9412345, 'garymanu@sdf.com', 500),
('C004', 'Arnab Jain', 9335612, 'arnabjain@hfgb.com', NULL),
('C005', 'Palak Pal', 5423168, 'palakpal@sdgh.com', NULL),
('C006', 'Ram Kumar', 9865321, 'ramkumar@jbh.com', NULL)

INSERT INTO Train
(Trainid, Source, Destination, Stops, ACQuota, NonACQuota, Ticketprice) Values
('AA303', 'Mumbai', 'Nagpur', 1 , 29, 39, 2000),
('UA509', 'Nagpur', 'Surat', 1, 11, 22, 1500),
('CD011', 'Surat' , 'Nagpur' , 0, 25, 19, 2000),
('EF908', 'Nagpur' , 'Pune' , 1, 11, 10, 3000),
('CQ906', 'Pune' , 'Mumbai', 2, 22, 30, 3500)

INSERT INTO Booking
(Bookingid, Customerid, Trainid, Bookedon , BookedFor, Amount ) Values
('B001', 'C004', 'UA509', '31-12-2014', '22-01-2015', 3500),
('B002', 'C003', 'AA303', '31-12-2014', '31-01-2015', 4000 ),
('B003', 'C004', 'CD011', '31-12-2014', '15-01-2015', 4000 ),
('B004', 'C002', 'AA303', '09-01-2015', '23-01-2015', 4500 ),
('B005', 'C005', 'EF908', '10-01-2015', '20-03-2015', 4850 ),
('B006', 'C005', 'EF908', '12-01-2015', '24-01-2015', 4650 ),
('B007', 'C001', 'CD011', '13-01-2015', '23-02-2015', 3650 )

/*
Q1-display customerid of all the customer who have done booking multiple times for eg customer c004 has done multple bookings.
*/

Select Customerid from Booking group by Customerid having count(*)>1

"C005"
"C004"

/*
Q2- display customerid of the costomer who have booked a rain from Suat or to Surat. For eg for the given sample data customerid C004 would be one of the rows in the output
along with other rows.
*/

select distinct(b.Customerid) from Booking b inner join Train t on b.Trainid=t.Trainid and (t.Source='Surat' OR t.Destination='Surat')
                                                                                             ----extra caution while giving Brackets
"C001"
"C004"

/*
Q3-display the trainid , source, destination, and stops of the same destination. If the number of stops is 0, display 'Non-stop' display the recors only if more than one train arrive at the same destination.
*/

select t1.Trainid, t1.Source, t1.Destination, t1.Stops,
CASE
	when t1.Stops='0' then 'Non-stop'
	else 'Break journey'
end type_of_train
from Train t1 inner join Train t2 on t1.Destination=t2.Destination
and t1.Trainid<>t2.Trainid

"AA303"	 "Mumbai"	"Nagpur"	1	"Break journey"
"CD011"	 "Surat"	"Nagpur"	0	"Non-stop"


/*
Q4-for each trainid, display total number of bookings done and total number of quotaseats (AC+NONAC) whether or not a booking was made for train.
*/

select t.Trainid, count(Bookingid) no_of_bookings, (ACQuota+NonACQuota) quota from Train t left join Booking b on t.Trainid=b.Trainid 
group by t.Trainid, t.ACQuota,t.NonACQuota

"AA303"	 2	68
"EF908"	 2	21
"UA509"	 1	33
"CQ906"	 0	52
"CD011"	 2	44

/*
Q5- display the customerid, bookingid and trainid for the customers who have boked a round trip for eg;-  customer c004 has booked a round trip nagpur to sutrat , surat to nagpur.
*/
select b.Trainid,b.Customerid,b.Bookingid from Booking b, Train t, Train t1 where t.Trainid=b.Trainid
AND (t.Source=t1.Destination and t.Destination=t1.Source)
"UA509"	"C004"	"B001"
"CD011"	"C004"	"B003"
"CD011"	"C001"	"B007"

select b.Trainid,b.Customerid,b.Bookingid from  Booking b inner join Booking b1 on b.Customerid=b1.Customerid
AND b.Bookingid<>b1.Bookingid
"UA509"	"C004"	"B001"
"CD011"	"C004"	"B003"
"EF908"	"C005"	"B005"
"EF908"	"C005"	"B006"

select b.Trainid,b.Customerid,b.Bookingid from Booking b inner join Booking b1 on b.Customerid=b1.Customerid
AND b.Bookingid<>b1.Bookingid
inner join  Train t on t.Trainid=b.Trainid
inner join Train t1 on (t.Source=t1.Destination and t.Destination=t1.Source)
"CD011"	"C004"	"B003"
"UA509"	"C004"	"B001"

/*
Q6- TrainID, Total which has 2nd highest total amount
*/

select Trainid, sum(amount), dense_rank() over(order by sum(amount) desc) from Booking group by Trainid

"EF908"	 9500	1
"AA303"	 8500	2
"CD011"	 7650	3
"UA509"	 3500	4

