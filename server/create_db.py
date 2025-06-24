import sqlite3

db_path = "mcm.db"
SCRIPT = """
PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS user (
    user_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    account      TEXT UNIQUE NOT NULL,
    password     TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS electricity (
    user_id                  INTEGER,
    year                     INTEGER,
    month                    INTEGER CHECK (month BETWEEN 1 AND 12),
    consumption              REAL CHECK (consumption >= 0),
    PRIMARY KEY (user_id, year, month),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);
"""

# """
# /* === 維度表 === */
# CREATE TABLE industry_types (
#     industry_type_id INTEGER PRIMARY KEY,
#     name             TEXT UNIQUE
# );

# CREATE TABLE device_types (
#     device_type_id   INTEGER PRIMARY KEY,
#     name             TEXT UNIQUE
# );

# CREATE TABLE refrigerant_types (
#     refrigerant_type_id INTEGER PRIMARY KEY,
#     name                TEXT UNIQUE
# );

# /* === 使用者 === */
# CREATE TABLE users (
#     user_id      INTEGER PRIMARY KEY AUTOINCREMENT,
#     account      TEXT UNIQUE NOT NULL,
#     password     TEXT NOT NULL,
#     shop_name    TEXT,
#     phone        TEXT,
#     industry_type_id INTEGER,
#     email        TEXT,
#     postal_code  TEXT,
#     region       TEXT,
#     address      TEXT,
#     FOREIGN KEY (industry_type_id)
#         REFERENCES industry_types(industry_type_id)
# );

# /* === 活動數據 === */

# CREATE TABLE refrigerants (
#     user_id                INTEGER,
#     year                   INTEGER,
#     name                   TEXT,
#     count                  REAL CHECK (count >= 0),
#     use_month              REAL CHECK (use_month >= 0),
#     refrigerant_supplement REAL CHECK (refrigerant_supplement >= 0),
#     refrigerant_type_id    INTEGER,
#     device_type_id         INTEGER,
#     PRIMARY KEY (user_id, year, name),
#     FOREIGN KEY (user_id)            REFERENCES users(user_id)            ON DELETE CASCADE,
#     FOREIGN KEY (refrigerant_type_id) REFERENCES refrigerant_types(refrigerant_type_id),
#     FOREIGN KEY (device_type_id)     REFERENCES device_types(device_type_id)
# );

# CREATE TABLE fuels (
#     user_id   INTEGER,
#     year      INTEGER,
#     month     INTEGER CHECK (month BETWEEN 1 AND 12),
#     gasoline  REAL CHECK (gasoline  >= 0),
#     diesel    REAL CHECK (diesel    >= 0),
#     PRIMARY KEY (user_id, year, month),
#     FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
# );

# CREATE TABLE employees (
#     user_id              INTEGER,
#     year                 INTEGER,
#     month                INTEGER CHECK (month BETWEEN 1 AND 12),
#     employees_count      INTEGER CHECK (employees_count >= 0),
#     working_hours_per_day  REAL CHECK (working_hours_per_day  >= 0),
#     working_days_per_month REAL CHECK (working_days_per_month >= 0),
#     PRIMARY KEY (user_id, year, month),
#     FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
# );

# /* === 係數／參數表 === */
# CREATE TABLE device_type_configs (
#     device_type_id        INTEGER,
#     year                  INTEGER,
#     equipment_escape_rate REAL,
#     PRIMARY KEY (device_type_id, year),
#     FOREIGN KEY (device_type_id) REFERENCES device_types(device_type_id)
# );

# CREATE TABLE electricity_configs (
#     year        INTEGER PRIMARY KEY,
#     coefficient REAL
# );

# CREATE TABLE employee_configs (
#     year                  INTEGER PRIMARY KEY,
#     wastewater_volume      REAL,
#     emission_factor        REAL,
#     sewage_concentration   REAL,
#     septic_tank_efficiency REAL,
#     conversion             REAL
# );

# CREATE TABLE fuel_configs (
#     year        INTEGER PRIMARY KEY,
#     gasoline_co2_emission_coef  REAL,
#     gasoline_ch4_emission_coef  REAL,
#     gasoline_n2o_emission_coef  REAL,
#     diesel_co2_emission_coef    REAL,
#     diesel_ch4_emission_coef    REAL,
#     diesel_n2o_emission_coef    REAL
# );

# CREATE TABLE gwp_configs (
#     year        INTEGER PRIMARY KEY,
#     gwp_electric REAL,
#     gwp_ch4      REAL,
#     gwp_co2      REAL,
#     gwp_n2o      REAL
# );

# CREATE TABLE refrigerant_type_configs (
#     refrigerant_type_id INTEGER,
#     year                INTEGER,
#     refrigerant_gwp     REAL,
#     PRIMARY KEY (refrigerant_type_id, year),
#     FOREIGN KEY (refrigerant_type_id) REFERENCES refrigerant_types(refrigerant_type_id)
# );

# CREATE TABLE year_configs (
#     year INTEGER PRIMARY KEY
# );

# /* === 常用索引 === */
# CREATE INDEX idx_electricities_user_ym  ON electricities(user_id, year, month);
# CREATE INDEX idx_fuels_user_ym          ON fuels(user_id, year, month);
# CREATE INDEX idx_employees_user_ym      ON employees(user_id, year, month);
# """




conn = sqlite3.connect(db_path)

cursor = conn.cursor()
cursor.executescript(SCRIPT)
conn.commit()
conn.close()
print(f"{db_path} created successfully.")


