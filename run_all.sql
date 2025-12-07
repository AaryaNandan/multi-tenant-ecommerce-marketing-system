-- run_all.sql: apply schema, seed data, then run queries
-- Usage (MySQL): mysql -u root -p marketplace < run_all.sql
SOURCE 03_create_tables.sql;
SOURCE 05_seed_data.sql;
SOURCE 06_crud_and_queries.sql;
