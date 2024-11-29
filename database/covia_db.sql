--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2024-11-29 16:07:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS covia_db;
--
-- TOC entry 5021 (class 1262 OID 18085)
-- Name: covia_db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE covia_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Mexico.1252';


ALTER DATABASE covia_db OWNER TO postgres;

\connect covia_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 218 (class 1259 OID 18087)
-- Name: alert_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alert_type (
    id integer NOT NULL,
    alert text,
    color text,
    status boolean DEFAULT true
);


ALTER TABLE public.alert_type OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 18086)
-- Name: alert_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alert_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alert_type_id_seq OWNER TO postgres;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 217
-- Name: alert_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alert_type_id_seq OWNED BY public.alert_type.id;


--
-- TOC entry 244 (class 1259 OID 18223)
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id integer NOT NULL,
    device_id text,
    alert_id integer,
    description text,
    latitude text,
    longitude text,
    date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 18222)
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alerts_id_seq OWNER TO postgres;

--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 243
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


--
-- TOC entry 245 (class 1259 OID 18232)
-- Name: camera_device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.camera_device (
    camera_id integer,
    device_id text
);


ALTER TABLE public.camera_device OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 18096)
-- Name: cameras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cameras (
    id text NOT NULL,
    name text,
    current_status text,
    contact text,
    latitude text,
    longitude text,
    address text,
    city text,
    camera_brand text,
    last_update date DEFAULT CURRENT_DATE,
    url text,
    streaming_token text,
    status boolean DEFAULT true
);


ALTER TABLE public.cameras OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 18106)
-- Name: cameras_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cameras_devices (
    id integer NOT NULL,
    server text,
    name text,
    ip_address text,
    password text,
    stream text,
    title text,
    "position" text,
    status boolean DEFAULT true
);


ALTER TABLE public.cameras_devices OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18105)
-- Name: cameras_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cameras_devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cameras_devices_id_seq OWNER TO postgres;

--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 220
-- Name: cameras_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cameras_devices_id_seq OWNED BY public.cameras_devices.id;


--
-- TOC entry 234 (class 1259 OID 18175)
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    id text NOT NULL,
    group_id integer,
    name text,
    device_status text,
    last_update date DEFAULT CURRENT_DATE,
    phone text,
    model text,
    fuel_id integer,
    km_per_liter text,
    is_dvr boolean,
    status boolean DEFAULT true
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 18116)
-- Name: fuel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fuel (
    id integer NOT NULL,
    fuel text,
    status boolean DEFAULT true
);


ALTER TABLE public.fuel OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18115)
-- Name: fuel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fuel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fuel_id_seq OWNER TO postgres;

--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 222
-- Name: fuel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fuel_id_seq OWNED BY public.fuel.id;


--
-- TOC entry 225 (class 1259 OID 18126)
-- Name: geofences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geofences (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    color character varying(255),
    area character varying(255)
);


ALTER TABLE public.geofences OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 18125)
-- Name: geofences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.geofences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.geofences_id_seq OWNER TO postgres;

--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 224
-- Name: geofences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.geofences_id_seq OWNED BY public.geofences.id;


--
-- TOC entry 227 (class 1259 OID 18135)
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    "group" text,
    status boolean DEFAULT true
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 18134)
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO postgres;

--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 226
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- TOC entry 229 (class 1259 OID 18145)
-- Name: nvr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nvr (
    id integer NOT NULL,
    name text,
    app_key text,
    secret_key text,
    code text,
    access_token text,
    expired_token text,
    status boolean DEFAULT true
);


ALTER TABLE public.nvr OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 18154)
-- Name: nvr_camera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nvr_camera (
    nvr_id integer,
    camera_id text
);


ALTER TABLE public.nvr_camera OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 18144)
-- Name: nvr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nvr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nvr_id_seq OWNER TO postgres;

--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 228
-- Name: nvr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nvr_id_seq OWNED BY public.nvr.id;


--
-- TOC entry 232 (class 1259 OID 18160)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    profile integer,
    status boolean DEFAULT true
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 18159)
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profiles_id_seq OWNER TO postgres;

--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 231
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- TOC entry 236 (class 1259 OID 18185)
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    id integer NOT NULL,
    device_id text,
    latitude text,
    longitude text,
    date date
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 18184)
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.routes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.routes_id_seq OWNER TO postgres;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 235
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.routes_id_seq OWNED BY public.routes.id;


--
-- TOC entry 238 (class 1259 OID 18194)
-- Name: summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.summary (
    id integer NOT NULL,
    device_id text,
    average_speed text,
    distance text,
    initial_odometer text,
    final_odometer text,
    max_speed text,
    spent_fuel text,
    km_per_liter text
);


ALTER TABLE public.summary OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 18193)
-- Name: summary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.summary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.summary_id_seq OWNER TO postgres;

--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 237
-- Name: summary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.summary_id_seq OWNED BY public.summary.id;


--
-- TOC entry 239 (class 1259 OID 18202)
-- Name: user_device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_device (
    user_id text,
    device_id text
);


ALTER TABLE public.user_device OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 18207)
-- Name: user_geofence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_geofence (
    user_id text,
    geofence_id integer
);


ALTER TABLE public.user_geofence OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 18212)
-- Name: user_nvr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_nvr (
    user_id text,
    nvr_id integer
);


ALTER TABLE public.user_nvr OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 18217)
-- Name: user_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profile (
    user_id text,
    profile_id integer
);


ALTER TABLE public.user_profile OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 18167)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text,
    password character varying(255),
    phone character varying(255),
    birthday date,
    status boolean DEFAULT true
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 4776 (class 2604 OID 18090)
-- Name: alert_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_type ALTER COLUMN id SET DEFAULT nextval('public.alert_type_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 18226)
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


--
-- TOC entry 4780 (class 2604 OID 18109)
-- Name: cameras_devices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras_devices ALTER COLUMN id SET DEFAULT nextval('public.cameras_devices_id_seq'::regclass);


--
-- TOC entry 4782 (class 2604 OID 18119)
-- Name: fuel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fuel ALTER COLUMN id SET DEFAULT nextval('public.fuel_id_seq'::regclass);


--
-- TOC entry 4784 (class 2604 OID 18129)
-- Name: geofences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geofences ALTER COLUMN id SET DEFAULT nextval('public.geofences_id_seq'::regclass);


--
-- TOC entry 4785 (class 2604 OID 18138)
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 18148)
-- Name: nvr id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr ALTER COLUMN id SET DEFAULT nextval('public.nvr_id_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 18163)
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 18188)
-- Name: routes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes ALTER COLUMN id SET DEFAULT nextval('public.routes_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 18197)
-- Name: summary id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary ALTER COLUMN id SET DEFAULT nextval('public.summary_id_seq'::regclass);


--
-- TOC entry 4988 (class 0 OID 18087)
-- Dependencies: 218
-- Data for Name: alert_type; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5014 (class 0 OID 18223)
-- Dependencies: 244
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5015 (class 0 OID 18232)
-- Dependencies: 245
-- Data for Name: camera_device; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4989 (class 0 OID 18096)
-- Dependencies: 219
-- Data for Name: cameras; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4991 (class 0 OID 18106)
-- Dependencies: 221
-- Data for Name: cameras_devices; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5004 (class 0 OID 18175)
-- Dependencies: 234
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4993 (class 0 OID 18116)
-- Dependencies: 223
-- Data for Name: fuel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fuel VALUES (1, 'Magna', true) ON CONFLICT DO NOTHING;
INSERT INTO public.fuel VALUES (2, 'Premium', true) ON CONFLICT DO NOTHING;
INSERT INTO public.fuel VALUES (3, 'Disel', true) ON CONFLICT DO NOTHING;
INSERT INTO public.fuel VALUES (4, 'Eléctrico', true) ON CONFLICT DO NOTHING;


--
-- TOC entry 4995 (class 0 OID 18126)
-- Dependencies: 225
-- Data for Name: geofences; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4997 (class 0 OID 18135)
-- Dependencies: 227
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4999 (class 0 OID 18145)
-- Dependencies: 229
-- Data for Name: nvr; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5000 (class 0 OID 18154)
-- Dependencies: 230
-- Data for Name: nvr_camera; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5002 (class 0 OID 18160)
-- Dependencies: 232
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5006 (class 0 OID 18185)
-- Dependencies: 236
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5008 (class 0 OID 18194)
-- Dependencies: 238
-- Data for Name: summary; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5009 (class 0 OID 18202)
-- Dependencies: 239
-- Data for Name: user_device; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5010 (class 0 OID 18207)
-- Dependencies: 240
-- Data for Name: user_geofence; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5011 (class 0 OID 18212)
-- Dependencies: 241
-- Data for Name: user_nvr; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5012 (class 0 OID 18217)
-- Dependencies: 242
-- Data for Name: user_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5003 (class 0 OID 18167)
-- Dependencies: 233
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 217
-- Name: alert_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_type_id_seq', 1, false);


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 243
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq', 1, false);


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 220
-- Name: cameras_devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cameras_devices_id_seq', 1, false);


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 222
-- Name: fuel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fuel_id_seq', 4, true);


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 224
-- Name: geofences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geofences_id_seq', 1, false);


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 226
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 1, false);


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 228
-- Name: nvr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nvr_id_seq', 1, false);


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 231
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 1, false);


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 235
-- Name: routes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routes_id_seq', 1, false);


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 237
-- Name: summary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.summary_id_seq', 1, false);


--
-- TOC entry 4799 (class 2606 OID 18095)
-- Name: alert_type pk_alert_type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_type
    ADD CONSTRAINT pk_alert_type PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 18231)
-- Name: alerts pk_alerts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT pk_alerts PRIMARY KEY (id);


--
-- TOC entry 4801 (class 2606 OID 18104)
-- Name: cameras pk_camera; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT pk_camera PRIMARY KEY (id);


--
-- TOC entry 4803 (class 2606 OID 18114)
-- Name: cameras_devices pk_cameras_devices; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras_devices
    ADD CONSTRAINT pk_cameras_devices PRIMARY KEY (id);


--
-- TOC entry 4817 (class 2606 OID 18183)
-- Name: devices pk_device; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT pk_device PRIMARY KEY (id);


--
-- TOC entry 4805 (class 2606 OID 18124)
-- Name: fuel pk_fuel; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fuel
    ADD CONSTRAINT pk_fuel PRIMARY KEY (id);


--
-- TOC entry 4807 (class 2606 OID 18133)
-- Name: geofences pk_geofences; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geofences
    ADD CONSTRAINT pk_geofences PRIMARY KEY (id);


--
-- TOC entry 4809 (class 2606 OID 18143)
-- Name: groups pk_groups; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT pk_groups PRIMARY KEY (id);


--
-- TOC entry 4811 (class 2606 OID 18153)
-- Name: nvr pk_nvr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr
    ADD CONSTRAINT pk_nvr PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 18166)
-- Name: profiles pk_profiles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT pk_profiles PRIMARY KEY (id);


--
-- TOC entry 4819 (class 2606 OID 18192)
-- Name: routes pk_routes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT pk_routes PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 18201)
-- Name: summary pk_summary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary
    ADD CONSTRAINT pk_summary PRIMARY KEY (id);


--
-- TOC entry 4815 (class 2606 OID 18174)
-- Name: users pk_tbl_0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_tbl_0 PRIMARY KEY (id);


--
-- TOC entry 4838 (class 2606 OID 18242)
-- Name: alerts fk_alerts_alert_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_alerts_alert_type FOREIGN KEY (alert_id) REFERENCES public.alert_type(id);


--
-- TOC entry 4839 (class 2606 OID 18237)
-- Name: alerts fk_alerts_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_alerts_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4840 (class 2606 OID 18252)
-- Name: camera_device fk_camera_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_device
    ADD CONSTRAINT fk_camera_device FOREIGN KEY (camera_id) REFERENCES public.cameras_devices(id);


--
-- TOC entry 4841 (class 2606 OID 18247)
-- Name: camera_device fk_camera_device_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_device
    ADD CONSTRAINT fk_camera_device_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4826 (class 2606 OID 18262)
-- Name: devices fk_devices_fuel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT fk_devices_fuel FOREIGN KEY (fuel_id) REFERENCES public.fuel(id);


--
-- TOC entry 4827 (class 2606 OID 18257)
-- Name: devices fk_devices_groups; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT fk_devices_groups FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- TOC entry 4824 (class 2606 OID 18267)
-- Name: nvr_camera fk_nvr_camera_cameras; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr_camera
    ADD CONSTRAINT fk_nvr_camera_cameras FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- TOC entry 4825 (class 2606 OID 18272)
-- Name: nvr_camera fk_nvr_camera_geofences; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr_camera
    ADD CONSTRAINT fk_nvr_camera_geofences FOREIGN KEY (nvr_id) REFERENCES public.nvr(id);


--
-- TOC entry 4828 (class 2606 OID 18277)
-- Name: routes fk_routes_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT fk_routes_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4829 (class 2606 OID 18282)
-- Name: summary fk_summary_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary
    ADD CONSTRAINT fk_summary_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4830 (class 2606 OID 18292)
-- Name: user_device fk_user_device_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_device
    ADD CONSTRAINT fk_user_device_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4831 (class 2606 OID 18287)
-- Name: user_device fk_user_device_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_device
    ADD CONSTRAINT fk_user_device_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4832 (class 2606 OID 18302)
-- Name: user_geofence fk_user_geofence_fuel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_geofence
    ADD CONSTRAINT fk_user_geofence_fuel FOREIGN KEY (geofence_id) REFERENCES public.geofences(id);


--
-- TOC entry 4833 (class 2606 OID 18297)
-- Name: user_geofence fk_user_geofence_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_geofence
    ADD CONSTRAINT fk_user_geofence_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4834 (class 2606 OID 18312)
-- Name: user_nvr fk_user_nvr_geofences; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_nvr
    ADD CONSTRAINT fk_user_nvr_geofences FOREIGN KEY (nvr_id) REFERENCES public.nvr(id);


--
-- TOC entry 4835 (class 2606 OID 18307)
-- Name: user_nvr fk_user_nvr_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_nvr
    ADD CONSTRAINT fk_user_nvr_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4836 (class 2606 OID 18322)
-- Name: user_profile fk_user_profile_profiles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT fk_user_profile_profiles FOREIGN KEY (profile_id) REFERENCES public.profiles(id);


--
-- TOC entry 4837 (class 2606 OID 18317)
-- Name: user_profile fk_user_profile_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT fk_user_profile_users FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2024-11-29 16:07:29

--
-- PostgreSQL database dump complete
--

