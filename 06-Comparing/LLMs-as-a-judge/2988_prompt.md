You are a PostgreSQL SQL expert tasked with judging competitive SQL query answers with PostgreSQL. I will provide you with the following information for each problem:

* A short **problem description** explaining what to achieve.
* The **database schema** with table names, column names, and their data types.
* Example **table data** with some rows.
* The expected **output format/sample**.
* Two SQL queries that that satisfies the problem requirements and matches the output format.

Your goal is to tell which is the most **correct, efficient, and readable SQL query**. Keep it concise in a table.

---

# Cearense Championship

The Soccer Cearense Championship attracts thousands of fans every year and you work for a newspaper and are in charge to calculate the score table. Show a table with the following rows: the team name, number of matches, victories, defeats, draws, and scores. Knowing that the score is calculated with each victory valuing 3 points, draw valuing 1 and defeat valuing 0. In the end, show your table with the score from the highest to the lowest.  
  
## Schema

teams  **Column** | **Type**  
---|---  
id (PK) | integer  
name | varchar (50)  
matches  **Column** | **Type**  
---|---  
id (PK) | integer  
team_1 (FK) | integer  
team_2 (FK) | integer  
team_1_goals | integer  
team_2_goals | integer  
  
## Tables

teams  **id** | **name**  
---|---  
1 | CEARA  
2 | FORTALEZA  
3 | GUARANY DE SOBRAL  
4 | FLORESTA  
matches  **id** | **team_1** | **team_2** | **team_1_goals** | **team_2_goals**  
---|---|---|---|---  
1 | 4 | 1 | 0 | 4  
2 | 3 | 2 | 0 | 1  
3 | 1 | 3 | 3 | 0  
4 | 3 | 4 | 0 | 1  
5 | 1 | 2 | 0 | 0  
6 | 2 | 4 | 2 | 1  
  
## Output Sample

**name** | **matches** | **victories** | **defeats** | **draws** | **score**  
---|---|---|---|---|---  
CEARA | 3 | 2 | 0 | 1 | 7  
FORTALEZA | 3 | 2 | 0 | 1 | 7  
FLORESTA | 3 | 1 | 2 | 0 | 3  
GUARANY DE SOBRAL | 3 | 0 | 3 | 0 | 0


---

SQL 1: 
```
WITH all_team_matches AS (
    -- Select matches where the team is team_1
    SELECT
        m.team_1 AS team_id,
        m.team_1_goals AS goals_for,
        m.team_2_goals AS goals_against
    FROM
        matches AS m
    UNION ALL
    -- Select matches where the team is team_2 and unify with the above
    SELECT
        m.team_2 AS team_id,
        m.team_2_goals AS goals_for,
        m.team_1_goals AS goals_against
    FROM
        matches AS m
),
-- Calculate the statistics for each team
team_stats AS (
    SELECT
        team_id,
        COUNT(team_id) AS matches,
        SUM(CASE WHEN goals_for > goals_against THEN 1 ELSE 0 END) AS victories,
        SUM(CASE WHEN goals_for < goals_against THEN 1 ELSE 0 END) AS defeats,
        SUM(CASE WHEN goals_for = goals_against THEN 1 ELSE 0 END) AS draws
    FROM
        all_team_matches
    GROUP BY
        team_id
)
-- Select the final results and join to get team names
SELECT
    t.name,
    s.matches,
    s.victories,
    s.defeats,
    s.draws,
    (s.victories * 3 + s.draws) AS score
FROM
    team_stats AS s
JOIN
    teams AS t ON s.team_id = t.id
ORDER BY
    score DESC;
```

SQL 2: 
```
WITH team_matches AS (
  -- Get all matches for each team, normalizing the data
  SELECT 
    t.id,
    t.name,
    CASE 
      WHEN m.team_1 = t.id THEN m.team_1_goals
      ELSE m.team_2_goals
    END as team_goals,
    CASE 
      WHEN m.team_1 = t.id THEN m.team_2_goals
      ELSE m.team_1_goals
    END as opponent_goals
  FROM teams t
  JOIN matches m ON (t.id = m.team_1 OR t.id = m.team_2)
),
team_stats AS (
  SELECT 
    name,
    COUNT(*) as matches,
    SUM(CASE WHEN team_goals > opponent_goals THEN 1 ELSE 0 END) as victories,
    SUM(CASE WHEN team_goals < opponent_goals THEN 1 ELSE 0 END) as defeats,
    SUM(CASE WHEN team_goals = opponent_goals THEN 1 ELSE 0 END) as draws
  FROM team_matches
  GROUP BY id, name
)
SELECT 
  name,
  matches,
  victories,
  defeats,
  draws,
  (victories * 3 + draws * 1) as score
FROM team_stats
ORDER BY score DESC, name ASC;
```
