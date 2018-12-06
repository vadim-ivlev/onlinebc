--
-- PostgreSQL database dump
--

-- Dumped from database version 11.1 (Debian 11.1-1.pgdg90+1)
-- Dumped by pg_dump version 11.1 (Debian 11.1-1.pgdg90+1)

-- Started on 2018-12-06 11:42:14 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS onlinebc;
--
-- TOC entry 2949 (class 1262 OID 16384)
-- Name: onlinebc; Type: DATABASE; Schema: -; Owner: root
--

CREATE DATABASE onlinebc WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE onlinebc OWNER TO root;

\connect onlinebc

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 232 (class 1255 OID 25160)
-- Name: get_answers(integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_answers(idd integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_answers(idd integer) OWNER TO root;

--
-- TOC entry 218 (class 1255 OID 25076)
-- Name: get_broadcast(integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_broadcast(idd integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN   
    RETURN
    (
        select row_to_json(t) from
        ( select *, get_posts(id) as posts  from broadcast where id = idd ) t
    );
END;
$$;


ALTER FUNCTION public.get_broadcast(idd integer) OWNER TO root;

--
-- TOC entry 231 (class 1255 OID 25155)
-- Name: get_media(integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_media(idd integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_media(idd integer) OWNER TO root;

--
-- TOC entry 233 (class 1255 OID 25075)
-- Name: get_posts(integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_posts(idd integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_posts(idd integer) OWNER TO root;

--
-- TOC entry 217 (class 1255 OID 16387)
-- Name: js(anyelement); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.js(t anyelement) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN array_to_json(array_agg(to_json( t )),true);
END;
$$;


ALTER FUNCTION public.js(t anyelement) OWNER TO root;

--
-- TOC entry 2950 (class 0 OID 0)
-- Dependencies: 217
-- Name: FUNCTION js(t anyelement); Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON FUNCTION public.js(t anyelement) IS 'Description';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 206 (class 1259 OID 24955)
-- Name: post; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.post (
    id integer NOT NULL,
    id_parent integer,
    id_broadcast integer,
    text text,
    post_time integer,
    post_type integer,
    link character varying(256),
    has_big_img integer,
    author text
);


ALTER TABLE public.post OWNER TO root;

--
-- TOC entry 211 (class 1259 OID 25161)
-- Name: answer_view; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.answer_view AS
 SELECT post.id,
    post.id_parent,
    post.id_broadcast,
    post.has_big_img,
    post.author AS posts__answer__author,
    post.text AS posts__answer__text,
    post.post_type AS posts__answer__type,
    post.link AS posts__answer__uri,
    to_char(to_timestamp((post.post_time)::double precision), 'DD.MM.YYYY'::text) AS posts__answer__date,
    to_char(to_timestamp((post.post_time)::double precision), 'HH24:MI'::text) AS posts__answer__time,
    public.get_media(post.id) AS posts__answer__media,
    '[]'::json AS posts__answer__answers
   FROM public.post;


ALTER TABLE public.answer_view OWNER TO root;

--
-- TOC entry 204 (class 1259 OID 24935)
-- Name: broadcast; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.broadcast (
    id integer NOT NULL,
    title character varying(256),
    time_created integer,
    time_begin integer,
    is_ended integer,
    show_date integer,
    show_time integer,
    is_yandex integer,
    yandex_ids character varying(255),
    show_main_page integer,
    link_article character varying(256),
    link_img character varying(255),
    groups_create integer,
    is_diary integer,
    diary_author character varying(255)
);


ALTER TABLE public.broadcast OWNER TO root;

--
-- TOC entry 205 (class 1259 OID 24945)
-- Name: broadcast_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.broadcast_id_seq
    START WITH 400
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.broadcast_id_seq OWNER TO root;

--
-- TOC entry 2951 (class 0 OID 0)
-- Dependencies: 205
-- Name: broadcast_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.broadcast_id_seq OWNED BY public.broadcast.id;


--
-- TOC entry 202 (class 1259 OID 16388)
-- Name: broadcast_json; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.broadcast_json (
    id integer NOT NULL,
    broadcast json
);


ALTER TABLE public.broadcast_json OWNER TO root;

--
-- TOC entry 203 (class 1259 OID 16394)
-- Name: broadcasts_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.broadcasts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.broadcasts_id_seq OWNER TO root;

--
-- TOC entry 2952 (class 0 OID 0)
-- Dependencies: 203
-- Name: broadcasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.broadcasts_id_seq OWNED BY public.broadcast_json.id;


--
-- TOC entry 209 (class 1259 OID 25097)
-- Name: media; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.media (
    id integer NOT NULL,
    post_id integer NOT NULL,
    uri character varying(255),
    thumb character varying(255),
    source character varying(255)
);


ALTER TABLE public.media OWNER TO root;

--
-- TOC entry 2953 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE media; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.media IS 'Images for posts';


--
-- TOC entry 208 (class 1259 OID 25095)
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.media_id_seq OWNER TO root;

--
-- TOC entry 2954 (class 0 OID 0)
-- Dependencies: 208
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- TOC entry 207 (class 1259 OID 25059)
-- Name: post_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.post_id_seq
    START WITH 30000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_id_seq OWNER TO root;

--
-- TOC entry 2955 (class 0 OID 0)
-- Dependencies: 207
-- Name: post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.post_id_seq OWNED BY public.post.id;


--
-- TOC entry 210 (class 1259 OID 25156)
-- Name: post_view; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.post_view AS
 SELECT post.id,
    post.id_parent,
    post.id_broadcast,
    post.has_big_img,
    post.author AS posts__author,
    post.text AS posts__text,
    post.post_type AS posts__type,
    post.link AS posts__uri,
    to_char(to_timestamp((post.post_time)::double precision), 'DD.MM.YYYY'::text) AS posts__date,
    to_char(to_timestamp((post.post_time)::double precision), 'HH24:MI'::text) AS posts__time,
    public.get_media(post.id) AS posts__media,
    '[]'::json AS posts__answers
   FROM public.post;


ALTER TABLE public.post_view OWNER TO root;

--
-- TOC entry 213 (class 1259 OID 25167)
-- Name: test; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.test (
    id integer NOT NULL,
    username jsonb
);


ALTER TABLE public.test OWNER TO root;

--
-- TOC entry 214 (class 1259 OID 25176)
-- Name: test1; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.test1 (
    n integer
);


ALTER TABLE public.test1 OWNER TO root;

--
-- TOC entry 215 (class 1259 OID 25179)
-- Name: test2; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.test2 (
    column1 character varying
);


ALTER TABLE public.test2 OWNER TO root;

--
-- TOC entry 212 (class 1259 OID 25165)
-- Name: test_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_id_seq OWNER TO root;

--
-- TOC entry 2956 (class 0 OID 0)
-- Dependencies: 212
-- Name: test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.test_id_seq OWNED BY public.test.id;


--
-- TOC entry 216 (class 1259 OID 25242)
-- Name: ttt; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.ttt (
    value json,
    rnum bigint
);


ALTER TABLE public.ttt OWNER TO root;

--
-- TOC entry 2803 (class 2604 OID 24947)
-- Name: broadcast id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcast ALTER COLUMN id SET DEFAULT nextval('public.broadcast_id_seq'::regclass);


--
-- TOC entry 2802 (class 2604 OID 16408)
-- Name: broadcast_json id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcast_json ALTER COLUMN id SET DEFAULT nextval('public.broadcasts_id_seq'::regclass);


--
-- TOC entry 2805 (class 2604 OID 25100)
-- Name: media id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- TOC entry 2804 (class 2604 OID 25061)
-- Name: post id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.post ALTER COLUMN id SET DEFAULT nextval('public.post_id_seq'::regclass);


--
-- TOC entry 2806 (class 2604 OID 25170)
-- Name: test id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.test ALTER COLUMN id SET DEFAULT nextval('public.test_id_seq'::regclass);


--
-- TOC entry 2810 (class 2606 OID 24949)
-- Name: broadcast broadcast_pkey1; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcast
    ADD CONSTRAINT broadcast_pkey1 PRIMARY KEY (id);


--
-- TOC entry 2808 (class 2606 OID 16754)
-- Name: broadcast_json broadcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcast_json
    ADD CONSTRAINT broadcasts_pkey PRIMARY KEY (id);


--
-- TOC entry 2814 (class 2606 OID 25105)
-- Name: media media_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pk PRIMARY KEY (id);


--
-- TOC entry 2812 (class 2606 OID 25063)
-- Name: post post_pkey1; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey1 PRIMARY KEY (id);


--
-- TOC entry 2817 (class 2606 OID 25175)
-- Name: test test_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id);


--
-- TOC entry 2815 (class 1259 OID 25111)
-- Name: media_post_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX media_post_id_idx ON public.media USING btree (post_id);


--
-- TOC entry 2820 (class 2606 OID 25106)
-- Name: media media_post_fk; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_post_fk FOREIGN KEY (post_id) REFERENCES public.post(id);


--
-- TOC entry 2818 (class 2606 OID 25068)
-- Name: post post_broadcast_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_broadcast_fkey FOREIGN KEY (id_broadcast) REFERENCES public.broadcast(id);


--
-- TOC entry 2819 (class 2606 OID 25150)
-- Name: post post_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_post_fkey FOREIGN KEY (id_parent) REFERENCES public.post(id);


-- Completed on 2018-12-06 11:42:14 UTC

--
-- PostgreSQL database dump complete
--

