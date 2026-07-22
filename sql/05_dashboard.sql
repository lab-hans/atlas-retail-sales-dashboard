-- Atlas Retail — Sales & Revenue Analytics · 05 · Dashboard feeds
-- Pre-computed summary views the Power BI report connects to.

-- KPI header: headline totals
SELECT ROUND(SUM(sales), 0)                       AS total_sales,
       ROUND(SUM(profit), 0)                      AS total_profit,
       ROUND(100.0 * SUM(profit) / SUM(sales), 1) AS margin_pct,
       COUNT(*)                                   AS order_lines,
       COUNT(DISTINCT order_id)                   AS orders,
       COUNT(DISTINCT customer_id)                AS customers
FROM fact_sales;

-- Sales & margin by category
DROP VIEW IF EXISTS v_sales_by_category;
CREATE VIEW v_sales_by_category AS
    SELECT p.category,
           SUM(f.sales)  AS total_sales,
           SUM(f.profit) AS total_profit,
           ROUND(100.0 * SUM(f.profit) / SUM(f.sales), 1) AS margin_pct
    FROM fact_sales f
    JOIN dim_product p ON f.product_id = p.product_id
    GROUP BY p.category;
SELECT * FROM v_sales_by_category ORDER BY total_profit DESC;

-- Sales & margin by region
DROP VIEW IF EXISTS v_sales_by_region;
CREATE VIEW v_sales_by_region AS
    SELECT c.region,
           SUM(f.sales)  AS total_sales,
           SUM(f.profit) AS total_profit,
           ROUND(100.0 * SUM(f.profit) / SUM(f.sales), 1) AS margin_pct
    FROM fact_sales f
    JOIN dim_customer c ON f.customer_id = c.customer_id
    GROUP BY c.region;

-- Monthly trend with running profit
DROP VIEW IF EXISTS v_monthly_trend;
CREATE VIEW v_monthly_trend AS
    WITH monthly AS (
        SELECT strftime('%Y-%m', order_date) AS month,
               SUM(sales)  AS sales,
               SUM(profit) AS profit
        FROM fact_sales
        GROUP BY month
    )
    SELECT month, sales, profit,
           SUM(profit) OVER (ORDER BY month) AS running_profit
    FROM monthly;

-- Confirm the views exist
SELECT name FROM sqlite_master WHERE type = 'view' ORDER BY name;
