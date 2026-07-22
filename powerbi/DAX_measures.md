# Atlas Retail — DAX measures (Power BI / Fabric semantic model "Sales Model")

Reference for every measure, its DAX, and what it does. Data = a synthetic Superstore-style star schema
(`fact_sales` + `dim_customer` + `dim_product` + `dim_calendar`).

## Setup — dedicated `_Key_Measures` table (pro pattern)
Keep all measures in one home table (reads professional; sorts to top via the `_`):
1. **New table** → `_Key_Measures = {BLANK()}` → confirm (empty 1-col holder).
2. Move each measure → its **Properties → Home table → `_Key_Measures`** (or drag in the Data pane).
3. Right-click the `Value` column → **Hide** → table shows a calculator icon (measures-only).

## Core KPIs (Page 1)

| Measure | DAX | What it does |
|---|---|---|
| **Total Sales** | `SUM(fact_sales[sales])` | total revenue (Superstore "sales" = revenue) |
| **Total Profit** | `SUM(fact_sales[profit])` | total profit (already net of cost) |
| **Profit Margin %** | `DIVIDE([Total Profit], [Total Sales])` | profit ÷ sales, as a ratio (format as %) |
| **Total Orders** | `DISTINCTCOUNT(fact_sales[order_id])` | count of distinct orders (not order-lines) |
| **Avg Order Value** | `DIVIDE([Total Sales], [Total Orders])` | sales ÷ orders = AOV |

_All five live in the **`_Key_Measures`** table._

**Notes**
- `DIVIDE(a, b)` = safe divide → returns BLANK on ÷0 (never an error). Prefer over `/`.
- `DISTINCTCOUNT` vs `COUNT`/`COUNTROWS`: distinct = unique order_ids (lines ≠ orders — the grain).
- Measures reference other measures (`[Total Profit]`) → build once, reuse (like a CTE).
- Format: Profit Margin % → Percentage; Total Sales/Profit/AOV → Currency; Orders → Whole number.

## Time intelligence
_dim_calendar[date] is a real Date/time column, related to fact_sales → time-intel works._

| Measure | DAX | What it does |
|---|---|---|
| **Sales Previous Year** | `CALCULATE([Total Sales], SAMEPERIODLASTYEAR(dim_calendar[date]))` | same period, prior year |
| **YoY Growth %** | `IF(HASONEVALUE(dim_calendar[year]), DIVIDE([Total Sales]-[Sales Previous Year], [Sales Previous Year]))` | YoY growth; **guarded** so the grand-total row is blank (see note) |
| **Sales YTD** | `TOTALYTD([Total Sales], dim_calendar[date])` | year-to-date cumulative |

- `SAMEPERIODLASTYEAR` / `TOTALYTD` need a **date column in a related table** (have it). Best practice: also *Mark as date table*.
- Running total (alt to YTD, all-time): `CALCULATE([Total Sales], FILTER(ALLSELECTED(dim_calendar[date]), dim_calendar[date] <= MAX(dim_calendar[date])))`.
- **⚠ YoY at the grand total is misleading:** `SAMEPERIODLASTYEAR` shifts the *whole* visible range back a year, so at the Total (2022–2024) the "prior year" only captures 2022+2023 → you divide 3 yrs of sales by 2 yrs → a bogus 52.7%. **Fix = the `HASONEVALUE(dim_calendar[year])` guard** → blanks the total, keeps per-year YoY. (`HASONEVALUE` = true only when one year is in filter context; false on multi-year totals.)

## Ranking / share
- Top-N products & customers via **RANKX**; share-of-total via measure ÷ `ALL`.
