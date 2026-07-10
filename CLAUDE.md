# BatterBowl Dashboard — Project Context

## What this is
A single-page static HTML dashboard visualizing BatterBowl's monthly sales &
expenditure data, sourced from a WooCommerce-adjacent internal tracking
spreadsheet (`MONTHLY_EXPENDITURE.xlsx`). No backend — everything (Excel
parsing, charts, filtering) runs client-side in the browser.

## Repo / hosting
- GitHub repo: https://github.com/akarthikreddy/batterbowl-dashboard
- Hosted via **GitHub Pages** (Settings → Pages → Deploy from branch `main`, root)
- Live URL: `https://akarthikreddy.github.io/batterbowl-dashboard/`
- Local path: `/Users/karthik/mac data/batterbowl/projects/claude/batterbowl_dashboard`
- Deploy flow: edit `index.html` → `git add . && git commit -m "..." && git push`
  → GitHub Pages redeploys automatically within ~1-2 min.

## Files
- `index.html` — the entire app (HTML + CSS + JS in one file)
- `README.md` — setup/usage notes
- `.gitignore` — just `.DS_Store` / `*.log`

## Tech used (all via CDN, no build step)
- **Chart.js** (`cdnjs.cloudflare.com`) — all charts
- **SheetJS / xlsx.js** (`cdnjs.cloudflare.com`) — parses uploaded `.xlsx` client-side

## What the dashboard does
Three tabs:
1. **Month view** — pick a month (dropdown or ‹ › arrows). Shows expenditure
   breakdown by category (horizontal bar), sales vs cost vs profit, and
   metric cards (total orders, avg order value, avg orders/day, margin).
2. **Compare months** — trend lines (sales/cost/profit, each toggleable),
   side-by-side monthly bars, profit margin % line across all months.
3. **Spending breakdown** — aggregates every expense category across a
   user-selected month range (From/To selectors, or "All time"). Donut
   chart (top 10 + "Other") + full sortable table with % of total spend.
   Category names are normalized (trimmed, whitespace-collapsed,
   title-cased) so e.g. `"raw  material"` and `"raw material"` merge into
   one line instead of appearing as duplicates.

There's an **"Upload updated Excel"** button (top right) — lets the user
(or anyone with the link) drop in a newer `MONTHLY_EXPENDITURE.xlsx` and
every chart recalculates in-browser. The page also ships with a **bundled
default dataset** (baked into a `const DEFAULT_DATA = {...}` JSON blob in
the JS) so it shows real data even before anyone uploads anything.

## Source spreadsheet structure (important — this is what the parser assumes)
Each sheet = one month. Sheet names follow this exact chronological list
(hardcoded as `MONTH_ORDER` in the JS, used both for sort order and display
labels):
```
sep, OCT24, NOV24, dec24, jan25, feb25, MARCH25, "april 25", may25,
"june 25", " july 25", aug25, sep25, oct25, nov25, dec25, jan26, feb26,
march26, APRIL26, may26
```
(Note some have inconsistent casing/spacing in the original file — the
parser normalizes with `.trim().toLowerCase()` when matching labels, but
sheet *names* are matched literally against `MONTH_ORDER`.)

Within each sheet:
- Column B holds row labels: `EXPENDITURE` (header), category rows (raw
  material, vegetables, salaries, rent, ads online, etc.), `total exp`,
  then further down `TOTAL PACKED MATERIAL`, `WASTAGE`, `PERSONAL & EB`,
  `TOTAL ORDERS`, `AVG ORDER/ DAY`, `AVG ORDER VALUE`, `ONLINE SALES`,
  `COUPONS`, `OFF LINE SALES`, `TOTAL SALES`.
- Daily entries run across columns C onward (one column per day of month).
- A `total` column (position varies per sheet — found by scanning the
  header row for the literal string `"total"`) holds each category's
  monthly total.
- `TOTAL ORDERS` / `AVG ORDER/ DAY` / `AVG ORDER VALUE` are read from
  column C specifically (single values, not the total column).
- Other non-month sheets in the original workbook (`Salry sheet25-26`,
  `Salry sheet26-27`, `project`, `new invest`, `estimate`) are intentionally
  excluded/ignored.

The JS parser (`parseWorkbook()` in `index.html`) mirrors a Python/openpyxl
prototype exactly — if you need to see the original Python version for
reference/debugging, ask and I can reconstruct it, but the JS is the
source of truth now since that's what runs live.

## Known constraints / things to watch
- If a re-uploaded Excel renames a sheet to something not in `MONTH_ORDER`,
  it gets appended at the end of the order rather than sorted correctly —
  flagged as a known limitation, not yet fixed.
- If the header row layout changes (e.g. "EXPENDITURE" moves out of column
  B, or the "total" column label is renamed), that sheet will silently be
  skipped rather than erroring loudly.
- Currency formatting assumes INR (₹), Indian digit grouping
  (`toLocaleString('en-IN')`).

## Possible next steps (not yet done, just flagged in conversation)
- Make sheet-name matching more tolerant of format drift.
- Surface a warning in the UI when a sheet is skipped during parsing,
  instead of failing silently.
- Karthik doesn't have a paid Excel plan — he edits the source spreadsheet
  via Google Sheets / LibreOffice / WPS / Excel Online and exports as
  `.xlsx` before uploading to the dashboard.
