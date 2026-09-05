# Key Findings — Customer Fabric Purchase Analysis

## Overview
- Total unique customers: 4240 (by phone number)
- Data spans: December – May (6 months)
- Most active month: December with 261 purchase records

## 1. Monthly Demand Trend
Customer count by month (chronological, Dec → May):

| Month | Customer Count |
|---|---|
| December | 1013 |
| January | 1003 |
| February | 607 |
| March | 488 |
| April | 385 |
| May | 385 |

## 2. Repeat Customer Behavior
- **9.37%** of customers purchased in more than one month
- Of those repeat customers, 326 tended to buy the same fabric again.

## 3. Fabric Popularity
- Most requested fabric overall: Black kota

## 4. Data Quality Notes
- **5.83%** of records are missing city, **5.31%** missing state, **1.68%**
  missing phone number
- **192** records had malformed name/address fields due to inconsistent
  data entry in the original export
- Some rows have city and state values swapped or inconsistent (e.g. a city
  name entered in the state column) — a source data-entry issue, not
  something correctable via SQL alone
