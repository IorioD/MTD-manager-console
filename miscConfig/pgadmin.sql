--DROP DATABASE mtdmanager WITH (FORCE);

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
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER DATABASE mtdmanager OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
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
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE SCHEMA mtdmanager;


ALTER SCHEMA mtdmanager OWNER TO mtdmanager;

SET default_tablespace = '';

SET default_table_access_method = heap;

--------------------------------------------------------------------------------------------------------------------
--                                            DEPLOYMENT TABLES
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE mtdmanager.deployment (
    id integer NOT NULL,
    name character varying NOT NULL,
    namespace character varying,
    status character varying NOT NULL,
    type character varying NOT NULL
);
ALTER TABLE mtdmanager.deployment OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE SEQUENCE mtdmanager.deployment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE mtdmanager.deployment_id_seq OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER SEQUENCE mtdmanager.deployment_id_seq OWNED BY mtdmanager.deployment.id;

--------------------------------------------------------------------------------------------------------------------
--                                            POD TABLES
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE mtdmanager.pod (
    id integer NOT NULL,
    name character varying NOT NULL,
    namespace character varying,
    type character varying NOT NULL,
    node_name character varying,
    status character varying,
    pod_ip character varying,
    strategy integer NOT NULL,
    enabled boolean NOT NULL,
    id_deplo integer
);
ALTER TABLE mtdmanager.pod OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE SEQUENCE mtdmanager.pod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE mtdmanager.pod_id_seq OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER SEQUENCE mtdmanager.pod_id_seq OWNED BY mtdmanager.pod.id;

--------------------------------------------------------------------------------------------------------------------
--                                            NODE TABLES
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE mtdmanager.node (
    id integer NOT NULL,
    hostname character varying NOT NULL,
    ip_address character varying NOT NULL,
    role character varying,
    type character varying,
    available boolean DEFAULT false
);
ALTER TABLE mtdmanager.node OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE SEQUENCE mtdmanager.node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE mtdmanager.node_id_seq OWNER TO mtdmanager;
ALTER SEQUENCE mtdmanager.node_id_seq OWNED BY mtdmanager.node.id;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE TABLE mtdmanager.node_label (
    id integer NOT NULL,
    key character varying,
    value character varying,
    id_node integer NOT NULL
);
ALTER TABLE mtdmanager.node_label OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

CREATE SEQUENCE mtdmanager.node_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE mtdmanager.node_label_id_seq OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER SEQUENCE mtdmanager.node_label_id_seq OWNED BY mtdmanager.node_label.id;

--------------------------------------------------------------------------------------------------------------------
--                                            PARAMETER TABLES
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE mtdmanager.parameter (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);
ALTER TABLE mtdmanager.parameter OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE SEQUENCE mtdmanager.parameter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE mtdmanager.parameter_id_seq OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER SEQUENCE mtdmanager.parameter_id_seq OWNED BY mtdmanager.parameter.id;

--------------------------------------------------------------------------------------------------------------------
--                                            SERVICE ACCOUNT TABLES
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE mtdmanager.service_account (
    id integer NOT NULL,
    name character varying,
    namespace character varying,
    deployment integer
);
ALTER TABLE mtdmanager.service_account OWNER TO mtdmanager;

--------------------------------------------------------------------------------------------------------------------
--                                            STRATEGY TABLES
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE mtdmanager.strategy (
    id integer NOT NULL,
    name character varying NOT NULL,
    enabled boolean NOT NULL,
    scheduling character varying NOT NULL
);
ALTER TABLE mtdmanager.strategy OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE SEQUENCE mtdmanager.strategy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE mtdmanager.strategy_id_seq OWNER TO mtdmanager;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER SEQUENCE mtdmanager.strategy_id_seq OWNED BY mtdmanager.strategy.id;
--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ALTER TABLE ONLY mtdmanager.deployment ALTER COLUMN id SET DEFAULT nextval('mtdmanager.deployment_id_seq'::regclass);

ALTER TABLE ONLY mtdmanager.pod ALTER COLUMN id SET DEFAULT nextval('mtdmanager.pod_id_seq'::regclass);

ALTER TABLE ONLY mtdmanager.node ALTER COLUMN id SET DEFAULT nextval('mtdmanager.node_id_seq'::regclass);

ALTER TABLE ONLY mtdmanager.node_label ALTER COLUMN id SET DEFAULT nextval('mtdmanager.node_label_id_seq'::regclass);

ALTER TABLE ONLY mtdmanager.parameter ALTER COLUMN id SET DEFAULT nextval('mtdmanager.parameter_id_seq'::regclass);

ALTER TABLE ONLY mtdmanager.strategy ALTER COLUMN id SET DEFAULT nextval('mtdmanager.strategy_id_seq'::regclass);

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--                                    ID  hostname          IP         Role            Type  availab 
INSERT INTO mtdmanager.node VALUES (1, 'master', '192.168.56.117', 'control-plane', 'cloud', true);
INSERT INTO mtdmanager.node VALUES (2, 'worker1', '192.168.56.115', 'worker', 'cloud', true);
INSERT INTO mtdmanager.node VALUES (3, 'worker2', '192.168.56.116', 'worker', 'cloud', true);

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--                                        ID  key   value   id_node
INSERT INTO mtdmanager.node_label VALUES (1, 'name', 'master', 1);
INSERT INTO mtdmanager.node_label VALUES (2, 'name', 'worker', 2);
INSERT INTO mtdmanager.node_label VALUES (3, 'name', 'worker', 3);

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
INSERT INTO mtdmanager.parameter VALUES (1, 'period', '60000');

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
INSERT INTO mtdmanager.strategy VALUES (1, 'ip-shuffling', false, 'fixed');
INSERT INTO mtdmanager.strategy VALUES (2, 'redundancy-service', false, 'fixed');
INSERT INTO mtdmanager.strategy VALUES (3, 'pod-migration', false, 'fixed');
INSERT INTO mtdmanager.strategy VALUES (4, 'service-account-shuffling', false, 'fixed');

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

SELECT pg_catalog.setval('mtdmanager.parameter_id_seq', 1, true);

SELECT pg_catalog.setval('mtdmanager.node_label_id_seq', 2, true);

SELECT pg_catalog.setval('mtdmanager.strategy_id_seq', 5, true);

SELECT pg_catalog.setval('mtdmanager.deployment_id_seq', 7, true);

SELECT pg_catalog.setval('mtdmanager.node_id_seq', 8, true);

SELECT pg_catalog.setval('mtdmanager.pod_id_seq', 9, true);

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER TABLE ONLY mtdmanager.deployment
    ADD CONSTRAINT deployment_pkey PRIMARY KEY (id);

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER TABLE ONLY mtdmanager.pod
    ADD CONSTRAINT pod_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mtdmanager.pod
    ADD CONSTRAINT pod_id_deplo_name_fk FOREIGN KEY (id_deplo) REFERENCES mtdmanager.deployment(id) ON DELETE CASCADE;

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER TABLE ONLY mtdmanager.node
    ADD CONSTRAINT node_ip_address_key UNIQUE (ip_address);

ALTER TABLE ONLY mtdmanager.node
    ADD CONSTRAINT node_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mtdmanager.node_label
    ADD CONSTRAINT node_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mtdmanager.node_label
    ADD CONSTRAINT node_label_node_id_fk FOREIGN KEY (id_node) REFERENCES mtdmanager.node(id) ON DELETE CASCADE;

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER TABLE ONLY mtdmanager.parameter
    ADD CONSTRAINT parameter_key_key UNIQUE (key);

ALTER TABLE ONLY mtdmanager.parameter
    ADD CONSTRAINT parameter_pkey PRIMARY KEY (id);

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER TABLE ONLY mtdmanager.service_account
    ADD CONSTRAINT service_account_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mtdmanager.service_account
    ADD CONSTRAINT service_account_deployment_id_fk FOREIGN KEY (deployment) REFERENCES mtdmanager.deployment(id);

--    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ALTER TABLE ONLY mtdmanager.strategy
    ADD CONSTRAINT strategy_name_key UNIQUE (name);

ALTER TABLE ONLY mtdmanager.strategy
    ADD CONSTRAINT strategy_pkey PRIMARY KEY (id);