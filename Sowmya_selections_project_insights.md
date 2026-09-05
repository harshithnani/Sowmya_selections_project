# Key Findings — Customer Fabric Purchase Analysis

*Fill in the [ ] placeholders below with your actual query results before
publishing — these are the exact numbers a reader will want to see.*

## Overview
- Total unique customers: **[ ]** (by phone number)
- Data spans: December – May (6 months)
- Most active month: **[ ]** with **[ ]** purchase records

## 1. Monthly Demand Trend
Customer count by month (chronological, Dec → May):

| Month | Customer Count |
|---|---|
| December | [ ] |
| January | [ ] |
| February | [ ] |
| March | [ ] |
| April | [ ] |
| May | [ ] |

[One sentence describing the trend — growing, shrinking, seasonal spike, etc.]

## 2. Repeat Customer Behavior
- **[ ]%** of customers purchased in more than one month
- Of those repeat customers, [ ] tended to buy the same fabric again vs.
  [ ] who switched to a different fabric on their next purchase

[One sentence interpreting this — e.g. "Most repeat customers stick with
their preferred fabric, suggesting strong product loyalty" or the opposite]

## 3. Fabric Popularity
- Most requested fabric overall: **[ ]**
- [Any fabric that appears seasonal — popular in some months, absent in others]

## 4. Data Quality Notes
- **[ ]%** of records are missing city, **[ ]%** missing state, **[ ]%**
  missing phone number
- **[ ]** records had malformed name/address fields due to inconsistent
  data entry in the original export
- Some rows have city and state values swapped or inconsistent (e.g. a city
  name entered in the state column) — a source data-entry issue, not
  something correctable via SQL alone

## Recommendations
1. [e.g. "Standardize data entry with a dropdown for state, to eliminate
   city/state mix-ups going forward"]
2. [e.g. "Investigate the December spike/dip — is it holiday-driven demand?"]
3. [e.g. "Consider a proper customer ID field to avoid relying on phone
   number formatting consistency"]
