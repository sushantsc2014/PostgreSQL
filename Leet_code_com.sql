/* Leetcode.com problems */

--- 1
Write an SQL query to find all dates id with higher temperature compared to its previous dates (yesterday).

Weather
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+


select t1.id from Weather t1, Weather t2 where t1.recordDate=(t2.recordDate+1) and
t1.Temperature>t2.Temperature and t1.id<>t2.id

Result table:
+----+
| id |
+----+
| 2  |
| 4  |
+----+
--------------------------

--- 2 Swap Salary
create table salary (id int, name varchar(3), sex varchar(1) check (sex in ('M','F')))

1	"A"	"M"
2	"B"	"F"
3	"C"	"M"
4	"D"	"F"

update salary set sex='F' where sex='M' AND set sex='M' where sex='F'  ---wrong syntax

update salary set name='Joy', sex='F' where id=1 ----- this works, mutiple columns but single condition in where

update salary set 
sex= 
CASE
when sex='F' then 'M'
else 'F'
end;

1	"A"	"F"
2	"B"	"M"
3	"C"	"F"
4	"D"	"M"