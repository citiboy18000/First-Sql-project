
/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

WITH category_table as 
(SELECT 
	 p.category, 
     SUM( s.sales_amount) as sales_per_category
FROM goldproducts as p
RIGHT JOIN goldsales as s
on p.product_key = s.product_key
GROUP BY p.category)

SELECT 	
	category,
    sales_per_category,
    SUM(sales_per_category) OVER() as Total_sales,
    concat( round( sales_per_category / SUM(sales_per_category) OVER() *100, 2), '%') as percentage 
    FROM category_table
    ORDER BY percentage DESC;
    
    -- Rank each countries according to their overall contributions to sales
    
    WITH country_table as 
    (SELECT 
		c.country,
        SUM(sales_amount) as country_spend
	FROM goldsales as s 
    LEFT JOIN goldcustomers c
    on s.customer_key = c.customer_key 
    GROUP BY c.country
  ),
percentage_table as (
    SELECT 
		country, 
        country_spend, 
        SUM(country_spend) OVER() total_spend,
        concat( round( country_spend / SUM(country_spend) OVER() *100, 2), '%') as Percentage 
	FROM country_table)
    
    SELECT 
		country,
        country_spend,
        total_spend,
        percentage,
        RANK() OVER (ORDER BY cast( percentage as FLOAT )DESC) as ranking 
	FROM percentage_table 
	