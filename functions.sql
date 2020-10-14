create or replace function sum_num(x integer, y integer)
returns integer as $$
declare
sum integer;
 begin
 	sum:=x+y;
	return sum;
 end;
 $$ language plpgsql;
 
 select sum_num(2,3);
 
 
----------------------------------------------
ODD-EVEN

create or replace function odd_even(x integer)
returns text as $$
	begin
		if mod(x,2) = 0 then
		return 'Even number';
		else
		return 'Odd number';
		end if;
	end
$$ language plpgsql;

select odd_even(5);

----------------------------------------------

FACTORIAL OF 'n'

create or replace function factorial_n(x integer)
returns integer
as $$
	begin
		if x=0 then
		return 1;
		else
		return x!;
		end if;
	end
$$ language plpgsql;

select factorial_n(10)

------------------------------------------------
/*Fuction return nuber of products availbe between given price range*/

create or replace function trigger_practice.product_count(price_from int, price_to int)
returns integer as $$
declare
	count_product integer;
begin
	select count(*) into count_product from trigger_practice.product where product_price between price_from and price_to;
	return count_product;
end;
$$ language 'plpgsql';

select trigger_practice.product_count(10000,50000)

-------------------------------------------------------------------------------------------------------------------------------------
/* To get DEPARTMENT ID for Employee number (Employee database)*/

create or replace function emp_dept_id( employee_id int )
returns char(4) as $$
declare max_date date default (select max(from_date) from dept_emp where emp_no = employee_id);
begin    
    return (
        select
            dept_no
        from
            dept_emp
        where
            emp_no = employee_id
            and
            from_date = max_date);
end;
$$ language 'plpgsql';

select emp_dept_id(10126)
"d009"

select emp_dept_id(10101)
"d007"

-------------------------------------------------------------------------------------------------
/* To get Department name of employee*/

create function emp_dept_name( employee_id int )
returns varchar(40) as $anything$
begin
    return (
        select
            dept_name
        from
            departments
        where
            dept_no = emp_dept_id(employee_id)
    );
end;
$anything$ language 'plpgsql';

select emp_dept_name(10101)
"Sales"
---------------------------------------------------------------------------------------------------
/* To get Current manager of employee */ 

create or replace function emp_manager(employee_no int)
returns int as $$
begin
  return(select emp_no from current_dept_manager where dept_no=emp_dept_id(employee_no));
end;
$$ language 'plpgsql'

select emp_manager(10042)
10022
 
