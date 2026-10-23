# SQLite load summary

- Database: bluestock_dw.db. Tables loaded: 6. All loaded in one transaction.
- Method: SQLAlchemy engine and DataFrame.to_sql with if_exists=append. Foreign keys were ON.

## Row counts (source, DataFrame, database)
```
            table  source_rows  dataframe_rows  database_rows  match
         dim_fund           40              40             40   True
         fact_nav        64320           64320          64320   True
fact_transactions        32778           32778          32778   True
 fact_performance           40              40             40   True
         fact_aum           90              90             90   True
         dim_date         1608            1608           1608   True
```

## Other checks
- Transaction amounts match: True.
- NAV sum matches: True.
- AUM sum matches: True.
- Foreign key problems: 0. Integrity check: ok.
- fund_house names in fact_aum that are not in dim_fund: 0.
- dim_date: 1608 days, from 2022-01-03 to 2026-05-29.
