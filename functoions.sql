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


Fuction return nuber of products availbe between given price range

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