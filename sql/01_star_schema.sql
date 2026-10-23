  -- Star schema for the Bluestock project (SQLite)
-- Run with: PRAGMA foreign_keys = ON; set on the connection.

-- ---------------------------------------------------------------
-- Drop old tables. Children first, parents last.
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS fact_aum;
DROP TABLE IF EXISTS fact_performance;
DROP TABLE IF EXISTS fact_transactions;
DROP TABLE IF EXISTS fact_nav;
DROP TABLE IF EXISTS dim_fund;
DROP TABLE IF EXISTS dim_date;

-- ---------------------------------------------------------------
-- dim_date: one row for each calendar day
-- date_key is a smart key: 20261022 means 22 October 2026
-- ---------------------------------------------------------------
CREATE TABLE dim_date (
    date_key        INTEGER PRIMARY KEY,
    full_date       TEXT    NOT NULL UNIQUE,            -- 'YYYY-MM-DD'
    year            INTEGER NOT NULL,
    quarter         INTEGER NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    month           INTEGER NOT NULL CHECK (month BETWEEN 1 AND 12),
    month_name      TEXT    NOT NULL,
    day_of_month    INTEGER NOT NULL CHECK (day_of_month BETWEEN 1 AND 31),
    day_of_week     INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),  -- 0 = Monday, 6 = Sunday
    day_name        TEXT    NOT NULL,
    week_of_year    INTEGER NOT NULL CHECK (week_of_year BETWEEN 0 AND 53),
    is_weekend      INTEGER NOT NULL CHECK (is_weekend IN (0, 1)),
    fiscal_year     INTEGER NOT NULL,                   -- Indian financial year, 1 April to 31 March. Stores the year it ends in.
    fiscal_quarter  INTEGER NOT NULL CHECK (fiscal_quarter BETWEEN 1 AND 4)  -- April to June = 1
) STRICT;

-- ---------------------------------------------------------------
-- dim_fund: one row for each scheme (source: 01_fund_master)
-- amfi_code is a natural key
-- ---------------------------------------------------------------
CREATE TABLE dim_fund (
    amfi_code           INTEGER PRIMARY KEY,
    fund_house          TEXT    NOT NULL,
    scheme_name         TEXT    NOT NULL,
    category            TEXT,
    sub_category        TEXT,
    plan                TEXT,
    launch_date         TEXT,                           -- 'YYYY-MM-DD'
    benchmark           TEXT,
    expense_ratio_pct   REAL CHECK (expense_ratio_pct >= 0),
    exit_load_pct       REAL CHECK (exit_load_pct >= 0),
    min_sip_amount      REAL CHECK (min_sip_amount >= 0),
    min_lumpsum_amount  REAL CHECK (min_lumpsum_amount >= 0),
    fund_manager        TEXT,
    risk_category       TEXT,
    sebi_category_code  TEXT
) STRICT;

CREATE INDEX idx_dim_fund_house    ON dim_fund (fund_house);
CREATE INDEX idx_dim_fund_category ON dim_fund (category);

-- ---------------------------------------------------------------
-- fact_nav: one row for each fund on each date
-- ---------------------------------------------------------------
CREATE TABLE fact_nav (
    amfi_code   INTEGER NOT NULL,
    date_key    INTEGER NOT NULL,
    nav         REAL    NOT NULL CHECK (nav > 0),
    is_filled   INTEGER NOT NULL DEFAULT 0 CHECK (is_filled IN (0, 1)),   -- 1 = copied from the last business day
    PRIMARY KEY (amfi_code, date_key),
    FOREIGN KEY (amfi_code) REFERENCES dim_fund (amfi_code),
    FOREIGN KEY (date_key)  REFERENCES dim_date (date_key)
) STRICT;

CREATE INDEX idx_fact_nav_date ON fact_nav (date_key);

-- ---------------------------------------------------------------
-- fact_transactions: one row for each transaction
-- transaction_id is a surrogate key. The source file has no ID.
-- ---------------------------------------------------------------
CREATE TABLE fact_transactions (
    transaction_id      INTEGER PRIMARY KEY,
    investor_id         TEXT    NOT NULL,
    date_key            INTEGER NOT NULL,
    amfi_code           INTEGER NOT NULL,
    transaction_type    TEXT    NOT NULL CHECK (transaction_type IN ('SIP', 'Lumpsum', 'Redemption')),
    amount_inr          REAL    NOT NULL CHECK (amount_inr > 0),
    payment_mode        TEXT,
    kyc_status          TEXT,                           -- add a CHECK when your manager gives the allowed list
    state               TEXT,
    city                TEXT,
    city_tier           TEXT,
    age_group           TEXT,
    gender              TEXT,
    annual_income_lakh  REAL CHECK (annual_income_lakh >= 0),
    FOREIGN KEY (date_key)  REFERENCES dim_date (date_key),
    FOREIGN KEY (amfi_code) REFERENCES dim_fund (amfi_code)
) STRICT;

CREATE INDEX idx_fact_tx_investor ON fact_transactions (investor_id);
CREATE INDEX idx_fact_tx_date     ON fact_transactions (date_key);
CREATE INDEX idx_fact_tx_fund     ON fact_transactions (amfi_code);

-- ---------------------------------------------------------------
-- fact_performance: one row for each fund at one snapshot date
-- The source file has no date, so snapshot_date_key is filled when you load.
-- ---------------------------------------------------------------
CREATE TABLE fact_performance (
    amfi_code           INTEGER NOT NULL,
    snapshot_date_key   INTEGER NOT NULL,
    return_1yr_pct      REAL CHECK (return_1yr_pct >= -100),
    return_3yr_pct      REAL CHECK (return_3yr_pct >= -100),
    return_5yr_pct      REAL CHECK (return_5yr_pct >= -100),
    benchmark_3yr_pct   REAL CHECK (benchmark_3yr_pct >= -100),
    alpha               REAL,
    beta                REAL,
    sharpe_ratio        REAL,
    sortino_ratio       REAL,
    std_dev_ann_pct     REAL CHECK (std_dev_ann_pct >= 0),
    max_drawdown_pct    REAL CHECK (max_drawdown_pct BETWEEN -100 AND 100),
    aum_crore           REAL CHECK (aum_crore >= 0),
    expense_ratio_pct   REAL CHECK (expense_ratio_pct BETWEEN 0 AND 100),
    morningstar_rating  INTEGER CHECK (morningstar_rating BETWEEN 1 AND 5),
    anomaly_count       INTEGER NOT NULL DEFAULT 0 CHECK (anomaly_count >= 0),   -- from Task 10
    PRIMARY KEY (amfi_code, snapshot_date_key),
    FOREIGN KEY (amfi_code)         REFERENCES dim_fund (amfi_code),
    FOREIGN KEY (snapshot_date_key) REFERENCES dim_date (date_key)
) STRICT;

-- ---------------------------------------------------------------
-- fact_aum: one row for each fund house on each date
-- The source has no amfi_code, so fund_house stays as text.
-- The source also has aum_lakh_crore. It is the same value in another unit,
-- so it is not stored. 1 lakh crore = 100000 crore.
-- ---------------------------------------------------------------
CREATE TABLE fact_aum (
    date_key        INTEGER NOT NULL,
    fund_house      TEXT    NOT NULL,
    aum_crore       REAL CHECK (aum_crore >= 0),
    num_schemes     INTEGER CHECK (num_schemes >= 0),
    PRIMARY KEY (date_key, fund_house),
    FOREIGN KEY (date_key) REFERENCES dim_date (date_key)
) STRICT;

CREATE INDEX idx_fact_aum_house ON fact_aum (fund_house);