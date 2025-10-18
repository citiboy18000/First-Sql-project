
/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_sales as 
	(SELECT 
		YEAR(order_date) as order_year,
		p.product_name,
		SUM(sales_amount) as current_sales 
	FROM goldsales as s 
	LEFT JOIN goldproducts as P
	on s.product_key = p.product_key 
	WHERE YEAR(order_date) is not NULL
	GROUP BY order_year, product_name )
    
    SELECT 
		order_year, 
        product_name, 
        current_sales,
        avg(current_sales) over(PARTITION BY product_name) as avg_sales,
        current_sales -  avg(current_sales) over(PARTITION BY product_name) as avg_diff, 
        CASE 
			WHEN current_sales -  avg(current_sales) over(PARTITION BY product_name) > 0 THEN 'Above avg'
            WHEN current_sales -  avg(current_sales) over(PARTITION BY product_name) < 0 THEN 'Below avg'
            ELSE 'Average' 
		END as flag,
        LAG(current_sales) OVER(PARTITION BY product_name) as py_sales,
        current_sales -   LAG(current_sales) OVER(PARTITION BY product_name) sales_diff,
         CASE 
			WHEN current_sales -   LAG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Increase'
            WHEN current_sales -   LAG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Decrease'
            ELSE 'The same' 
		END as sales_change
	FROM yearly_sales
	ORDER BY product_name, order_year
        

    