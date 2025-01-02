--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-01-02 09:14:04

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

--
-- TOC entry 218 (class 1259 OID 20570)
-- Name: alert_type_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alert_type_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alert_type_id_seq1 OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 237 (class 1259 OID 20589)
-- Name: alert_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alert_type (
    id integer DEFAULT nextval('public.alert_type_id_seq1'::regclass) NOT NULL,
    alert text,
    color text,
    status boolean DEFAULT true
);


ALTER TABLE public.alert_type OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 20569)
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
-- TOC entry 255 (class 1259 OID 20725)
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id text NOT NULL,
    device_id text,
    alert_id integer,
    description text,
    latitude text,
    longitude text,
    date timestamp without time zone DEFAULT CURRENT_DATE
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 20571)
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
-- TOC entry 220 (class 1259 OID 20572)
-- Name: alerts_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerts_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alerts_id_seq1 OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 20598)
-- Name: cameras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cameras (
    id text NOT NULL,
    name text,
    latitude text,
    longitude text,
    status boolean DEFAULT true
);


ALTER TABLE public.cameras OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 20573)
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
-- TOC entry 222 (class 1259 OID 20574)
-- Name: cameras_devices_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cameras_devices_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cameras_devices_id_seq1 OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 21614)
-- Name: device_downloads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_downloads (
    device_id text,
    download_id text
);


ALTER TABLE public.device_downloads OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 20675)
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    id text NOT NULL,
    name text,
    device_status text,
    phone text,
    model text,
    fuel_id integer,
    km_per_liter text,
    is_dvr boolean,
    channelcount integer,
    status boolean DEFAULT true,
    last_update timestamp without time zone DEFAULT CURRENT_DATE,
    imei text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    icon text,
    pad_lock boolean
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 21607)
-- Name: downloads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.downloads (
    id text NOT NULL,
    name text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    cameras integer[],
    percentage integer,
    status_id integer,
    dir text,
    dirname text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.downloads OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 20607)
-- Name: drones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drones (
    id integer NOT NULL,
    name text,
    latitude text,
    longitude text,
    status boolean DEFAULT true
);


ALTER TABLE public.drones OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 20606)
-- Name: drones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.drones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.drones_id_seq OWNER TO postgres;

--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 239
-- Name: drones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.drones_id_seq OWNED BY public.drones.id;


--
-- TOC entry 224 (class 1259 OID 20576)
-- Name: fuel_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fuel_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fuel_id_seq1 OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 20616)
-- Name: fuel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fuel (
    id integer DEFAULT nextval('public.fuel_id_seq1'::regclass) NOT NULL,
    fuel text,
    status boolean DEFAULT true
);


ALTER TABLE public.fuel OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 20575)
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
-- TOC entry 226 (class 1259 OID 20578)
-- Name: geofences_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.geofences_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.geofences_id_seq1 OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 20625)
-- Name: geofences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geofences (
    id integer DEFAULT nextval('public.geofences_id_seq1'::regclass) NOT NULL,
    name character varying(255),
    description character varying(255),
    color character varying(255),
    area text,
    status boolean DEFAULT true
);


ALTER TABLE public.geofences OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 20577)
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
-- TOC entry 257 (class 1259 OID 21160)
-- Name: group_device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_device (
    group_id integer,
    device_id text
);


ALTER TABLE public.group_device OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 20580)
-- Name: groups_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq1 OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 20634)
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id integer DEFAULT nextval('public.groups_id_seq1'::regclass) NOT NULL,
    "group" text,
    status boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_DATE,
    last_update timestamp with time zone DEFAULT CURRENT_DATE
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 20579)
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
-- TOC entry 259 (class 1259 OID 21527)
-- Name: licences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.licences (
    id integer NOT NULL,
    licence text
);


ALTER TABLE public.licences OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 21526)
-- Name: licences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.licences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.licences_id_seq OWNER TO postgres;

--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 258
-- Name: licences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.licences_id_seq OWNED BY public.licences.id;


--
-- TOC entry 230 (class 1259 OID 20582)
-- Name: nvr_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nvr_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nvr_id_seq1 OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 20643)
-- Name: nvr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nvr (
    id integer DEFAULT nextval('public.nvr_id_seq1'::regclass) NOT NULL,
    name text,
    app_key text,
    secret_key text,
    code text,
    access_token text,
    expired_token text,
    streaming_token text,
    address text,
    city text,
    camera_brand text,
    contact text,
    last_update timestamp without time zone DEFAULT CURRENT_DATE,
    status boolean DEFAULT true,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.nvr OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 20653)
-- Name: nvr_camera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nvr_camera (
    nvr_id integer,
    camera_id text
);


ALTER TABLE public.nvr_camera OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 20581)
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
-- TOC entry 232 (class 1259 OID 20584)
-- Name: profiles_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profiles_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profiles_id_seq1 OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 20658)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id integer DEFAULT nextval('public.profiles_id_seq1'::regclass) NOT NULL,
    profile text,
    status boolean DEFAULT true
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 20583)
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
-- TOC entry 249 (class 1259 OID 20684)
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    id text NOT NULL,
    device_id text,
    latitude text,
    longitude text,
    date timestamp without time zone,
    speed text
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 20585)
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
-- TOC entry 234 (class 1259 OID 20586)
-- Name: routes_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.routes_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.routes_id_seq1 OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 21630)
-- Name: status_download; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_download (
    id integer NOT NULL,
    status text
);


ALTER TABLE public.status_download OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 21629)
-- Name: status_download_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.status_download_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.status_download_id_seq OWNER TO postgres;

--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 262
-- Name: status_download_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_download_id_seq OWNED BY public.status_download.id;


--
-- TOC entry 236 (class 1259 OID 20588)
-- Name: summary_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.summary_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.summary_id_seq1 OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 20692)
-- Name: summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.summary (
    id integer DEFAULT nextval('public.summary_id_seq1'::regclass) NOT NULL,
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
-- TOC entry 235 (class 1259 OID 20587)
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
-- TOC entry 251 (class 1259 OID 20705)
-- Name: user_drone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_drone (
    user_id text,
    drone_id integer
);


ALTER TABLE public.user_drone OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 20710)
-- Name: user_geofence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_geofence (
    user_id text,
    geofence_id integer
);


ALTER TABLE public.user_geofence OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 21137)
-- Name: user_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_group (
    user_id text,
    group_id integer
);


ALTER TABLE public.user_group OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 20715)
-- Name: user_nvr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_nvr (
    user_id text,
    nvr_id integer
);


ALTER TABLE public.user_nvr OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 20720)
-- Name: user_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profile (
    user_id text,
    profile_id integer
);


ALTER TABLE public.user_profile OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 20667)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text,
    password character varying(255),
    phone character varying(255),
    birthdate date,
    status boolean DEFAULT true,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    licence_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 4812 (class 2604 OID 20610)
-- Name: drones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drones ALTER COLUMN id SET DEFAULT nextval('public.drones_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 21530)
-- Name: licences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.licences ALTER COLUMN id SET DEFAULT nextval('public.licences_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 21633)
-- Name: status_download id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_download ALTER COLUMN id SET DEFAULT nextval('public.status_download_id_seq'::regclass);


--
-- TOC entry 5059 (class 0 OID 20589)
-- Dependencies: 237
-- Data for Name: alert_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.alert_type VALUES (1, 'Alerta de pérdida de video', '#000000', true);
INSERT INTO public.alert_type VALUES (3, 'Alerta de cobertura de cámara', '#FF0000', true);
INSERT INTO public.alert_type VALUES (13, 'Alerta de Emergencia', '#00FF99', true);
INSERT INTO public.alert_type VALUES (18, 'Alerta de geo-cercado', '#005005', true);
INSERT INTO public.alert_type VALUES (19, 'Apagado ilegal', '#FFC6DE', true);
INSERT INTO public.alert_type VALUES (20, 'Apagado forzado', '#FF00FF', true);
INSERT INTO public.alert_type VALUES (29, 'Alerta de temperatura', '#00A8CD', true);
INSERT INTO public.alert_type VALUES (36, 'Alerta de distancia', '#A0A0A0', true);
INSERT INTO public.alert_type VALUES (38, 'Alerta de cambio de carril', '#F5FF70', true);
INSERT INTO public.alert_type VALUES (47, 'Alerta de cambios anormales de temperatura', '#0033FF', true);
INSERT INTO public.alert_type VALUES (58, 'Fatiga de conductor', '#9A00FF', true);
INSERT INTO public.alert_type VALUES (60, 'Detección de teléfono', '#3283FF', true);
INSERT INTO public.alert_type VALUES (61, 'Detección de conductor fumando', '#3D4040', true);
INSERT INTO public.alert_type VALUES (62, 'Detección de conductor distraído', '#FFFF00', true);
INSERT INTO public.alert_type VALUES (63, 'Salida de carril', '#FF7F00', true);
INSERT INTO public.alert_type VALUES (64, 'Aviso de colisión frontal', '#695141', true);
INSERT INTO public.alert_type VALUES (74, 'Alerta de arranque anormal', '#03737E', true);
INSERT INTO public.alert_type VALUES (160, 'Alerta de exceso de velocidad', '#ACCDFF', true);
INSERT INTO public.alert_type VALUES (162, 'Control de la distancia de seguimiento', '#00FF00', true);
INSERT INTO public.alert_type VALUES (163, 'Advertencia de colisión de peatones', '#630000', true);
INSERT INTO public.alert_type VALUES (164, 'Detección de bostezos', '#380055', true);
INSERT INTO public.alert_type VALUES (169, 'Detección de cinturón de seguridad', '#E4B7FF', true);
INSERT INTO public.alert_type VALUES (392, 'Zona ciega', '#C54200', true);


--
-- TOC entry 5077 (class 0 OID 20725)
-- Dependencies: 255
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5060 (class 0 OID 20598)
-- Dependencies: 238
-- Data for Name: cameras; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cameras VALUES ('aa921ea0c77f41a5b97319db69796a37', 'HELIPUERTO TRASERA', '20.701784', '-100.196503', true);
INSERT INTO public.cameras VALUES ('7b9ba844aa324e78acb569ef88d4d6a6', 'BODEGA GENERAL', '20.702702', '-100.196868', true);
INSERT INTO public.cameras VALUES ('86c0cf57bb1d4b42b42e0a0e90bf6b0d', 'HELIPUERTO FRENTE', '20.701945', '-100.196534', true);
INSERT INTO public.cameras VALUES ('5eb091732eb143ebbe75aa70101139b9', 'VIÑEDOS RESTAURANTE', '20.702540', '-100.196750', true);
INSERT INTO public.cameras VALUES ('bdde2a54f54b4691b782644ea07244e8', 'RODEO', '20.702756', '-100.196700', true);
INSERT INTO public.cameras VALUES ('8c968aaed44846ca82718b4f81a1b328', 'INVERNADERO', '20.702733', '-100.196930', true);
INSERT INTO public.cameras VALUES ('ba5b524f863f412190050c9b4847dd02', 'COCINA', '20.702687', '-100.196518', true);
INSERT INTO public.cameras VALUES ('ee1b24b46352490f8aeed7179968bcbf', 'ESTACIONAMIENTO LADO CABALLERIZA', '20.702600', '-100.196446', true);
INSERT INTO public.cameras VALUES ('0fd691f8db1a4bafa8e71a08438f0ea4', 'ACCESO BARRICAS', '20.702728', '-100.196744', true);
INSERT INTO public.cameras VALUES ('02e2d54677614f77941cfe59c10320a7', 'BODEGA COCINA', '20.702737', '-100.196466', true);
INSERT INTO public.cameras VALUES ('5a7886a367d64811b21fb1bc0fb383f7', 'ACCESO BAÑOS', '20.702768', '-100.196758', true);
INSERT INTO public.cameras VALUES ('985c95b90152465cab098413cfe4880d', 'BAR', '20.702860', '-100.196441', true);
INSERT INTO public.cameras VALUES ('12d19145d02b4f3591edf85bbca9e998', 'ESTACIONAMIENTO LADO HELIPUERTO', '20.702613', '-100.196468', true);
INSERT INTO public.cameras VALUES ('aa83900f8e68475c821e79e41c3bf3d0', 'CABALLERIZAS', '20.702722', '-100.196914', true);
INSERT INTO public.cameras VALUES ('760a0e5e2a434ba6a7fff693ba0ae500', 'RESTAURANTE', '20.702746', '-100.196643', true);
INSERT INTO public.cameras VALUES ('6aed8e6908684bacb7f0254c136b3efb', 'CAMINO A CASETA 3', '20.703208', '-100.196828', true);
INSERT INTO public.cameras VALUES ('caf02dfb133348b29d887b14ba455145', 'ATRAS RESTAURANTE', '20.702723', '-100.196866', true);
INSERT INTO public.cameras VALUES ('5f97329c3d0c4f6fa2ae3ff682e667dc', 'CAMINO A FINCA', '20.702955', '-100.196825', true);
INSERT INTO public.cameras VALUES ('7a838321ba4a494db359530855afac08', 'CUARTO DE JUEGOS', '20.702693', '-100.196834', true);
INSERT INTO public.cameras VALUES ('05fd8aa973884433b3d22582b3b86cd0', 'ENTRADA A FABRICA 1', '20.703118', '-100.196711', true);
INSERT INTO public.cameras VALUES ('8d18f97c211e416da74dd694f2b0d704', 'ENTRADA A FABRICA 2', '20.703123', '-100.196614', true);
INSERT INTO public.cameras VALUES ('50aaf3f914cc42629399e0a33473db2d', 'CANCHAS', '20.702655', '-100.196466', true);
INSERT INTO public.cameras VALUES ('1e55c2d326cd4a7c9fb1ec130aff1296', 'PALAPA', '21.113561', '-86.977110', true);
INSERT INTO public.cameras VALUES ('eea1353bcf2147dba7035cdfa407834e', 'FRENTE ESTE', '21.114253', '-86.977046', true);
INSERT INTO public.cameras VALUES ('4be0179a25bf43fc8468856f886cc4a8', 'FRENTE OESTE', '21.114626', '-86.977914', true);
INSERT INTO public.cameras VALUES ('5695737947fb40719b65ab4a8b4552c4', 'PLUMA Y CUARTOS', '21.114257', '-86.977293', true);
INSERT INTO public.cameras VALUES ('890ab15d09724f4a8d37e5222faabbae', 'AUDITORIO', '21.112852', '-86.977052', true);
INSERT INTO public.cameras VALUES ('38f298ac86954526bc2bcc1ab28577e8', 'ENTRADA OESTE', '21.112219', '-86.977562', true);
INSERT INTO public.cameras VALUES ('39a145c54eb1465abad3cb22533b7dff', 'PASILLO 2', '21.114124', '-86.977084', true);
INSERT INTO public.cameras VALUES ('d788b69e5ba547b0a419b144db887358', 'ACCESO PLUMA', '21.112503', '-86.977122', true);
INSERT INTO public.cameras VALUES ('c2a636da22334443ba74ab3fe0e20a8b', 'PASILLO GYM', '21.113105', '-86.977106', true);
INSERT INTO public.cameras VALUES ('889559789d884721b6aa875e6bd0e147', 'CANCHAS SUR', '21.112505', '-86.977492', true);
INSERT INTO public.cameras VALUES ('c1f225eab4274152be26fc7a25e1ff08', 'CANCHAS NORTE', '21.114662', '-86.977666', true);
INSERT INTO public.cameras VALUES ('2d1d0a2eb7ec461a9a97e8114ddcee74', 'GYM', '21.113080', '-86.977050', true);
INSERT INTO public.cameras VALUES ('5a0aadaa4e7a4089936be625711b06f5', 'RECEPCION', '21.112525', '-86.977108', true);
INSERT INTO public.cameras VALUES ('a6a31655a1d54169a67cd8b8dfc96440', 'IPCamera 07', '21.113196', '-86.977736', true);
INSERT INTO public.cameras VALUES ('6db64b6e5de34eccbdcd0a8bc21a5854', 'CANCHA PADEL', '21.113402', '-86.977321', true);
INSERT INTO public.cameras VALUES ('42d09028882740b1bc161ea7f9e191f7', 'ACCESO ALBERCA', '21.113776', '-86.977321', true);
INSERT INTO public.cameras VALUES ('943c2505e7b64ba5ad71e4c3f167fee3', 'GYM EJECUTIVO', '21.112440', '-86.977312', true);
INSERT INTO public.cameras VALUES ('0dc3153e0cc24469bb8108c4139e9bd4', 'ACCESO PRINCIPAL', '21.112563', '-86.977197', true);
INSERT INTO public.cameras VALUES ('c40fa11899e34e3fae6aeacca5a4908a', 'OFNA SUPERIOR', '21.112588', '-86.977083', true);
INSERT INTO public.cameras VALUES ('6bfe6aa48515450c9f7f68091918e569', 'Camera 01', '20.909092', '-100.740657', true);
INSERT INTO public.cameras VALUES ('a2741f671fa94287846a7a9c979bd6f6', 'ALMACEN', '21.113686', '-86.977085', true);
INSERT INTO public.cameras VALUES ('3e80a5139d274d559a438c89140b7bdd', 'CUARTOS', '21.114121', '-86.977387', true);
INSERT INTO public.cameras VALUES ('f6d2f055d32c4f51b4b47117838dc04c', 'ENTRADA ESTE', '21.114875', '-86.977141', true);
INSERT INTO public.cameras VALUES ('398f4eb293ee4d15b3c21ff5fb7948a0', 'FRENTE', '21.114254', '-86.977107', true);
INSERT INTO public.cameras VALUES ('1c218f7b23ec4698b593b8b5cac1af7c', 'PERIMETRO', '21.112572', '-86.977183', true);
INSERT INTO public.cameras VALUES ('602eb088062f419b94fdf6658caa8fc2', 'EXT SUP ESTE', '21.115011', '-86.977139', true);
INSERT INTO public.cameras VALUES ('b14c6b78af234a108b45d50081d158a8', 'LAVANDERIA', '21.113580', '-86.977210', true);
INSERT INTO public.cameras VALUES ('1ca41689b40541a4b0f6f705b6cf1c4a', 'CANCHA TENIS', '21.114628', '-86.977822', true);
INSERT INTO public.cameras VALUES ('3a9d67a934d14ff0a61dd19983da0b19', 'PASILLO 1', '21.113802', '-86.977353', true);
INSERT INTO public.cameras VALUES ('ee821c7931ce446fb04721072f01d0b6', 'OFNA INFERIOR', '21.114164', '-86.977135', true);
INSERT INTO public.cameras VALUES ('1522e60c54634735aba394c7cd65bdf9', 'OFICINA DOMO', '21.112581', '-86.977178', true);
INSERT INTO public.cameras VALUES ('c8aa939aa3a7491292034769d0d6057e', 'FONDO', '21.112434', '-86.977246', true);
INSERT INTO public.cameras VALUES ('69d4ccc8e9bc4f33b8adb0589b281808', 'Garage', '20.909147', '-100.740707', true);
INSERT INTO public.cameras VALUES ('ca37f443c8ef43f08b584203c0b67538', 'Jardin', '20.909252', '-100.740658', true);
INSERT INTO public.cameras VALUES ('840b0ad7a68f414495d951b46a32b1e0', 'Terraza', '20.909228', '-100.740561', true);
INSERT INTO public.cameras VALUES ('84a75ef5c6c045d1abd9a5b03e7e0711', 'Entrada Principal', '20.909170', '-100.740494', true);
INSERT INTO public.cameras VALUES ('cfb63f167532422aa4e2abc39f63c4a5', 'Chorro 1', '20.909168', '-100.740531', true);
INSERT INTO public.cameras VALUES ('ce034cdf0abb414f9360ba1007d1b1ee', 'Entrada Lavanderia', '20.909111', '-100.740573', true);
INSERT INTO public.cameras VALUES ('ec698919692c4c7fb2b2adf21415fee7', 'Lavanderia', '20.909144', '-100.740579', true);
INSERT INTO public.cameras VALUES ('d9046bd958c5489290fd1f83f1256a1d', 'Arco', '20.909142', '-100.740647', true);
INSERT INTO public.cameras VALUES ('bd7e4d29f6214aec866cc006ec6aab15', 'Bajada explanada', '20.909104', '-100.740759', true);
INSERT INTO public.cameras VALUES ('3fdd2764612b40e8bc3f99e96675b2e5', 'Pasillo lavanderia', '20.909145', '-100.740545', true);
INSERT INTO public.cameras VALUES ('bed4b0480dfe47fcad769fe3b038b304', 'Entrada explanada', '20.909680', '-100.740873', true);
INSERT INTO public.cameras VALUES ('e4d64a0777b64cc786784ac10907b97c', 'Chorro 2', '20.909288', '-100.740474', true);
INSERT INTO public.cameras VALUES ('aa48fdd97ceb47bba1b68454e9921466', 'Explanada', '20.909828', '-100.740794', true);
INSERT INTO public.cameras VALUES ('fe8e05605d4848e7bf429aed5bc132a7', 'Entrada principal', '20.909105', '-100.740582', true);
INSERT INTO public.cameras VALUES ('bfc3cb059fbe43cb9b0f0a5cce688a3e', 'Puerta Cochera', '20.909085', '-100.740722', true);
INSERT INTO public.cameras VALUES ('c7177453bda64b2199038349c279236d', 'Cochera', '20.909273', '-100.740800', true);
INSERT INTO public.cameras VALUES ('1ae809bb4bcc4d98bbaa2820b7e8018f', 'Vecino', '20.909057', '-100.740633', true);


--
-- TOC entry 5083 (class 0 OID 21614)
-- Dependencies: 261
-- Data for Name: device_downloads; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5070 (class 0 OID 20675)
-- Dependencies: 248
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.devices VALUES ('00D2019B37', 'JEEP SAHARA BLANCO', 'online', '', 'SAHARA', 1, '14', true, 4, true, '2024-12-27 16:43:42.946541', '860369050377736', '2024-12-27 15:21:55.917661', NULL, true);
INSERT INTO public.devices VALUES ('00D2019BB3', 'HM-03 VERSA', 'online', '', 'VERSA', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369050385580', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019CDD', 'HM-06 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369050843265', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019D18', 'CHEROKEE NEGRA', 'online', '', 'CHEROKEE', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051491668', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019D2E', 'HM-05 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369050385507', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019D38', 'PRESIDENCIA CELAYA', 'online', '', 'CHEROKEE', 2, '12', true, 4, true, '2024-12-11 00:00:00', '866901060282433', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019D57', 'HM-08 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051169751', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019D6A', 'HM-01 WRANGLER', 'online', '', 'WRANGLER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051528253', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019D74', 'SPRINTER', 'online', '', '2024', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369050475316', '2024-12-11 15:58:05.296143', NULL, false);
INSERT INTO public.devices VALUES ('00D2019D7F', 'VS-8773 RZR', 'online', '', 'RZR', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051566576', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019EA9', 'SUBURBAN OLIMPO', 'online', '', 'SUBURBAN', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051528303', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019EB1', 'DS-255 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051561403', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2019EBA', 'VS-0067 S10', 'online', '', 'S10', 2, '12', true, 6, true, '2024-12-11 00:00:00', '860369050498961', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2021B99', 'GN-23936', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051514154', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2022361', 'DS-851 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369050901212', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D20254E2', 'GN-18672', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051531372', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2025500', 'GN-24434', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051599114', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2025F17', 'GN-23939', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051514774', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2025FAC', 'GN-21537', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051512323', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D20263D3', 'GN-21545', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051516753', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D20263E7', 'GN-21533', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051539862', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202642E', 'GN-24437', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051599130', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202647F', 'GN-23447', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051514022', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2026F08', 'HM-02 RUBICON', 'online', '', 'RUBICON', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051095774', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2026F0A', 'GN-24431', 'online', '', 'CHARGER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051507737', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2027004', 'HM-04 RZR', 'online', '', 'RZR', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369050384880', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2027037', 'HM-07 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369051077236', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202922E', 'VS-7997 S10', 'online', '', 'S10', 2, '12', true, 3, true, '2024-12-11 00:00:00', '860369052119235', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D2029CEB', 'VS-8118 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052119755', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202A1BF', 'VS-4694 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052176714', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202A1ED', 'VS-8047 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052115217', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202AC51', 'JEEP VS-0393', 'online', '', ' RUBICON', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052144407', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202AC6D', 'DS-079', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052143771', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202AC71', 'JEEP VS-9398', 'online', '', 'WRANGLER', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052144449', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202AC87', 'RZR DS-125', 'online', '', '2016', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052115167', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202AC88', 'RZR DS-157', 'online', '', 'RZD', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052144456', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202AE4C', 'DS-323 S10', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052115324', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202AEDA', 'DS-955', 'online', '', 'S10', 2, '12', true, 4, true, '2024-12-11 00:00:00', '860369052149828', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202A185', 'TEQ-087', 'online', '', 'ISUZU', 3, '12', true, 4, true, '2024-12-11 00:00:00', '869267074833430', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202CF27', 'TEQ-374', 'online', '', 'ISUZU', 3, '12', true, 4, true, '2024-12-11 00:00:00', '869267074830394', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D20291FD', 'TEQ-316', 'online', '', 'ISUZU', 3, '12', true, 4, true, '2024-12-20 16:56:23.16595', '869267074833513', '2024-12-11 12:29:00.803534', NULL, false);
INSERT INTO public.devices VALUES ('00D202923A', 'TEQ-567', 'online', '', 'ISUZU', 3, '12', true, 4, true, '2024-12-20 16:56:27.069752', '869267074808853', '2024-12-11 12:29:00.803534', NULL, false);


--
-- TOC entry 5082 (class 0 OID 21607)
-- Dependencies: 260
-- Data for Name: downloads; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5062 (class 0 OID 20607)
-- Dependencies: 240
-- Data for Name: drones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.drones VALUES (1, 'El Marques', '20.65483789435777', '-100.23658591138923', true);
INSERT INTO public.drones VALUES (2, 'Tequisquiapan Presidencia', '20.51894624480391', '-99.88390862718508', true);
INSERT INTO public.drones VALUES (3, 'Tequisquiapan C4', '20.51425679319526', '-99.90252848083128', true);
INSERT INTO public.drones VALUES (4, 'Okip', '20.951813080049142', '-100.85115352048969', true);
INSERT INTO public.drones VALUES (5, 'Valle de Santiago Linktec', '20.3978572961637', '-101.21191894082146', true);
INSERT INTO public.drones VALUES (6, 'Valle de Santiago Centro', '20.389392856405994', '-101.18087702998326', true);


--
-- TOC entry 5063 (class 0 OID 20616)
-- Dependencies: 241
-- Data for Name: fuel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fuel VALUES (1, 'Magna', true);
INSERT INTO public.fuel VALUES (2, 'Premium', true);
INSERT INTO public.fuel VALUES (3, 'Disel', true);
INSERT INTO public.fuel VALUES (4, 'Eléctrico', true);


--
-- TOC entry 5064 (class 0 OID 20625)
-- Dependencies: 242
-- Data for Name: geofences; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.geofences VALUES (1, 'Guardia Nacional Qro', NULL, '#F44336', 'POLYGON((20.579099242526205 -100.36411583574049, 20.579318996325796 -100.36338054807418, 20.579361192068824 -100.36320047767394, 20.58044458298003 -100.36356525809997, 20.5802612471151 -100.36441356094114))', true);
INSERT INTO public.geofences VALUES (2, 'Guardia Nacional SJR', NULL, '#F44336', 'POLYGON((20.313676238739767 -99.93404961109161, 20.313464945670525 -99.93119501590729, 20.31487302954873 -99.93065857410431, 20.31659300365584 -99.93073367595673, 20.316613126411006 -99.93395305156707, 20.31513965880558 -99.93389404296875))', true);
INSERT INTO public.geofences VALUES (3, 'Valhalla', NULL, '#673AB7', 'POLYGON((20.700245651056743 -100.20357381470501, 20.700968256410956 -100.1949041903764, 20.71024314042437 -100.19357381470502, 20.71024314042437 -100.20357381470501))', true);
INSERT INTO public.geofences VALUES (4, 'Reyno', NULL, '#B71C1C', 'POLYGON((20.689758143792325 -101.40245354538361, 20.69085216231734 -101.4010044277231, 20.69197798708389 -101.40161597137849, 20.69359560011721 -101.40247427826326, 20.69329951866826 -101.40328466778199, 20.692953253189707 -101.4040735996286, 20.691205154862903 -101.40324747925202))', true);
INSERT INTO public.geofences VALUES (5, 'Guardian Nacional Salamanca', NULL, '#F12213', 'POLYGON((20.54066464440502 -101.18186050515511, 20.5380876356407 -101.17924194436411, 20.53825515979388 -101.17890398602823, 20.54047223363789 -101.17747168641428, 20.54144676487339 -101.17849128823617, 20.542642315327985 -101.17970400910714))', true);
INSERT INTO public.geofences VALUES (6, 'Relleno Sanitario Tequisquiapan', NULL, '#F44336', 'POLYGON((20.520034237723834 -99.86532690601823, 20.51847677616909 -99.86298729496478, 20.521603894798805 -99.86094881611346, 20.523060845677424 -99.8633957155275))', true);
INSERT INTO public.geofences VALUES (7, 'Protección Civil Tequisquiapan', NULL, '#F44336', 'POLYGON((20.51386562549772 -99.90458018064498, 20.513821663335456 -99.90465887993574, 20.51368726464679 -99.90464101970196, 20.51346870951807 -99.90462139248848, 20.51337167847733 -99.90458932831883, 20.51323947751051 -99.9044687512517, 20.51307053644147 -99.90437780082226, 20.51291855212346 -99.90423345088959, 20.51329141851434 -99.90342677652836, 20.51334021933583 -99.90280249238015, 20.513500902809472 -99.90233612328768, 20.513674146746716 -99.90195022046566, 20.51375197620437 -99.90181761875749, 20.51376951463975 -99.90136851638556, 20.514106046111642 -99.90103893995285, 20.51437138847795 -99.90137933582066, 20.514596536610416 -99.90168754518032, 20.514987797431058 -99.90226775407791, 20.515178717275944 -99.90258193492889))', true);
INSERT INTO public.geofences VALUES (8, 'Mr. Fierro', NULL, '#3B4FBA', 'POLYGON((19.484007833915815 -98.88642518022594, 19.48387002454081 -98.88621658423483, 19.484055224700896 -98.88608381488856, 19.484213262784426 -98.88595274904307, 19.48429733898203 -98.88609307566223, 19.484343486049305 -98.88616366484699))', true);
INSERT INTO public.geofences VALUES (9, 'Kalmekak', NULL, '#1A237E', 'POLYGON((20.951166758776736 -100.85241912380971, 20.95115673927173 -100.851793806713, 20.95118679778478 -100.85050732509413, 20.95175193147083 -100.85052140669146, 20.95235714072787 -100.85054353491583, 20.952342111589626 -100.85212408081807, 20.951590367502263 -100.85236816183843, 20.951309679276285 -100.85241912380971))', true);
INSERT INTO public.geofences VALUES (10, 'Castillo', NULL, '#D32F2F', 'POLYGON((20.9090764170995 -100.74075185823813, 20.909102099292856 -100.74071479666605, 20.909110242426426 -100.74061604428664, 20.909116506375007 -100.74052716899291, 20.909367809602283 -100.74048894751445, 20.909575264909716 -100.74047620702163, 20.909569000980284 -100.74096643495932))', true);
INSERT INTO public.geofences VALUES (11, 'Acrópolis', NULL, '#B71C1C', 'POLYGON((20.9092366854902 -100.74159765336337, 20.909331897400257 -100.74131931993787, 20.909651609624706 -100.74146013591115, 20.909545749236067 -100.74175992700877, 20.909386519489956 -100.74168683681312))', true);
INSERT INTO public.geofences VALUES (12, 'Catacumbas', NULL, '#8D6E63', 'POLYGON((19.410674010828803 -99.2307055991585, 19.410331228760416 -99.23077792820284, 19.40992773159903 -99.23062495168993, 19.40895882837047 -99.22997567591021, 19.40919156805401 -99.22962662634204, 19.412012103673174 -99.22979828771899, 19.411991865804104 -99.23028144773791, 19.41198680633644 -99.23061976847002, 19.411294993486536 -99.23029790338823))', true);
INSERT INTO public.geofences VALUES (13, 'Asgard', NULL, '#03A9F4', 'POLYGON((21.112024637353397 -86.9777669323803, 21.11262515782131 -86.97652166260492, 21.114978549992504 -86.97712247742426, 21.11466828630855 -86.97787385834467, 21.11429797073963 -86.97862523926507))', true);
INSERT INTO public.geofences VALUES (14, 'Caessa transportes', NULL, '#F44336', 'POLYGON((25.597354150759774 -99.94967262779856, 25.597160634055335 -99.9467536595979, 25.59963291649676 -99.94690386330274, 25.599439403479625 -99.94975845848704))', true);
INSERT INTO public.geofences VALUES (15, 'Rango de vuelo Dron 1 Valle de Santiago', NULL, '#D1C4E9', 'POLYGON((20.39153050356755 -101.27946711063385, 20.384204171036185 -101.27861080408096, 20.37957537861994 -101.27753892064092, 20.374946447280752 -101.27612371444701, 20.370538650265352 -101.27382874369621, 20.36613072733676 -101.27161960363388, 20.36192384720588 -101.26889547944067, 20.357716852431956 -101.26591386318206, 20.352521445482775 -101.26175307512283, 20.347486813744943 -101.25690564155579, 20.342291062717646 -101.2502128481865, 20.337738978514892 -101.24317673206329, 20.33510323532967 -101.23773448467256, 20.332950343049685 -101.23177725315094, 20.332044912107943 -101.22856660366057, 20.33121995930064 -101.22509846210478, 20.330636453438018 -101.22145865917204, 20.33021391333538 -101.21764719486237, 20.330218943581524 -101.21145529270171, 20.330545909227496 -101.20500589847565, 20.331758191204415 -101.19688280582429, 20.3339362507118 -101.18944635868073, 20.33580996095568 -101.18583542346956, 20.33752268830491 -101.1824819803238, 20.33971827137943 -101.17921436786654, 20.34207477887777 -101.17594675540926, 20.34455196520213 -101.17272205829622, 20.34686816136277 -101.17001234531405, 20.349345270839688 -101.16704514026641, 20.351902813262853 -101.16424959659577, 20.355131744393585 -101.16057760715483, 20.35852154649088 -101.15742060184478, 20.36191127417056 -101.15443525791169, 20.365823953342773 -101.15170740604401, 20.369808461940806 -101.1499586057663, 20.37359171443967 -101.1485531282425, 20.37902428236018 -101.14689015865326, 20.384456658939826 -101.14574217319489, 20.388058531229813 -101.14521646022797, 20.391660319366927 -101.14503407001496, 20.39550337324651 -101.14485167980195, 20.39886364313337 -101.14501261234284, 20.403721385166186 -101.1451681804657, 20.408498530906346 -101.145581240654, 20.412913545221556 -101.14616596221924, 20.417811063213357 -101.14739441394806, 20.422136081323867 -101.14854239940644, 20.42646097787828 -101.15054869174958, 20.431167801870185 -101.15375661373139, 20.435432122736454 -101.15739368915558, 20.439977818930988 -101.1618461561203, 20.444081046514867 -101.16625570774079, 20.44731809922733 -101.17015163898468, 20.450394241413445 -101.17443380832673, 20.453389902391123 -101.17914513111114, 20.455621531327257 -101.18441435337066, 20.45823510958155 -101.19302160739898, 20.459682610708484 -101.20158594608307, 20.46040635615578 -101.2089299249649, 20.460808435485976 -101.2164455652237, 20.46015505603976 -101.22360442638396, 20.458938757666697 -101.23041996479033, 20.457079109300246 -101.23740716457365, 20.45393273403509 -101.24396521091461, 20.450444504663306 -101.24942891597749, 20.44631281065307 -101.25403431415558, 20.441658238851325 -101.25919761180877, 20.436842669585136 -101.26367426395416, 20.4305258729462 -101.26893139362335, 20.426281524510202 -101.27186036586761, 20.42203705897793 -101.27410269260406, 20.41612337334453 -101.27608752727508, 20.410289902717025 -101.27764320850372, 20.40461710145972 -101.2786839056015, 20.39805915951501 -101.27929544925689))', true);
INSERT INTO public.geofences VALUES (16, 'Rango de vuelo Dron 2 Valle de Santiago', NULL, '#D1C4E9', 'POLYGON((20.386159195997035 -101.24957389116287, 20.380039639742616 -101.2486413199082, 20.373437072897293 -101.24719376452266, 20.3666483055311 -101.24468489184974, 20.360422518005574 -101.24166103504598, 20.354196479414696 -101.23812219411134, 20.349630285814676 -101.234992723912, 20.34506395724026 -101.23117660820483, 20.341986340377527 -101.22847629144785, 20.3390696209666 -101.22526099056003, 20.336233327341922 -101.22241047009824, 20.333396981678266 -101.21887330412864, 20.33009968802095 -101.21204170644283, 20.32744620843196 -101.20486678600311, 20.32604273826083 -101.20090245842934, 20.32471974217403 -101.19659480810165, 20.324005420191124 -101.19248561859132, 20.323452069908864 -101.1882905983925, 20.323411826174773 -101.18258267641068, 20.323673410259307 -101.17524397134781, 20.32457889021314 -101.167733604908, 20.32695584343663 -101.16056003689766, 20.329493728842642 -101.1539014530182, 20.333177146679486 -101.14728913724423, 20.33734335888907 -101.14102014422417, 20.341589936852973 -101.13457948982716, 20.346319252209863 -101.12934046506882, 20.34916120616261 -101.12718128681183, 20.352043344125423 -101.12485044717789, 20.35662052801467 -101.12171226263047, 20.361117108413882 -101.11874573946, 20.36677061922791 -101.11676090478898, 20.372343460987377 -101.11503356218338, 20.377413979634625 -101.11372464418412, 20.38377163344926 -101.11254447221756, 20.39045233204918 -101.11241572618485, 20.39833947222073 -101.11335986375809, 20.404315644536968 -101.11436837434769, 20.410291584991455 -101.1160635304451, 20.417312997767965 -101.11977570772171, 20.424173220490673 -101.12400286912919, 20.432102768988983 -101.13041234850883, 20.439549348110795 -101.13750847339631, 20.44430828419845 -101.1444909453392, 20.446252280397434 -101.14881266593933, 20.44819625200651 -101.15313438653946, 20.449952967963718 -101.15748629331588, 20.451709663836674 -101.16218152284621, 20.452810415821446 -101.16702295541762, 20.453589482094554 -101.17186438798905, 20.454222784669913 -101.17794236421585, 20.454534408788263 -101.18419200181961, 20.45389356818079 -101.18942903757095, 20.453091885382413 -101.19466607332228, 20.45224998828504 -101.19883022546767, 20.45108640350824 -101.20299437761305, 20.449362371849993 -101.2073744702339, 20.447638320848085 -101.21166873216629, 20.444888846724382 -101.2172289967537, 20.441495917805305 -101.22210261583328, 20.437499705480203 -101.22731955766677, 20.433181668750777 -101.23184985399246, 20.427615306307374 -101.23638278722763, 20.422048742445796 -101.23997158288955, 20.418895126756386 -101.24175793409347, 20.41541968876831 -101.24380177736282, 20.410657105817 -101.24563104391098, 20.40508992864879 -101.24728864908218, 20.399321430594917 -101.24873167753219, 20.393070010251876 -101.2498313832283))', true);
INSERT INTO public.geofences VALUES (17, 'Rango de vuelo Dron 1 Tequisquiapan', NULL, '#D1C4E9', 'POLYGON((20.45191419973171 -99.90529096603393, 20.451672938290113 -99.90278005599976, 20.45171314855668 -99.89770513534546, 20.452215776000784 -99.89147695541381, 20.452477141621817 -99.88816701889039, 20.453288576742473 -99.88405693171546, 20.454783569878224 -99.87814440008253, 20.456687874440014 -99.87271372310818, 20.459772667711427 -99.86610098823905, 20.46220281496974 -99.86188774079085, 20.465977421719256 -99.8572377961874, 20.469988315661656 -99.85343107104302, 20.474713076961862 -99.84959417104722, 20.47853381313476 -99.8467268896103, 20.484566942201475 -99.8433955860138, 20.491808593302487 -99.84050952911377, 20.49921621715096 -99.83834230422974, 20.506152178117052 -99.83675443649292, 20.511180584535015 -99.83581029891968, 20.51665494139151 -99.8353811454773, 20.522169294317663 -99.8359390449524, 20.52685555535318 -99.83681880950928, 20.530484704896043 -99.8376878452301, 20.534147936225448 -99.83906650066376, 20.539114163640978 -99.8415582728386, 20.544088771196652 -99.84460660338402, 20.547942311052328 -99.84741822898388, 20.550913838319147 -99.84985401004553, 20.555453522194234 -99.85450512811542, 20.55804477279781 -99.8570881792158, 20.56151019541165 -99.86095462542028, 20.56360939493963 -99.86353361129761, 20.565300122483283 -99.86641732692718, 20.568999818571893 -99.87179013252259, 20.571577561634665 -99.87772922515869, 20.574161539004262 -99.88359926223755, 20.576436608232136 -99.89104780197142, 20.576968959490998 -99.89736181259156, 20.57706940291653 -99.90466833114624, 20.57692878210232 -99.90911552429198, 20.576587273871173 -99.91253274917602, 20.575974566011755 -99.9169879436493, 20.574317229149298 -99.92251602172851, 20.572499160136296 -99.92752911567688, 20.570568065882977 -99.93162553071976, 20.56835568990941 -99.93555028438567, 20.565963726359364 -99.93931510567663, 20.563411001620615 -99.94307992696761, 20.56137117688493 -99.94608886539936, 20.559170596724975 -99.94875448107719, 20.55629990638473 -99.95188315287231, 20.55302732580861 -99.95544097810983, 20.550035966689872 -99.95811903879047, 20.546883807915602 -99.96045377671717, 20.543309629229576 -99.96270268395541, 20.53869049682168 -99.96512325257062, 20.532343102531296 -99.967393617481, 20.525471786284108 -99.96895795337855, 20.521413626631112 -99.96962106704711, 20.518511797623457 -99.96992147445678, 20.515609913611733 -99.96996438980102, 20.512189437501583 -99.97013605117797, 20.508527712951206 -99.96970689773559, 20.50452622643536 -99.96918118476867, 20.50052463540566 -99.9681404876709, 20.49449290110352 -99.96613419532775, 20.48996944335588 -99.96401525020599, 20.484270454700198 -99.96119624853134, 20.478513836209807 -99.95706899940967, 20.47340027637956 -99.95225510478019, 20.46748242560556 -99.94555293500423, 20.46215118878712 -99.93786740034818, 20.460384081346586 -99.934712661542, 20.458737578886797 -99.93151500739157, 20.457151372043775 -99.927931115143, 20.456087868219885 -99.92511969909071, 20.455044461728587 -99.92196496028453, 20.45416188671563 -99.91812357597053, 20.453207922319656 -99.91279111394658, 20.45233437221835 -99.90827404346317))', true);
INSERT INTO public.geofences VALUES (18, 'Rango de vuelo Dron 1 San Miguel de Allende', NULL, '#C5CAE9', 'POLYGON((20.893324375630783 -100.82206933677196, 20.88771118207259 -100.82039527595043, 20.88410258967467 -100.81903798758984, 20.880493910558762 -100.81750903785229, 20.87732622076599 -100.81602300345897, 20.87333644047415 -100.81326296508313, 20.86755207337681 -100.80832097232341, 20.863998136042227 -100.80482000768185, 20.862247452664803 -100.80285042524336, 20.860496748900736 -100.80075209677219, 20.85822468849616 -100.79764525771141, 20.856393417914006 -100.79501245930791, 20.854562125031965 -100.79225091487169, 20.8532955591264 -100.79014594621957, 20.852049034809248 -100.78804097756742, 20.851185140556552 -100.78639304284007, 20.85028113637141 -100.78463781975209, 20.849206679483007 -100.78198673885315, 20.84841377597977 -100.77974388292057, 20.847578872860794 -100.77696498208213, 20.84684422987384 -100.77405733521095, 20.846426774538678 -100.77123022075975, 20.84599929151615 -100.76832800445611, 20.84571444944104 -100.76563907338131, 20.84554992558772 -100.76307888833922, 20.8454856672249 -100.75972476942873, 20.845461515101217 -100.75649939655094, 20.845533529616382 -100.7518940105976, 20.846126924090584 -100.74690238654614, 20.846990306064733 -100.74250490486622, 20.848094316633667 -100.7381074231863, 20.84947905569552 -100.73353828012944, 20.851064305983645 -100.72888330638409, 20.852830009010646 -100.72409958660603, 20.85515714382818 -100.71923003613949, 20.85760455175702 -100.71500421583653, 20.860292533888288 -100.71116463363171, 20.862939551107527 -100.7079708826521, 20.8658271268959 -100.70524920045915, 20.867932694006615 -100.70334290980672, 20.870078331321334 -100.7014795344985, 20.87367019711342 -100.69906669750033, 20.87726197704067 -100.69701864092818, 20.880943888909563 -100.69503495737237, 20.884745997911544 -100.69330876588201, 20.892359950538502 -100.691068741376, 20.90017397540254 -100.68951536237779, 20.905043006945547 -100.68922147050138, 20.90971143502566 -100.68935673206732, 20.91379844264197 -100.68966365501025, 20.91788533885508 -100.69009932398588, 20.9202043387834 -100.69074094749804, 20.92252330283285 -100.69135038450204, 20.92469191193123 -100.69201346568634, 20.92717114439295 -100.69283747941152, 20.931381444018232 -100.69447688467721, 20.935431296468145 -100.69620212063141, 20.939350029489017 -100.69833610568158, 20.943268659954377 -100.70072758279716, 20.94735946923187 -100.70435903047189, 20.951209698852317 -100.70833380090055, 20.95499971393391 -100.71233002900132, 20.958549176953884 -100.71660520683962, 20.961096675139842 -100.72029029869465, 20.96348383114536 -100.72425434028725, 20.965328602427174 -100.72833921295123, 20.96677261311105 -100.73250991630366, 20.967604815704135 -100.73616167804458, 20.96823664657327 -100.73955594772006, 20.968880493093764 -100.74332275854714, 20.96944419061989 -100.74708956937421, 20.969807521034046 -100.75128553364367, 20.97001055877213 -100.75505234447076, 20.970073340965108 -100.75873332460935, 20.970055977238093 -100.76215681268252, 20.96999854054147 -100.76562321609993, 20.969620519572224 -100.76891795814038, 20.968536038065952 -100.77281261622905, 20.967331327677755 -100.77670727431774, 20.966006385501995 -100.78075213611126, 20.964481059461274 -100.78466825187206, 20.96293568043004 -100.78804792582987, 20.961189908895154 -100.791298853755, 20.959504230672763 -100.79461415469646, 20.95725746508308 -100.7977792519331, 20.953691820571475 -100.80183475196361, 20.949153590958144 -100.80625503242015, 20.943808316975325 -100.810728957057, 20.94001201714799 -100.81334679305553, 20.936576358826027 -100.8156642216444, 20.93176777796126 -100.81801920115947, 20.9285313554765 -100.81945552408695, 20.925254778127062 -100.82076310098171, 20.92093589389729 -100.8221135932207, 20.91658907630318 -100.82305203109979, 20.912242132666464 -100.82373297691345, 20.90937837074938 -100.8239633116126, 20.904528793402594 -100.82375661388039, 20.897984524294255 -100.82309536553919))', true);
INSERT INTO public.geofences VALUES (19, 'FRIGORIFICOS', NULL, '#F44336', 'POLYGON((19.35008968291608 -99.07320467816929, 19.349522806152486 -99.07200232373816, 19.35294313664374 -99.07131567823035, 19.353489756382235 -99.07228199826817))', true);
INSERT INTO public.geofences VALUES (20, 'Rango de vuelo Dron 1 Okip', NULL, '#C5CAE9', 'POLYGON((20.89676649673713 -100.8885619688034, 20.893889827231085 -100.88243025779724, 20.891414043128005 -100.87591230869293, 20.890055852722295 -100.87207397699356, 20.88877783945877 -100.8676777458191, 20.88783373149721 -100.86236997812986, 20.88737075933199 -100.856590141654, 20.88726864213992 -100.85055281311271, 20.887567475690293 -100.84477297663688, 20.88902905763093 -100.83840305417775, 20.89081137897558 -100.83168980896471, 20.892794147451344 -100.82581341296434, 20.895137727220412 -100.82015159368514, 20.89709632041206 -100.81654284343124, 20.899255347703104 -100.81314866989851, 20.90385394408578 -100.80739029109478, 20.908733025375142 -100.80188940435647, 20.914213267758637 -100.79668892502785, 20.917334141516516 -100.79431399092078, 20.920454950302982 -100.79249695628882, 20.92429722964045 -100.79050826027988, 20.927898905172345 -100.78929204046726, 20.93446067799455 -100.78750333100558, 20.940781678743555 -100.78665875911713, 20.942881044653895 -100.7863100719452, 20.94510062010278 -100.78604721546174, 20.947593126538056 -100.78587287187577, 20.95008559146536 -100.78584873199463, 20.95231750998871 -100.78595333814621, 20.954589472328692 -100.78616523265839, 20.95781564425473 -100.78645509243012, 20.96103172776035 -100.78695952892303, 20.96328595067617 -100.78731367111205, 20.96554013961306 -100.7877965593338, 20.96854316741586 -100.7884725213051, 20.97140588088083 -100.78927722930908, 20.975436879199574 -100.79102605223656, 20.979107134455493 -100.79298945188522, 20.98269716044745 -100.79504941105841, 20.985714243235023 -100.7973239356279, 20.988474892593434 -100.79948043733835, 20.99132368586225 -100.80189174465835, 20.992748062117066 -100.8031403136626, 20.994092291784153 -100.80443179801105, 20.996458192683097 -100.80731115009634, 20.99864376239464 -100.81019050218164, 21.00003201430442 -100.81211297584696, 21.00130005962154 -100.81405690718442, 21.003174568239945 -100.81736725611145, 21.004808671700232 -100.82084926641545, 21.006402694064928 -100.82439564973582, 21.007836448200774 -100.82777037167921, 21.009224367629148 -100.83171615264143, 21.010291777192474 -100.83557610291521, 21.011359179118426 -100.8393502225005, 21.012186203679725 -100.84303851139732, 21.012569668081117 -100.84825151036843, 21.012792885620886 -100.85312118658564, 21.012735672549297 -100.85730421729501, 21.0123579669418 -100.86062894111964, 21.01118259218877 -100.86608394657901, 21.00994711480459 -100.87117417161237, 21.00839112615219 -100.87583524320331, 21.006614774112062 -100.88021736505672, 21.004881140761153 -100.88347207377706, 21.00306735908659 -100.8865980364647, 21.00129361995109 -100.88950942243115, 20.999479794676045 -100.8923349777091, 20.99738548823314 -100.89503178695433, 20.995331218592018 -100.89738527344566, 20.993156720446986 -100.8999747943303, 20.990621584089126 -100.90260723055921, 20.987775876421917 -100.90541132816506, 20.986924201579082 -100.9061284458206, 20.986172693502898 -100.90684556347615, 20.984449286130822 -100.90825834111513, 20.98152332112395 -100.91061182760646, 20.977956166757156 -100.91270782203236, 20.974449034917406 -100.91467507042556, 20.970460947364895 -100.91629899606485, 20.96561116169705 -100.91779417567143, 20.96329663860911 -100.91852202216303, 20.960861853482488 -100.9190782072777, 20.95598236823247 -100.92009573234293, 20.953081675314877 -100.92052939302312, 20.950958776979043 -100.92072363888165, 20.948715612549158 -100.92078913870745, 20.945119732823574 -100.92059714646783, 20.941558224921422 -100.91996470854504, 20.938122680371546 -100.91922724191711, 20.93455547987642 -100.91819908089268, 20.931572021272228 -100.91723732453045, 20.9276566876367 -100.91580304847253, 20.92354082474944 -100.91428294172613, 20.91956515154967 -100.91235513920947, 20.91742694904806 -100.91116593239389, 20.915268672236145 -100.90978360652923, 20.91231704298498 -100.9072569656372, 20.90936535563098 -100.90438700199127, 20.9075049172892 -100.90248933911323, 20.90548409499125 -100.90042001485824, 20.903483290857277 -100.89805028319358, 20.901522551342744 -100.8954230594635, 20.89904431301234 -100.892271463871))', true);
INSERT INTO public.geofences VALUES (21, 'Aztlán', NULL, '#F44336', 'POLYGON((19.413783574821736 -105.00764285342021, 19.413662148892556 -105.00630638853832, 19.415369819145074 -105.00601670996471, 19.41559243094095 -105.00720297114177))', true);


--
-- TOC entry 5079 (class 0 OID 21160)
-- Dependencies: 257
-- Data for Name: group_device; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.group_device VALUES (1, '00D2019EA9');
INSERT INTO public.group_device VALUES (1, '00D2019D18');
INSERT INTO public.group_device VALUES (2, '00D2025500');
INSERT INTO public.group_device VALUES (2, '00D20254E2');
INSERT INTO public.group_device VALUES (2, '00D2026F0A');
INSERT INTO public.group_device VALUES (2, '00D2025FAC');
INSERT INTO public.group_device VALUES (2, '00D20263D3');
INSERT INTO public.group_device VALUES (2, '00D2021B99');
INSERT INTO public.group_device VALUES (2, '00D202647F');
INSERT INTO public.group_device VALUES (2, '00D202642E');
INSERT INTO public.group_device VALUES (2, '00D20263E7');
INSERT INTO public.group_device VALUES (2, '00D2025F17');
INSERT INTO public.group_device VALUES (3, '00D2027004');
INSERT INTO public.group_device VALUES (3, '00D2027037');
INSERT INTO public.group_device VALUES (3, '00D2026F08');
INSERT INTO public.group_device VALUES (3, '00D2019BB3');
INSERT INTO public.group_device VALUES (3, '00D2019CDD');
INSERT INTO public.group_device VALUES (3, '00D2019D2E');
INSERT INTO public.group_device VALUES (3, '00D2019D57');
INSERT INTO public.group_device VALUES (3, '00D2019D6A');
INSERT INTO public.group_device VALUES (4, '00D202A1BF');
INSERT INTO public.group_device VALUES (4, '00D2019D7F');
INSERT INTO public.group_device VALUES (4, '00D202AC51');
INSERT INTO public.group_device VALUES (4, '00D202AC71');
INSERT INTO public.group_device VALUES (4, '00D202922E');
INSERT INTO public.group_device VALUES (4, '00D2019EBA');
INSERT INTO public.group_device VALUES (4, '00D2029CEB');
INSERT INTO public.group_device VALUES (5, '00D2019D38');
INSERT INTO public.group_device VALUES (6, '00D202A1ED');
INSERT INTO public.group_device VALUES (6, '00D202AE4C');
INSERT INTO public.group_device VALUES (6, '00D2019EB1');
INSERT INTO public.group_device VALUES (6, '00D202AC6D');
INSERT INTO public.group_device VALUES (6, '00D202AEDA');
INSERT INTO public.group_device VALUES (6, '00D202AC87');
INSERT INTO public.group_device VALUES (6, '00D202AC88');
INSERT INTO public.group_device VALUES (6, '00D2022361');
INSERT INTO public.group_device VALUES (1, '00D2019D74');
INSERT INTO public.group_device VALUES (7, '00D202A185');
INSERT INTO public.group_device VALUES (7, '00D202CF27');
INSERT INTO public.group_device VALUES (7, '00D20291FD');
INSERT INTO public.group_device VALUES (7, '00D202923A');
INSERT INTO public.group_device VALUES (1, '00D2019B37');


--
-- TOC entry 5065 (class 0 OID 20634)
-- Dependencies: 243
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.groups VALUES (1, 'Vehiculos Okip', true, '2024-12-27 00:00:00-06', '2024-12-27 00:00:00-06');
INSERT INTO public.groups VALUES (2, 'Guardia Nacional', true, '2024-12-27 00:00:00-06', '2024-12-27 00:00:00-06');
INSERT INTO public.groups VALUES (3, 'Vehiculos Tequisquiapan', true, '2024-12-27 00:00:00-06', '2024-12-27 00:00:00-06');
INSERT INTO public.groups VALUES (5, 'Presidencia Celaya', true, '2024-12-27 00:00:00-06', '2024-12-27 00:00:00-06');
INSERT INTO public.groups VALUES (6, 'Vehiculos Salvatierra', true, '2024-12-27 00:00:00-06', '2024-12-27 00:00:00-06');
INSERT INTO public.groups VALUES (7, 'Servicio Publico Tequisquiapan', true, '2024-12-27 00:00:00-06', '2024-12-27 00:00:00-06');
INSERT INTO public.groups VALUES (4, 'Vehiculos Valle de Santiago', true, '2024-12-27 00:00:00-06', '2024-12-27 13:14:45.326173-06');


--
-- TOC entry 5081 (class 0 OID 21527)
-- Dependencies: 259
-- Data for Name: licences; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.licences VALUES (1, 'Silver');
INSERT INTO public.licences VALUES (2, 'Gold');
INSERT INTO public.licences VALUES (3, 'Platinum');
INSERT INTO public.licences VALUES (4, 'VIP');


--
-- TOC entry 5066 (class 0 OID 20643)
-- Dependencies: 244
-- Data for Name: nvr; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nvr VALUES (1, 'Casa de Quino (Valhalla)', 'bf48adbd98bcd1a631b5b61c4df497bf:59a60d86e4e60af08f1a1adf96fd8bf9662189009d8d62f57860e996ea7dc768560fb4a8412af367d9c488ae8cb1948c', '06e5a0f3d6ca5b729cb02e4d79416780:1a11b38b9825103f3cdc5578687c46aff85e1541b836764109cdf067e2f3f1af2117e1d4891da619354e706bbcbf1ff4', 'EmvyG8', 'hcc.zl3awvprionbgpklp75swr7ohq6a5e9u', '1736266168357', 'at.8opc6j3dcfufx9wr1ug3mdly11y4lhq6-9rjhe2g17p-0aftelx-8sjpvjnbe', 'Carretera La Griega - El Lobo, km 4 CP 76249', 'El Marques, Querétaro', 'Hikvision', '4151010141', '2025-01-02 09:07:34.196454', true, '2024-12-10 15:03:10.141495');
INSERT INTO public.nvr VALUES (2, 'Casa Chorro (Castillo)', 'e2edeeb9b00219fd1c2eb5d6a78d8b6f:85c21efef6c458c8f9e8c9a25b517a0276bf23dc27e000a6de957be8d368b92670a23a99b33eec7fe2a73e572929214d', 'af41c6630b8d8fd85871f607014903d4:ed082c746b5f1b4589841c56d0c822e94c1ca1cba54ab657f0826f29bad13ca1ad6c6d4eebf5b296eca595252f6f2daf', '', 'hcc.remhrcyjqmwuluyb92aythzwiugnmtz0', '1736198774336', 'at.5fju3r0r2zx7l3p95mco6ref5ose3eie-7zqii1s6rk-1psr7x3-ftr3upuis', 'Calle Chorro # 39 Zona Centro CP 37700', 'San Miguel de Allende, Gto.', 'Hikvision', '4151010141', '2025-01-02 09:07:35.333656', true, '2024-12-10 15:03:10.141495');
INSERT INTO public.nvr VALUES (3, 'Cancun (Asgard)', '875481a4cb0820508b34a7a4d05a81df:bc61b84d8b9926d01b50798cbba64504505979dc12211c32e463c442ecc7b175bf4778cbc955e17e353a7d82a522be70', '9eda7776d28db0ca213c6316f0d47bbc:7ef345437722f257bc7094c3337d943434772fa6c926435146551162b6c268602dc102fa183ab3f6e57c07ddb70c3f8a', '2prX0A', 'hcc.57v4cvv8levvwaw3odw7049tre2wa2r0', '1736281408817', 'at.bt1xjbm669a0rtnc2i8co9wgbpilt8hp-6m3zfdo9wx-0qcwa66-yvfdgz5qi', 'Supermanzana # 131, Manzana 6, Lotes 299, 301, 303 Lanas de la Calle 89', 'Cancun, Benito Juarez, Quintana Roo', 'Hikvision', '4151010141', '2025-01-02 09:07:36.167636', true, '2024-12-10 15:03:10.141495');


--
-- TOC entry 5067 (class 0 OID 20653)
-- Dependencies: 245
-- Data for Name: nvr_camera; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nvr_camera VALUES (1, 'aa921ea0c77f41a5b97319db69796a37');
INSERT INTO public.nvr_camera VALUES (1, '7b9ba844aa324e78acb569ef88d4d6a6');
INSERT INTO public.nvr_camera VALUES (1, '86c0cf57bb1d4b42b42e0a0e90bf6b0d');
INSERT INTO public.nvr_camera VALUES (1, '5eb091732eb143ebbe75aa70101139b9');
INSERT INTO public.nvr_camera VALUES (1, 'bdde2a54f54b4691b782644ea07244e8');
INSERT INTO public.nvr_camera VALUES (1, '8c968aaed44846ca82718b4f81a1b328');
INSERT INTO public.nvr_camera VALUES (1, 'ba5b524f863f412190050c9b4847dd02');
INSERT INTO public.nvr_camera VALUES (1, 'ee1b24b46352490f8aeed7179968bcbf');
INSERT INTO public.nvr_camera VALUES (1, '0fd691f8db1a4bafa8e71a08438f0ea4');
INSERT INTO public.nvr_camera VALUES (1, '02e2d54677614f77941cfe59c10320a7');
INSERT INTO public.nvr_camera VALUES (1, '5a7886a367d64811b21fb1bc0fb383f7');
INSERT INTO public.nvr_camera VALUES (1, '985c95b90152465cab098413cfe4880d');
INSERT INTO public.nvr_camera VALUES (1, '12d19145d02b4f3591edf85bbca9e998');
INSERT INTO public.nvr_camera VALUES (1, 'aa83900f8e68475c821e79e41c3bf3d0');
INSERT INTO public.nvr_camera VALUES (1, '760a0e5e2a434ba6a7fff693ba0ae500');
INSERT INTO public.nvr_camera VALUES (1, '6aed8e6908684bacb7f0254c136b3efb');
INSERT INTO public.nvr_camera VALUES (1, 'caf02dfb133348b29d887b14ba455145');
INSERT INTO public.nvr_camera VALUES (1, '5f97329c3d0c4f6fa2ae3ff682e667dc');
INSERT INTO public.nvr_camera VALUES (1, '7a838321ba4a494db359530855afac08');
INSERT INTO public.nvr_camera VALUES (1, '05fd8aa973884433b3d22582b3b86cd0');
INSERT INTO public.nvr_camera VALUES (1, '8d18f97c211e416da74dd694f2b0d704');
INSERT INTO public.nvr_camera VALUES (1, '50aaf3f914cc42629399e0a33473db2d');
INSERT INTO public.nvr_camera VALUES (3, '1e55c2d326cd4a7c9fb1ec130aff1296');
INSERT INTO public.nvr_camera VALUES (3, 'eea1353bcf2147dba7035cdfa407834e');
INSERT INTO public.nvr_camera VALUES (3, '4be0179a25bf43fc8468856f886cc4a8');
INSERT INTO public.nvr_camera VALUES (3, '5695737947fb40719b65ab4a8b4552c4');
INSERT INTO public.nvr_camera VALUES (3, '890ab15d09724f4a8d37e5222faabbae');
INSERT INTO public.nvr_camera VALUES (3, '38f298ac86954526bc2bcc1ab28577e8');
INSERT INTO public.nvr_camera VALUES (3, '39a145c54eb1465abad3cb22533b7dff');
INSERT INTO public.nvr_camera VALUES (3, 'd788b69e5ba547b0a419b144db887358');
INSERT INTO public.nvr_camera VALUES (3, 'c2a636da22334443ba74ab3fe0e20a8b');
INSERT INTO public.nvr_camera VALUES (3, '889559789d884721b6aa875e6bd0e147');
INSERT INTO public.nvr_camera VALUES (3, 'c1f225eab4274152be26fc7a25e1ff08');
INSERT INTO public.nvr_camera VALUES (3, '2d1d0a2eb7ec461a9a97e8114ddcee74');
INSERT INTO public.nvr_camera VALUES (3, '5a0aadaa4e7a4089936be625711b06f5');
INSERT INTO public.nvr_camera VALUES (3, 'a6a31655a1d54169a67cd8b8dfc96440');
INSERT INTO public.nvr_camera VALUES (3, '6db64b6e5de34eccbdcd0a8bc21a5854');
INSERT INTO public.nvr_camera VALUES (3, '42d09028882740b1bc161ea7f9e191f7');
INSERT INTO public.nvr_camera VALUES (3, '943c2505e7b64ba5ad71e4c3f167fee3');
INSERT INTO public.nvr_camera VALUES (3, '0dc3153e0cc24469bb8108c4139e9bd4');
INSERT INTO public.nvr_camera VALUES (3, 'c40fa11899e34e3fae6aeacca5a4908a');
INSERT INTO public.nvr_camera VALUES (3, '6bfe6aa48515450c9f7f68091918e569');
INSERT INTO public.nvr_camera VALUES (3, 'a2741f671fa94287846a7a9c979bd6f6');
INSERT INTO public.nvr_camera VALUES (3, '3e80a5139d274d559a438c89140b7bdd');
INSERT INTO public.nvr_camera VALUES (3, 'f6d2f055d32c4f51b4b47117838dc04c');
INSERT INTO public.nvr_camera VALUES (3, '398f4eb293ee4d15b3c21ff5fb7948a0');
INSERT INTO public.nvr_camera VALUES (3, '1c218f7b23ec4698b593b8b5cac1af7c');
INSERT INTO public.nvr_camera VALUES (3, '602eb088062f419b94fdf6658caa8fc2');
INSERT INTO public.nvr_camera VALUES (3, 'b14c6b78af234a108b45d50081d158a8');
INSERT INTO public.nvr_camera VALUES (3, '1ca41689b40541a4b0f6f705b6cf1c4a');
INSERT INTO public.nvr_camera VALUES (3, '3a9d67a934d14ff0a61dd19983da0b19');
INSERT INTO public.nvr_camera VALUES (3, 'ee821c7931ce446fb04721072f01d0b6');
INSERT INTO public.nvr_camera VALUES (3, '1522e60c54634735aba394c7cd65bdf9');
INSERT INTO public.nvr_camera VALUES (3, 'c8aa939aa3a7491292034769d0d6057e');
INSERT INTO public.nvr_camera VALUES (2, '69d4ccc8e9bc4f33b8adb0589b281808');
INSERT INTO public.nvr_camera VALUES (2, 'ca37f443c8ef43f08b584203c0b67538');
INSERT INTO public.nvr_camera VALUES (2, '840b0ad7a68f414495d951b46a32b1e0');
INSERT INTO public.nvr_camera VALUES (2, '84a75ef5c6c045d1abd9a5b03e7e0711');
INSERT INTO public.nvr_camera VALUES (2, 'cfb63f167532422aa4e2abc39f63c4a5');
INSERT INTO public.nvr_camera VALUES (2, 'ce034cdf0abb414f9360ba1007d1b1ee');
INSERT INTO public.nvr_camera VALUES (2, 'ec698919692c4c7fb2b2adf21415fee7');
INSERT INTO public.nvr_camera VALUES (2, 'd9046bd958c5489290fd1f83f1256a1d');
INSERT INTO public.nvr_camera VALUES (2, 'bd7e4d29f6214aec866cc006ec6aab15');
INSERT INTO public.nvr_camera VALUES (2, '3fdd2764612b40e8bc3f99e96675b2e5');
INSERT INTO public.nvr_camera VALUES (2, 'bed4b0480dfe47fcad769fe3b038b304');
INSERT INTO public.nvr_camera VALUES (2, 'e4d64a0777b64cc786784ac10907b97c');
INSERT INTO public.nvr_camera VALUES (2, 'aa48fdd97ceb47bba1b68454e9921466');
INSERT INTO public.nvr_camera VALUES (2, 'fe8e05605d4848e7bf429aed5bc132a7');
INSERT INTO public.nvr_camera VALUES (2, 'bfc3cb059fbe43cb9b0f0a5cce688a3e');
INSERT INTO public.nvr_camera VALUES (2, 'c7177453bda64b2199038349c279236d');
INSERT INTO public.nvr_camera VALUES (2, '1ae809bb4bcc4d98bbaa2820b7e8018f');


--
-- TOC entry 5068 (class 0 OID 20658)
-- Dependencies: 246
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.profiles VALUES (1, 'Admin', true);
INSERT INTO public.profiles VALUES (2, 'Owner', true);
INSERT INTO public.profiles VALUES (3, 'Capturist', true);
INSERT INTO public.profiles VALUES (4, 'Monitorist', true);
INSERT INTO public.profiles VALUES (5, 'Client', true);


--
-- TOC entry 5071 (class 0 OID 20684)
-- Dependencies: 249
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5085 (class 0 OID 21630)
-- Dependencies: 263
-- Data for Name: status_download; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.status_download VALUES (-6, 'Pause');
INSERT INTO public.status_download VALUES (-5, 'Limited number of connections');
INSERT INTO public.status_download VALUES (-4, 'In resolution');
INSERT INTO public.status_download VALUES (-3, 'Not complete');
INSERT INTO public.status_download VALUES (-2, 'Insufficient disk space');
INSERT INTO public.status_download VALUES (-1, 'Waiting for');
INSERT INTO public.status_download VALUES (0, 'Resolution to complete');
INSERT INTO public.status_download VALUES (1, 'Downloading');
INSERT INTO public.status_download VALUES (2, 'No video files');
INSERT INTO public.status_download VALUES (3, 'Task completed');
INSERT INTO public.status_download VALUES (4, 'Task failed');
INSERT INTO public.status_download VALUES (5, 'Deletion');
INSERT INTO public.status_download VALUES (6, 'Download failed');
INSERT INTO public.status_download VALUES (8, 'Task expired');


--
-- TOC entry 5072 (class 0 OID 20692)
-- Dependencies: 250
-- Data for Name: summary; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5073 (class 0 OID 20705)
-- Dependencies: 251
-- Data for Name: user_drone; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_drone VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 1);
INSERT INTO public.user_drone VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 2);
INSERT INTO public.user_drone VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 3);
INSERT INTO public.user_drone VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 4);
INSERT INTO public.user_drone VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 5);
INSERT INTO public.user_drone VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 6);


--
-- TOC entry 5074 (class 0 OID 20710)
-- Dependencies: 252
-- Data for Name: user_geofence; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 1);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 2);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 3);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 4);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 5);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 6);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 7);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 8);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 9);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 10);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 11);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 12);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 13);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 14);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 15);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 16);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 17);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 18);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 19);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 20);
INSERT INTO public.user_geofence VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 21);


--
-- TOC entry 5078 (class 0 OID 21137)
-- Dependencies: 256
-- Data for Name: user_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_group VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 1);
INSERT INTO public.user_group VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 2);
INSERT INTO public.user_group VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 3);
INSERT INTO public.user_group VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 4);
INSERT INTO public.user_group VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 5);
INSERT INTO public.user_group VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 6);
INSERT INTO public.user_group VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 7);


--
-- TOC entry 5075 (class 0 OID 20715)
-- Dependencies: 253
-- Data for Name: user_nvr; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_nvr VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 1);
INSERT INTO public.user_nvr VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 2);
INSERT INTO public.user_nvr VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 3);


--
-- TOC entry 5076 (class 0 OID 20720)
-- Dependencies: 254
-- Data for Name: user_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_profile VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 1);
INSERT INTO public.user_profile VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 2);
INSERT INTO public.user_profile VALUES ('31f26520-6b64-449c-8de4-f9343db8c1fe', 1);
INSERT INTO public.user_profile VALUES ('31f26520-6b64-449c-8de4-f9343db8c1fe', 2);
INSERT INTO public.user_profile VALUES ('db74b852-2521-4359-8e52-56c30915a94c', 1);
INSERT INTO public.user_profile VALUES ('db74b852-2521-4359-8e52-56c30915a94c', 2);


--
-- TOC entry 5069 (class 0 OID 20667)
-- Dependencies: 247
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES ('642b27e6-c176-4983-bb05-d7d5d239eadf', 'Administrador', 'Okip', 'admin.covia@gmail.com', '$2b$10$lwh6jAImCJHt72hXDLISF.j43QMIg5RrcQMZudfblB/ogK43UMmB.', '4151684208', '2024-12-31', true, '2024-12-31 12:07:14.534422', '2024-12-31 11:56:31.555209', NULL);
INSERT INTO public.users VALUES ('31f26520-6b64-449c-8de4-f9343db8c1fe', 'Eduardo', 'Navarro', 'eduardx62@gmail.com', '$2b$10$L8gd6tid/gOx0RwtsXLmYeOiUeWI3q0WycoJKgXNTCS/cpiictv32', '4151684208', '2001-08-18', true, '2024-12-31 12:28:05.225625', '2024-12-31 12:28:05.225625', NULL);
INSERT INTO public.users VALUES ('db74b852-2521-4359-8e52-56c30915a94c', 'Angel', 'Diaz', 'angeltj27@gmail.com', '$2b$10$E4OFsHpdKZ3W9XvQXLtxBe60icHQcxXGtoQVOXDNf5gegYTxHlu1O', '4151036598', '2001-04-25', true, '2024-12-31 12:31:39.080701', '2024-12-31 12:31:39.080701', NULL);


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 217
-- Name: alert_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_type_id_seq', 1, false);


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 218
-- Name: alert_type_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_type_id_seq1', 1, false);


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 219
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq', 1, false);


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 220
-- Name: alerts_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq1', 1, false);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 221
-- Name: cameras_devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cameras_devices_id_seq', 1, false);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 222
-- Name: cameras_devices_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cameras_devices_id_seq1', 1, false);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 239
-- Name: drones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.drones_id_seq', 6, true);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 223
-- Name: fuel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fuel_id_seq', 1, false);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 224
-- Name: fuel_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fuel_id_seq1', 1, false);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 225
-- Name: geofences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geofences_id_seq', 1, false);


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 226
-- Name: geofences_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geofences_id_seq1', 1, false);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 227
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 1, false);


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 228
-- Name: groups_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq1', 14, true);


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 258
-- Name: licences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.licences_id_seq', 4, true);


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 229
-- Name: nvr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nvr_id_seq', 1, false);


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 230
-- Name: nvr_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nvr_id_seq1', 1, false);


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 231
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 1, false);


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 232
-- Name: profiles_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq1', 1, false);


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 233
-- Name: routes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routes_id_seq', 1, false);


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 234
-- Name: routes_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routes_id_seq1', 1, false);


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 262
-- Name: status_download_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_download_id_seq', 1, false);


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 235
-- Name: summary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.summary_id_seq', 1, false);


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 236
-- Name: summary_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.summary_id_seq1', 1, false);


--
-- TOC entry 4840 (class 2606 OID 20597)
-- Name: alert_type pk_alert_type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_type
    ADD CONSTRAINT pk_alert_type PRIMARY KEY (id);


--
-- TOC entry 4864 (class 2606 OID 21496)
-- Name: alerts pk_alerts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT pk_alerts PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 20605)
-- Name: cameras pk_camera; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT pk_camera PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2606 OID 20683)
-- Name: devices pk_device; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT pk_device PRIMARY KEY (id);


--
-- TOC entry 4868 (class 2606 OID 21613)
-- Name: downloads pk_downloads; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT pk_downloads PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 20615)
-- Name: drones pk_drones; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drones
    ADD CONSTRAINT pk_drones PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 20624)
-- Name: fuel pk_fuel; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fuel
    ADD CONSTRAINT pk_fuel PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 20633)
-- Name: geofences pk_geofences; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geofences
    ADD CONSTRAINT pk_geofences PRIMARY KEY (id);


--
-- TOC entry 4850 (class 2606 OID 20642)
-- Name: groups pk_groups; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT pk_groups PRIMARY KEY (id);


--
-- TOC entry 4866 (class 2606 OID 21534)
-- Name: licences pk_licences; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.licences
    ADD CONSTRAINT pk_licences PRIMARY KEY (id);


--
-- TOC entry 4852 (class 2606 OID 20652)
-- Name: nvr pk_nvr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr
    ADD CONSTRAINT pk_nvr PRIMARY KEY (id);


--
-- TOC entry 4854 (class 2606 OID 20666)
-- Name: profiles pk_profiles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT pk_profiles PRIMARY KEY (id);


--
-- TOC entry 4860 (class 2606 OID 21505)
-- Name: routes pk_routes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT pk_routes PRIMARY KEY (id);


--
-- TOC entry 4870 (class 2606 OID 21637)
-- Name: status_download pk_status_download; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_download
    ADD CONSTRAINT pk_status_download PRIMARY KEY (id);


--
-- TOC entry 4862 (class 2606 OID 20699)
-- Name: summary pk_summary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary
    ADD CONSTRAINT pk_summary PRIMARY KEY (id);


--
-- TOC entry 4856 (class 2606 OID 20674)
-- Name: users pk_tbl_0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_tbl_0 PRIMARY KEY (id);


--
-- TOC entry 4885 (class 2606 OID 20734)
-- Name: alerts fk_alerts_alert_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_alerts_alert_type FOREIGN KEY (alert_id) REFERENCES public.alert_type(id);


--
-- TOC entry 4886 (class 2606 OID 21589)
-- Name: alerts fk_alerts_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_alerts_devices FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4892 (class 2606 OID 21619)
-- Name: device_downloads fk_device_downloads_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_downloads
    ADD CONSTRAINT fk_device_downloads_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4893 (class 2606 OID 21624)
-- Name: device_downloads fk_device_downloads_downloads; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_downloads
    ADD CONSTRAINT fk_device_downloads_downloads FOREIGN KEY (download_id) REFERENCES public.downloads(id);


--
-- TOC entry 4874 (class 2606 OID 20744)
-- Name: devices fk_devices_fuel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT fk_devices_fuel FOREIGN KEY (fuel_id) REFERENCES public.fuel(id);


--
-- TOC entry 4891 (class 2606 OID 21645)
-- Name: downloads fk_downloads_status_download; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT fk_downloads_status_download FOREIGN KEY (status_id) REFERENCES public.status_download(id);


--
-- TOC entry 4889 (class 2606 OID 21170)
-- Name: group_device fk_group_device_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_device
    ADD CONSTRAINT fk_group_device_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4890 (class 2606 OID 21165)
-- Name: group_device fk_group_device_groups; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_device
    ADD CONSTRAINT fk_group_device_groups FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- TOC entry 4871 (class 2606 OID 20754)
-- Name: nvr_camera fk_nvr_camera_cameras; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr_camera
    ADD CONSTRAINT fk_nvr_camera_cameras FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- TOC entry 4872 (class 2606 OID 20759)
-- Name: nvr_camera fk_nvr_camera_geofences; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr_camera
    ADD CONSTRAINT fk_nvr_camera_geofences FOREIGN KEY (nvr_id) REFERENCES public.nvr(id);


--
-- TOC entry 4875 (class 2606 OID 21584)
-- Name: routes fk_routes_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT fk_routes_devices FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4876 (class 2606 OID 20769)
-- Name: summary fk_summary_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary
    ADD CONSTRAINT fk_summary_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4877 (class 2606 OID 20789)
-- Name: user_drone fk_user_dron_drones; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_drone
    ADD CONSTRAINT fk_user_dron_drones FOREIGN KEY (drone_id) REFERENCES public.drones(id);


--
-- TOC entry 4878 (class 2606 OID 20784)
-- Name: user_drone fk_user_dron_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_drone
    ADD CONSTRAINT fk_user_dron_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4879 (class 2606 OID 20794)
-- Name: user_geofence fk_user_geofence_fuel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_geofence
    ADD CONSTRAINT fk_user_geofence_fuel FOREIGN KEY (geofence_id) REFERENCES public.geofences(id);


--
-- TOC entry 4880 (class 2606 OID 20799)
-- Name: user_geofence fk_user_geofence_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_geofence
    ADD CONSTRAINT fk_user_geofence_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4887 (class 2606 OID 21147)
-- Name: user_group fk_user_group_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group
    ADD CONSTRAINT fk_user_group_devices FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- TOC entry 4888 (class 2606 OID 21142)
-- Name: user_group fk_user_group_devices_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group
    ADD CONSTRAINT fk_user_group_devices_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4881 (class 2606 OID 20804)
-- Name: user_nvr fk_user_nvr_geofences; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_nvr
    ADD CONSTRAINT fk_user_nvr_geofences FOREIGN KEY (nvr_id) REFERENCES public.nvr(id);


--
-- TOC entry 4882 (class 2606 OID 20809)
-- Name: user_nvr fk_user_nvr_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_nvr
    ADD CONSTRAINT fk_user_nvr_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4883 (class 2606 OID 20814)
-- Name: user_profile fk_user_profile_profiles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT fk_user_profile_profiles FOREIGN KEY (profile_id) REFERENCES public.profiles(id);


--
-- TOC entry 4884 (class 2606 OID 20819)
-- Name: user_profile fk_user_profile_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT fk_user_profile_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4873 (class 2606 OID 21535)
-- Name: users fk_users_licences; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_licences FOREIGN KEY (licence_id) REFERENCES public.licences(id);


-- Completed on 2025-01-02 09:14:04

--
-- PostgreSQL database dump complete
--

