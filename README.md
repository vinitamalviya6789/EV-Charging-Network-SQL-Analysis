# EV Charging Network Operations & Revenue Analysis

## Project Overview

This project analyzes an EV charging network using PostgreSQL to understand charging activity, customer behavior, station performance, energy consumption, and payment patterns.

The goal is to turn raw relational data into useful business insights that can support operational and revenue-related decisions.

## Business Questions

The analysis focuses on questions such as:

- How active is the charging network?
- Which cities and stations have higher charging activity?
- How much energy is being consumed?
- Which customers and vehicle models contribute more to charging usage?
- Which payment methods are used most often?
- How is charging revenue distributed across the network?
- Which charging infrastructure areas may require closer attention?

## Database Structure

The project contains 7 relational tables:

- `customers`
- `vehicles`
- `locations`
- `stations`
- `chargers`
- `charging_sessions`
- `payments`

The tables are connected using primary keys and foreign keys to represent a realistic EV charging business environment.

## SQL Analysis

The project uses PostgreSQL and includes analysis using:

- SELECT and filtering
- Aggregate functions
- GROUP BY and HAVING
- INNER and LEFT JOINs
- Subqueries
- CASE and conditional logic
- Date and timestamp analysis
- RANK and DENSE_RANK
- PARTITION BY
- LAG
- Window functions

## Key Findings

- Total collected revenue: **₹13,261.50**
- Total energy consumed: **884.10 kWh**
- Highest-activity city: **Jaipur with 8 completed sessions**
- Most-used successful payment method: **Card with 11 payments**
- Highest energy-consuming vehicle model: **Hyundai Ioniq 5 with 134.70 kWh**

## Project Structure

```text
EV Charging SQL Analysis
│
├── README.md
├── Data
├── SQL
│   ├── 01_analysis_queries.sql
│   └── 02_final_insights.sql
├── Documentation
│   └── Database_Schema.md
└── Insights
    └── Key_Findings.md 


    Tools Used
PostgreSQL
pgAdmin
SQL
Objective

The project demonstrates how SQL can be used to explore relational business data, identify meaningful patterns, and produce insights that can support operational decision-making.

