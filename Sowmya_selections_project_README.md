# Customer Fabric Purchase Analysis (SQL)

A MySQL analysis of a real fabric/clothing business's customer purchase log,
spanning December to May. Unlike a typical order-level e-commerce dataset,
this data has no price, quantity, or order ID — just customer details and
what fabric they purchased each month — so the analysis focuses on **customer
behavior, regional demand, and product popularity** rather than revenue.

## About the Data
- Source: private business records (6 monthly sheets combined into one table)
- Columns: `s_no`, `customer_name`, `city`, `state`, `phone_number`,
  `fabric_purchased`, `purchase_month`
- Note: `fabric_purchased` can contain multiple comma-separated fabric names
  in a single cell (e.g. `"Cotton, Silk"`)
- `phone_number` is used as a stand-in for a unique customer ID, since no
  formal customer ID exists in the source data

⚠️ Raw data is private and not included in this repo — only the SQL queries
and anonymized/aggregated findings are shared.

## Business Questions Answered
1. How many unique customers are there overall?
2. Which month had the most fabric purchases?
3. How to filter/search purchases for a specific fabric (given multi-value cells)?
4. How does customer count trend month-over-month (Dec → May)?
5. What % of customers are repeat buyers (purchased in 2+ months)?
6. Do repeat customers tend to buy the same fabric again, or different ones?
7. What % of records have missing city/state/phone data?
8. How many records have malformed name/address entries?

## SQL Techniques Used
- Aggregate functions (`COUNT`, `SUM`) with `GROUP BY`
- `CASE WHEN` for conditional counting, percentage calculations, and custom
  chronological sorting (since month names sort alphabetically by default)
- CTEs for multi-step logic (e.g. repeat customer rate)
- Self-joins to compare a customer's purchases against their own other
  purchases across months
- `LIKE` pattern matching to handle multi-value (comma-separated) cells
- Data quality auditing: NULL vs. empty-string handling, malformed field
  detection

## Key Findings
See [insights.md](insights.md) for the full write-up with actual numbers.

## Known Data Quality Issues (and how they were handled)
- **Comma-separated fabric cells**: a single row can list multiple fabrics
  purchased at once. Exact-match filtering (`fabric_purchased = 'X'`) misses
  these rows, so `LIKE '%X%'` is used instead. A fully normalized fabric-level
  breakdown (one row per fabric) is a noted next step.
- **Inconsistent city/state entry**: some rows have a city name entered in
  the `state` field (e.g. "Bengaluru" instead of "Karnataka") — a data entry
  inconsistency in the source, not a query error.
- **Empty vs. NULL values**: blank cells loaded as empty strings (`''`)
  rather than SQL `NULL`, so all missing-data checks test for both.
- **Malformed name/address fields**: a handful of rows have address text
  merged into the `customer_name` field, due to an unescaped comma in the
  original export. Flagged via length-based detection rather than corrected
  automatically, since names vary naturally in length and a blind fix risks
  breaking valid short names.
