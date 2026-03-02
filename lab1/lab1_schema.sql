--
-- PostgreSQL database dump
--

\restrict fnH8Gt9YdDKEmcjZJEkVq4YDs1Q48FaDhRCGukZZj8wmawt4nTCWzR6xuk3Fff0

-- Dumped from database version 15.15 (Ubuntu 15.15-1.pgdg24.04+1)
-- Dumped by pg_dump version 15.15 (Ubuntu 15.15-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: books_read; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books_read (
    book_id integer NOT NULL,
    title character varying(200) NOT NULL,
    author character varying(100) NOT NULL,
    category character varying(50),
    pages integer,
    date_finished date,
    rating numeric(3,1),
    notes text,
    CONSTRAINT books_read_pages_check CHECK ((pages > 0)),
    CONSTRAINT books_read_rating_check CHECK (((rating >= (0)::numeric) AND (rating <= 5.0)))
);


ALTER TABLE public.books_read OWNER TO postgres;

--
-- Name: books_read_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_read_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_read_book_id_seq OWNER TO postgres;

--
-- Name: books_read_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_read_book_id_seq OWNED BY public.books_read.book_id;


--
-- Name: books_read book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_read ALTER COLUMN book_id SET DEFAULT nextval('public.books_read_book_id_seq'::regclass);


--
-- Name: books_read books_read_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_read
    ADD CONSTRAINT books_read_pkey PRIMARY KEY (book_id);


--
-- PostgreSQL database dump complete
--

\unrestrict fnH8Gt9YdDKEmcjZJEkVq4YDs1Q48FaDhRCGukZZj8wmawt4nTCWzR6xuk3Fff0

