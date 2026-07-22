-- ════════════════════════════════════════════════════════════════════════
--   Atlas Retail — Sales & Revenue Analytics
--   00 · Setup — schema + data load
--   Engine: SQLite (retail.db) · 9,994 order lines · 2022-2024
-- ════════════════════════════════════════════════════════════════════════
--   The prebuilt database `retail.db` ships with this repo, ready to query.
--   To rebuild from source: create the schema below, then import the CSVs
--   from /data and /powerbi_csv. In the SQLite CLI, for example:
--       .mode csv
--       .import --skip 1 data/orders.csv             orders
--       .import --skip 1 powerbi_csv/dim_customer.csv dim_customer
--       .import --skip 1 powerbi_csv/dim_product.csv  dim_product
--       .import --skip 1 powerbi_csv/fact_sales.csv   fact_sales
-- ════════════════════════════════════════════════════════════════════════

-- Flat source table (denormalized) — used by 01_explore.sql
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  row_id       INTEGER,
  order_id     TEXT, order_date TEXT, ship_date TEXT, ship_mode TEXT,
  customer_id  TEXT, customer_name TEXT, segment TEXT,
  country TEXT, city TEXT, state TEXT, region TEXT,
  product_id   TEXT, category TEXT, sub_category TEXT, product_name TEXT,
  sales REAL, quantity INTEGER, discount REAL, profit REAL
);

-- Star schema (fact + dimensions) — used by 02-05
DROP TABLE IF EXISTS dim_customer;
CREATE TABLE dim_customer (
  customer_id TEXT, customer_name TEXT, segment TEXT,
  region TEXT, state TEXT, city TEXT
);

DROP TABLE IF EXISTS dim_product;
CREATE TABLE dim_product (
  product_id TEXT, category TEXT, sub_category TEXT, product_name TEXT
);

DROP TABLE IF EXISTS fact_sales;
CREATE TABLE fact_sales (
  row_id INTEGER, order_id TEXT, order_date TEXT, ship_date TEXT, ship_mode TEXT,
  customer_id TEXT, product_id TEXT,
  sales REAL, quantity INTEGER, discount REAL, profit REAL
);
