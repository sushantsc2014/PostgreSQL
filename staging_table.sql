create table staging_tab as
(
select 
	   a1.product_id,
       a1.store_id,
       a1.product_name,
	   a1.quantity,
       (case
		when customer.email_id is null OR customer.email_id=''
		then 'No email'
                else customer.email_id
       end) as email_cust
FROM (
      select 
		 p.production_id as product_id,
		 s.store_id as store_id,
		 p.product_name as product_name,
		 coalesce(s.quantity,0) as quantity
      from production.products p left join production.stocks s on p.production_id=s.product_id
     ) a1
left join Sales.stores store on a1.store_id=store.store_id
left join sales.orders orders_tab on a1.store_id= orders_tab.store_id
left join  sales.customer customer on orders_tab.customer_id=customer.customer_id)













