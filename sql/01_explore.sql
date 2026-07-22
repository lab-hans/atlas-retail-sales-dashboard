-- Atlas Retail — Sales & Revenue Analytics · 01 · Data exploration
-- Engine: SQLite (retail.db). First look at the raw orders table.

-- Preview the table
SELECT * FROM orders LIMIT 5;

-- Key columns: who bought what, when, for how much
SELECT customer_id, customer_name, product_id, product_name, order_id, order_date, sales
FROM orders
LIMIT 10;

-- Loss-making order lines (zero or negative profit) — worst first
SELECT order_id, order_date, product_id, product_name, category, sales, quantity, discount, profit
FROM orders
WHERE profit <= 0
ORDER BY profit
LIMIT 10;

-- Category performance: sales, discount and profit by category
SELECT category,
       SUM(sales)    AS total_sales,
       SUM(discount) AS total_discount,
       SUM(profit)   AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit DESC;
