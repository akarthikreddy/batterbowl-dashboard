# BatterBowl Dashboard

A single-page dashboard for BatterBowl's monthly sales & expenditure data.
No backend — everything (Excel parsing, charts, filtering) runs client-side
in the browser.

**Live:** https://akarthikreddy.github.io/batterbowl-dashboard/

## Usage

Just open `index.html` in a browser (or visit the live URL above). It ships
with a bundled default dataset, so it shows real numbers immediately.

To bring in newer data, click **"Upload updated Excel"** (top right) and
select an updated `MONTHLY_EXPENDITURE.xlsx`. The charts recalculate
instantly. The uploaded data is saved in your browser's local storage, so
it will still be there next time you open the dashboard **on the same
browser/device** — re-uploading again simply replaces it. Uploading is
per-browser: opening the dashboard on a different computer or browser
will show the bundled default until you upload there too.

## Tabs

1. **Month View** — pick a month, see expenditure by category, sales vs
   cost vs profit, and metric cards (orders, avg order value, avg
   orders/day, margin).
2. **Compare Months** — trend lines (sales/cost/profit, each toggleable
   via the legend), side-by-side monthly bars, and profit margin % across
   all months.
3. **Spending Breakdown** — pick a month range (or "All time"), see a
   donut of top categories + a full sortable table with % of total spend.

## Source spreadsheet format

Each sheet in the `.xlsx` = one month. The parser expects:
- Column B: row labels (`EXPENDITURE` header, category rows, `total exp`,
  `TOTAL ORDERS`, `AVG ORDER/ DAY`, `AVG ORDER VALUE`, `ONLINE SALES`,
  `COUPONS`, `OFF LINE SALES`, `TOTAL SALES`, etc).
  daily values in the columns after that.
- A `total` column (position varies per sheet, found automatically) with
  each category's monthly total.
- `TOTAL ORDERS` / `AVG ORDER/ DAY` / `AVG ORDER VALUE` are read from
  column C specifically.

Sheet names are matched literally against a hardcoded chronological month
list in the JS (`MONTH_META` in `index.html`) — if a re-uploaded file
renames a sheet, it won't be recognized. If a sheet's layout doesn't match
(no `EXPENDITURE` header or no `total` column found), it's skipped and a
banner lists which sheets were skipped.

## Deploying

This is a static site hosted via GitHub Pages (`main` branch, root).
Just commit and push — Pages redeploys automatically within a minute or two.

```
git add .
git commit -m "..."
git push
```
