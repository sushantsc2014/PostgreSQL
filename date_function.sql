/* TO_DATE  */-----------------

--in POSTGRESQL
select to_date('16-01-2021','DD-MM-YYYY')
select to_date('16/01/2021','DD/MM/YYYY')
select to_date('16-01-2021','DD-MM-YYYY')
select to_date('2021-01-16','YYYY-MM-DD')

"2021-01-16"

SELECT TO_TIMESTAMP('16-01-2021 21:30:20', 'DD-MM-YYYY HH24:MI:SS');  -- "2021-01-16 21:30:20+05:30"
SELECT TO_TIMESTAMP('16-01-2021 09:30:20', 'DD-MM-YYYY HH:MI:SS');  -- "2021-01-16 209:30:20+05:30"  

--in ORACLE
select to_date('16-01-2021','DD-MM-YYYY') from dual
select to_date('16/01/2021','DD/MM/YYYY') from dual
select to_date('16-01-2021','DD-MM-YYYY') from dual
select to_date('2021-01-16','YYYY-MM-DD') from dual

16-JAN-21

select to_timestamp('16-01-2021 21:30:20', 'DD-MM-YYYY HH24:MI:SS') from dual  --16-JAN-21 09.30.20.000000 PM
select to_timestamp('16-01-2021 09:30:20', 'DD-MM-YYYY HH:MI:SS') from dual   -- 16-JAN-21 09.30.20.000000 AM


/* TO_CHAR */-----------------

--in POSTGRESQL

select to_char(current_date,'MM-DD-YYYY')  -- "16-01-2021" (in TEXT)
select to_char(current_date,'MM/DD/YYYY')  -- "01/16/2021" (in TEXT)
select to_char(current_date,'DD-MM-YYYY')  -- "16-01-2021" (in TEXT)

--in ORACLE

select to_char(sysdate,'MM-DD-YYYY') from dual  -- 01-16-2021
select to_char(sysdate,'MM/DD/YYYY') from dual  -- 01/16/2021
select to_char(sysdate,'DD/MM/YYYY') from dual  -- 16/01/2021


----ADDITION, SUBSTRACTION from DATE--------------

/* In POSTGRESQL */

select current_date+5   --"2021-01-21"
select current_date+36  --"2021-02-21"

/* In ORACLE */
select sysdate+4 from dual
select sysdate+45 from dual  -- 02-MAR-21


select (current_date- to_date('20-11-2020','DD-MM-YYYY'))  -- 57  integer

select (sysdate- to_date('20-11-2020','DD-MM-YYYY')) from dual -- 57.55




select current_time+ interval  '1 hour'  -- "20:07:14.588929+05:30"   --postgresql

select (current_timestamp+ interval '1' hour) from dual  -- 16-JAN-21 06.40.52.818436 AM US/PACIFIC   --Oracle