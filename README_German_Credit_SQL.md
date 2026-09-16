# German Credit Dataset — Exploratory Data Analysis (MySQL)

An exploratory SQL analysis of the German Credit dataset, a widely used benchmark in credit risk research. The project answers four questions: who the borrowers are, how much credit they take, why they borrow, and which borrower segments carry the most financial exposure.

---

## Dataset

**Source:** German Credit Data (Statlog dataset)
**Table:** `g_credit_data`
**Records:** 1,000 borrowers
**Key fields:** Age, Sex, Job, Housing, Saving accounts, Checking account, Credit amount, Duration, Purpose

The dataset is publicly available via the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/statlog+(german+credit+data)) and [Kaggle](https://www.kaggle.com/datasets/uciml/german-credit).

---

## Tools

- **MySQL 8.x**
- No external libraries — pure SQL, all analysis runs in a single script

---

## Analytical queries

The script runs 12 structured queries, each answering a specific business question about the credit portfolio.

---

### 1. Overall Credit Portfolio Summary
Baseline statistics across the full 1,000-borrower portfolio: average age, average credit amount, average loan duration, and min/max values for each.

---

### 2. Borrower Demographic Profile
Borrower count, percentage share, average age, and average credit amount broken down by sex — to see whether gender correlates with borrowing scale.

---

### 3. Age Distribution
Borrowers bucketed into five age groups (Under 25 / 25–34 / 35–44 / 45–54 / 55+), with average credit amount and average loan duration per group.

---

### 4. Credit Amount by Job Category
Average credit amount, total credit exposure, and average duration grouped by employment category — to identify which job types are associated with larger borrowing.

---

### 5. Credit Purpose Analysis
Loan count, percentage of total portfolio, total credit amount, average credit amount, and average duration by loan purpose (car, furniture, education, business, etc.) — ordered by total credit exposure to show where capital is concentrated.

---

### 6. Housing Profile and Credit Behaviour
Average age, average credit amount, and average duration by housing status (own / free / rent) — to test whether home ownership is associated with different borrowing patterns.

---

### 7. Savings Account Analysis
Average credit amount, duration, and age broken down by savings account level (little / moderate / quite rich / rich / NA) — to examine whether savings level relates to borrowing scale.

---

### 8. Checking Account Analysis
Same structure as savings analysis, applied to checking account status (little / moderate / rich / NA).

---

### 9. Combined Financial Profile
Cross-tabulation of savings level and checking level, showing average credit amount and duration for combinations with at least 5 borrowers. Filtered with `HAVING COUNT(*) >= 5` to avoid noise from rare combinations.

---

### 10. Credit Amount Segmentation
Borrowers segmented into four credit bands:

| Band | Range |
|---|---|
| Low Credit | < 2,000 |
| Medium Credit | 2,000 – 5,000 |
| High Credit | 5,001 – 10,000 |
| Very High Credit | 10,000+ |

Average duration and average age reported per band.

---

### 11. Loan Duration by Purpose
For each loan purpose: total loans, average duration, shortest and longest duration, and average credit amount — to identify which purposes are associated with longer, more exposed repayment periods.

---

### 12. Borrowing Exposure Index
A derived metric — credit per month — computed as `Credit amount / Duration` per borrower, then averaged by age group. This creates a simple monthly repayment burden index to identify which age segments are most financially stretched relative to loan size.

```sql
credit_per_month = `Credit amount` / NULLIF(Duration, 0)
```

---

### 13. High-Exposure Borrower Segmentation
Rule-based exposure classification:

| Segment | Criteria |
|---|---|
| High Exposure | Credit ≥ 10,000 AND Duration ≥ 36 months |
| Moderate Exposure | Credit ≥ 5,000 OR Duration ≥ 24 months |
| Lower Exposure | Everything else |

Count, average credit amount, and average duration per segment.

---

### 14. Job × Housing Cross-Segmentation
Average credit amount and duration by the combination of job category and housing status, filtered to groups of 5+ borrowers. Identifies which employment–housing combinations carry the highest average credit exposure.

---

### 15. Final Executive Summary Query
A single aggregated row covering: total borrowers, average age, total portfolio value, average credit amount, average loan duration, number of distinct loan purposes, housing categories, and savings categories — a one-line portfolio snapshot.

---

## Key analytical patterns addressed

| Question | Query |
|---|---|
| Who borrows? | Demographics (sex, age group, job, housing) |
| How much do they borrow? | Credit amount by segment, job, purpose |
| Why do they borrow? | Purpose analysis, duration by purpose |
| Who is most exposed? | Exposure index, high-exposure segmentation, combined financial profile |

---

## How to run

```sql
-- 1. Create and populate the table with the German Credit dataset
--    (CSV import or manual INSERT from the UCI/Kaggle source)

-- 2. Run the analysis script:
SOURCE german_data_exploratory_data_Analysis_project.sql;
```

The script assumes a table named `g_credit_data` with the following columns:
`Age`, `Sex`, `Job`, `Housing`, `Saving accounts`, `Checking account`,
`Credit amount`, `Duration`, `Purpose`

Column names with spaces must be wrapped in backticks in MySQL.

---

## Files

```
german_data_exploratory_data_Analysis_project.sql   — Full EDA script (15 queries)
```

---

## Related projects

- `README_Fintech_SQL.md` — A companion SQL project covering a synthetic fintech lender's portfolio with a focus on data cleaning and payment collection analysis
