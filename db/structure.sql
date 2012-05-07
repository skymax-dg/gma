--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: gma_dev; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE gma_dev IS 'Db di sviluppo ';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: anagens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE anagens (
    id integer NOT NULL,
    codice integer,
    tipo character varying(255),
    cognome character varying(255),
    nome character varying(255),
    ragsoc character varying(255),
    codfis character varying(255),
    pariva character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: anagens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE anagens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anagens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE anagens_id_seq OWNED BY anagens.id;


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE articles (
    id integer NOT NULL,
    codice character varying(255),
    descriz character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: causmags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE causmags (
    id integer NOT NULL,
    descriz character varying(255),
    tipo character varying(255),
    magsrc_id integer,
    magdst_id integer,
    fattura character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: causmags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE causmags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: causmags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE causmags_id_seq OWNED BY causmags.id;


--
-- Name: mags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mags (
    id integer NOT NULL,
    codice integer,
    descriz character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mags_id_seq OWNED BY mags.id;


--
-- Name: prezzoarticclis; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prezzoarticclis (
    id integer NOT NULL,
    anag_id integer,
    artic_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    prezzo numeric(8,2)
);


--
-- Name: prezzoarticclis_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prezzoarticclis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prezzoarticclis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prezzoarticclis_id_seq OWNED BY prezzoarticclis.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY anagens ALTER COLUMN id SET DEFAULT nextval('anagens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY causmags ALTER COLUMN id SET DEFAULT nextval('causmags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mags ALTER COLUMN id SET DEFAULT nextval('mags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prezzoarticclis ALTER COLUMN id SET DEFAULT nextval('prezzoarticclis_id_seq'::regclass);


--
-- Name: anagens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY anagens
    ADD CONSTRAINT anagens_pkey PRIMARY KEY (id);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: causmags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY causmags
    ADD CONSTRAINT causmags_pkey PRIMARY KEY (id);


--
-- Name: mags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mags
    ADD CONSTRAINT mags_pkey PRIMARY KEY (id);


--
-- Name: prezzoarticclis_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prezzoarticclis
    ADD CONSTRAINT prezzoarticclis_pkey PRIMARY KEY (id);


--
-- Name: idx_anagens_on_codfis; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX idx_anagens_on_codfis ON anagens USING btree (codfis);


--
-- Name: idx_anagens_on_codice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX idx_anagens_on_codice ON anagens USING btree (codice);


--
-- Name: idx_anagens_on_pariva; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX idx_anagens_on_pariva ON anagens USING btree (pariva);


--
-- Name: idx_articles_on_codice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX idx_articles_on_codice ON articles USING btree (codice);


--
-- Name: idx_articles_on_descriz; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX idx_articles_on_descriz ON articles USING btree (descriz);


--
-- Name: index_causmags_on_magdst_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_causmags_on_magdst_id ON causmags USING btree (magdst_id);


--
-- Name: index_causmags_on_magsrc_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_causmags_on_magsrc_id ON causmags USING btree (magsrc_id);


--
-- Name: index_prezzoarticclis_on_anag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prezzoarticclis_on_anag_id ON prezzoarticclis USING btree (anag_id);


--
-- Name: index_prezzoarticclis_on_artic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prezzoarticclis_on_artic_id ON prezzoarticclis USING btree (artic_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120504130809');

INSERT INTO schema_migrations (version) VALUES ('20120504142807');

INSERT INTO schema_migrations (version) VALUES ('20120504150604');

INSERT INTO schema_migrations (version) VALUES ('20120504161156');

INSERT INTO schema_migrations (version) VALUES ('20120506220858');

INSERT INTO schema_migrations (version) VALUES ('20120506223806');