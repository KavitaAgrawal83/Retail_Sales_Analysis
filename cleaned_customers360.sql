with payment_agg as(
	select order_id,
		   count(distinct payment_type ) distinct_payment_types,
		   COUNT( case when payment_type = 'credit_card' THEN 1 END) AS credit_card,
		   COUNT( case when payment_type = 'UPI/Cash' THEN 1 END) AS [UPI/Cash],
		   COUNT( case when payment_type = 'debit_card' THEN 1 END) AS debit_card,
		   COUNT( case when payment_type = 'voucher' THEN 1 END) AS voucher
	from [dbo].[OrderPayments]
    group by order_id
)
SELECT															  -- Customer Information from Customers table----- 96802
						C.Custid AS customer_id,                                          
						C.customer_city AS customer_city,                                  
						C.customer_state AS customer_state,
						C.Gender AS customer_gender,

						min(o.bill_date_timestamp) as first_transaction_date, 
						max(o.bill_date_timestamp) as last_transaction_date,
						datediff(day, min(o.bill_date_timestamp), max(o.bill_date_timestamp)) as tenure,
						datediff(day, max(o.bill_date_timestamp), '2023-10-31')	as inactive_days,

						round(sum( o.total_amount),2) as total_spent, --OR Sales_Per_Customer
						sum(o.quantity) as total_quantity,
						sum(o.discount) as total_discount,
						round(SUM(o.discount) / SUM(o.MRP) * 100,2) AS discount_percentage, 
						round(avg(o.total_amount  - (o.Cost_Per_Unit * O.Quantity)), 2) as AVG_profit,

						count(distinct case when o.discount > 0 then o.order_id end) as transactions_with_discount,
						count(distinct case when o.discount <= 0 then o.order_id end) as transactions_without_discount,
						count(distinct case when (o.total_amount - o.discount - o.Cost_Per_Unit*O.QUANTITY) <= 0 then o.order_id end) 
						as transactions_with_loss,
						count(distinct case when (o.total_amount - o.discount - o.Cost_Per_Unit*O.QUANTITY) > 0 then o.order_id end) 
						as transactions_with_profit,

						count(distinct o.order_id) as total_order_placed,
						count(o.product_id) as total_PRODUCT_PURCHASED,
						count(distinct o.product_id) as distinct_products,
						count(distinct o.category) as distinct_categories,
						count(case when o.category = 'Food & Beverages' then o.order_id end) as Food_Bev_cat,
						count(case when o.category = 'Construction_Tools' then 1 end) as Const_tool_cat,
						count(case when o.category = 'Fashion' then 1 end) as Fashion_cat,
						count(case when o.category = 'Stationery' then 1 end) as Stationary_cat,
						count(case when o.category = 'Pet_Shop' then 1 end) as Pet_shop_cat,
						count(case when o.category = 'Luggage_Accessories' then 1 end) as Luggage_asses_cat,
						count(case when o.category = 'Electronics' then 1 end) as Electronics_cat,
						count(case when o.category = 'Toys & Gifts' then 1 end) as Toy_gift_cat,
						count(case when o.category = 'Furniture' then 1 end) as Furniture_cat,
						count(case when o.category = 'Auto' then 1 end) as Auto_cat,
						count(case when o.category = 'Baby' then 1 end) as Baby_cat,
						count(case when o.category = 'Computers & Accessories' then 1 end) as Computer_asses_cat,
						count(case when o.category = 'Home_Appliances' then 1 end) as home_applin_cat,
						count(distinct o.channel) as channels_used,
						count(case when o.channel = 'Instore' then o.order_id end) as Instore_channel,
						count(case when o.channel = 'Phone Delivery' then 1 end) as Phone_channel, 
						count(case when o.channel = 'Online' then 1 end) as online_channel,

						sum(p.distinct_payment_types) as payment_types_used,
						sum(p.voucher) as voucher_transactions,
						sum(p.credit_card) as credit_card_transactions, 
						sum(p.debit_card) as debit_card_transactions,
						sum(p.[upi/cash]) as upi_transactions,

						AVG(o.Avg_rating) AS avg_customer_rating  ,       
						ISNULL(Avg(O.Avg_rating), 0) / COUNT(DISTINCT O.Customer_id) as Avg_RATING_Per_CUSTOMER,

						-- Time-Based
						COUNT(CASE WHEN DATENAME(WEEKDAY, O.Bill_date_timestamp) IN ('Saturday', 'Sunday') THEN 1 END) AS Weekend_Transactions,
						COUNT(CASE WHEN DATENAME(WEEKDAY, O.Bill_date_timestamp) NOT IN ('Saturday', 'Sunday') THEN 1 END) AS Weekday_Transactions,

						COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 0 AND DATEPART(hour, o.bill_date_timestamp) < 12 THEN 1 END) AS Morning_orders,
						COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 12 AND DATEPART(hour, o.bill_date_timestamp) < 16 THEN 1 END) AS Afternoon_orders,
						COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 16 AND DATEPART(hour, o.bill_date_timestamp) < 19 THEN 1 END) AS Evening_orders,
						COUNT(CASE WHEN DATEPART(hour, o.bill_date_timestamp) >= 19 AND DATEPART(hour, o.bill_date_timestamp) < 24 THEN 1 END) AS Night_orders
						
INTO C						
FROM 
Finalised_Records_2 O 
left join Customers C	ON C.Custid = O.customer_id					-- Join Orders to get order-related information 
left join payment_agg p on p.order_id=o.order_id
GROUP BY															-- Group by customer and order details to aggregate metrics
		C.Custid ,C.customer_city ,C.customer_state,C.Gender
---------------------96802---------------------
---DROP TABLE C
--SELECT round(SUM(total_spent),2) FROM C---------15454264.86
select * from C