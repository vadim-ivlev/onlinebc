--
-- PostgreSQL database dump
--

-- Dumped from database version 11.0 (Debian 11.0-1.pgdg90+2)
-- Dumped by pg_dump version 11.0 (Debian 11.0-1.pgdg90+2)

-- Started on 2018-11-12 00:39:07 UTC

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
-- TOC entry 212 (class 1255 OID 24726)
-- Name: get_broadcast(anyelement); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_broadcast(id anyelement) RETURNS json
    LANGUAGE plpgsql
    AS $$
begin   
    return  
    (
        select row_to_json( t, true )
        from 
        ( select *, get_posts(id) as POSTS  from online_trans_list where id_trans = id limit 1) t 
    );
    
END;
$$;


ALTER FUNCTION public.get_broadcast(id anyelement) OWNER TO root;

--
-- TOC entry 213 (class 1255 OID 24724)
-- Name: get_posts(anyelement); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_posts(id anyelement) RETURNS json
    LANGUAGE plpgsql
    AS $$
begin   
    return  
    (
        select array_to_json(array_agg(row_to_json( t, true )),true) 
        from ( 
            select * from online_trans_data where id_trans = id 
        ) t 
    );
    
END;
$$;


ALTER FUNCTION public.get_posts(id anyelement) OWNER TO root;

--
-- TOC entry 214 (class 1255 OID 24725)
-- Name: js(anyelement); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.js(t anyelement) RETURNS json
    LANGUAGE plpgsql
    AS $$
begin
    return ( array_to_json(array_agg(to_json( t )),true));
END;
$$;


ALTER FUNCTION public.js(t anyelement) OWNER TO root;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 18170)
-- Name: broadcasts; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.broadcasts (
    id integer NOT NULL,
    broadcast json
);


ALTER TABLE public.broadcasts OWNER TO root;

--
-- TOC entry 197 (class 1259 OID 18176)
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
-- TOC entry 2887 (class 0 OID 0)
-- Dependencies: 197
-- Name: broadcasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.broadcasts_id_seq OWNED BY public.broadcasts.id;


--
-- TOC entry 199 (class 1259 OID 24587)
-- Name: online_trans_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.online_trans_data (
    id_trans_data integer NOT NULL,
    id_trans_data_parent integer NOT NULL,
    id_trans integer NOT NULL,
    text text NOT NULL,
    time_data integer NOT NULL,
    type_text integer NOT NULL,
    link_data character varying(256) NOT NULL,
    img_data character varying(256) NOT NULL,
    has_big_img integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.online_trans_data OWNER TO root;

--
-- TOC entry 198 (class 1259 OID 24577)
-- Name: online_trans_list; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.online_trans_list (
    id_trans integer NOT NULL,
    title character varying(256) NOT NULL,
    time_created integer NOT NULL,
    time_begin integer NOT NULL,
    ended integer NOT NULL,
    show_date integer NOT NULL,
    show_time integer NOT NULL,
    yandex_trans_id integer NOT NULL,
    yandex_trans_id_field character varying(255) NOT NULL,
    show_main_page integer NOT NULL,
    link_article character varying(256) NOT NULL,
    link_img character varying(255) NOT NULL,
    groups_create integer NOT NULL,
    disable_autoupdate integer NOT NULL,
    diary integer NOT NULL,
    diary_author character varying(255) NOT NULL,
    unicode integer NOT NULL
);


ALTER TABLE public.online_trans_list OWNER TO root;

--
-- TOC entry 2754 (class 2604 OID 18178)
-- Name: broadcasts id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcasts ALTER COLUMN id SET DEFAULT nextval('public.broadcasts_id_seq'::regclass);


--
-- TOC entry 2756 (class 2606 OID 18431)
-- Name: broadcasts broadcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcasts
    ADD CONSTRAINT broadcasts_pkey PRIMARY KEY (id);


--
-- TOC entry 2760 (class 2606 OID 24594)
-- Name: online_trans_data online_trans_data_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.online_trans_data
    ADD CONSTRAINT online_trans_data_pkey PRIMARY KEY (id_trans_data);


--
-- TOC entry 2758 (class 2606 OID 24584)
-- Name: online_trans_list online_trans_list_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.online_trans_list
    ADD CONSTRAINT online_trans_list_pkey PRIMARY KEY (id_trans);


-- Completed on 2018-11-12 00:39:10 UTC

--
-- PostgreSQL database dump complete
--

