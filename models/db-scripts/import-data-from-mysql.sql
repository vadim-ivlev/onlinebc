/*
DATA IMPORT FROM MYSQL TO POSTGRES

1. Using dbeaver make copies 
- auth_users,
- online_trans_data,
- online_trans_list
from mySQL/works to Postgres/onlinebc schema public .

2. Create tables 
- podcast,
- post

*/


--broadcast ********************************************************************

DROP TABLE IF EXISTS broadcast CASCADE;

CREATE TABLE broadcast AS
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
    online_trans_list
;

-- set id as autoincrement + primary key for broadcast
CREATE SEQUENCE broadcast_id_seq START 1000;
ALTER SEQUENCE broadcast_id_seq OWNED BY broadcast.id;
ALTER TABLE broadcast ALTER COLUMN id SET NOT NULL;
ALTER TABLE broadcast ALTER COLUMN id SET DEFAULT nextval('broadcast_id_seq');
ALTER TABLE broadcast ADD CONSTRAINT broadcast_pkey1 PRIMARY KEY (id);
--SELECT setval('broadcast_id_seq', 1000, true);




-- post *********************************************************

DROP TABLE IF EXISTS post CASCADE;


CREATE TABLE post AS
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
    (select (a."name" || ' ' || a.second_name) from auth_users a where a.id = p.user_id )  author
FROM 
    online_trans_data p
;

-- set id as autoincrement + primary key for post
CREATE SEQUENCE post_id_seq START 30000;
ALTER SEQUENCE post_id_seq OWNED BY post.id;
ALTER TABLE post ALTER COLUMN id SET NOT NULL;
ALTER TABLE post ALTER COLUMN id SET DEFAULT nextval('post_id_seq');
ALTER TABLE post ADD CONSTRAINT post_pkey1 PRIMARY KEY (id);
--SELECT setval('post_id_seq', 30000, true);
ALTER TABLE post ADD CONSTRAINT post_broadcast_fkey FOREIGN KEY (id_broadcast) REFERENCES broadcast (id);

-- CLEARING POST TABLE.
-- Remove zerros from id_parent columns 
-- or in general
-- set id_parents= NULL if there is no such id in post table

UPDATE post SET id_parent=NULL WHERE id_parent NOT IN (SELECT DISTINCT id FROM post);
-- drp the old constrain
ALTER TABLE IF EXISTS post DROP CONSTRAINT IF EXISTS post_post_fkey;
-- now we can add a recursive foreign key without errors
ALTER TABLE post ADD CONSTRAINT post_post_fkey FOREIGN KEY (id_parent) REFERENCES post (id);




-- some checks;
--INSERT INTO broadcast (title) VALUES ('Новый');
--DELETE FROM broadcast WHERE id = (SELECT max(id) FROM broadcast);
--

-- delete temporary objects
DROP TABLE IF EXISTS online_trans_data CASCADE;
DROP TABLE IF EXISTS online_trans_list CASCADE;
DROP TABLE IF EXISTS auth_users CASCADE;



-- Media : holds post images 

DROP TABLE IF EXISTS media CASCADE;

CREATE TABLE media (
    id serial NOT NULL,
    post_id int4 NOT NULL,
    uri varchar(255) NULL,
    thumb varchar(255) NULL,
    "source" varchar(255) NULL,
    CONSTRAINT media_pk PRIMARY KEY (id),
    CONSTRAINT media_post_fk FOREIGN KEY (post_id) REFERENCES post(id)
);

CREATE INDEX media_post_id_idx ON media (post_id);



COMMENT ON TABLE public.media IS 'Images for posts';




INSERT INTO media (post_id, uri, source)
SELECT 
    id post_id,
    split_part(img,'|',1) AS uri,
    split_part(img,'|',2) AS source
FROM 
    public.post
WHERE 
    split_part(img,'|',1) <> 'none_img'
;

--SOME additional stuff
--SELECT count(*) FROM public.media;
--DELETE FROM media;
--SELECT setval('media_id_seq', 1, true);


ALTER TABLE post DROP COLUMN img CASCADE;
ALTER TABLE post DROP COLUMN user_id CASCADE;

