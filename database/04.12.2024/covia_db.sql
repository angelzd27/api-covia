--
-- PostgreSQL database dump

--

-- Dumped from database version 17.2

-- Dumped by pg_dump version 17.2

-- Started on 2024-12-04 08:54:34

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 218 (class 1259 OID 19158)
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
-- TOC entry 237 (class 1259 OID 19177)
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
-- TOC entry 217 (class 1259 OID 19157)
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
-- TOC entry 220 (class 1259 OID 19160)
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
-- TOC entry 254 (class 1259 OID 19306)
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id integer DEFAULT nextval('public.alerts_id_seq1'::regclass) NOT NULL,
    device_id text,
    alert_id integer,
    description text,
    latitude text,
    longitude text,
    date timestamp without time zone DEFAULT CURRENT_DATE
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 19159)
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
-- TOC entry 255 (class 1259 OID 19315)
-- Name: camera_device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.camera_device (
    camera_id integer,
    device_id text
);


ALTER TABLE public.camera_device OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 19186)
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
-- TOC entry 222 (class 1259 OID 19162)
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
-- TOC entry 239 (class 1259 OID 19194)
-- Name: cameras_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cameras_devices (
    id integer DEFAULT nextval('public.cameras_devices_id_seq1'::regclass) NOT NULL,
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
-- TOC entry 221 (class 1259 OID 19161)
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
-- TOC entry 247 (class 1259 OID 19261)
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    id text NOT NULL,
    group_id integer,
    name text,
    device_status text,
    phone text,
    model text,
    fuel_id integer,
    km_per_liter text,
    is_dvr boolean,
    status boolean DEFAULT true,
    last_update timestamp without time zone DEFAULT CURRENT_DATE
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 19164)
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
-- TOC entry 240 (class 1259 OID 19203)
-- Name: fuel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fuel (
    id integer DEFAULT nextval('public.fuel_id_seq1'::regclass) NOT NULL,
    fuel text,
    status boolean DEFAULT true
);


ALTER TABLE public.fuel OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 19163)
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
-- TOC entry 226 (class 1259 OID 19166)
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
-- TOC entry 241 (class 1259 OID 19212)
-- Name: geofences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geofences (
    id integer DEFAULT nextval('public.geofences_id_seq1'::regclass) NOT NULL,
    name character varying(255),
    description character varying(255),
    color character varying(255),
    area character varying(255)
);


ALTER TABLE public.geofences OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 19165)
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
-- TOC entry 228 (class 1259 OID 19168)
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
-- TOC entry 242 (class 1259 OID 19220)
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id integer DEFAULT nextval('public.groups_id_seq1'::regclass) NOT NULL,
    "group" text,
    status boolean DEFAULT true
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 19167)
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
-- TOC entry 230 (class 1259 OID 19170)
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
-- TOC entry 243 (class 1259 OID 19229)
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
    status boolean DEFAULT true
);


ALTER TABLE public.nvr OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 19239)
-- Name: nvr_camera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nvr_camera (
    nvr_id integer,
    camera_id text
);


ALTER TABLE public.nvr_camera OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 19169)
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
-- TOC entry 232 (class 1259 OID 19172)
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
-- TOC entry 245 (class 1259 OID 19244)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id integer DEFAULT nextval('public.profiles_id_seq1'::regclass) NOT NULL,
    profile text,
    status boolean DEFAULT true
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 19171)
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
-- TOC entry 234 (class 1259 OID 19174)
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
-- TOC entry 248 (class 1259 OID 19270)
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    id integer DEFAULT nextval('public.routes_id_seq1'::regclass) NOT NULL,
    device_id text,
    latitude text,
    longitude text,
    date timestamp without time zone
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 19173)
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
-- TOC entry 236 (class 1259 OID 19176)
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
-- TOC entry 249 (class 1259 OID 19278)
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
-- TOC entry 235 (class 1259 OID 19175)
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
-- TOC entry 250 (class 1259 OID 19286)
-- Name: user_device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_device (
    user_id text,
    device_id text
);


ALTER TABLE public.user_device OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 19291)
-- Name: user_geofence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_geofence (
    user_id text,
    geofence_id integer
);


ALTER TABLE public.user_geofence OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 19296)
-- Name: user_nvr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_nvr (
    user_id text,
    nvr_id integer
);


ALTER TABLE public.user_nvr OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 19301)
-- Name: user_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profile (
    user_id text,
    profile_id integer
);


ALTER TABLE public.user_profile OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 19253)
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
-- TOC entry 5017 (class 0 OID 19177)
-- Dependencies: 237
-- Data for Name: alert_type; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5034 (class 0 OID 19306)
-- Dependencies: 254
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5035 (class 0 OID 19315)
-- Dependencies: 255
-- Data for Name: camera_device; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5018 (class 0 OID 19186)
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
-- TOC entry 5019 (class 0 OID 19194)
-- Dependencies: 239
-- Data for Name: cameras_devices; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5027 (class 0 OID 19261)
-- Dependencies: 247
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5020 (class 0 OID 19203)
-- Dependencies: 240
-- Data for Name: fuel; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5021 (class 0 OID 19212)
-- Dependencies: 241
-- Data for Name: geofences; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5022 (class 0 OID 19220)
-- Dependencies: 242
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5023 (class 0 OID 19229)
-- Dependencies: 243
-- Data for Name: nvr; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nvr VALUES (3, 'Cancun (Asgard)', 'w9fvjmxthjd2x95kv9s9jhzwj45eofub', 'uawmsdlxeh24as71cbfm6f58d7der2pg', '2prX0A', 'hcc.57v4cvv8levvwaw3odw7049tre2wa2r0', '1733684827662', 'at.cmne858u63cxfnq0dqporiu896r6mpml-99teisjkem-1btqf9y-os0qjvddi', 'Supermanzana # 131, Manzana 6, Lotes 299, 301, 303 Lanas de la Calle 89', 'Cancun, Benito Juarez, Quintana Roo', 'Hikvision', '4151010141', '2024-12-03 00:00:00', true);
INSERT INTO public.nvr VALUES (2, 'Casa Chorro (Castillo)', '19rnz5pfab180ra64d74unsed7lh4wdv', '59myvdqih6ohpmox3hlkegnf2azv8fsf', '', 'hcc.remhrcyjqmwuluyb92aythzwiugnmtz0', '1733596861288', 'at.b2s0peh790ylz4zh3z5qt4537rrkdhkm-5tr2p8wi20-08st1lm-poitjb9bi', 'Calle Chorro # 39 Zona Centro CP 37700', 'San Miguel de Allende, Gto.', 'Hikvision', '4151010141', '2024-12-03 00:00:00', true);
INSERT INTO public.nvr VALUES (1, 'Casa de Quino (Valhalla)', 'ozkm0f8x6kxcsmiyzylo0t5206kafdfb', 'g5tngho8i81fcaqw988wmx0ad3ncbi81', 'EmvyG8', 'hcc.zl3awvprionbgpklp75swr7ohq6a5e9u', '1733600648593', 'at.1w1i7q5l2ersb8ffa8bturty9lqy61vi-45hps4fe6p-0yqzf3g-hgwkrifpx', 'Carretera La Griega - El Lobo, km 4 CP 76249', 'El Marques, Querétaro', 'Hikvision', '4151010141', '2024-12-03 00:00:00', true);


--
-- TOC entry 5024 (class 0 OID 19239)
-- Dependencies: 244
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
-- TOC entry 5025 (class 0 OID 19244)
-- Dependencies: 245
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5028 (class 0 OID 19270)
-- Dependencies: 248
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5029 (class 0 OID 19278)
-- Dependencies: 249
-- Data for Name: summary; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5030 (class 0 OID 19286)
-- Dependencies: 250
-- Data for Name: user_device; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5031 (class 0 OID 19291)
-- Dependencies: 251
-- Data for Name: user_geofence; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5032 (class 0 OID 19296)
-- Dependencies: 252
-- Data for Name: user_nvr; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_nvr VALUES ('4200', 1);
INSERT INTO public.user_nvr VALUES ('4200', 2);
INSERT INTO public.user_nvr VALUES ('4200', 3);


--
-- TOC entry 5033 (class 0 OID 19301)
-- Dependencies: 253
-- Data for Name: user_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5026 (class 0 OID 19253)
-- Dependencies: 246
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES ('4200', 'Eduardo', 'Navarro', 'e.navarro@gmail.com', 'KomiSan#2', '4151010141', '2001-08-18', true);


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 217
-- Name: alert_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_type_id_seq', 1, false);


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 218
-- Name: alert_type_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_type_id_seq1', 1, false);


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 219
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq', 1, false);


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 220
-- Name: alerts_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq1', 1, false);


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 221
-- Name: cameras_devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cameras_devices_id_seq', 1, false);


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 222
-- Name: cameras_devices_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cameras_devices_id_seq1', 1, false);


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 223
-- Name: fuel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fuel_id_seq', 1, false);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 224
-- Name: fuel_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fuel_id_seq1', 1, false);


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 225
-- Name: geofences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geofences_id_seq', 1, false);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 226
-- Name: geofences_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geofences_id_seq1', 1, false);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 227
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 1, false);


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 228
-- Name: groups_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq1', 1, false);


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 229
-- Name: nvr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nvr_id_seq', 1, false);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 230
-- Name: nvr_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nvr_id_seq1', 3, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 231
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 1, false);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 232
-- Name: profiles_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq1', 1, false);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 233
-- Name: routes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routes_id_seq', 1, false);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 234
-- Name: routes_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routes_id_seq1', 1, false);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 235
-- Name: summary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.summary_id_seq', 1, false);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 236
-- Name: summary_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.summary_id_seq1', 1, false);


--
-- TOC entry 4809 (class 2606 OID 19185)
-- Name: alert_type pk_alert_type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_type
    ADD CONSTRAINT pk_alert_type PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 19314)
-- Name: alerts pk_alerts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT pk_alerts PRIMARY KEY (id);


--
-- TOC entry 4811 (class 2606 OID 19193)
-- Name: cameras pk_camera; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT pk_camera PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 19202)
-- Name: cameras_devices pk_cameras_devices; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras_devices
    ADD CONSTRAINT pk_cameras_devices PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 19269)
-- Name: devices pk_device; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT pk_device PRIMARY KEY (id);


--
-- TOC entry 4815 (class 2606 OID 19211)
-- Name: fuel pk_fuel; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fuel
    ADD CONSTRAINT pk_fuel PRIMARY KEY (id);


--
-- TOC entry 4817 (class 2606 OID 19219)
-- Name: geofences pk_geofences; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geofences
    ADD CONSTRAINT pk_geofences PRIMARY KEY (id);


--
-- TOC entry 4819 (class 2606 OID 19228)
-- Name: groups pk_groups; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT pk_groups PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 19238)
-- Name: nvr pk_nvr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr
    ADD CONSTRAINT pk_nvr PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 19252)
-- Name: profiles pk_profiles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT pk_profiles PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 19277)
-- Name: routes pk_routes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT pk_routes PRIMARY KEY (id);


--
-- TOC entry 4831 (class 2606 OID 19285)
-- Name: summary pk_summary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary
    ADD CONSTRAINT pk_summary PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 19260)
-- Name: users pk_tbl_0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_tbl_0 PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 19325)
-- Name: alerts fk_alerts_alert_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_alerts_alert_type FOREIGN KEY (alert_id) REFERENCES public.alert_type(id);


--
-- TOC entry 4849 (class 2606 OID 19320)
-- Name: alerts fk_alerts_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_alerts_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4850 (class 2606 OID 19335)
-- Name: camera_device fk_camera_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_device
    ADD CONSTRAINT fk_camera_device FOREIGN KEY (camera_id) REFERENCES public.cameras_devices(id);


--
-- TOC entry 4851 (class 2606 OID 19330)
-- Name: camera_device fk_camera_device_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_device
    ADD CONSTRAINT fk_camera_device_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4836 (class 2606 OID 19345)
-- Name: devices fk_devices_fuel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT fk_devices_fuel FOREIGN KEY (fuel_id) REFERENCES public.fuel(id);


--
-- TOC entry 4837 (class 2606 OID 19340)
-- Name: devices fk_devices_groups; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT fk_devices_groups FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- TOC entry 4834 (class 2606 OID 19350)
-- Name: nvr_camera fk_nvr_camera_cameras; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr_camera
    ADD CONSTRAINT fk_nvr_camera_cameras FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- TOC entry 4835 (class 2606 OID 19355)
-- Name: nvr_camera fk_nvr_camera_geofences; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nvr_camera
    ADD CONSTRAINT fk_nvr_camera_geofences FOREIGN KEY (nvr_id) REFERENCES public.nvr(id);


--
-- TOC entry 4838 (class 2606 OID 19360)
-- Name: routes fk_routes_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT fk_routes_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4839 (class 2606 OID 19365)
-- Name: summary fk_summary_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary
    ADD CONSTRAINT fk_summary_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4840 (class 2606 OID 19375)
-- Name: user_device fk_user_device_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_device
    ADD CONSTRAINT fk_user_device_devices FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 4841 (class 2606 OID 19370)
-- Name: user_device fk_user_device_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_device
    ADD CONSTRAINT fk_user_device_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4842 (class 2606 OID 19385)
-- Name: user_geofence fk_user_geofence_fuel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_geofence
    ADD CONSTRAINT fk_user_geofence_fuel FOREIGN KEY (geofence_id) REFERENCES public.geofences(id);


--
-- TOC entry 4843 (class 2606 OID 19380)
-- Name: user_geofence fk_user_geofence_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_geofence
    ADD CONSTRAINT fk_user_geofence_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4844 (class 2606 OID 19395)
-- Name: user_nvr fk_user_nvr_geofences; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_nvr
    ADD CONSTRAINT fk_user_nvr_geofences FOREIGN KEY (nvr_id) REFERENCES public.nvr(id);


--
-- TOC entry 4845 (class 2606 OID 19390)
-- Name: user_nvr fk_user_nvr_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_nvr
    ADD CONSTRAINT fk_user_nvr_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4846 (class 2606 OID 19405)
-- Name: user_profile fk_user_profile_profiles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT fk_user_profile_profiles FOREIGN KEY (profile_id) REFERENCES public.profiles(id);


--
-- TOC entry 4847 (class 2606 OID 19400)
-- Name: user_profile fk_user_profile_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT fk_user_profile_users FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2024-12-04 08:54:34

--
-- PostgreSQL database dump complete
--

