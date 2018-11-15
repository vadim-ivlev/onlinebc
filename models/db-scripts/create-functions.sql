/*

## Functions to represent tables as JSONs

*/

-- get_posts:  returns json of posts by broadcast id

DROP FUNCTION IF EXISTS get_posts(integer);

CREATE OR REPLACE FUNCTION get_posts(idd integer) RETURNS json AS $$
BEGIN   
    RETURN  
    (
        select array_to_json(array_agg(row_to_json( t, false )),true) from 
        ( 
            SELECT 
                id,
                id_parent,
                id_broadcast,
                author          posts__author,
                "text"          posts__text,
                post_type       posts__type,
                link            posts__uri,
                to_char(to_timestamp(post_time::double precision), 'DD.MM.YYYY'::text)    AS posts__date,
                to_char(to_timestamp(post_time::double precision), 'HH24:MI'::text)       AS posts__time,
                ('[]')::json    posts__media,
                ('[]')::json    posts__answers
            FROM 
                post 
            WHERE 
                    id_broadcast = idd 
                AND id_parent = 0
        ) t 
    );
    
END;
$$ LANGUAGE plpgsql;

-- test
--SELECT get_posts(354);
SELECT jsonb_pretty( get_posts(354)::jsonb);






-- get_broadcast(id): returns json of a broadcast by id.

DROP FUNCTION IF EXISTS get_broadcast(integer);

CREATE OR REPLACE FUNCTION get_broadcast(idd integer) RETURNS json AS $$
BEGIN   
    RETURN  
    (
        select row_to_json(t, true)
        from 
        ( select *, get_posts(id) as posts  from broadcast where id = idd ) t 
    );
    
END;
$$ LANGUAGE plpgsql;


-- test 
SELECT get_broadcast(247);
SELECT jsonb_pretty( get_broadcast(247)::jsonb);



SELECT jsonb_pretty ( (broadcast->'online'->'broadcast'->0->'posts') ::jsonb ) "json" FROM broadcast_json WHERE id=247;
SELECT jsonb_pretty ( get_posts(247)::jsonb);
