--DROP DATABASE mtdmanager WITH (FORCE);

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

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

--
-- Name: mtdmanager; Type: DATABASE; Schema: -; Owner: mtdmanager
--

--CREATE DATABASE mtdmanager WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Italian_Italy.1252';


ALTER DATABASE mtdmanager OWNER TO mtdmanager;


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

--
-- Name: mtdmanager; Type: SCHEMA; Schema: -; Owner: mtdmanager
--

CREATE SCHEMA mtdmanager;


ALTER SCHEMA mtdmanager OWNER TO mtdmanager;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: deployment; Type: TABLE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE TABLE mtdmanager.deployment (
    name character varying NOT NULL,
    strategy integer NOT NULL,
    namespace character varying,
    id integer NOT NULL,
    type character varying NOT NULL,
    enabled boolean NOT NULL
);


ALTER TABLE mtdmanager.deployment OWNER TO mtdmanager;

--
-- Name: deployment_id_seq; Type: SEQUENCE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE SEQUENCE mtdmanager.deployment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mtdmanager.deployment_id_seq OWNER TO mtdmanager;

--
-- Name: deployment_id_seq; Type: SEQUENCE OWNED BY; Schema: mtdmanager; Owner: mtdmanager
--

ALTER SEQUENCE mtdmanager.deployment_id_seq OWNED BY mtdmanager.deployment.id;


--
-- Name: node; Type: TABLE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE TABLE mtdmanager.node (
    hostname character varying NOT NULL,
    ip_address character varying NOT NULL,
    id integer NOT NULL,
    role character varying,
    available boolean DEFAULT false
);


ALTER TABLE mtdmanager.node OWNER TO mtdmanager;

--
-- Name: node_id_seq; Type: SEQUENCE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE SEQUENCE mtdmanager.node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mtdmanager.node_id_seq OWNER TO mtdmanager;

--
-- Name: node_id_seq; Type: SEQUENCE OWNED BY; Schema: mtdmanager; Owner: mtdmanager
--

ALTER SEQUENCE mtdmanager.node_id_seq OWNED BY mtdmanager.node.id;


--
-- Name: node_label; Type: TABLE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE TABLE mtdmanager.node_label (
    id integer NOT NULL,
    key character varying,
    value character varying,
    id_node integer NOT NULL
);


ALTER TABLE mtdmanager.node_label OWNER TO mtdmanager;

--
-- Name: node_label_id_seq; Type: SEQUENCE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE SEQUENCE mtdmanager.node_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mtdmanager.node_label_id_seq OWNER TO mtdmanager;

--
-- Name: node_label_id_seq; Type: SEQUENCE OWNED BY; Schema: mtdmanager; Owner: mtdmanager
--

ALTER SEQUENCE mtdmanager.node_label_id_seq OWNED BY mtdmanager.node_label.id;


--
-- Name: parameter; Type: TABLE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE TABLE mtdmanager.parameter (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE mtdmanager.parameter OWNER TO mtdmanager;

--
-- Name: parameter_id_seq; Type: SEQUENCE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE SEQUENCE mtdmanager.parameter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mtdmanager.parameter_id_seq OWNER TO mtdmanager;

--
-- Name: parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: mtdmanager; Owner: mtdmanager
--

ALTER SEQUENCE mtdmanager.parameter_id_seq OWNED BY mtdmanager.parameter.id;


--
-- Name: service_account; Type: TABLE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE TABLE mtdmanager.service_account (
    id integer NOT NULL,
    name character varying,
    namespace character varying,
    deployment integer
);


ALTER TABLE mtdmanager.service_account OWNER TO mtdmanager;

--
-- Name: strategy; Type: TABLE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE TABLE mtdmanager.strategy (
    name character varying NOT NULL,
    enabled boolean NOT NULL,
    scheduling character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE mtdmanager.strategy OWNER TO mtdmanager;

--
-- Name: strategy_id_seq; Type: SEQUENCE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE SEQUENCE mtdmanager.strategy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mtdmanager.strategy_id_seq OWNER TO mtdmanager;

--
-- Name: strategy_id_seq; Type: SEQUENCE OWNED BY; Schema: mtdmanager; Owner: mtdmanager
--

ALTER SEQUENCE mtdmanager.strategy_id_seq OWNED BY mtdmanager.strategy.id;


--
-- Name: timeseries; Type: TABLE; Schema: mtdmanager; Owner: mtdmanager
--

CREATE TABLE mtdmanager.timeseries (
    id_gateway character varying NOT NULL,
    id_device character varying NOT NULL,
    device_attribute character varying NOT NULL,
    device_attribute_value character varying,
    device_attribute_type character varying NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE mtdmanager.timeseries OWNER TO mtdmanager;

--
-- Name: deployment id; Type: DEFAULT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.deployment ALTER COLUMN id SET DEFAULT nextval('mtdmanager.deployment_id_seq'::regclass);


--
-- Name: node id; Type: DEFAULT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.node ALTER COLUMN id SET DEFAULT nextval('mtdmanager.node_id_seq'::regclass);


--
-- Name: node_label id; Type: DEFAULT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.node_label ALTER COLUMN id SET DEFAULT nextval('mtdmanager.node_label_id_seq'::regclass);


--
-- Name: parameter id; Type: DEFAULT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.parameter ALTER COLUMN id SET DEFAULT nextval('mtdmanager.parameter_id_seq'::regclass);


--
-- Name: strategy id; Type: DEFAULT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.strategy ALTER COLUMN id SET DEFAULT nextval('mtdmanager.strategy_id_seq'::regclass);



--
-- Data for Name: node; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--

INSERT INTO mtdmanager.node VALUES ('master', '192.168.1.37', 1, 'master', true);
INSERT INTO mtdmanager.node VALUES ('worker', '192.168.1.38', 2, 'worker', true);
INSERT INTO mtdmanager.node VALUES ('edge', '10.0.2.15', 3, 'edge', true);


--
-- Data for Name: node_label; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--

INSERT INTO mtdmanager.node_label VALUES (1, 'name', 'master', 1);
INSERT INTO mtdmanager.node_label VALUES (2, 'name', 'worker', 2);


--
-- Data for Name: parameter; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--

INSERT INTO mtdmanager.parameter VALUES (1, 'period', '60000');


--
-- Data for Name: service_account; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--



--
-- Data for Name: strategy; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--

INSERT INTO mtdmanager.strategy VALUES ('ip-shuffling', false, 'fixed', 1);
INSERT INTO mtdmanager.strategy VALUES ('dynamic-pod-replica', false, 'fixed', 2);
INSERT INTO mtdmanager.strategy VALUES ('node-migration', false, 'fixed', 3);
INSERT INTO mtdmanager.strategy VALUES ('service-account-shuffling', false, 'fixed', 4);

--
-- Example data
-- Data for Name: timeseries; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--

INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:16:24.137');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:16:29.109');


--
-- Name: deployment_id_seq; Type: SEQUENCE SET; Schema: mtdmanager; Owner: mtdmanager
--

SELECT pg_catalog.setval('mtdmanager.deployment_id_seq', 7, true);


--
-- Name: node_id_seq; Type: SEQUENCE SET; Schema: mtdmanager; Owner: mtdmanager
--

SELECT pg_catalog.setval('mtdmanager.node_id_seq', 8, true);


--
-- Name: node_label_id_seq; Type: SEQUENCE SET; Schema: mtdmanager; Owner: mtdmanager
--

SELECT pg_catalog.setval('mtdmanager.node_label_id_seq', 2, true);


--
-- Name: parameter_id_seq; Type: SEQUENCE SET; Schema: mtdmanager; Owner: mtdmanager
--

SELECT pg_catalog.setval('mtdmanager.parameter_id_seq', 1, true);


--
-- Name: strategy_id_seq; Type: SEQUENCE SET; Schema: mtdmanager; Owner: mtdmanager
--

SELECT pg_catalog.setval('mtdmanager.strategy_id_seq', 5, true);


--
-- Name: deployment deployment_pkey; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.deployment
    ADD CONSTRAINT deployment_pkey PRIMARY KEY (id);


--
-- Name: node node_ip_address_key; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.node
    ADD CONSTRAINT node_ip_address_key UNIQUE (ip_address);


--
-- Name: node_label node_label_pkey; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.node_label
    ADD CONSTRAINT node_label_pkey PRIMARY KEY (id);


--
-- Name: node node_pkey; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.node
    ADD CONSTRAINT node_pkey PRIMARY KEY (id);


--
-- Name: parameter parameter_key_key; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.parameter
    ADD CONSTRAINT parameter_key_key UNIQUE (key);


--
-- Name: parameter parameter_pkey; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.parameter
    ADD CONSTRAINT parameter_pkey PRIMARY KEY (id);


--
-- Name: service_account service_account_pkey; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.service_account
    ADD CONSTRAINT service_account_pkey PRIMARY KEY (id);


--
-- Name: strategy strategy_name_key; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.strategy
    ADD CONSTRAINT strategy_name_key UNIQUE (name);


--
-- Name: strategy strategy_pkey; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.strategy
    ADD CONSTRAINT strategy_pkey PRIMARY KEY (id);


--
-- Name: timeseries timeseries_pkey; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.timeseries
    ADD CONSTRAINT timeseries_pkey PRIMARY KEY ("timestamp");


--
-- Name: timeseries timeseries_timestamp_key; Type: CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.timeseries
    ADD CONSTRAINT timeseries_timestamp_key UNIQUE ("timestamp");


--
-- Name: deployment deployment_strategy_id_fk; Type: FK CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.deployment
    ADD CONSTRAINT deployment_strategy_id_fk FOREIGN KEY (strategy) REFERENCES mtdmanager.strategy(id);


--
-- Name: node_label node_label_node_id_fk; Type: FK CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.node_label
    ADD CONSTRAINT node_label_node_id_fk FOREIGN KEY (id_node) REFERENCES mtdmanager.node(id) ON DELETE CASCADE;


--
-- Name: service_account service_account_deployment_id_fk; Type: FK CONSTRAINT; Schema: mtdmanager; Owner: mtdmanager
--

ALTER TABLE ONLY mtdmanager.service_account
    ADD CONSTRAINT service_account_deployment_id_fk FOREIGN KEY (deployment) REFERENCES mtdmanager.deployment(id);


--
-- PostgreSQL database dump complete
--

