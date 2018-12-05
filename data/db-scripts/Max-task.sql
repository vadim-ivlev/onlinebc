CREATE TABLE IF NOT EXISTS "test" (
  "id" SERIAL PRIMARY KEY,
  "username" jsonb
);

INSERT INTO "test" ("username") VALUES
('[{"id": 1,"title": "Max"},{"id": 2,"title": "Chagin"},{"id": 3,"title": "Chagin"},{"id": 4,"title": "Chagin"}]');


-- Delete element from jsonb
UPDATE test
   SET username = username #- coalesce(('{' || (
            SELECT i
              FROM generate_series(0, jsonb_array_length(username) - 1) AS i
             WHERE (username->i->'id' = '2')
         ) || '}')::text[], '{}') WHERE id = 1;

     

(SELECT i
              FROM generate_series(0, jsonb_array_length(username) - 1) AS i
             WHERE (username->i->'id' = '2'));
             
         
         
-- **********************************************************************88
with k as (
    SELECT ind as i
    FROM test, generate_series(0, jsonb_array_length(username) - 1) AS ind
    WHERE (username->ind->'id' = '2')
    group by ind
    ),
    j as ( SELECT array(select i from k) as a )
update test set username = jsonb_set("username",( select a from j )::text[] || '{age}'::text[], '1'::jsonb) where id = 1 returning id,username;



SELECT i FROM test, generate_series(0, jsonb_array_length(username) - 1) AS i
    WHERE (username->i->'id' = '1');
    


SELECT (test.username->1) FROM test;

SELECT *, row_number() OVER () as rnum FROM test2 CROSS JOIN  test1;

SELECT generate_series(0,9) AS s;


SELECT * FROM test2 CROSS JOIN  generate_series(0, 1) as i;


DROP  TABLE  IF EXISTS ttt;

CREATE TABLE ttt AS
select value, row_number() OVER () as rnum 
    from json_array_elements(
        (SELECT username FROM test WHERE id=1)::json
    ) AS t;


-------------------------------------------------------
SELECT rnum
FROM (
        select value, row_number() OVER () as rnum 
        from json_array_elements
        (
        
            (SELECT username FROM test WHERE id=1)::json
        ) AS 
        
    ) AS temp_table
WHERE (value->>'id')::int = 10
;




-- ------------------------------------------------------------
DO $$
DECLARE
--ttt;
BEGIN

DROP  TABLE  IF EXISTS ttt;    
    
CREATE  TABLE ttt AS
select value, row_number() OVER () as rnum 
    from json_array_elements(
        (SELECT username FROM test WHERE id=1)::json
    ) AS t;

RAISE NOTICE 'num = %', (
SELECT rnum
FROM ttt
WHERE (value->>'id')::int = 3
)
;

END $$;




