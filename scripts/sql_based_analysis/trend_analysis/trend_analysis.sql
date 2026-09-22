/*
===============================================================================
Trend Analysis
===============================================================================
This analysis uses the Gold-layer dimensional model to evaluate historical
sales performance and identify trends across product categories.

The analysis combines:
    - gold.fact_sales       : sales transactions and measures
    - gold.dim_products     : product and category attributes
    - gold.dim_order_date   : calendar and time attributes

A reusable CTE is created to provide a consistent analytical dataset for
revenue and quantity analysis across different time periods.

The analysis focuses on:
    1. Revenue trends by product category
    2. Quantity sold trends by product category
    3. Year-over-year changes in category revenue
    4. Identification of changes in product-category performance

Unknown-date records are excluded using the warehouse's designated
unknown-date key (-1).
===============================================================================
*/

-- REUSABLE BASE PRODUCT SALES CTE
WITH product_sales AS
(
SELECT
s.order_number, s.product_key, s.customer_key, 
s.order_date_key, s.sales_amount, s.quantity, p.product_name, 
p.category, p.subcategory, p.product_line,
t.order_date,
t.order_day_name,
t.order_week_of_month,
t.order_month,
t.order_year
FROM gold.dim_products AS p
INNER JOIN
gold.fact_sales AS s
ON p.product_key = s.product_key
INNER JOIN
gold.dim_order_date AS t
ON  s.order_date_key = t.order_date_key
WHERE s.order_date_key != -1
)
SELECT *
FROM product_sales

-- -------------------------------------------------------------------------------
-- Quantity sold per category ( All time sales)
WITH product_sales AS
(
SELECT
s.order_number,
s.product_key, 
s.customer_key, 
s.order_date_key,
s.sales_amount,
s.quantity,
p.product_name, 
p.category,
p.subcategory,
p.product_line,
t.order_date,
t.order_day_name,
t.order_week_of_month,
t.order_month,
t.order_year
FROM gold.dim_products AS p
INNER JOIN
gold.fact_sales AS s
ON p.product_key = s.product_key
INNER JOIN
gold.dim_order_date AS t
ON  s.order_date_key = t.order_date_key
WHERE s.order_date_key != -1
)
SELECT 
category,
SUM(quantity) AS quantity_sold
FROM product_sales
GROUP BY category
ORDER BY quantity_sold DESC;
-- --------------------------------
/*
category	quantity_sold
Accessories	36096
Bikes	    15203
Clothing	9105
*/
-- --------------------------------
-- Revenue Generated per Category (All time sales)
WITH product_sales AS
(
SELECT
s.order_number,
s.product_key, 
s.customer_key, 
s.order_date_key,
s.sales_amount,
s.quantity,
p.product_name, 
p.category,
p.subcategory,
p.product_line,
t.order_date,
t.order_day_name,
t.order_week_of_month,
t.order_month,
t.order_year
FROM gold.dim_products AS p
INNER JOIN
gold.fact_sales AS s
ON p.product_key = s.product_key
INNER JOIN
gold.dim_order_date AS t
ON  s.order_date_key = t.order_date_key
WHERE s.order_date_key != -1
)
SELECT 
category,
SUM(sales_amount) AS revenue_generated
FROM product_sales
GROUP BY category
ORDER BY revenue_generated DESC;
-- ---------------------------------------

