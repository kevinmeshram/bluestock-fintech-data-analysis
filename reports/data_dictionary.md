### fact_daily_return

Grain: one fund on one day that has a NAV in the source and a previous NAV. Source: `fact_nav`, rows with `is_filled = 0`.

| Column | SQLite type | Key and rules | Business definition | Source | Notes |
|---|---|---|---|---|---|
| `amfi_code` | INTEGER | PK (part 1), FK to dim_fund.amfi_code | The fund. | fact_nav.amfi_code | |
| `date_key` | INTEGER | PK (part 2), FK to dim_date.date_key | The date of the later NAV (day t). | fact_nav.date_key | Only days with a NAV from the source. |
| `days_since_prev` | INTEGER | NOT NULL, 1 or more | The number of calendar days since the previous NAV. 1 is a normal weekday. 3 is a Monday. | Calculated | A long gap means that NAV days are missing. |
| `daily_return` | REAL | NOT NULL, CHECK above -1 | The change of the NAV since the previous NAV, as a fraction. 0.01 means 1%. | Calculated: nav_t / nav_(t-1) - 1 | A fraction, not a percent. Columns that end in _pct are percent. |