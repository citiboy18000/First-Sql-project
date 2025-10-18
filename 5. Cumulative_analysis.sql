
/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total and average sales per month 
-- and the running total and moving average of sales over time 

WITH Monthly_sales as 
	(SELECT 
		YEAR(order_date) as order_year, 
		MONTH(order_date) as order_month, 
		SUM(sales_amount) as Total_sales,
        round(AVG(sales_amount), 2) as Avg_sales
	FROM goldsales 
	WHERE  MONTH(order_date) IS NOT NULL
	GROUP BY order_year, order_month
	ORDER BY order_year, order_month)
    
    SELECT 
		order_year,
        order_month,
        Total_sales,
        Avg_sales,
        SUM(Total_sales) OVER(PARTITION BY order_year ORDER BY order_year, order_month) AS Running_total,
		round(avg(avg_sales) OVER(PARTITION BY order_year ORDER BY order_year, order_month), 2) AS Moving_avg
	FROM Monthly_sales; 
    
    -- Calculate the total and average sales per year 
-- and the running total and moving average of sales over time 

SELECT 
	order_year,
    Total_sales,
    SUM(Total_sales) OVER(ORDER BY order_year) as Running_total, 
    avg_sales,
    round( avg(avg_sales) OVER(ORDER BY order_year), 2) as Moving_avg
FROM
		(SELECT 
			year(order_date) as order_year,
			SUM(sales_amount) as Total_sales,
			round(AVG(sales_amount), 2) as Avg_sales 
		FROM goldsales 
		WHERE year(order_date) IS NOT NULL
		GROUP BY order_year
		ORDER BY order_year) t
    

