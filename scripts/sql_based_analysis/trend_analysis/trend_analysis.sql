/*
===============================================================================
Trend Analysis
===============================================================================

Purpose:
    Analyze historical sales trends across product categories using the Gold
    layer of the data warehouse.

Approach:
    - Combine sales transactions from fact_sales with product attributes from
      dim_products and calendar attributes from dim_order_date.
    - Create a reusable analytical dataset using a CTE.
    - Exclude records associated with the unknown date key (-1).
    - Analyze revenue and quantity trends across categories and time periods.
    - Use year-over-year comparisons to identify changes in sales performance.

Key Business Questions:
    - How has revenue changed over time?
    - Which product categories are driving sales growth or decline?
    - How has sales volume changed across categories?
    - Are changes in revenue accompanied by changes in quantity sold?

Output:
    The resulting analysis supports identification of historical sales patterns,
    category performance, and changes in customer demand over time.
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

