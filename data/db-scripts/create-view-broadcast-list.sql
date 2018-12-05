CREATE OR REPLACE VIEW public.broadcast_list
AS SELECT broadcast.id_trans AS id,
    broadcast.title AS name,
    broadcast.time_created,
    to_char(to_timestamp(broadcast.time_begin::double precision), 'YYYY-MM-DD'::text) AS date,
    to_char(to_timestamp(broadcast.time_begin::double precision), 'HH24:MI'::text) AS "time",
    broadcast.ended,
    broadcast.show_date,
    broadcast.show_time,
    broadcast.yandex_trans_id,
    broadcast.yandex_trans_id_field,
    broadcast.show_main_page,
    broadcast.link_article,
    broadcast.link_img,
    broadcast.groups_create,
    broadcast.disable_autoupdate,
    broadcast.diary,
    broadcast.diary_author,
    broadcast.unicode
   FROM broadcast;

-- Permissions

ALTER TABLE public.broadcast_list OWNER TO root;
GRANT ALL ON TABLE public.broadcast_list TO root;
