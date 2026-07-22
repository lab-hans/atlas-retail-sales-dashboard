-- Atlas Retail — Sales & Revenue Analytics · 02 · Joins (star schema)
-- Enrich the fact table with customer and product dimensions.

-- Fact / dimension previews
SELECT * FROM fact_sales   LIMIT 5;
SELECT * FROM dim_customer LIMIT 5;
SELECT * FROM dim_product  LIMIT 5;

-- Fact + customer dimension: add name & region to each sale
SELECT f.order_id, c.customer_name, c.region, f.sales, f.profit
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
LIMIT 10;

-- Fact + both dimensions: customer and product attributes on each sale
SELECT f.order_id,
       c.customer_name, c.region,
       p.category, p.sub_category,
       f.sales, f.profit
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
JOIN dim_product  p ON f.product_id  = p.product_id
LIMIT 10;

-- Profit by region (join + aggregate)
SELECT c.region,
       SUM(f.sales)    AS total_sales,
       AVG(f.discount) AS avg_discount,
       SUM(f.profit)   AS total_profit
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_profit DESC;

-- Margin % by region (computed column)
SELECT c.region,
       SUM(f.sales)  AS total_sales,
       SUM(f.profit) AS total_profit,
       ROUND(100.0 * SUM(f.profit) / SUM(f.sales), 1) AS margin_pct
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.region
ORDER BY margin_pct DESC;

-- Data-quality check: every fact row should match a customer (LEFT JOIN + COUNT)
SELECT COUNT(*)             AS fact_rows,
       COUNT(c.customer_id) AS matched_rows
FROM fact_sales f
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id;
