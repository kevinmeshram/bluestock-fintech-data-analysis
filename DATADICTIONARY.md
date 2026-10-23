# Data dictionary: Bluestock mutual fund analytics

| Item | Value |
|---|---|
| Project | Bluestock Fintech data analysis |
| Database | `data/processed/bluestock_dw.db` (SQLite, star schema) |
| Schema file | `sql/01_create_schema.sql` |
| Author | Kevin, data analyst intern |
| Last updated | 2026-10-23 |
| Status | Draft. A manager must review section 9. |

## 1. About this file

This file describes every column in the database and in the source files. For each column it gives the data type, the business meaning, and the source.

- **Section 6** documents the six tables in the SQLite database. Each table has these columns:
  - **Column**: the column name.
  - **SQLite type**: the type in the database (INTEGER, REAL, or TEXT).
  - **Key and rules**: primary key (PK), foreign key (FK), and rules that the database checks.
  - **Business definition**: what the column means.
  - **Source**: the source file and column that the data came from.
  - **Notes**: cleaning steps and warnings.
- **Section 7** documents the five source files that are not loaded into the database.
- **Section 8** shows how each table was made from its source file.
- **Section 9** lists the data quality rules and the open questions.

The database holds personal data (see `fact_transactions`). This file holds **no data values**. It is safe to share inside the team.

## 2. Units and conventions

- Columns that end in `_pct` are percent values. The value 12.5 means 12.5%. It does not mean 0.125.
- Money is in Indian rupees (INR), unless the column name says another unit.
- 1 lakh = 100,000. 1 crore = 10,000,000. 1 lakh crore = 100,000 crore.
- `date_key` is a date written as a number: YYYYMMDD. Example: 20261009 is 9 October 2026.
- A date stored as text uses the form YYYY-MM-DD.
- A missing value is stored as NULL.
- A yes/no column uses 1 for yes and 0 for no.
- A table name that starts with `dim_` is a dimension table. A table name that starts with `fact_` is a fact table.

## 3. Glossary

| Term | Meaning |
|---|---|
| AMFI | Association of Mutual Funds in India. It gives each scheme a number. |
| AMC | Asset Management Company. A company that runs mutual funds. The fund house is its brand name. |
| Scheme | One mutual fund product. |
| AMFI code | The number that AMFI gives to a scheme. Each plan and each option has its own code. |
| NAV | Net Asset Value. The price of one unit of a fund. It changes on each business day. |
| SIP | Systematic Investment Plan. A fixed amount goes into a fund at regular times. |
| Lumpsum | One single investment, usually larger. |
| Redemption | The investor sells units and takes money out of the fund. |
| KYC | Know Your Customer. An identity check that an investor needs before investing. |
| AUM | Assets Under Management. The total money in a fund or in a fund house. |
| Expense ratio | The yearly cost of the fund, as a percent of the money in it. The fund takes it out of the NAV each day. |
| Exit load | A fee for selling early. It is a percent of the amount sold. |
| Direct plan | A plan that you buy straight from the fund house. It has no distributor commission. |
| Regular plan | A plan that you buy through a distributor. The fund pays the distributor a commission. |
| Growth option | The fund keeps the profit. The NAV goes up. |
| IDCW option | The fund pays part of the profit to the investor. The NAV goes down by the same amount. |
| Benchmark | An index that a fund compares itself with. |
| Riskometer | The SEBI risk label for a scheme. It has six levels: Low, Low to Moderate, Moderate, Moderately High, High, Very High. |
| Alpha | The extra return of a fund compared with its benchmark, after adjusting for risk. A positive value means the fund did better. |
| Beta | How much a fund moves when the market moves. 1 means the same. Above 1 means more. |
| Sharpe ratio | The return for each unit of risk. A higher value is better. |
| Sortino ratio | Like the Sharpe ratio, but it counts only the downward moves as risk. |
| Standard deviation | How much the returns of a fund swing. A large value means a bumpy ride. |
| Maximum drawdown | The biggest fall from a high point to the next low point. |
| Fiscal year | The Indian financial year. It runs from 1 April to 31 March. |
| Fact table | A table of events and numbers. It has many rows. |
| Dimension table | A table of descriptions (who, what, when). It has fewer rows. |
| Grain | What one row of a table means. |
| Primary key (PK) | A column, or a group of columns, that identifies one row. It is unique. |
| Foreign key (FK) | A column that points to the primary key of another table. |

## 4. Table overview

| Table | Type | Grain (one row is...) | Primary key | Foreign keys | Source |
|---|---|---|---|---|---|
| dim_date | Dimension | One calendar day | date_key | None | Generated |
| dim_fund | Dimension | One scheme | amfi_code | None | 01_fund_master |
| fact_nav | Fact | One fund on one date | amfi_code, date_key | amfi_code to dim_fund, date_key to dim_date | 02_nav_history |
| fact_transactions | Fact | One transaction | transaction_id | amfi_code to dim_fund, date_key to dim_date | 08_investor_transactions |
| fact_performance | Fact | One fund at one snapshot date | amfi_code, snapshot_date_key | amfi_code to dim_fund, snapshot_date_key to dim_date | 07_scheme_performance |
| fact_aum | Fact | One fund house on one date | date_key, fund_house | date_key to dim_date | 03_aum_by_fund_house |

Row counts are in `reports/sqlite_load_summary.md`.

## 5. Relationships

- `dim_fund.amfi_code` is the parent of `fact_nav.amfi_code`, `fact_transactions.amfi_code`, and `fact_performance.amfi_code`.
- `dim_date.date_key` is the parent of `fact_nav.date_key`, `fact_transactions.date_key`, `fact_performance.snapshot_date_key`, and `fact_aum.date_key`.
- `fact_aum.fund_house` is plain text. It has no foreign key. A spelling difference with `dim_fund.fund_house` breaks a join.
- The database enforces these links when the setting `PRAGMA foreign_keys = ON` is on. SQLite has it off by default. Set it on every connection.

## 6. Warehouse tables

### dim_date

Grain: one calendar day. Source: generated by `build_dim_date()` in `notebooks/11_load_sqlite.ipynb`.

| Column | SQLite type | Key and rules | Business definition | Source | Notes |
|---|---|---|---|---|---|
| `date_key` | INTEGER | PK | The date as a number in the form YYYYMMDD. | Generated | Smart key. Example: 20261009. |
| `full_date` | TEXT | NOT NULL, UNIQUE | The date as text in the form YYYY-MM-DD. | Generated | |
| `year` | INTEGER | NOT NULL | The calendar year. | Generated | |
| `quarter` | INTEGER | NOT NULL, 1 to 4 | The calendar quarter. January to March is 1. | Generated | |
| `month` | INTEGER | NOT NULL, 1 to 12 | The calendar month as a number. | Generated | |
| `month_name` | TEXT | NOT NULL | The month name in English. | Generated | |
| `day_of_month` | INTEGER | NOT NULL, 1 to 31 | The day number in the month. | Generated | |
| `day_of_week` | INTEGER | NOT NULL, 0 to 6 | The day of the week. 0 is Monday. 6 is Sunday. | Generated | |
| `day_name` | TEXT | NOT NULL | The day name in English. | Generated | |
| `week_of_year` | INTEGER | NOT NULL, 0 to 53 | The ISO week number of the year. | Generated | The first days of January can belong to week 52 or 53 of the old year. |
| `is_weekend` | INTEGER | NOT NULL, 0 or 1 | 1 if the day is a Saturday or a Sunday. | Generated | Market holidays are not marked. |
| `fiscal_year` | INTEGER | NOT NULL | The Indian financial year that holds the day. It is stored as the year in which the fiscal year ends. | Generated | April 2026 belongs to fiscal year 2027. To confirm with the manager. |
| `fiscal_quarter` | INTEGER | NOT NULL, 1 to 4 | The quarter of the fiscal year. April to June is 1. January to March is 4. | Generated | |

### dim_fund

Grain: one scheme. Source: `01_fund_master`.

| Column | SQLite type | Key and rules | Business definition | Source | Notes |
|---|---|---|---|---|---|
| `amfi_code` | INTEGER | PK | The AMFI code of the scheme. A unique number for each scheme, plan, and option. | 01_fund_master.amfi_code | Natural key. All fact tables point to it. |
| `fund_house` | TEXT | NOT NULL | The name of the fund house (AMC) that runs the scheme. | 01_fund_master.fund_house | Text trimmed. The spelling must match `fact_aum.fund_house`. |
| `scheme_name` | TEXT | NOT NULL | The full name of the scheme, with its plan and option. | 01_fund_master.scheme_name | Text trimmed. |
| `category` | TEXT | | The broad group of the scheme. Examples: Equity, Debt, Hybrid. | 01_fund_master.category | The words of the source file are kept. |
| `sub_category` | TEXT | | The smaller group inside the category. Example: Large Cap. | 01_fund_master.sub_category | |
| `plan` | TEXT | | The plan of the scheme: Direct or Regular. | 01_fund_master.plan | The allowed values are to be confirmed. |
| `launch_date` | TEXT | | The date when the scheme started, as YYYY-MM-DD. | 01_fund_master.launch_date | Changed from the source format. |
| `benchmark` | TEXT | | The index that the scheme compares itself with. | 01_fund_master.benchmark | |
| `expense_ratio_pct` | REAL | CHECK 0 or more | The yearly cost of the scheme, as a percent of the money in it. | 01_fund_master.expense_ratio_pct | The value in the master. `fact_performance` has its own value. |
| `exit_load_pct` | REAL | CHECK 0 or more | The fee for selling early, as a percent of the amount sold. | 01_fund_master.exit_load_pct | The holding period is not in the data. |
| `min_sip_amount` | REAL | CHECK 0 or more | The smallest amount for one SIP payment, in rupees. | 01_fund_master.min_sip_amount | Used to check SIP amounts. Currency to be confirmed. |
| `min_lumpsum_amount` | REAL | CHECK 0 or more | The smallest one-time investment, in rupees. | 01_fund_master.min_lumpsum_amount | Currency to be confirmed. |
| `fund_manager` | TEXT | | The name of the person who manages the scheme. | 01_fund_master.fund_manager | Text trimmed. |
| `risk_category` | TEXT | | The risk level of the scheme. | 01_fund_master.risk_category | `07_scheme_performance` calls the same idea `risk_grade`. |
| `sebi_category_code` | TEXT | | The code of the SEBI category, as given in the source. | 01_fund_master.sebi_category_code | Stored as text. The meaning is to be confirmed. |

### fact_nav

Grain: one fund on one date. Source: `02_nav_history`, after Task 8.

| Column | SQLite type | Key and rules | Business definition | Source | Notes |
|---|---|---|---|---|---|
| `amfi_code` | INTEGER | PK (part 1), FK to dim_fund.amfi_code | The fund that the NAV belongs to. | 02_nav_history.amfi_code | |
| `date_key` | INTEGER | PK (part 2), FK to dim_date.date_key | The date of the NAV. | 02_nav_history.date | Changed to the number form YYYYMMDD. |
| `nav` | REAL | NOT NULL, CHECK above 0 | The price of one unit of the fund on that date, in rupees. | 02_nav_history.nav | Changed from text to a number. A value of 0 or below was treated as missing and then filled. |
| `is_filled` | INTEGER | NOT NULL, 0 or 1, default 0 | 1 means the source had no valid NAV for this day. The NAV is the last known NAV, copied forward. 0 means the NAV is from the source. | Created in Task 8 | The fill covers weekends, holidays, and bad values. The longest fill is 7 days. This limit is an assumption. |

### fact_transactions

Grain: one transaction. Source: `08_investor_transactions`, after Task 9. **This table holds personal data. Do not share the data or push the database to GitHub.**

| Column | SQLite type | Key and rules | Business definition | Source | Notes |
|---|---|---|---|---|---|
| `transaction_id` | INTEGER | PK | A number that the database makes for each transaction. | Made by the database | Surrogate key. The source has no transaction ID. |
| `investor_id` | TEXT | NOT NULL | The code of the investor. | 08_investor_transactions.investor_id | Personal data. |
| `date_key` | INTEGER | NOT NULL, FK to dim_date.date_key | The date of the transaction. | 08_investor_transactions.transaction_date | The source had mixed date formats. Changed to YYYYMMDD. |
| `amfi_code` | INTEGER | NOT NULL, FK to dim_fund.amfi_code | The fund of the transaction. | 08_investor_transactions.amfi_code | |
| `transaction_type` | TEXT | NOT NULL, CHECK in SIP, Lumpsum, Redemption | The kind of transaction. SIP is a regular fixed payment. Lumpsum is a single payment. Redemption is a sale of units. | 08_investor_transactions.transaction_type | Many spellings were standardised to these three values. |
| `amount_inr` | REAL | NOT NULL, CHECK above 0 | The amount of the transaction, in rupees. | 08_investor_transactions.amount_inr | Always above 0. The transaction type shows the direction. |
| `payment_mode` | TEXT | | How the investor paid or received the money. | 08_investor_transactions.payment_mode | The values are as in the source. |
| `kyc_status` | TEXT | | The KYC status of the investor at the time of the transaction. | 08_investor_transactions.kyc_status | Standardised to the allowed list. The official list is to be confirmed. |
| `state` | TEXT | | The state where the investor lives. | 08_investor_transactions.state | |
| `city` | TEXT | | The city where the investor lives. | 08_investor_transactions.city | |
| `city_tier` | TEXT | | The class (tier) of the city. | 08_investor_transactions.city_tier | The values are as in the source. The meaning is to be confirmed. |
| `age_group` | TEXT | | The age band of the investor. | 08_investor_transactions.age_group | |
| `gender` | TEXT | | The gender of the investor, as recorded. | 08_investor_transactions.gender | Personal data. |
| `annual_income_lakh` | REAL | CHECK 0 or more | The yearly income of the investor, in lakh rupees. | 08_investor_transactions.annual_income_lakh | 1 lakh = 100,000 rupees. Personal data. |

### fact_performance

Grain: one fund at one snapshot date. Source: `07_scheme_performance`, after Task 10.

| Column | SQLite type | Key and rules | Business definition | Source | Notes |
|---|---|---|---|---|---|
| `amfi_code` | INTEGER | PK (part 1), FK to dim_fund.amfi_code | The fund that the numbers belong to. | 07_scheme_performance.amfi_code | |
| `snapshot_date_key` | INTEGER | PK (part 2), FK to dim_date.date_key | The date of the snapshot. | Set at load time | The source has no date. The newest NAV date is used. This is an assumption. |
| `return_1yr_pct` | REAL | CHECK -100 or more | The return of the fund over 1 year, in percent. | 07_scheme_performance.return_1yr_pct | A return below -100 is impossible. Such values were set to missing. |
| `return_3yr_pct` | REAL | CHECK -100 or more | The return of the fund over 3 years, in percent. | 07_scheme_performance.return_3yr_pct | To confirm: a yearly rate or a total return. |
| `return_5yr_pct` | REAL | CHECK -100 or more | The return of the fund over 5 years, in percent. | 07_scheme_performance.return_5yr_pct | To confirm: a yearly rate or a total return. |
| `benchmark_3yr_pct` | REAL | CHECK -100 or more | The 3-year return of the benchmark index, in percent. | 07_scheme_performance.benchmark_3yr_pct | Use it to compare with `return_3yr_pct`. |
| `alpha` | REAL | | The extra return of the fund compared with its benchmark, after adjusting for risk. | 07_scheme_performance.alpha | |
| `beta` | REAL | | How much the fund moves when the market moves. | 07_scheme_performance.beta | |
| `sharpe_ratio` | REAL | | The return for each unit of risk. A higher value is better. | 07_scheme_performance.sharpe_ratio | |
| `sortino_ratio` | REAL | | The return for each unit of downward risk. A higher value is better. | 07_scheme_performance.sortino_ratio | |
| `std_dev_ann_pct` | REAL | CHECK 0 or more | The yearly standard deviation of the returns, in percent. | 07_scheme_performance.std_dev_ann_pct | |
| `max_drawdown_pct` | REAL | CHECK -100 to 100 | The biggest fall from a high point to the next low point, in percent. | 07_scheme_performance.max_drawdown_pct | The sign rule (negative or positive) is to be confirmed. |
| `aum_crore` | REAL | CHECK 0 or more | The money in the fund, in crore rupees. | 07_scheme_performance.aum_crore | |
| `expense_ratio_pct` | REAL | CHECK 0 to 100 | The yearly cost of the fund, in percent. | 07_scheme_performance.expense_ratio_pct | Values outside 0.1 to 2.5 were flagged, not changed. |
| `morningstar_rating` | INTEGER | CHECK 1 to 5 | The Morningstar star rating of the fund. | 07_scheme_performance.morningstar_rating | Can be missing. |
| `anomaly_count` | INTEGER | NOT NULL, default 0, CHECK 0 or more | The number of anomaly flags for the fund. 0 means no flag. | Created in Task 10 | The flagged funds are in `reports/scheme_performance_review_list.csv`. |

### fact_aum

Grain: one fund house on one date. Source: `03_aum_by_fund_house`.

| Column | SQLite type | Key and rules | Business definition | Source | Notes |
|---|---|---|---|---|---|
| `date_key` | INTEGER | PK (part 1), FK to dim_date.date_key | The date of the AUM record. | 03_aum_by_fund_house.date | Changed to YYYYMMDD. |
| `fund_house` | TEXT | PK (part 2), NOT NULL | The name of the fund house. | 03_aum_by_fund_house.fund_house | Text trimmed. Plain text. No foreign key to `dim_fund`. |
| `aum_crore` | REAL | CHECK 0 or more | The total money that the fund house manages, in crore rupees. | 03_aum_by_fund_house.aum_crore | The source also has `aum_lakh_crore`. It is the same value in another unit, so it is not stored. |
| `num_schemes` | INTEGER | CHECK 0 or more | The number of schemes that the fund house had on that date. | 03_aum_by_fund_house.num_schemes | |

## 7. Source files that are not loaded

These files have no table in the database. The types are **expected** types. They are not checked yet. Check them with `df.dtypes`.

### 04_monthly_sip_inflows

| Column | Expected type | Business definition | Notes |
|---|---|---|---|
| `month` | date | The month of the record. | The format is to be confirmed. |
| `sip_inflow_crore` | decimal number | The total money that came in through SIPs in the month, in crore rupees. | |
| `active_sip_accounts_crore` | decimal number | The number of active SIP accounts, in crore. | The meaning is to be confirmed. |
| `new_sip_accounts_lakh` | decimal number | The number of new SIP accounts in the month, in lakh. | |
| `sip_aum_lakh_crore` | decimal number | The money in funds that came through SIPs, in lakh crore rupees. | The meaning is to be confirmed. |
| `yoy_growth_pct` | decimal number | The growth compared with the same month one year before, in percent. | |

### 05_category_inflows

| Column | Expected type | Business definition | Notes |
|---|---|---|---|
| `month` | date | The month of the record. | The format is to be confirmed. |
| `category` | text | The fund category. | |
| `net_inflow_crore` | decimal number | The money that came in, minus the money that went out, for the category in the month, in crore rupees. | Can be negative. |

### 06_industry_folio_count

The columns of this file are **not documented yet**. Print the columns, then add one row for each column.

| Column | Expected type | Business definition | Notes |
|---|---|---|---|
| TODO | | | |

### 09_portfolio_holdings

| Column | Expected type | Business definition | Notes |
|---|---|---|---|
| `amfi_code` | integer | The scheme that holds the stock. | Points to `dim_fund.amfi_code`. |
| `stock_symbol` | text | The exchange code of the stock. | |
| `stock_name` | text | The name of the company. | |
| `sector` | text | The business sector of the company. | |
| `weight_pct` | decimal number | The share of the scheme's money that is in this stock, in percent. | |
| `market_value_cr` | decimal number | The value of the holding, in crore rupees. | |
| `current_price_inr` | decimal number | The price of one share, in rupees. | |
| `portfolio_date` | date | The date of the portfolio record. | |

### 10_benchmark_indices

| Column | Expected type | Business definition | Notes |
|---|---|---|---|
| `date` | date | The date of the index value. | |
| `index_name` | text | The name of the index. | |
| `close_value` | decimal number | The closing level of the index on that date, in index points. | It is not an amount of rupees. |

## 8. Lineage and cleaning rules

| Target table | Source file | Task | Rules applied |
|---|---|---|---|
| dim_date | Generated | Task 12 | One row for each day, from the oldest to the newest date in the data. The fiscal year runs from April to March. |
| dim_fund | 01_fund_master | Task 6, Task 12 | Text trimmed. Launch date changed to YYYY-MM-DD. No rows removed. The key was checked: unique and not empty. |
| fact_nav | 02_nav_history | Task 8 | Dates parsed. NAV changed to numbers. Exact duplicates removed. For the same fund and date, the last row was kept. Sorted by fund and date. A NAV of 0 or below was treated as missing. Every calendar day was added for each fund. The last NAV was copied forward for up to 7 days. The flag `is_filled` marks these rows. |
| fact_transactions | 08_investor_transactions | Task 9 | The transaction type was standardised to SIP, Lumpsum, and Redemption. Amounts above 0 only. Mixed date formats fixed. KYC values checked against the allowed list. Identical rows were kept, because the source has no transaction ID. Removed rows are in an audit file that is not on GitHub. |
| fact_performance | 07_scheme_performance | Task 10 | All numeric columns checked. Impossible values were set to missing. Anomaly flags were added. No rows removed. The snapshot date is the newest NAV date. |
| fact_aum | 03_aum_by_fund_house | Task 12 | Dates parsed. Fund house text trimmed. The unit column `aum_lakh_crore` was not stored. |

## 9. Data quality rules and open questions

### Rules that the database enforces

- Every primary key is unique and never empty.
- Every foreign key points to an existing row in its parent table.
- `nav` and `amount_inr` are above 0.
- `transaction_type` is one of SIP, Lumpsum, or Redemption.
- Returns are -100 or more. Standard deviation and AUM are 0 or more.
- `morningstar_rating` is from 1 to 5.
- STRICT tables stop text from going into a number column.

### Rules that the analysis flags but the database does not enforce

- Expense ratio between 0.1 and 2.5 percent.
- Outliers inside each category.
- Differences between `scheme_performance` and the fund master.
- The sign of `max_drawdown_pct`.

### Open questions for the manager

1. Are the 3-year and 5-year returns yearly rates or total returns?
2. Does `max_drawdown_pct` use negative or positive numbers for a fall?
3. Does the expense ratio range of 0.1 to 2.5 percent apply to all categories and plans? Index funds and liquid funds can be cheaper.
4. Which date is the snapshot date of `fact_performance`?
5. What is the official list of KYC values?
6. What do the values of `plan`, `payment_mode`, `city_tier`, and `sebi_category_code` mean?
7. Is the fiscal year convention right? The year in which it ends is stored.
8. Can `fact_aum` link to `dim_fund` through a new table, `dim_fund_house`?
9. Can two identical transaction rows be two real transactions?
10. Are the minimum SIP and lumpsum amounts in rupees?
11. What are the columns of `06_industry_folio_count`?

## 10. Change log

| Date | Change | Author |
|---|---|---|
| 2026-10-23 | First version of the data dictionary. | Kevin |