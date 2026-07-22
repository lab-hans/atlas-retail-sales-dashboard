-- Atlas Retail — Sales & Revenue Analytics · 04 · Window functions
-- Per-row calculations across related rows: share-of-total, ranking, running totals, MoM.

-- Each region's profit as a % of the company total  (SUM OVER ())
WITH region_profit AS (
    SELECT c.region, SUM(f.profit) AS total_profit
    FROM fact_sales f
    JOIN dim_customer c ON f.customer_id = c.customer_id
    GROUP BY c.region
)
SELECT region, total_profit,
       SUM(total_profit) OVER ()                                  AS all_regions_total,
       ROUND(100.0 * total_profit / SUM(total_profit) OVER (), 1) AS pct_of_total
FROM region_profit
ORDER BY total_profit DESC;

-- Sub-category profit as a % within its category  (PARTITION BY)
WITH subcat AS (
    SELECT p.category, p.sub_category, SUM(f.profit) AS profit
    FROM fact_sales f
    JOIN dim_product p ON f.product_id = p.product_id
    GROUP BY p.category, p.sub_category
)
SELECT category, sub_category, profit,
       SUM(profit) OVER (PARTITION BY category)                            AS category_total,
       ROUND(100.0 * profit / SUM(profit) OVER (PARTITION BY category), 1) AS pct_of_category
FROM subcat
ORDER BY category, profit DESC;

-- Rank sub-categories within each category  (RANK)
WITH subcat AS (
    SELECT p.category, p.sub_category, SUM(f.profit) AS profit
    FROM fact_sales f
    JOIN dim_product p ON f.product_id = p.product_id
    GROUP BY p.category, p.sub_category
)
SELECT category, sub_category, profit,
       RANK() OVER (PARTITION BY category ORDER BY profit DESC) AS rank_in_category
FROM subcat
ORDER BY category, rank_in_category;

-- Running (cumulative) profit by month
WITH monthly AS (
    SELECT strftime('%Y-%m', order_date) AS month, SUM(profit) AS profit
    FROM fact_sales
    GROUP BY month
)
SELECT month, profit,
       SUM(profit) OVER (ORDER BY month) AS running_total
FROM monthly
ORDER BY month;

-- Month-over-month change  (LAG)
WITH monthly AS (
    SELECT strftime('%Y-%m', order_date) AS month, SUM(profit) AS profit
    FROM fact_sales
    GROUP BY month
)
SELECT month, profit,
       LAG(profit) OVER (ORDER BY month)          AS prev_month,
       profit - LAG(profit) OVER (ORDER BY month) AS mom_change
FROM monthly
ORDER BY month;
