# Data quality summary: AMFI codes

- Fund master: 40 rows, 40 unique AMFI codes, 0 repeated codes.
- NAV history: 46000 rows, 40 unique AMFI codes.
- Check 1 (PASS): 0 fund master codes are not in NAV history.
- Check 2: 0 NAV history codes are not in the fund master.
- NAV rows for each code: smallest 1150, largest 1150.
- NAV date range: 2022-01-03 00:00:00 to 2026-05-29 00:00:00.
- NAV table problems: 0 empty values, 0 duplicate rows, 0 repeated (code, date) pairs.
- NAV values: 0 not numbers, 0 zero or negative. Dates not valid: 0.