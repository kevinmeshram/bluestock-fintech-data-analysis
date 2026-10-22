# Investor transactions cleaning summary

- Rows at start: 32778. Rows at end: 32778.
- Identical rows (not removed, no transaction ID): 0.
- Rows for each type: {'SIP': 19716, 'Lumpsum': 8095, 'Redemption': 4967}.
- Date formats found: {'9999-99-99': 32778}.
- Rows removed (date missing or not readable): 0.
- KYC status: {'Verified': 30146, 'Pending': 2632}.
- KYC missing: 0. KYC value not in the allowed list: 0.
- Final checks passed: types, amounts, dates, KYC values.

## Assumptions to confirm with my manager
- Identical rows can be real transactions, so they were kept.
- All amounts must be positive. The transaction type shows the direction.
- The list of allowed KYC values.