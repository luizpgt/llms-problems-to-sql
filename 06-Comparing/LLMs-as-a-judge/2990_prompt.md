You are a PostgreSQL SQL expert tasked with judging competitive SQL query answers with PostgreSQL. I will provide you with the following information for each problem:

* A short **problem description** explaining what to achieve.
* The **database schema** with table names, column names, and their data types.
* Example **table data** with some rows.
* The expected **output format/sample**.
* Two SQL queries that that satisfies the problem requirements and matches the output format.

Your goal is to tell which is the most **correct, efficient, and readable SQL query**. Keep it concise in a table.

---

# Employees CPF

Show the CPF, employees (empregados) name and department (departamentos) name of the employees that don't work (trabalha) in any project (projetos). The result must be order by CPF.  
  
## Schema

empregados  **Column** | **Type**  
---|---  
cpf (PK) | varchar (15)  
enome | varchar (60)  
salario | float  
cpf_supervisor | varchar (15)  
dnumero | integer)  
departamentos  **Column** | **Type**  
---|---  
dnumero (PK) | integer  
dnome | varchar (60)  
cpf_gerente (FK) | varchar (15)  
trabalha  **Column** | **Type**  
---|---  
cpf_emp (FK) | varchar (15)  
pnumero | integer  
projetos  **Column** | **Type**  
---|---  
pnumero (PK) | integer  
pnome | varchar (45)  
dnumero (FK) | integer  
  
## Tables

empregados  **cpf** | **enome** | **salario** | **cpf_supervisor** | **dnumero**  
---|---|---|---|---  
049382234322 | João Silva | 2350 | 2434332222 | 1010  
586733922290 | Mario Silveira | 3500 | 2434332222 | 1010  
2434332222 | Aline Barros | 2350 | (null) | 1010  
1733332162 | Tulio Vidal | 8350 | (null) | 1020  
4244435272 | Juliana Rodrigues | 3310 | (null) | 1020  
1014332672 | Natalia Marques | 2900 | (null) | 1010  
departamentos  **dnumero** | **dnome** | **cpf_gerente**  
---|---|---  
1010 | Pesquisa | 049382234322  
1020 | Ensino | 2434332222  
trabalha  **cpf_emp** | **pnumero**  
---|---  
49382234322 | 2010  
586733922290 | 2020  
49382234322 | 2020  
projetos  **pnumero** | **pnome** | **dnumero**  
---|---|---  
2010 | Alpha | 1010  
2020 | Beta | 1020  
  
## Output Sample

**cpf** | **enome** | **dnome**  
---|---|---  
1014332672 | Natalia Marques | Pesquisa  
1733332162 | Tulio Vidal | Ensino  
2434332222 | Aline Barros | Pesquisa  
4244435272 | Juliana Rodrigues | Ensino


---

SQL 1: 
```
SELECT
    e.cpf,
    e.enome,
    d.dnome
FROM
    empregados AS e
JOIN
    departamentos AS d ON e.dnumero = d.dnumero
LEFT JOIN
    trabalha AS t ON e.cpf = t.cpf_emp
WHERE
    t.cpf_emp IS NULL
ORDER BY
    e.cpf;
```

SQL 2: 
```
SELECT 
    e.cpf,
    e.enome,
    d.dnome
FROM empregados e
JOIN departamentos d ON e.dnumero = d.dnumero
WHERE e.cpf NOT IN (
    SELECT DISTINCT cpf_emp 
    FROM trabalha 
    WHERE cpf_emp IS NOT NULL
)
ORDER BY e.cpf;
```
