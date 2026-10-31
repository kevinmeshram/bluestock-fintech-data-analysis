# CAGR summary

- Formula: CAGR = (NAV_end / NAV_start) ^ (1 / n) - 1, for n = 1, 3, and 5 years. Shown in percent.
- End date: 2026-05-29. Start dates: 1 yr 2025-05-29, 3 yr 2023-05-29, 5 yr 2021-05-29.
- NAV on a weekend or holiday is the last known NAV (filled rows from Task 8).
- Funds: 40. With a CAGR: 1 yr 40, 3 yr 40, 5 yr 0. The others have too little history or a NAV gap.
- Best 3-year CAGR: ['Axis Midcap Fund - Regular - Growth', 'Mirae Asset Large Cap Fund - Regular - Growth', 'ICICI Pru Bluechip Fund - Direct - Growth'].
- Worst 3-year CAGR: ['Axis Small Cap Fund - Regular - Growth', 'ABSL Small Cap Fund - Regular - Growth', 'SBI Small Cap Fund - Direct Plan - Growth'].
- IDCW funds (CAGR from NAV is too low for these): 0.
- Funds whose last NAV is before the end date: 0.
- Checks passed: 1-year CAGR equals the total return, CAGR above -100, spot check with SQL.
- Comparison with the source returns in fact_performance: see the notebook, Step 8.

## Assumptions to confirm
- The end date is the newest NAV date in the data.
- n is a whole number of calendar years.
- CAGR uses two NAV values only. It depends on the start and end dates.