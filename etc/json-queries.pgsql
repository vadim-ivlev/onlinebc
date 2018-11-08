
SELECT jsonb_pretty(broadcast::jsonb) as json
FROM broadcasts
LIMIT 1;



SELECT 
    broadcast ->> 'interval' AS inter,
    CAST( broadcast -> 'online' ->> 'broadcast__id' AS INT) AS idd,
    broadcast -> 'online' ->> 'broadcast__id' AS broadcast_id,
    broadcast -> 'online' ->  'broadcast' -> 0 ->> 'name' as name

FROM broadcasts 

WHERE 

    CAST( broadcast -> 'online' ->> 'broadcast__id' AS INT) = 71

LIMIT 3;