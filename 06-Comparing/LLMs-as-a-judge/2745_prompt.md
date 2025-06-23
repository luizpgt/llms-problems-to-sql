You are a PostgreSQL SQL expert tasked with judging competitive SQL query answers with PostgreSQL. I will provide you with the following information for each problem:

* A short **problem description** explaining what to achieve.
* The **database schema** with table names, column names, and their data types.
* Example **table data** with some rows.
* The expected **output format/sample**.
* Two SQL queries that that satisfies the problem requirements and matches the output format.

Your goal is to tell which is the most **correct, efficient, and readable SQL query**. Keep it concise in a table.

---

# Taxes

You are going to the International Personal Tax meeting and your proposal is: every individual with income higher than 3000 must pay a tax to the government, which is 10% of his/her income.  
  
Show the name and the tax value of each person who earns more than 3000, with two decimal places of precision.

## Schema

people  **Column** | **Type**  
---|---  
id (PK) | integer  
name | varchar  
salary | numeric  
  
## Tables

people  **id** | **name** | **salary**  
---|---|---  
1 | James M. Tabarez | 883  
2 | Rafael T. Hendon | 4281  
3 | Linda J. Gardner | 4437  
4 | Nicholas J. Conn | 8011  
5 | Karol A. Morales | 2508  
6 | Lolita S. Graves | 8709  
  
## Output Sample

**name** |  **tax******  
---|---  
Rafael T. Hendon | 428.10  
Linda J. Gardner | 443.70  
Nicholas J. Conn | 801.10  
Lolita S. Graves | 870.90


---

SQL 1: 
```
SELECT
  name,
  ROUND(salary * 0.1, 2) AS tax
FROM
  people
WHERE
  salary > 3000;
```

SQL 2: 
```
SELECT 
    name,
    ROUND(salary * 0.10, 2) AS tax
FROM people
WHERE salary > 3000;
```
