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