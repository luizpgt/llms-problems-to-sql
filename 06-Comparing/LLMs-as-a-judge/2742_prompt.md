You are a PostgreSQL SQL expert tasked with judging competitive SQL query answers with PostgreSQL. I will provide you with the following information for each problem:

* A short **problem description** explaining what to achieve.
* The **database schema** with table names, column names, and their data types.
* Example **table data** with some rows.
* The expected **output format/sample**.
* Two SQL queries that that satisfies the problem requirements and matches the output format.

Your goal is to tell which is the most **correct, efficient, and readable SQL query**. Keep it concise in a table.

---

# Richard's Multiverse

Richard is a famous scientist because of his multiverse theory, where he describes every hypothetical set of parallel universes by means of a database. Thanks to that you now have a job..  
  
As your first task, you must select every Richard from dimensions C875 and C774, together with its existence probability (the famous factor N) with three decimal places of precision.

Remember that the N factor is calculated by multiplying the **omega** value by 1,618. The data must be sorted by the least **omega** value.

## Schema

dimensions  **Column** | **Type**  
---|---  
id (PK) | numeric  
name | varchar  
life_registry  **Column** | **Type**  
---|---  
id (PK) | numeric  
name | varchar  
omega | numeric  
dimensions_id (FK) | numeric  
  
## Tables

dimensions  **id** | **name**  
---|---  
1 | C774  
2 | C784  
3 | C794  
4 | C824  
5 | C875  
life_registry  **id** | **name** | **omega** | **dimensions_id**  
---|---|---|---  
1 | Richard Postman | 5.6 | 2  
2 | Simple Jelly | 1.4 | 1  
3 | Richard Gran Master | 2.5 | 1  
4 | Richard Turing | 6.4 | 4  
5 | Richard Strall | 1.0 | 3  
  
## Output Sample

**name** | **The N Factor**  
---|---  
Richard Gran Master | 4.045


---

SQL 1: 
```
SELECT
  lr.name,
  CAST(lr.omega * 1.618 AS NUMERIC(10, 3)) AS "The N Factor"
FROM
  life_registry AS lr
JOIN
  dimensions AS d ON lr.dimensions_id = d.id
WHERE
  d.name IN ('C774', 'C875') AND lr.name LIKE 'Richard%'
ORDER BY
  lr.omega;
```

SQL 2: 
```
SELECT 
    lr.name,
    ROUND(lr.omega * 1.618, 3) AS "The N Factor"
FROM life_registry lr
INNER JOIN dimensions d ON lr.dimensions_id = d.id
WHERE lr.name LIKE '%Richard%'
    AND d.name IN ('C875', 'C774')
ORDER BY lr.omega ASC;
```
