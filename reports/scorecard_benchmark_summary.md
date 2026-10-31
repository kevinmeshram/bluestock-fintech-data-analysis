# Scorecard and benchmark comparison summary

- Score (0 to 100) = 30% x 3-year return rank + 25% x Sharpe rank + 20% x alpha rank + 15% x expense ratio rank (inverse) + 10% x max drawdown rank (inverse).
- Each rank is changed to points: 100 x (N - rank) / (N - 1). Rank 1 gets 100 points.
- Funds with a score: 40 of 40. A fund with a missing part has no score.
- Top 5: ['Mirae Asset Large Cap Fund - Regular - Growth', 'ICICI Pru Midcap Fund - Regular - Growth', 'Kotak Flexicap Fund - Regular - Growth', 'HDFC Mid-Cap Opportunities Fund - Regular - Growth', 'ICICI Pru Bluechip Fund - Direct - Growth'].
- Rank correlation with an equal-weight score: 0.97. Funds in both top 5 lists: 5 of 5.
- Benchmark window: 2023-05-29 to 2026-05-29. Tracking error = std(fund return - index return) x sqrt(252).
- Tracking error of the top 5 against the Nifty 50: [19.19, 22.84, 20.51, 22.82, 18.82] (percent a year).
- Tracking error of the top 5 against the Nifty 100: [18.8, 23.27, 20.65, 22.5, 18.73] (percent a year).
- Checks passed: score between 0 and 100, one fund recomputed with scipy, direction of the inverse parts, index against index, one fund recomputed by hand.

## Assumptions to confirm with my manager
- A fund with a missing part gets no score.
- All funds are ranked together. See score_in_category for the score inside categories.
- The parts overlap (return, Sharpe, alpha). See the correlation table in the notebook.
- The Nifty 50 and the Nifty 100 are used for every fund. Debt funds and mid or small cap funds have another benchmark.
- The index files may be price indices (no dividends).