# Customization Guide — Atlas Sales Dashboard

How to re-brand and extend the dashboard. Everything below is done in **Power BI / Fabric (Editing** mode).

## Colours & theme
- **View → Theme** → pick a built-in theme, or **Customize / Browse for themes** to load a `.json` brand theme (sets colours, fonts globally).
- Per-visual colours: select a visual → **Format (paint-roller) → Visual → Colours / Bars / Data colours**.

## Title, logo, branding
- **Title text:** click the page title text box → edit the text (font/size/colour in the text box format). *Type before clicking away — an empty text box auto-deletes.*
- **Logo:** toolbar → **Image** (insert) → upload your logo → position top-left/right.
- **Page name:** double-click the page tab (Page 1/2/3) → rename.

## Add a measure (KPI)
1. Select the **`_Key_Measures`** table → **New measure**.
2. Write DAX, e.g.:
   ```dax
   Total Quantity = SUM(fact_sales[quantity])
   Discount Rate  = AVERAGE(fact_sales[discount])
   Profit per Order = DIVIDE([Total Profit], [Total Orders])
   ```
3. **Format it:** Properties → **Format** (Currency / Percentage / Whole number).
4. Drop it into a **Card** or any visual. (Existing measures live in `_Key_Measures`; see `powerbi/DAX_measures.md`.)

## Add a visual
- **Visualizations** pane → pick a chart type → drag fields onto the axes/values wells.
- Bar/column breakdown: axis = a dim column, value = a measure. **Top N:** Filters pane → the axis field → *Filter type: Top N*.
- **Drill-down:** put two fields on the axis (e.g. `category`, `sub_category`) → click the drill-down arrow.
- **Slicer:** Slicer visual + a field (Year / Region / Category).

## Change what a KPI shows
Click a Card → in **Values**, remove the current measure and drag in another from `_Key_Measures`.

## Number formats
Set **in the model** (select the measure → Properties → Format) so *all* visuals inherit — not per-visual.

## Notes
- Built in **Fabric web** (browser) — no `.pbix` file to open in Desktop; edit online in the workspace.
- To reset filters/drill-through: use the **← back** button (drill-through) or the slicer clear icon.
- Data swap: see **`CONNECT_YOUR_DATA.md`**.
