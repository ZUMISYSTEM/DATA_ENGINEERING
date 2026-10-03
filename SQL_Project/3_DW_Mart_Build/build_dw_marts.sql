-- cd c:/Users/Nzume32/Documents/DATA_ENGINEERING/SQL_Project/3_DW_Mart_Build
-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: Data Warehouse(DW)- Create star schema tables
.read 01_Create_tables_dw.sql

-- Step 2: Loading data from CSV files into  tables
.read 02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart table (denormalized data warehouse)
.read 03_create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read 04_create_skills_mart.sql

-- Step 5: Mart - Create priority roles mart
.read 05_create_priority_mart.sql

-- Step 6: Mart - Update priority roles mart
.read 06_update_priority_mart.sql