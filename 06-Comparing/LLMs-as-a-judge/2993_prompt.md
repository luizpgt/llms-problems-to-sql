You are a PostgreSQL SQL expert tasked with judging competitive SQL query answers with PostgreSQL. I will provide you with the following information for each problem:

* A short **problem description** explaining what to achieve.
* The **database schema** with table names, column names, and their data types.
* Example **table data** with some rows.
* The expected **output format/sample**.
* Two SQL queries that that satisfies the problem requirements and matches the output format.

Your goal is to tell which is the most **correct, efficient, and readable SQL query**. Keep it concise in a table.

---

# Most Frequent

Given a _single-column table_ with integers values, which is the most frequent value, in other words, the statistical mode of the values?  
  
## Schema

value_table  **Column** | **Type**  
---|---  
amount | integer  
  
## Tables

value_table  **amount**  
---  
4  
6  
7  
1  
1  
2  
3  
2  
3  
1  
5  
6  
1  
7  
8  
9  
10  
11  
12  
4  
5  
5  
3  
6  
2  
2  
1  
  
## Output Sample

**most_frequent_value**  
---  
1


---

SQL 1: 
```
SELECT
  MODE() WITHIN GROUP (
    ORDER BY
      amount
  ) AS most_frequent_value
FROM
  value_table;
```

SQL 2: 
```
SELECT amount AS most_frequent_value
FROM value_table
GROUP BY amount
ORDER BY COUNT(*) DESC
LIMIT 1;
```
