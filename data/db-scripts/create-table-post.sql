--drop view if exists public.post_view ;
--create view public.post_view as 

--drop table if exists public.post;
--create table public.post as
SELECT 
    id_trans_data           id,
    id_trans_data_parent    id_parent,
    id_trans                id_podcast,
    "text",
    time_data               post_time,
    type_text               post_type,
    link_data               link,
    img_data                img,
    has_big_img,
    user_id,
    (select ("name" || ' ' || last_name) from author a where a.id = p.user_id ) author
FROM 
    public.online_trans_data p
--where
--    p.user_id != 0 
;