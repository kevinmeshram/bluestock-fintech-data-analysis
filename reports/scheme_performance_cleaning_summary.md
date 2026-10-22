# Scheme performance cleaning summary

- Rows: 40 at the start and 40 at the end. No row was removed.
- Values that were not numbers, by column: {'return_1yr_pct': 0, 'return_3yr_pct': 0, 'return_5yr_pct': 0, 'benchmark_3yr_pct': 0, 'alpha': 0, 'beta': 0, 'sharpe_ratio': 0, 'sortino_ratio': 0, 'std_dev_ann_pct': 0, 'max_drawdown_pct': 0, 'aum_crore': 0, 'expense_ratio_pct': 0, 'morningstar_rating': 0}.
- Hard-rule values changed to missing, by column: {'return_1yr_pct': 0, 'return_3yr_pct': 0, 'return_5yr_pct': 0, 'benchmark_3yr_pct': 0, 'max_drawdown_pct': 0, 'std_dev_ann_pct': 0, 'aum_crore': 0, 'morningstar_rating': 0, 'expense_ratio_pct': 0}.
- Expense ratio, rule 0.1% to 2.5%: {'in range': 40}.
- Flags (number of rows): {'not_number': 0, 'hard_invalid': 0, 'expense_out_of_range': 0, 'drawdown_sign_odd': 0}.
- Rows with at least one flag: 0 of 40. These are in scheme_performance_review_list.csv.
- Final checks passed: numeric columns, returns not below -100, expense ratio 0 to 100, row count.

## Assumptions to confirm with my manager
- The range 0.1% to 2.5% applies to all categories and plans. Index funds and liquid funds can be cheaper.
- Return, expense ratio, and drawdown values are in percent, not in fractions.
- A return below -100% cannot be true, so it was changed to missing.
- Flagged rows were kept. A person decides what to do with them.