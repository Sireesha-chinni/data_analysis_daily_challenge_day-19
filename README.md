# Day 19 : Sql Challenge🌾 Farm Yield Optimization

A SQL data analytics challenge for **Agri-Innovate**, a company that provides data-driven solutions to farmers. The goal is to analyze farm data (planting, irrigation, harvest) to improve crop yields and optimize resource allocation for the next season.

## 📁 Repository Contents

| File | Description |
|------|-------------|
| `day_19_data_analytics_daily_challenge.sql` | Table creation scripts and all queries, labeled by task |
| `Day19_Agri.pdf` | Original challenge statement |
| `README.md` | Project documentation |

## 🗄️ Database Schema

Database: `dailychallenges_2`

```
farmers (farmer_id) ──< plots (plot_id, farmer_id) ──< yields (plot_id)
                                                   └──< irrigation_logs (plot_id)
```

| Table | Key Columns |
|-------|-------------|
| **farmers** | `farmer_id` (PK), `first_name`, `last_name`, `email`, `hire_date` |
| **plots** | `plot_id` (PK), `plot_name`, `farmer_id` (FK), `crop_type`, `soil_type` |
| **yields** | `yield_id` (PK), `plot_id` (FK), `harvest_date`, `yield_kg`, `weather_condition` |
| **irrigation_logs** | `log_id` (PK), `plot_id` (FK), `irrigation_date`, `water_amount_liters` |

`plots` is the central table. Every analysis joins through it.

## 📋 Tasks Covered

### 1. Productivity & Performance
- **Top 3 most productive plots** by average yield per harvest (`plot_name`, `crop_type`, `average_yield_kg`)
- **Total water consumption per plot**, ranked highest to lowest (`plot_name`, `total_water_liters`)

### 2. Yield & Environmental Analysis
- **Average yield per crop type** under each weather condition
- **Highest-yielding plot for each soil type** (`soil_type`, `plot_name`, `highest_yield_kg`)

### 3. Farmer & Resource Management
- **Farmer with the lowest average water consumption per plot** (`first_name`, `last_name`, `average_water_liters_per_plot`)
- **Number of harvests per month** over the last 12 months

### 4. Advanced Analysis (Bonus)
- **Inefficient plots**: below-average yield for their crop type but above-average water usage compared to other plots with the same crop (`plot_name`, `crop_type`, `yield_kg`, `water_amount_liters`)

## 🛠️ SQL Concepts Used

- `JOIN` / `LEFT JOIN` across multiple tables
- Aggregations: `AVG`, `SUM`, `MAX`, `COUNT`
- `GROUP BY` / `ORDER BY` / `LIMIT`
- Common Table Expressions (CTEs)
- Window functions (`AVG() OVER (PARTITION BY ...)`)
- Correlated subqueries
- Date functions (`MONTHNAME`)
- `COALESCE` for null handling

## ▶️ How to Run

**Requirements:** MySQL 8.0+ (window functions and CTEs are used).

1. Create the database (if it doesn't exist yet):
   ```sql
   CREATE DATABASE IF NOT EXISTS dailychallenges_2;
   ```
2. Run the script:
   ```bash
   mysql -u <username> -p < day_19_data_analytics_daily_challenge.sql
   ```
   Or open the file in MySQL Workbench and execute it.
3. **Load sample data.** The script creates the tables but does not insert any rows. Add your own `INSERT` statements or import CSVs before running the queries.

## 💡 Design Notes

- **Avoiding fan-out:** `yields` and `irrigation_logs` are never joined together in one query. Joining both to `plots` would multiply rows and inflate sums and averages. Each table is aggregated separately (CTEs and subqueries).
- **Average water per plot (Task 3):** water is first totaled per plot, then averaged per farmer, so the result reflects water per plot rather than per irrigation event.
- **Bonus query:** each plot's average yield and total water are compared against the average for its crop type.

## 📊 Results

Result tables depend on the data loaded. Run each query against your dataset and paste the output here:

```
-- Task 1a: Top 3 Productive Plots
| plot_name | crop_type | average_yield_kg |
|-----------|-----------|------------------|
|    ...    |    ...    |       ...        |
```

## 👤 Author

Ch sai sireesha · [GitHub](https://github.com/Sireesha-chinni)
