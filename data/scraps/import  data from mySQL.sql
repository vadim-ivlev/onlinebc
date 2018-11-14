/*
DATA TRANFER FROM MYSQL TO POSTGRESS

1. Make copies auth_users,
online_trans_data,
online_trans_list
from mySQL/works to Postgres/onlinebc.public.

2. Create tables podcast,
post

3. Create views 

*/


--broadcast ********************************************************************

DROP TABLE IF EXISTS public.broadcast CASCADE;

CREATE TABLE public.broadcast AS
SELECT 
    id_trans                AS id,
    title,
    time_created,
    time_begin,
    ended                   AS is_ended,
    show_date,
    show_time,
    yandex_trans_id         AS is_yandex,
    yandex_trans_id_field   AS yandex_ids,
    show_main_page,
    link_article,
    link_img,
    groups_create,
    --disable_autoupdate,
    diary                   AS is_diary,
    diary_author
    --unicode
FROM 
    public.online_trans_list
;

-- set id as autoincrement + primary key for broadcast
CREATE SEQUENCE broadcast_id_seq START 1000;
ALTER SEQUENCE broadcast_id_seq OWNED BY broadcast.id;
ALTER TABLE broadcast ALTER COLUMN id SET NOT NULL;
ALTER TABLE broadcast ALTER COLUMN id SET DEFAULT nextval('broadcast_id_seq');
ALTER TABLE broadcast ADD CONSTRAINT broadcast_pkey1 PRIMARY KEY (id);
--SELECT setval('broadcast_id_seq', 1000, true);




-- post *********************************************************

DROP TABLE IF EXISTS public.post CASCADE;


CREATE TABLE public.post AS
SELECT 
    p.id_trans_data           id,
    p.id_trans_data_parent    id_parent,
    p.id_trans                id_broadcast,
    p."text",
    p.time_data               post_time,
    p.type_text               post_type,
    p.link_data               link,
    p.img_data                img,
    p.has_big_img,
    p.user_id,
    (select (a."name" || ' ' || a.second_name) from public.auth_users a where a.id = p.user_id )  author
FROM 
    public.online_trans_data p
;

-- set id as autoincrement + primary key for post
CREATE SEQUENCE post_id_seq START 30000;
ALTER SEQUENCE post_id_seq OWNED BY post.id;
ALTER TABLE post ALTER COLUMN id SET NOT NULL;
ALTER TABLE post ALTER COLUMN id SET DEFAULT nextval('post_id_seq');
ALTER TABLE post ADD CONSTRAINT post_pkey1 PRIMARY KEY (id);
--SELECT setval('post_id_seq', 30000, true);
ALTER TABLE post ADD CONSTRAINT post_broadcast_fkey FOREIGN KEY (id_broadcast) REFERENCES broadcast (id);


-- some checks;
--INSERT INTO broadcast (title) VALUES ('Новый');
--DELETE FROM broadcast WHERE id = (SELECT max(id) FROM broadcast);
--

-- delete temporary objects
DROP TABLE IF EXISTS public.online_trans_data CASCADE;
DROP TABLE IF EXISTS public.online_trans_list CASCADE;
DROP TABLE IF EXISTS public.auth_users CASCADE;






-- Functions --------------------------------


-- get_posts:  returns json of posts by broadcast id

DROP FUNCTION IF EXISTS get_posts(integer);

CREATE OR REPLACE FUNCTION public.get_posts(idd integer) RETURNS json AS $$
BEGIN   
    RETURN  
    (
        select array_to_json(array_agg(row_to_json( t, false )),true) 
        from ( 
            select * from post where id_broadcast = idd 
        ) t 
    );
    
END;
$$ LANGUAGE plpgsql;

-- test
--SELECT get_posts(247);
--SELECT jsonb_pretty( get_posts(247)::jsonb);






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
