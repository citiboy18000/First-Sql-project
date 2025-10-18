/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
CREATE VIEW Customer_report as
WITH first_query as (
/*---------------------------------------------------------------------------
1) first_query: Retrieves core columns from tables
---------------------------------------------------------------------------*/

SELECT 
	c.customer_key,
    concat(first_name, ' ', last_name) customer_name,
    gender,
    country,
    timestampdiff( year, birthdate, current_date) age,
    order_number,
    product_key,
    order_date,
    sales_amount,
    quantity
FROM goldsales s
LEFT JOIN goldcustomers c 
on s.customer_key = c.customer_key
WHERE order_date is NOT NULL ),

second_query as (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_name,
    age,
    gender,
	country,
    max(order_date) as last_order,
    timestampdiff( month, min(order_date), max(order_date) ) life_span,
    sum(sales_amount) as total_sales,
    count(DISTINCT order_number) as total_order,
    sum(quantity) as total_quantity,
    count(DISTINCT product_key) as total_product
    FROM first_query
    GROUP BY  customer_key,
    customer_name, age, gender,  country)
    
    SELECT
		customer_key,
		customer_name, 
		age,
        gender,
		country,
        CASE 
			WHEN age < 20 THEN 'Under 20'
			WHEN age between 20 and 29 THEN '20-29'
			WHEN age between 30 and 39 THEN '30-39'
			WHEN age between 40 and 49 THEN '40-49'
			ELSE '50 and above'
		END AS age_group,
        CASE 
			WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
			WHEN life_span >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment,
        last_order, 
        timestampdiff( month, last_order, current_date) as recency,
		life_span,
		total_sales,
		total_order,
        CASE
			WHEN total_order =0 THEN 0
			ELSE round(total_sales / total_order,2)
		END as avg_order,
		total_quantity,
		total_product, 
        CASE 
			WHEN life_span = 0 THEN total_sales
            ELSE round (total_sales / life_span,2)
		END as avg_monthly_spend
        
	FROM second_query;

    
    