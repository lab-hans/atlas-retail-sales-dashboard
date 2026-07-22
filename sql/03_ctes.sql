-- Atlas Retail — Sales & Revenue Analytics · 03 · CTEs (WITH)
-- Readable, multi-step queries.

-- Profit by region, as a named step
WITH region_profit AS (
    SELECT c.region, SUM(f.profit) AS total_profit
    FROM fact_sales f
    JOIN dim_customer c ON f.customer_id = c.customer_id
    GROUP BY c.region
)
SELECT * FROM region_profit
ORDER BY total_profit DESC;

-- Regions with above-average profit (CTE referenced twice)
WITH region_profit AS (
    SELECT c.region, SUM(f.profit) AS total_profit
    FROM fact_sales f
    JOIN dim_customer c ON f.customer_id = c.customer_id
    GROUP BY c.region
)
SELECT region, total_profit
FROM region_profit
WHERE total_profit > (SELECT AVG(total_profit) FROM region_profit)
ORDER BY total_profit DESC;

-- Two-step CTE: category totals, then margin %
WITH cat_totals AS (
    SELECT p.category, SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
    FROM fact_sales f
    JOIN dim_product p ON f.product_id = p.product_id
    GROUP BY p.category
),
cat_margin AS (
    SELECT category, total_sales, total_profit,
           ROUND(100.0 * total_profit / total_sales, 1) AS margin_pct
    FROM cat_totals
)
SELECT * FROM cat_margin
ORDER BY margin_pct DESC;
