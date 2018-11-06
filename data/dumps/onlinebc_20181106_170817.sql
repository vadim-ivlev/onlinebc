--
-- PostgreSQL database dump
--

-- Dumped from database version 11.0 (Debian 11.0-1.pgdg90+2)
-- Dumped by pg_dump version 11.0

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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: broadcasts; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.broadcasts (
    id integer NOT NULL,
    broadcast json NOT NULL
);


ALTER TABLE public.broadcasts OWNER TO root;

--
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
-- Name: broadcasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.broadcasts_id_seq OWNED BY public.broadcasts.id;


--
-- Name: broadcasts id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcasts ALTER COLUMN id SET DEFAULT nextval('public.broadcasts_id_seq'::regclass);


--
-- Data for Name: broadcasts; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO public.broadcasts VALUES (0, '{}');


--
-- Name: broadcasts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.broadcasts_id_seq', 1, false);


--
-- Name: broadcasts unique_broadcasts_id; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broadcasts
    ADD CONSTRAINT unique_broadcasts_id UNIQUE (id);


--
-- PostgreSQL database dump complete
--

