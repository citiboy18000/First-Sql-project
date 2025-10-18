
/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) as Total_sales  FROM goldsales;

-- Find the average sales
SELECT avg(sales_amount) as Average_sales FROM goldsales;

-- Find how many items are sold
SELECT SUM(quantity) as Total_quantity_sold FROM goldsales;

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM goldsales;

-- Find the Total number of Orders
SELECT count(DISTINCT order_number) as Total_order from goldsales; 

-- Find the total number of products
SELECT count(product_key) as Total_product from goldproducts;

-- Find the total number of customers
SELECT count(customer_key) as Total_customer from goldcustomers;

-- Find the total number of customers that has placed an order
SELECT count(DISTINCT customer_key) as Customer_with_orders from goldsales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM goldsales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM goldsales
UNION ALL
SELECT 'Average Price',  round( AVG(price), 2 ) FROM goldsales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM goldsales
UNION ALL
SELECT 'Total Products', COUNT(product_id) FROM goldproducts
UNION ALL
SELECT 'Total Customers', COUNT(customer_key)  FROM goldcustomers
UNION ALL 
SELECT 'Total Quantity Sold', SUM(quantity) FROM goldsales
UNION ALL 
SELECT 'Total Cost of Product', SUM(cost) FROM goldproducts ;









