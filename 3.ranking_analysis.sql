
/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT 
	s.product_key, 
    p.product_name,
	SUM(s.sales_amount) as Revenue 
FROM goldsales AS s
LEFT JOIN goldproducts AS p
ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name 
ORDER BY Revenue DESC 
LIMIT 5; 

-- Complex but Flexibly Ranking Using Window Functions and CTE
WITH ranking as 
	(SELECT 
		s.product_key, 
		p.product_name,
		SUM(s.sales_amount) as Revenue, 
		RANK() OVER( ORDER BY SUM(s.sales_amount)DESC) As revenue_rank
	FROM goldsales AS s
	LEFT JOIN goldproducts AS p
	ON s.product_key = p.product_key
	GROUP BY s.product_key, p.product_name)
    SELECT * FROM ranking 
    WHERE revenue_rank <6; 
    
    -- What are the 5 worst-performing products in terms of sales?

WITH ranking as 
	(SELECT 
		s.product_key, 
		p.product_name,
		SUM(s.sales_amount) as Revenue, 
		RANK() OVER( ORDER BY SUM(s.sales_amount)) As revenue_rank
	FROM goldsales AS s
	LEFT JOIN goldproducts AS p
	ON s.product_key = p.product_key
	GROUP BY s.product_key, p.product_name)
    SELECT * FROM ranking 
    WHERE revenue_rank <6; 
    
-- Find the top 10 customers who have generated the highest revenue
SELECT 
	s.customer_key, 
    concat(c.first_name, ' ', c.last_name) as Customer_Name,
    SUM(s.sales_amount) as Revenue_Generated
FROM goldsales as s 
LEFT JOIN goldcustomers as c
on s.customer_key = c.customer_key
GROUP BY 
	s.customer_key, 
    concat(c.first_name, ' ', c.last_name) 
ORDER BY Revenue_Generated DESC
LIMIT 10;

-- Using window functions and a sub-query
SELECT * FROM
		(SELECT 
			s.customer_key, 
			concat(c.first_name, ' ', c.last_name) as Customer_Name,
			SUM(s.sales_amount) as Revenue_Generated,
			RANK() OVER(ORDER BY SUM(s.sales_amount)  DESC) as Revenue_rank 
		FROM goldsales as s 
		LEFT JOIN goldcustomers as c
		on s.customer_key = c.customer_key
		GROUP BY 
			s.customer_key, 
			Customer_Name) t
WHERE 
	Revenue_rank <11;
    
    -- The 3 countries with the highest orders placed 
WITH Country_table AS 
			(SELECT 
				c.country, 
                COUNT(DISTINCT s.order_number) as order_count,
                RANK() OVER(ORDER BY COUNT(DISTINCT s.order_number)DESC) as ranking
			FROM goldcustomers c 
            LEFT JOIN goldsales s 
            ON c.customer_key = s.customer_key
            GROUP BY c.country)
		SELECT * 
			FROM country_table 
            where ranking <4;
            
-- The 3 customers with the fewest orders placed
 SELECT 
		s.customer_key, 
		concat(c.first_name, ' ', c.last_name) as Customer_Name,
		COUNT(DISTINCT s.order_number) as order_count               
	FROM goldsales as s 
	LEFT JOIN goldcustomers as c
	on s.customer_key = c.customer_key
	GROUP BY 
			s.customer_key, 
			Customer_Name
	ORDER BY order_count 
    LIMIT 3
    

	

