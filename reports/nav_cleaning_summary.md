# NAV history cleaning summary

- Rows at start: 46000. Rows at end: 64320. The end has more rows because weekends and holidays were added.
- Missing NAV values in the raw file: 0.
- Dates missing or not readable: 0 (rows removed).
- NAV values that were not numbers: 0. NAV zero or negative: 0. Both were treated as missing and then filled.
- Exact duplicate rows removed: 0.
- Same fund and date with different NAV: 0 (kept the last row).
- Rows filled with the last NAV: 18320 (column is_filled = True). Longest fill: 7 days.
- Rows removed because the gap was longer than 7 days or no earlier NAV existed: 0.
- Funds: 40. Dates: 2022-01-03 to 2026-05-29.
- Final checks passed: no missing NAV, all NAV above 0, no repeated fund and date, sorted by amfi_code and date.

## Assumptions to confirm with my manager
- When a fund has two NAV values on one date, the last row is the correct one.
- A gap of up to 7 days is a weekend or holiday. A longer gap is missing data.