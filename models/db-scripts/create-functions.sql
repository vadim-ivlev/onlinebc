/*

## Functions and views to represent tables as JSONs


*/

DROP VIEW IF EXISTS broadcast_view;

CREATE VIEW broadcast_view AS
    SELECT
        id,
        title name,
        is_ended,

        to_char(to_timestamp(time_begin::double precision), 'DD.MM.YYYY'::text)    AS date,
        to_char(to_timestamp(time_begin::double precision), 'HH24:MI'::text)       AS time,


         "info": "Трансляция завершена",

         link_article uri,
         "media": { "uri": "" },
         show_date,
         show_time,
         is_diary diary,
         diary_author,

         "posts": [],
         "posts__length": 85











        id,
        id_parent,
        id_broadcast,
        has_big_img,
        author          posts__author,
        "text"          posts__text,
        post_type       posts__type,
        link            posts__uri,
        to_char(to_timestamp(post_time::double precision), 'DD.MM.YYYY'::text)    AS posts__date,
        to_char(to_timestamp(post_time::double precision), 'HH24:MI'::text)       AS posts__time,
        get_media(id)   posts__media,
        ('[]')::json    posts__answers
    FROM
        broadcast;




-- post_view: has the same fields as rg.ru Json API

DROP VIEW IF EXISTS post_view;

CREATE VIEW post_view AS
    SELECT
        id,
        id_parent,
        id_broadcast,
        has_big_img,
        author          posts__author,
        "text"          posts__text,
        post_type       posts__type,
        link            posts__uri,
        to_char(to_timestamp(post_time::double precision), 'DD.MM.YYYY'::text)    AS posts__date,
        to_char(to_timestamp(post_time::double precision), 'HH24:MI'::text)       AS posts__time,
        get_media(id)   posts__media,
        ('[]')::json    posts__answers
    FROM
        post;


-- answer_view: has the same fields as rg.ru Json API

DROP VIEW IF EXISTS answer_view;

CREATE VIEW answer_view AS
    SELECT
        id,
        id_parent,
        id_broadcast,
        has_big_img,
        author          posts__answer__author,
        "text"          posts__answer__text,
        post_type       posts__answer__type,
        link            posts__answer__uri,
        to_char(to_timestamp(post_time::double precision), 'DD.MM.YYYY'::text)    AS posts__answer__date,
        to_char(to_timestamp(post_time::double precision), 'HH24:MI'::text)       AS posts__answer__time,
        get_media(id)   posts__answer__media,
        ('[]')::json    posts__answer__answers
    FROM
        post;







-- get_media:  returns media json by post id --------------------------------------

DROP FUNCTION IF EXISTS get_media(integer);

CREATE OR REPLACE FUNCTION get_media(idd integer) RETURNS json AS $$
BEGIN
    RETURN
    (
        select array_to_json(array_agg(row_to_json( t, false )),true) from
        (
            SELECT * FROM media
            WHERE post_id = idd
        ) t
    );

END;
$$ LANGUAGE plpgsql;




-- get_answers:  returns json of posts(answers) by post(questions) id ------------------------------------------

DROP FUNCTION IF EXISTS get_answers(integer);

CREATE OR REPLACE FUNCTION get_answers(idd integer) RETURNS json AS $$
BEGIN
    RETURN
    (
        select array_to_json(array_agg(row_to_json( t, false )),true) from
        (
            SELECT * FROM answer_view
            WHERE id_parent = idd
        ) t
    );

END;
$$ LANGUAGE plpgsql;





-- get_posts:  returns json of posts by broadcast id ------------------------------------------

DROP FUNCTION IF EXISTS get_posts(integer);

CREATE OR REPLACE FUNCTION get_posts(idd integer) RETURNS json AS $$
BEGIN   
    RETURN  
    (
        select array_to_json(array_agg(row_to_json( t, false )),true) from
        ( 
            SELECT * FROM post_view
            WHERE 
                    id_broadcast = idd 
                AND id_parent IS NULL
            ORDER BY id DESC
        ) t 
    );
    
END;
$$ LANGUAGE plpgsql;





-- get_broadcast(id): returns json of a broadcast by id. =======================================

DROP FUNCTION IF EXISTS get_broadcast(integer);

CREATE OR REPLACE FUNCTION get_broadcast(idd integer) RETURNS json AS $$
BEGIN   
    RETURN
    (
        select row_to_json(t) from
        ( select *, get_posts(id) as posts  from broadcast where id = idd ) t
    );
END;
$$ LANGUAGE plpgsql;


-- tests

SELECT jsonb_pretty( get_media(5329)::jsonb);
SELECT jsonb_pretty( get_answers(23929)::jsonb);
-- SELECT jsonb_pretty( get_post(354)::jsonb);
SELECT jsonb_pretty( get_posts(354)::jsonb);
SELECT jsonb_pretty( get_broadcast(354)::jsonb);




-- the following expressions are equal ???
-- (select row_to_json(t)                                          from (...) t )
-- (select array_to_json(array_agg(row_to_json( t, false )),false) from (...) t )