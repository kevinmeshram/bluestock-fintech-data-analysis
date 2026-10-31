# Alpha, beta, and maximum drawdown summary

- Index: NIFTY100. Regression window: 2022-01-04 to 2026-05-29 (4.40 years). Funds: 40.
- Regression: fund daily return on index daily return, scipy.stats.linregress. Beta = slope. Alpha = intercept x 252, in percent.
- Fund and index returns cover the same dates (index close looked up on each start and end date).
- Funds with a weak fit (R2 below 0.5): 40. Funds with a significant alpha (t above 2 in size): 29.
- Beta: median -0.00, min -0.07, max 0.10.
- Alpha (plain) median 16.23% a year. Alpha (Jensen, risk-free rate removed) median 9.92% a year.
- Maximum drawdown = min(NAV / running max - 1), on real NAV days.
- Common-window drawdown: median -16.3%, worst -52.6% (SBI Small Cap Fund - Direct Plan - Growth, 2023-01-17 to 2025-10-28).
- NIFTY100 drawdown in the same window: -33.0% (2022-09-21 to 2024-10-17).
- Funds that have not recovered to their peak: 4.
- Checks passed: index regressed on itself gives slope 1, one fund recomputed by hand, brute force drawdown for one fund, drawdowns between -100 and 0.

## Assumptions to confirm
- All funds are compared with the Nifty 100. Small cap, debt, and liquid funds fit it poorly (see weak_fit).
- The index file may be a price index. Then alpha is a little too high (dividends are missing).
- The rule for repeated index dates: keep the last row.
- Alpha uses plain returns, as in the task. Jensen alpha is shown for comparison.
- Drawdown uses real NAV days only. The full-history values depend on how long each fund has existed.