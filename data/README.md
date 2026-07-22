# data — raw source

`orders.csv` — the flat, denormalized source dataset (9,994 order lines, 2022–2024; synthetic *Superstore* data).

This is what the **SQL layer** loads: `sql/00_setup.sql` imports it into the `orders` table, and `sql/01_explore.sql` explores it.

The **modeled star-schema** tables that Power BI actually connects to live in [`../powerbi_csv/`](../powerbi_csv).
