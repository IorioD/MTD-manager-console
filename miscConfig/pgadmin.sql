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
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:16:34.129');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:16:39.145');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:16:44.308');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:16:49.467');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:16:54.619');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:16:59.78');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:17:04.786');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:17:09.791');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:17:14.812');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:17:19.802');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:17:24.972');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:17:30.152');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:17:35.303');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:17:40.452');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:17:45.458');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:17:50.471');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:17:55.489');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:18:00.493');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:18:05.652');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:18:10.808');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:18:15.968');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:18:21.118');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:18:26.139');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:18:31.148');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:18:36.162');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:18:41.167');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:18:51.606');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:18:56.758');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:19:01.909');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:29:54.576');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:29:59.543');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:30:04.548');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:30:09.548');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:30:14.571');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:30:19.588');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:30:24.614');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:30:29.63');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:30:34.639');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:30:39.643');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:30:44.642');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:30:49.64');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:30:54.666');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:30:59.684');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:31:04.71');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:31:09.731');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:31:14.739');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:31:19.757');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:31:24.755');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:31:29.76');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:31:34.779');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:31:39.8');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:31:44.822');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:31:49.842');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:31:54.85');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:31:59.853');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:32:04.852');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:32:09.854');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:32:14.873');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:32:19.894');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:32:24.916');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:32:29.938');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:32:34.945');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:32:39.947');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:32:44.95');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:32:49.947');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:32:54.973');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:32:59.994');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:33:05.016');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:33:10.038');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:33:15.039');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:33:20.045');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:33:25.05');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:33:30.049');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:33:35.068');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:33:40.089');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:33:45.11');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:33:50.131');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:33:55.141');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:34:00.141');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:34:05.144');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:34:10.143');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:34:15.163');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:34:20.183');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:34:25.203');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:34:30.222');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:34:35.231');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:34:40.228');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:34:45.235');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:34:50.236');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:34:55.252');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:35:00.275');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:35:05.295');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:35:10.315');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:35:15.322');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:35:20.325');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:35:25.329');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:35:30.331');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:35:35.347');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:35:40.373');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:35:45.392');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:35:50.412');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:35:55.42');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:36:00.42');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:36:05.426');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:36:10.425');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:36:15.444');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:36:20.466');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:36:25.488');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:36:30.508');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:36:35.512');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:36:40.511');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:36:45.516');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:36:50.518');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:36:55.54');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:37:00.562');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:37:05.592');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:37:10.612');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:37:15.615');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:37:20.615');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:37:25.62');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:37:30.623');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:37:35.645');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:37:40.664');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:37:45.692');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:37:50.713');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:37:55.719');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:38:00.72');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:38:05.723');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:38:10.725');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:38:15.747');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:38:20.768');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:38:25.791');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:38:30.811');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:38:35.816');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:38:40.821');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:38:45.817');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:38:50.825');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:38:55.847');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:39:00.868');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:39:05.897');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:39:10.916');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:39:15.922');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:39:20.922');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:39:25.927');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:39:30.927');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:39:35.945');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:39:40.962');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:39:45.981');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:39:51.002');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:39:56.004');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:40:01.004');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:40:06.01');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:40:11.012');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:40:16.031');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:40:21.051');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:40:26.071');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:40:31.096');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:40:36.104');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:40:41.105');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:40:46.108');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:40:51.105');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:40:56.123');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:41:01.142');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:41:06.165');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:41:11.189');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:41:16.196');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:41:21.198');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:41:26.2');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:41:31.202');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:41:36.217');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:41:41.244');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:41:46.269');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:41:51.294');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:41:56.303');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:42:01.306');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:42:06.309');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:42:11.312');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:42:16.327');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:42:21.347');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:42:26.37');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:42:31.391');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:42:36.4');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:42:41.402');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:42:46.404');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:42:51.405');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:42:56.425');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:43:01.444');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:43:06.464');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:43:11.485');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:43:16.492');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:43:21.494');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:43:26.498');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:43:31.498');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:43:36.527');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:43:41.545');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:43:46.565');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:43:51.585');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:43:56.592');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:44:01.592');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:44:06.597');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:44:11.597');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:44:16.621');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:44:21.638');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:44:26.664');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:44:31.685');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:44:36.692');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:44:41.696');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:44:46.699');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:44:51.697');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:44:56.716');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:45:01.737');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:45:06.758');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:45:11.778');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:45:16.785');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:45:21.786');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:45:26.79');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:45:31.787');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:45:36.808');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:45:41.834');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:45:46.854');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:45:51.881');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:45:56.885');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:46:01.892');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:46:06.893');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:46:11.895');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:46:16.91');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:46:21.932');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:46:26.952');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:46:31.98');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:46:36.98');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:46:41.985');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:46:46.985');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:46:51.985');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:46:57.004');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:47:02.023');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:47:07.044');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:47:12.063');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:47:17.068');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:47:22.073');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:47:27.075');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:47:32.078');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:47:37.094');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:47:42.115');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:47:47.134');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:47:52.153');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:47:57.161');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:48:02.163');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:48:07.166');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:48:12.167');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:48:17.184');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:48:22.21');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:48:27.236');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:48:32.257');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:48:37.259');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:48:42.265');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:48:47.264');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:48:52.265');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:48:57.283');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:49:02.303');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:49:07.321');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:49:12.34');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:49:17.347');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:49:22.342');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:49:27.35');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:49:32.352');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:49:37.369');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:49:42.388');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:49:47.417');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:49:52.44');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:49:57.445');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:50:02.445');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:50:07.452');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:50:12.452');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:50:17.47');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:50:22.492');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:50:27.514');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:50:32.534');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:50:37.536');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:50:42.537');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:50:47.538');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:50:52.541');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:50:57.564');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:51:02.584');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:51:07.603');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:51:12.624');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:51:17.625');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:51:22.625');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:51:27.627');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:51:32.627');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:51:37.647');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:51:42.666');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:51:47.686');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:51:52.709');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:51:57.71');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:52:02.716');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:52:07.714');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:52:12.715');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:52:17.738');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:52:22.757');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:52:27.776');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:52:32.795');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:52:37.796');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:52:42.798');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:52:47.799');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:52:52.803');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:52:57.821');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:53:02.84');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:53:07.865');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:53:12.89');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:53:17.896');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:53:22.893');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:53:27.898');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:53:32.9');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:53:37.922');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:53:42.948');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:53:47.972');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:53:52.992');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:53:57.997');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:54:03');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:54:07.998');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:54:13.002');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:54:18.025');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:54:23.044');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:54:28.064');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:54:33.084');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:54:38.085');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:54:43.086');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:54:48.09');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:54:53.09');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:54:58.112');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:55:03.134');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:55:08.156');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:55:13.176');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:55:18.177');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:55:23.178');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:55:28.184');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:55:33.189');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:55:38.203');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:55:43.224');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:55:48.246');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:55:53.265');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:55:58.272');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:56:03.273');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:56:08.277');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:56:13.279');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:56:18.297');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:56:23.322');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:56:28.343');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:56:33.362');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:56:38.369');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:56:43.371');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:56:48.369');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:56:53.374');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:56:58.393');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:57:03.409');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:57:08.434');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:57:13.455');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:57:18.461');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:57:23.463');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:57:28.462');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:57:33.461');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:57:38.484');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:57:43.509');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:57:48.536');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:57:53.557');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:57:58.563');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:58:03.563');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:58:08.562');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:58:13.567');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:58:18.587');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:58:23.605');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:58:28.626');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:58:33.653');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:58:38.658');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:58:43.662');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:58:48.657');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:58:53.659');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:58:58.677');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:59:03.698');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:59:08.72');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:59:13.739');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:59:18.748');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:59:23.742');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 22:59:28.742');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 22:59:33.744');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:59:38.768');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 22:59:43.786');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 22:59:48.806');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:59:53.828');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 22:59:58.828');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:00:03.831');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:00:08.83');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:00:13.832');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:00:18.85');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:00:23.87');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:00:28.893');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:00:33.914');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:00:38.915');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:00:43.915');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:00:48.916');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:00:53.917');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:00:58.947');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:01:03.964');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:01:08.982');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:01:14');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:01:19.002');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:01:24.002');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:01:29.004');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:01:34.004');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:01:39.025');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:01:44.042');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:01:49.061');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:01:54.08');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:01:59.082');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:02:04.082');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:02:09.083');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:02:14.084');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:02:19.108');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:02:24.13');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:02:29.147');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:02:34.167');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:02:39.166');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:02:44.17');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:02:49.172');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-16 23:02:54.172');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:02:59.19');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:03:04.206');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:03:09.224');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:03:14.242');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-16 23:03:19.244');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:03:24.244');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-16 23:03:29.245');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:03:34.246');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-16 23:03:39.267');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-16 23:03:44.286');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:01:23.208');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:01:28.181');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:01:33.203');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:01:38.211');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:01:43.212');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:01:48.212');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:01:53.22');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:01:58.238');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:02:03.257');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:02:08.281');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:02:13.299');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:02:18.3');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:02:23.302');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:02:28.305');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:02:33.306');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:02:38.329');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:02:43.348');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:02:48.369');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:02:53.387');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:02:58.389');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:03:03.389');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:03:08.392');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:03:13.394');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:03:18.42');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:03:23.441');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:03:28.464');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:03:33.488');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:03:38.493');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:03:43.494');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:03:48.496');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:03:53.497');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:03:58.517');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:04:03.536');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:04:08.555');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:04:13.577');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:04:18.579');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:04:23.58');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:04:28.582');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:04:33.582');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:04:38.605');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:04:43.623');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:04:48.641');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:04:53.663');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:04:58.664');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:05:03.666');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:05:08.667');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:05:13.669');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:05:18.689');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:05:23.712');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:05:28.731');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:05:33.754');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:05:38.758');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:05:43.757');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:05:48.759');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:05:53.76');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:05:58.784');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:06:03.807');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:06:08.832');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:06:13.851');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:06:18.853');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:06:23.854');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:06:28.855');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:06:33.856');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:06:38.879');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:06:43.9');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:06:48.922');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:06:53.942');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:06:58.943');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:07:03.943');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:07:08.944');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:07:13.945');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:07:18.968');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:07:23.994');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:07:29.014');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:07:34.035');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:07:39.035');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:07:44.036');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:07:49.038');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:07:54.039');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:07:59.067');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:08:04.085');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:08:09.103');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:08:14.123');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:08:19.123');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:08:24.125');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:08:29.129');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:08:34.131');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:08:39.148');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:08:44.168');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:08:49.187');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:08:54.207');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:08:59.207');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:09:04.209');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:09:09.21');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:09:14.212');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:09:19.232');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:09:24.253');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:09:29.276');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:09:34.297');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:09:39.299');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:09:44.3');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:09:49.302');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:09:54.304');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:09:59.321');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:10:04.343');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:10:09.365');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:10:14.388');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:10:19.389');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:10:24.39');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:10:29.392');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:10:34.393');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:10:39.413');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:10:44.43');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:10:49.452');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:10:54.471');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:10:59.477');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:11:04.478');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:11:09.479');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:11:14.485');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:11:19.5');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:11:24.525');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:11:29.543');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:11:34.566');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:11:39.568');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:11:44.568');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:11:49.57');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:11:54.572');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:11:59.592');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:12:04.609');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:12:09.628');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:12:14.647');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:12:19.648');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:12:24.649');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:12:29.65');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:12:34.651');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:12:39.672');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:12:44.689');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:12:49.711');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:12:54.729');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:12:59.731');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:13:04.733');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:13:09.734');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:13:14.735');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:13:19.755');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:13:24.775');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:13:29.796');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:13:34.819');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:13:39.821');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:13:44.82');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:13:49.823');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:13:54.823');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:13:59.846');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:14:04.865');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:14:09.885');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:14:14.904');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:14:19.906');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:14:24.908');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:14:29.908');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:14:34.909');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:14:39.928');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:14:44.949');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:14:49.971');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:14:54.991');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:14:59.993');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:15:04.994');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:15:09.993');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:15:14.998');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:15:20.018');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:15:25.037');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:15:30.059');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:15:35.08');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:15:40.08');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:15:45.082');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:15:50.084');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:15:55.084');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:16:00.109');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:16:05.13');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:16:10.15');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:16:15.172');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:16:20.173');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:16:25.174');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:16:30.175');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:16:35.176');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:16:40.197');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:16:45.218');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:16:50.242');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:16:55.265');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:17:00.267');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:17:05.272');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:17:10.269');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:17:15.271');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:17:20.293');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:17:25.312');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:17:30.329');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:17:35.35');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:17:40.351');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:17:45.353');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:17:50.354');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:17:55.355');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:18:00.374');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:18:05.396');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:18:10.415');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:18:15.436');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:18:20.437');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:18:25.438');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:18:30.439');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:18:35.44');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:18:40.46');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:18:45.478');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:18:50.5');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:18:55.524');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:19:00.525');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:19:05.526');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:19:10.527');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:19:15.53');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:19:20.552');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:19:25.569');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:19:30.589');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:19:35.609');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:19:40.611');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:19:45.612');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:19:50.614');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:19:55.614');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:20:00.637');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:20:05.658');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:20:10.682');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:20:15.702');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:20:20.703');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:20:25.704');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:20:30.707');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:20:35.707');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:20:40.726');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:20:45.75');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:20:50.77');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:20:55.789');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:21:00.79');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:21:05.791');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:21:10.794');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:21:15.794');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:21:20.814');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:21:25.833');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:21:30.852');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:21:35.873');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:21:40.874');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:21:45.876');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:21:50.877');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:21:55.878');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:22:00.898');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:22:05.917');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:22:10.938');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:22:15.961');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:22:20.961');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:22:25.962');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:22:30.963');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:22:35.965');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:22:40.986');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:22:46.003');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:22:51.02');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:22:56.041');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:23:01.041');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:23:06.043');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:23:11.044');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:23:16.045');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:23:21.065');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:23:26.086');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:23:31.108');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:23:36.129');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:23:41.129');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:23:46.13');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:23:51.132');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:23:56.134');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:24:01.152');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:24:06.171');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:24:11.189');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:24:16.212');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:24:21.215');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:24:26.215');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:24:31.218');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:24:36.218');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:24:41.238');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:24:46.256');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:24:51.275');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:24:56.294');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:25:01.294');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:25:06.295');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:25:11.298');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:25:16.297');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:25:21.318');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:25:26.34');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:25:31.36');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:25:36.382');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:25:41.385');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:25:46.385');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:25:51.389');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:25:56.388');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:26:01.408');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:26:06.428');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:26:11.448');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:26:16.473');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:26:21.488');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:26:26.489');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:26:31.491');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:26:36.491');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:26:41.516');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:26:46.539');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:26:51.559');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:26:56.578');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:27:01.579');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:27:06.58');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:27:11.583');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:27:16.583');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:27:21.605');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:27:26.626');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:27:31.647');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:27:36.671');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:27:41.671');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:27:46.672');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:27:51.673');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:27:56.676');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:28:01.699');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:28:06.721');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:28:11.74');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:28:16.759');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:28:21.761');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:28:26.762');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:28:31.763');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:28:36.764');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:28:41.785');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:28:46.809');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:28:51.827');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:28:56.846');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:29:01.85');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:29:06.853');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:29:11.859');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:29:16.854');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:29:21.88');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:29:26.924');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:29:31.944');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:29:36.965');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:29:41.97');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:29:46.97');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:29:51.971');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:29:56.976');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:30:01.993');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:30:07.02');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:30:12.026');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:30:17.051');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:30:22.059');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:30:27.058');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:30:32.058');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:30:37.061');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:30:42.093');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:30:47.116');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:30:52.142');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:30:57.164');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:31:02.166');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:31:07.17');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:31:12.169');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:31:17.174');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:31:22.194');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:31:27.214');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:31:32.241');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:31:37.262');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:31:42.255');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:31:47.256');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:31:52.257');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:31:57.259');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:32:02.276');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:32:07.3');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:32:12.319');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:32:17.344');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:32:22.351');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:32:27.353');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:32:32.357');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:32:37.358');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:32:42.376');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:32:47.392');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:32:52.413');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:32:57.444');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:33:02.449');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:33:07.449');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:33:12.452');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:33:17.45');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:33:22.474');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:33:27.492');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:33:32.517');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:33:37.537');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:33:42.545');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:33:47.545');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '22 °C', 'number', '2023-03-17 09:33:52.548');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:33:57.548');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '24 °C', 'number', '2023-03-17 09:34:02.577');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '20 °C', 'number', '2023-03-17 09:34:07.593');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '21 °C', 'number', '2023-03-17 09:34:12.617');
INSERT INTO mtdmanager.timeseries VALUES ('gateway1', 'device1', 'temperature', '23 °C', 'number', '2023-03-17 09:34:17.642');


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

