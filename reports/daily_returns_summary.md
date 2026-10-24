# Daily returns summary

- Funds: 40. Return rows: 45960. Dates: 2022-01-04 to 2026-05-29.
- Formula: daily_return = nav_t / nav_(t-1) - 1, as a fraction. Only real NAV days were used (is_filled = 0).
- Overall (percent): mean 0.063, std 1.029, min -5.81, max 6.47.
- Skew 0.04. Kurtosis 1.37.
- Days exactly 0: 0.01%.
- Days with a move above 5% in size: 9.
- Returns that cover a gap of more than 7 days: 0.
- Database table fact_daily_return: 45960 rows. Row counts, sums, and a SQL LAG check all match.

## Assumptions to confirm with my manager
- Filled weekend and holiday rows were not used. They would give fake returns of 0%.
- Returns that span a long gap were kept. The column days_since_prev shows the gap.
- A move above 5% in one day is a "big move". This limit is my choice.