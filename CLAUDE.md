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
Each sheet = one month. Month sheets are **recognized by parsing their name**
(`monthInfo()` in the JS), not by matching a hardcoded list — so a brand-new
month tab (e.g. `jun26`, `july26`, `OCT27`) shows up automatically on upload
with no code changes. `monthInfo()` extracts a month word (full or
abbreviated: `jun`/`june`, `sep`/`sept`/`september`, etc.) plus a 2- or
4-digit year, and derives both the sort order and the display label (`Jun
2026`) from that. Casing/spacing don't matter (`"june 25"`, `JUN26`,
`June 26` all parse the same). The one sheet with no year in its name, `sep`
(Sept 2024, the earliest data), is handled by a small `MONTH_ALIASES` entry.
Example historical names: `sep, OCT24, NOV24, dec24, jan25 … APRIL26, may26,
jun26`. Any sheet whose name doesn't parse as a month is ignored.

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

Salary breakdowns come from the `Salry sheet<startYr>-<endYr>` tabs (one per
fiscal year, Apr–Mar). The fiscal start year is read straight from the sheet
name, and each month block is matched to its expenditure month by year+month
(via `monthInfo`), so no per-month mapping needs maintaining and June etc.
attach automatically.

The JS parser (`parseWorkbook()` in `index.html`) mirrors a Python/openpyxl
prototype exactly — if you need to see the original Python version for
reference/debugging, ask and I can reconstruct it, but the JS is the
source of truth now since that's what runs live.

## Known constraints / things to watch
- A month sheet whose name **doesn't parse as month+year** (e.g. `Q1`,
  `summary`, or a typo like `jne26`) is silently ignored. Sheets that *do*
  parse as a month but have a broken internal layout are collected and shown
  in the "skipped sheet(s)" banner after upload.
- If the header row layout changes (e.g. "EXPENDITURE" moves out of column
  B, or the "total" column label is renamed), that sheet is skipped and
  surfaced in the skip banner (it won't error loudly, but it's no longer
  fully silent).
- Currency formatting assumes INR (₹), Indian digit grouping
  (`toLocaleString('en-IN')`).

## Possible next steps (not yet done, just flagged in conversation)
- Karthik doesn't have a paid Excel plan — he edits the source spreadsheet
  via Google Sheets / LibreOffice / WPS / Excel Online and exports as
  `.xlsx` before uploading to the dashboard.
