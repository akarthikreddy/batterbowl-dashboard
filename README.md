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
   orders/day, margin). Two extra cards appear only for months that have
   the data: a day-by-day chart for any "Uncategorized" spend (an expense
   row in the source sheet with a value but no label in column B), and a
   per-employee staff salary breakdown (from the separate `Salry sheet*`
   tabs in the workbook — shown purely as supplementary detail, since it
   doesn't always reconcile with the "Salaries" expenditure category).
2. **Compare Months** — trend lines (sales/cost/profit, each toggleable
   via the legend), side-by-side monthly bars, and profit margin % across
   all months.
3. **Spending Breakdown** — pick a month range (or "All time"), see a
   donut of top categories + a full sortable table with % of total spend.

## Login

The dashboard is gated by a simple username/password screen (username
`admin`), with an optional "Remember me" so you don't have to sign in every
time. This is a client-side check only — there's no backend, and the repo
is public, so it stops a casual visitor but isn't real security; the
underlying data is still in the page source regardless.

To change the password, edit `config.js` in this folder (gitignored —
never committed) and reload:

```js
window.DASHBOARD_CONFIG = {
  password: "your-new-password"
};
```

The live GitHub Pages site never sees `config.js` (since it's gitignored),
so it always falls back to a password hash baked into `index.html`
(`FALLBACK_PASSWORD_HASH`). That hash is kept in sync with `config.js`
**automatically** by a git pre-commit hook — every time you `git commit`,
it recomputes the hash from whatever password is currently in `config.js`
and updates `index.html` before the commit is made, so pushing always
carries your latest local password forward to the live site too. No manual
hash step needed.

If the hook is ever missing (e.g. a fresh clone of the repo on a new
machine), reinstall it once with `./scripts/install-hooks.sh`.

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
