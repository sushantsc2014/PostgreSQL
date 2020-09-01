set search_path to trigger_practice;
select * from student;

create table product(
product_id serial primary key,
product_name text constraint product_name_rule NOT NULL,
product_brand text constraint brand_check check(product_brand in ('LG','SONY','SAMSUNG','WHIRLPOOL','BAJAJ','HITACHI')),
product_price numeric(7,2) NOT NULL,
product_mfg_date date default current_date)

select * from product;

select pg_get_serial_sequence('product','product_id');
select currval(pg_get_serial_sequence('product','product_id'));

alter sequence product_product_id_seq start with 1;

insert into product (product_name, product_brand, product_price)
values ('TV', 'SONY', 34000.56);

insert into product (product_name, product_brand, product_price, product_mfg_date)
values ('FRIDGE', 'SAMSUNG', 23000.00, to_date('2019-05-07', 'YYYY-MM-DD'));

insert into product (product_name, product_brand, product_price, product_mfg_date)
values ('AC', 'LG', 45000.75, to_date('2020-JAN-07', 'YYYY-MON-DD'));

create table product_track(
serial_no serial primary key,
product_id integer,
old_brand text,
new_brand text,
old_price numeric,
new_price numeric)

create or replace function product_track_trigger_fuction()
returns trigger
as $$
	begin
		insert into product_track (product_id,old_brand,new_brand,old_price,new_price)
		values (new.product_id, old.product_brand, new.product_brand, old.product_price, new.product_price);
	return new;
	end;
$$ language plpgsql;

create trigger product_track_before_trigger
before update or insert or delete on product
for each row
execute procedure product_track_trigger_fuction()

alter table product disable trigger product_track_before_trigger;
alter table product enable trigger product_track_before_trigger;

create trigger product_track_after_trigger
after update or insert or delete on product
for each row
execute procedure product_track_trigger_fuction()

alter table product disable trigger product_track_after_trigger; 
alter table product enable trigger product_track_after_trigger;

select * from product;
select * from product_track;


insert into product (product_name, product_brand, product_price)
values ('TV', 'SAMSUNG', 45000.50);


update product set product_brand='LG' where product_name='TV';

insert into product (product_name, product_brand, product_price, product_mfg_date)
values ('WASHING MACHINE', 'WHIRLPOOL', 55000.35, to_date('2018-06-07', 'YYYY-MM-DD'));

select * from product;
select * from product_track;

delete from product_track where serial_no between 11 and 15;

delete from product where product_id=5;


------------------------------------------------

Creating view--

create view trial_view as select product_name,product_brand from product where product_price < 25000;
select product_name,product_brand from  product where product_price < 25000;







	