# Connect Your Data — Atlas Sales Dashboard

Plug your own sales data into this dashboard. It reads **4 tables** in a **star schema**. Match the column names and types below and every visual + measure works unchanged.

## What you need
Four files (CSV or Excel), one per table. **Column names must match exactly** (case-insensitive is safest to keep identical). Extra columns are fine; the ones below are used by the dashboard.

### 1. `fact_sales` — one row per order line *(the numbers)*
| Column | Type | Required | Notes |
|---|---|---|---|
| `order_id` | text | ✅ | groups lines into an order (used for **order count**) |
| `order_date` | **date** | ✅ | drives all time-intelligence (YoY, YTD, trend) — must be a real date |
| `customer_id` | text | ✅ | key → `dim_customer` |
| `product_id` | text | ✅ | key → `dim_product` |
| `sales` | number | ✅ | revenue per line |
| `profit` | number | ✅ | profit per line |
| `quantity` | number | optional | |
| `discount` | number | optional | |
| `ship_date`, `ship_mode`, `row_id` | — | optional | |

### 2. `dim_customer` — one row per customer *(who)*
`customer_id` (✅ key) · `customer_name` · `segment` · `region` · `state` · `city`

### 3. `dim_product` — one row per product *(what)*
`product_id` (✅ key) · `product_name` · `category` · `sub_category`

### 4. `dim_calendar` — one row per date *(when)*
`date` (✅, real date) · `year` · `quarter` · `month` *(number 1–12)* · `month_name` · `day_name`
> Must cover every date in `order_date`. Generate one easily in Excel (a date column + `=YEAR()`, `=MONTH()`, `=TEXT(date,"mmm")`).

## Swap in your data (Fabric web)
1. In the **Lakehouse** → **Files** → **Upload** your 4 files (keep the same file/table names).
2. Right-click each → **Load to Tables** (overwrite the existing table).
3. Open the **semantic model** → **Refresh**. Confirm the 3 relationships still connect (fact → each dim on the shared key).
4. Open the report — every visual now shows **your** numbers.

## Checklist if something looks off
- **Blank/one giant trend point?** `order_date` / `date` isn't a real **Date** type — fix the column type.
- **`(Blank)` in a slicer or missing rows?** a `customer_id`/`product_id` in `fact_sales` has no match in the dim → fix the key or add the missing dim row.
- **Wrong totals?** a duplicated key or a text number that didn't import as a number.
