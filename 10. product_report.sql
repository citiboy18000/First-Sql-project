
/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
CREATE VIEW product_report as 

WITH first_query AS (
/*---------------------------------------------------------------------------
1) fist Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
    SELECT
	    s.order_number,
        s.order_date,
		s.customer_key,
        s.sales_amount,
        s.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM goldsales s 
    LEFT JOIN goldproducts p
        ON s.product_key = p.product_key
    WHERE order_date IS NOT NULL ), 
    
     second_table as (
    SELECT 
		 product_key,
         product_name,
         category,
         subcategory,
         SUM(cost) as Total_cost,
		 count(DISTINCT order_number) as total_order,
         max(order_date) as last_order,
         timestampdiff(month, min(order_date), max(order_date)) as lifespan,
		 count( DISTINCT customer_key) as customer_count,
         SUM( sales_amount) as total_sales ,
         sum( quantity) as total_quantity
	FROM first_query
    GROUP BY product_key,
         product_name,
         category,
         subcategory )
         
         SELECT 
				product_key,
				product_name,
				category,
				subcategory,
				Total_cost,
                CASE
					WHEN total_sales > 50000 THEN 'High-Performer'
					WHEN total_sales >= 10000 THEN 'Mid-Range'
					ELSE 'Low-Performer'
				END AS product_segment,

				total_order,
				last_order,
                timestampdiff( month, last_order, current_date) as recency,
				lifespan,
                CASE 
					WHEN lifespan = 0 THEN total_sales
                    ELSE total_sales / lifespan
				END as avg_monthly_sales,
				customer_count,
				total_sales ,
                case 
					WHEN total_order = 0 THEN 0 
                    ELSE total_sales / total_order
                END as avg_order_value,    
				total_quantity
                
		FROM second_table;
        
        SELECT * from product_report