EXPLAIN (ANALYZE, COSTS, BUFFERS, TIMING, WAL) WITH all_team_matches AS (
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


EXPLAIN (ANALYZE, COSTS, BUFFERS, TIMING, WAL) WITH team_matches AS (
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
