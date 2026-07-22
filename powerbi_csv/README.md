# powerbi_csv — star-schema model (Power BI source)

The Power BI report connects to these four tables (a star schema):

| File | Role |
|---|---|
| `fact_sales.csv` | fact — one row per order line (keys + measures) |
| `dim_customer.csv` | dimension — customer attributes |
| `dim_product.csv` | dimension — product attributes |
| `dim_calendar.csv` | dimension — date table (drives time-intelligence) |

These are the **modeled output** derived from the flat source in [`../data/orders.csv`](../data).
To plug in your own data, see [`../docs/CONNECT_YOUR_DATA.md`](../docs/CONNECT_YOUR_DATA.md).
