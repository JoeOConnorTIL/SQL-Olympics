# 🏅 SQL Olympics Project

This project is from a SQL challenge posted by Will Sutton which I am using to improve my use of SQL in data modeling. The task involved:

- Uploading Olympic athlete data into a database  
- Designing a **schema** with fact and dimension tables to optimise the storage of the data. 
- Practicing SQL operations like:
  - Table creation
  - Assigning primary and foreign keys
  - Populating tables using `INSERT`, `JOIN`, and CTEs  

📎 **Challenge Link**: [wjsutton/SQL_olympics](https://github.com/wjsutton/SQL_olympics)

---

## ⭐ Star Schema Design

Below is the resulting schema diagram for the project:

![Olympic Star Schema](Olympic%20Schema.png)

---

## 🔑 Key SQL takeaways:

### ✅ Creating a Table
```sql
CREATE TABLE athletes (
  athlete_id INT,
  name VARCHAR(100),
  sex VARCHAR(1),
  height INT,
  weight INT
);
```

### ✅ Populating a table with data and giving rows a unique ID (using a CTE in this example)
```sql
INSERT INTO teams
WITH teams_s1 AS (
  SELECT DISTINCT team, noc, noc_region, NOC_notes FROM staging
)
SELECT
  ROW_NUMBER() OVER (ORDER BY team) AS team_id,
  team,
  noc,
  noc_region,
  NOC_notes
FROM teams_s1;
```

### ✅ Assigning a primary key to a table
```sql
ALTER TABLE athletes
ADD PRIMARY KEY(athlete_id);
```

### ✅ Assigning a foreign key to a table
```sql
ALTER TABLE results
ADD FOREIGN KEY(team_id) REFERENCES teams(team_id);
```
