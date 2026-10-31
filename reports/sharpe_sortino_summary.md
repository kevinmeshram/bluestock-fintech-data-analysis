# Sharpe and Sortino summary

- Sharpe = (mean daily return - daily Rf) / std of daily returns x sqrt(252).
- Rf = 6.5% a year (RBI repo rate proxy). Daily Rf = Rf / 252 = 0.02579%.
- Common window for all funds: 2022-01-04 to 2026-05-29 (4.40 years).
- Funds ranked: 40. NAV days a year in the data: 261.
- Sortino (task version) uses the standard deviation of the negative days only.
- Sortino (textbook version) uses the downside deviation over all days, with a target of 0.
- Best 3 by Sharpe: ['Mirae Asset Large Cap Fund - Regular - Growth', 'Kotak Flexicap Fund - Regular - Growth', 'Mirae Asset Tax Saver Fund - Regular - Growth'].
- Worst 3 by Sharpe: ['ABSL Liquid Fund - Regular - Growth', 'HDFC Short Term Debt Fund - Regular - Growth', 'Nippon India Gilt Securities Fund - Regular - Growth'].
- Funds with a negative Sharpe ratio: 9.
- IDCW funds (payouts look like losses): 0.
- Rank agreement (Spearman): common vs full history 1.00; Sharpe vs source -0.22; Sortino task vs source -0.33; Sortino textbook vs source -0.29.
- Checks passed: one fund recomputed by hand, sign of Sharpe follows the excess return.

## Assumptions to confirm
- Rf is fixed at 6.5% for the whole period.
- 252 trading days a year.
- The ranking uses the common window, so all funds are compared on the same dates.
- Which Sortino version to use: the task version or the textbook version.
- Funds of different categories (equity, debt, liquid) are not directly comparable. See rank_sharpe_in_category.