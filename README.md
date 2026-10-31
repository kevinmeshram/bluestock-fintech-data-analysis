# bluestock-fintech-data-analysis

|       Table       |    Type   |               Grain               |          Primary key         |                     Foreign keys                     |                  Source file                 |
|:-----------------:|:---------:|:---------------------------------:|:----------------------------:|:----------------------------------------------------:|:--------------------------------------------:|
| dim_date          | Dimension | One calendar day                  | date_key                     | None                                                 | Made by you                                  |
| dim_fund          | Dimension | One scheme (one plan, one option) | amfi_code                    | None                                                 | 01_fund_master                               |
| fact_nav          | Fact      | One fund on one date              | amfi_code, date_key          | amfi_code to dim_fund; date_key to dim_date          | 02_nav_history (Task 8 clean file)           |
| fact_transactions | Fact      | One transaction                   | transaction_id               | amfi_code to dim_fund; date_key to dim_date          | 08_investor_transactions (Task 9 clean file) |
| fact_performance  | Fact      | One fund at one snapshot date     | amfi_code, snapshot_date_key | amfi_code to dim_fund; snapshot_date_key to dim_date | 07_scheme_performance (Task 10 clean file)   |
| fact_aum          | Fact      | One fund house on one date        | date_key, fund_house         | date_key to dim_date                                 | 03_aum_by_fu                                 |