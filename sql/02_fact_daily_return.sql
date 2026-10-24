-- fact_daily_return: one row for each fund on each day that has a NAV from the source
-- and a previous NAV. daily_return is a fraction: 0.01 means 1 percent.

DROP TABLE IF EXISTS fact_daily_return;

CREATE TABLE fact_daily_return (
    amfi_code        INTEGER NOT NULL,
    date_key         INTEGER NOT NULL,
    days_since_prev  INTEGER NOT NULL CHECK (days_since_prev >= 1),
    daily_return     REAL    NOT NULL CHECK (daily_return > -1),
    PRIMARY KEY (amfi_code, date_key),
    FOREIGN KEY (amfi_code) REFERENCES dim_fund (amfi_code),
    FOREIGN KEY (date_key)  REFERENCES dim_date (date_key)
) STRICT;

CREATE INDEX idx_fact_daily_return_date ON fact_daily_return (date_key);