                                                                               QUERY PLAN                                                                               
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=3.85..3.86 rows=4 width=158) (actual time=0.086..0.087 rows=4 loops=1)
   Sort Key: ((((sum(CASE WHEN (m.team_1_goals > m.team_2_goals) THEN 1 ELSE 0 END)) * 3) + (sum(CASE WHEN (m.team_1_goals = m.team_2_goals) THEN 1 ELSE 0 END)))) DESC
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=6
   ->  Hash Join  (cost=3.51..3.81 rows=4 width=158) (actual time=0.056..0.058 rows=4 loops=1)
         Hash Cond: (m.team_1 = t.id)
         Buffers: shared hit=3
         ->  HashAggregate  (cost=2.42..2.54 rows=12 width=36) (actual time=0.020..0.022 rows=4 loops=1)
               Group Key: m.team_1
               Batches: 1  Memory Usage: 24kB
               Buffers: shared hit=2
               ->  Append  (cost=0.00..2.18 rows=12 width=12) (actual time=0.003..0.006 rows=12 loops=1)
                     Buffers: shared hit=2
                     ->  Seq Scan on matches m  (cost=0.00..1.06 rows=6 width=12) (actual time=0.002..0.003 rows=6 loops=1)
                           Buffers: shared hit=1
                     ->  Seq Scan on matches m_1  (cost=0.00..1.06 rows=6 width=12) (actual time=0.001..0.001 rows=6 loops=1)
                           Buffers: shared hit=1
         ->  Hash  (cost=1.04..1.04 rows=4 width=122) (actual time=0.023..0.023 rows=4 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 9kB
               Buffers: shared hit=1
               ->  Seq Scan on teams t  (cost=0.00..1.04 rows=4 width=122) (actual time=0.010..0.011 rows=4 loops=1)
                     Buffers: shared hit=1
 Planning:
   Buffers: shared hit=133
 Planning Time: 0.493 ms
 Execution Time: 0.185 ms
(26 rows)

                                                           QUERY PLAN                                                            
---------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=2.92..2.93 rows=4 width=158) (actual time=0.049..0.050 rows=4 loops=1)
   Sort Key: (((team_stats.victories * 3) + (team_stats.draws * 1))) DESC, team_stats.name
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=5
   ->  Subquery Scan on team_stats  (cost=2.77..2.88 rows=4 width=158) (actual time=0.022..0.024 rows=4 loops=1)
         Buffers: shared hit=2
         ->  HashAggregate  (cost=2.77..2.81 rows=4 width=154) (actual time=0.021..0.022 rows=4 loops=1)
               Group Key: t.id
               Batches: 1  Memory Usage: 24kB
               Buffers: shared hit=2
               ->  Nested Loop  (cost=0.00..2.53 rows=7 width=134) (actual time=0.006..0.013 rows=12 loops=1)
                     Join Filter: ((t.id = m.team_1) OR (t.id = m.team_2))
                     Rows Removed by Join Filter: 12
                     Buffers: shared hit=2
                     ->  Seq Scan on matches m  (cost=0.00..1.06 rows=6 width=16) (actual time=0.001..0.002 rows=6 loops=1)
                           Buffers: shared hit=1
                     ->  Materialize  (cost=0.00..1.06 rows=4 width=122) (actual time=0.001..0.001 rows=4 loops=6)
                           Buffers: shared hit=1
                           ->  Seq Scan on teams t  (cost=0.00..1.04 rows=4 width=122) (actual time=0.001..0.002 rows=4 loops=1)
                                 Buffers: shared hit=1
 Planning:
   Buffers: shared hit=20
 Planning Time: 0.168 ms
 Execution Time: 0.085 ms
(24 rows)

