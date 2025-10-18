
/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH Cost_segmentation as 
(SELECT 
	product_key,
    product_name
    cost,
    CASE 
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS Cost_seg	
FROM goldproducts)
SELECT 
	cost_seg, 
    COUNT(product_key)
FROM Cost_segmentation 
GROUP BY cost_seg ;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH new_table as 
(SELECT 
	customer_key,
    sum(sales_amount) as total_spend,
    min(order_date) first_order,
    max(order_date) last_order,
    timestampdiff (month, min(order_date), max(order_date)) as lifespan
FROM goldsales 
GROUP BY customer_key
ORDER BY customer_key),
spending_table as 
(SELECT 
	customer_key,
    Total_spend ,
    lifespan, 
    CASE	
		WHEN lifespan >= 12 and total_spend >5000 THEN 'VIP'
        WHEN lifespan >= 12 and total_spend <=5000 THEN 'Regular'
        ELSE 'New'
	END as cust_seg
    FROM new_table )
    SELECT 
		cust_seg,
        count(customer_key) customer_count
	FROM spending_table
    GROUP BY cust_seg
    ORDER BY    count(customer_key) DESC
    