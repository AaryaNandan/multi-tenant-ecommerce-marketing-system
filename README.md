# Multi-Vendor E-Commerce Marketplace (DBMS Project)

**Project**: Multi-Vendor E-Commerce Marketplace

**Team**: <Archi Data>
**Team**: <Aarya Nandan>
**Team**: <Akshaj Kumar>
**Team**: <Rakshitha>

**DBMS**: MySQL (preferred) — compatible with PostgreSQL with small datatype/DDL tweaks

## Overview
This project builds a normalized relational schema and supporting artifacts for a marketplace where vendors list products, customers browse and buy, and admins moderate. Core functionality: product & inventory management, shopping carts, orders/payments, shipments, reviews, and vendor dashboards.

## Quickstart (MySQL)
1. Install MySQL and MySQL Workbench.
2. Create database: `CREATE DATABASE marketplace; USE marketplace;`
3. Run DDL: `mysql -u root -p marketplace < 03_create_tables.sql`
4. Load seed data: `mysql -u root -p marketplace < 05_seed_data.sql` (when ready)
5. Run queries: `mysql -u root -p marketplace < 06_crud_and_queries.sql`

## Deliverables (starter)
- 01_requirements.md
- 02_er_diagram.* (create using dbdiagram.io/draw.io)
- 02_er_notes.md
- 03_schema_draft.md
- 03_create_tables.sql
- 04_normalization.md
- 05_seed_data.sql
- 06_crud_and_queries.sql
- 07_indexes.sql
- 08_transactions.sql
- 09_constraints.sql
- 10_backup_restore.md
- README.md

## Notes
- Replace placeholder names and tweak datatypes for PostgreSQL if you use it.
