select ----------------------96893
		o.order_id as Order_id, o.Customer_id ,
		o.Bill_date_timestamp,
		count(o.product_id) as No_of_items,
		count(distinct o.category) as Distinct_categories,
		count(distinct o.Channel) as total_channel_used,

		sum(o.quantity) as Quantity,
		sum(o.Total_Amount) as Total_Amount,
		sum(o.discount) as Discount,
		round(sum(o.cost_per_unit * o.quantity), 2) as Total_cost, 
		round(sum(o.total_amount  - (o.cost_per_unit * o.quantity)), 2) as Total_profit,

		count(case when o.discount > 0 then 1 end) as Items_with_discount,
		count(case when o.discount <= 0 then 1 end) as Items_without_discount,

		AVG(o.Avg_rating) as Avg_Ratings,
		
		count(distinct case when (o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) <= 0 then 1 end) as orders_with_loss,
		count(distinct case when (o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) > 0 then 1 end) as Orders_with_profit,

		COUNT(CASE WHEN DATENAME(WEEKDAY, O.Bill_date_timestamp) IN ('Saturday', 'Sunday') THEN 1 END) AS Weekend_Transactions,
		COUNT(CASE WHEN DATENAME(WEEKDAY, O.Bill_date_timestamp) NOT IN ('Saturday', 'Sunday') THEN 1 END) AS Weekday_Transactions,

		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 0 AND DATEPART(hour, o.bill_date_timestamp) < 12 THEN 1 END) AS Morning_orders,
		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 12 AND DATEPART(hour, o.bill_date_timestamp) < 17 THEN 1 END) AS Afternoon_orders,
		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 17 AND DATEPART(hour, o.bill_date_timestamp) < 20 THEN 1 END) AS Evening_orders,
		COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 20 AND DATEPART(hour, o.bill_date_timestamp) < 24 THEN 1 END) AS Night_orders,
						
		---round((sum(o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) * 1.0 / nullif(sum(o.total_amount), 0)) * 100, 2) 
		---as Profit_margin_percent,
		
		count(case when o.channel = 'Instore' then o.order_id end) as Instore_channel,
		count(case when o.channel = 'Phone Delivery' then o.order_id end) as Phone_channel, 
		count(case when o.channel = 'Online' then o.order_id end) as online_channel
into O
from Finalised_Records_2 o
group by o.order_id, o.Bill_date_timestamp,o.Customer_id ------------------------------96893

select * from O---------15454264.86
----drop table O