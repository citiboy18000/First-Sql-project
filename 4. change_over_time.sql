
/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: YEAR(), MONTH(), DATE_FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/


-- Analyse sales performance over time
-- Quick Date Functions 
-- Yearly change

SELECT 
	YEAR( order_date) AS order_year,  
	SUM( sales_amount) AS Total_sales 
FROM goldsales
WHERE YEAR( order_date) IS NOT NULL
GROUP BY order_year
ORDER BY order_year ;

-- Monthly Change
SELECT 
	YEAR( order_date) AS order_year, 
    MONTH( order_date) AS order_month, 
    SUM( sales_amount) AS Total_sales,
    round( AVG(sales_amount), 2) as Avg_sales,
    SUM( quantity ) as Total_qty, 
    COUNT(DISTINCT customer_key) as Total_customer
FROM goldsales 
WHERE YEAR( order_date) IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month ;

-- Merging the year and month colum using Date_format()
SELECT 
	date_format(order_date, '%y-%m-01') AS order_month, 
    SUM( sales_amount) AS Total_sales,
    round( AVG(sales_amount), 2) as Avg_sales,
    SUM( quantity ) as Total_qty, 
    COUNT(DISTINCT customer_key) as Total_customer
FROM goldsales 
WHERE date_format(order_date, '%y-%m-01') IS NOT NULL
GROUP BY  order_month
ORDER BY  order_month 

