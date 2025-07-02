select 
	    distinct s.StoreID as Store_id,
		s.Region as Seller_Region , s.seller_state as Seller_State , s.seller_city as Seller_City ,-------------------------37 rows affected

		count(distinct o.product_id) as Total_products_sold, 
		count(distinct o.category) as Distinct_categories,
		count(distinct o.customer_id) as Distinct_customers,

		sum(o.quantity) as Total_quantity_sold, 
		sum(o.total_amount) as Total_sales, 
		sum(o.discount) as Total_discount_given,
		sum(o.cost_per_unit * o.quantity) as Total_cost,
		sum(o.total_amount - (o.cost_per_unit * o.quantity)) as Total_profit,

		count(case when o.discount > 0 then 1 end) as Items_with_discount,
		count(case when o.discount <= 0 then 1 end) as Items_without_discount,

		count(case when (o.total_amount - (o.cost_per_unit * o.quantity)) <= 0 then 1 end) as Loss_making_orders,
		count(case when (o.total_amount - (o.cost_per_unit * o.quantity)) > 0 then 1 end) as Profit_making_orders,
		
		count(case when datepart(weekday, o.bill_date_timestamp) in (1, 7) then 1 end) as Weekend_transactions,
		sum(case when datepart(weekday, o.bill_date_timestamp) not  in (1, 7) then 1 end) as Weekday_transactions,
		 
		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 0 AND DATEPART(hour, o.bill_date_timestamp) < 12 THEN 1 END) AS Morning_orders,
		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 12 AND DATEPART(hour, o.bill_date_timestamp) < 16 THEN 1 END) AS Afternoon_orders,
		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 16 AND DATEPART(hour, o.bill_date_timestamp) < 19 THEN 1 END) AS Evening_orders,
		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 19 AND DATEPART(hour, o.bill_date_timestamp) < 24 THEN 1 END) AS Night_orders,
 
		round(sum(case when datepart(weekday, o.bill_date_timestamp) in (1, 7) then o.total_amount end),0) as Weekend_sales,
		round(sum(case when datepart(weekday, o.bill_date_timestamp) not in (1, 7) then o.total_amount end),0) as Weekday_sales,
		
		round(sum(o.total_amount)/count(distinct o.order_id), 2) as Avg_order_value,
		round(sum(o.total_amount - (o.cost_per_unit * o.quantity))/ count(distinct o.order_id), 2) as Avg_profit_per_transaction,
		round(sum(o.total_amount - (o.cost_per_unit * o.quantity)) / count(distinct o.customer_id), 2) as Avg_profit_per_customer,
		round(count(*) / count(distinct o.customer_id), 2) as Avg_customer_visits,
		round(avg(o.avg_rating),0) as Avg_rating_per_customer,
		
		count(distinct case when o.channel = 'online' then o.order_id end) as Online_orders,
		count(distinct case when o.channel = 'Instore' then o.order_id end) as Instore_orders,
		count(distinct case when o.channel = 'Phone Delivery' then o.order_id end) as Phone_delivery_orders,
		count(distinct o.channel) as Total_channels_used
into S
--from Finalised_Records_2 o 
--inner join [dbo].[Stores_Info] as s on  o.Delivered_StoreID = s.StoreID
from  [dbo].[Stores_Info] as s  join Finalised_Records_2 as o on o.Delivered_StoreID = s.StoreID
group by s.StoreID, s.seller_city,s.seller_state,s.Region;

--drop TABLE S
select * from S----------------37
---SELECT SUM(Total_sales) FROM S-----------15955613.75
