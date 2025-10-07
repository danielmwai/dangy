--
-- PostgreSQL database dump for PayloadCMS (Strapi tables removed)
--

-- Dumped from database version 16.9
-- Dumped by pg_dump version 17.2

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_permissions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.admin_permissions (
    id integer NOT NULL,
    document_id character varying(255),
    action character varying(255),
    action_parameters jsonb,
    subject character varying(255),
    properties jsonb,
    conditions jsonb,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.admin_permissions OWNER TO anzwa;

--
-- Name: admin_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.admin_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_permissions_id_seq OWNER TO anzwa;

--
-- Name: admin_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.admin_permissions_id_seq OWNED BY public.admin_permissions.id;


--
-- Name: admin_permissions_role_lnk; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.admin_permissions_role_lnk (
    id integer NOT NULL,
    permission_id integer,
    role_id integer,
    permission_ord double precision
);


ALTER TABLE public.admin_permissions_role_lnk OWNER TO anzwa;

--
-- Name: admin_permissions_role_lnk_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.admin_permissions_role_lnk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_permissions_role_lnk_id_seq OWNER TO anzwa;

--
-- Name: admin_permissions_role_lnk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.admin_permissions_role_lnk_id_seq OWNED BY public.admin_permissions_role_lnk.id;


--
-- Name: admin_roles; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.admin_roles (
    id integer NOT NULL,
    document_id character varying(255),
    name character varying(255),
    code character varying(255),
    description character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.admin_roles OWNER TO anzwa;

--
-- Name: admin_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.admin_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_roles_id_seq OWNER TO anzwa;

--
-- Name: admin_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.admin_roles_id_seq OWNED BY public.admin_roles.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.admin_users (
    id integer NOT NULL,
    document_id character varying(255),
    firstname character varying(255),
    lastname character varying(255),
    username character varying(255),
    email character varying(255),
    password character varying(255),
    reset_password_token character varying(255),
    registration_token character varying(255),
    is_active boolean,
    blocked boolean,
    prefered_language character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.admin_users OWNER TO anzwa;

--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_users_id_seq OWNER TO anzwa;

--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: admin_users_roles_lnk; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.admin_users_roles_lnk (
    id integer NOT NULL,
    user_id integer,
    role_id integer,
    role_ord double precision,
    user_ord double precision
);


ALTER TABLE public.admin_users_roles_lnk OWNER TO anzwa;

--
-- Name: admin_users_roles_lnk_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.admin_users_roles_lnk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_users_roles_lnk_id_seq OWNER TO anzwa;

--
-- Name: admin_users_roles_lnk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.admin_users_roles_lnk_id_seq OWNED BY public.admin_users_roles_lnk.id;


--
-- Name: class_schedules; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.class_schedules (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    class_id character varying,
    day_of_week integer NOT NULL,
    start_time text NOT NULL,
    end_time text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.class_schedules OWNER TO anzwa;

--
-- Name: contact_submissions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.contact_submissions (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    message text NOT NULL,
    status character varying DEFAULT 'new'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.contact_submissions OWNER TO anzwa;

--
-- Name: files; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.files (
    id integer NOT NULL,
    document_id character varying(255),
    name character varying(255),
    alternative_text character varying(255),
    caption character varying(255),
    width integer,
    height integer,
    formats jsonb,
    hash character varying(255),
    ext character varying(255),
    mime character varying(255),
    size numeric(10,2),
    url character varying(255),
    preview_url character varying(255),
    provider character varying(255),
    provider_metadata jsonb,
    folder_path character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.files OWNER TO anzwa;

--
-- Name: files_folder_lnk; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.files_folder_lnk (
    id integer NOT NULL,
    file_id integer,
    folder_id integer,
    file_ord double precision
);


ALTER TABLE public.files_folder_lnk OWNER TO anzwa;

--
-- Name: files_folder_lnk_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.files_folder_lnk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.files_folder_lnk_id_seq OWNER TO anzwa;

--
-- Name: files_folder_lnk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.files_folder_lnk_id_seq OWNED BY public.files_folder_lnk.id;


--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.files_id_seq OWNER TO anzwa;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- Name: files_related_mph; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.files_related_mph (
    id integer NOT NULL,
    file_id integer,
    related_id integer,
    related_type character varying(255),
    field character varying(255),
    "order" double precision
);


ALTER TABLE public.files_related_mph OWNER TO anzwa;

--
-- Name: files_related_mph_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.files_related_mph_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.files_related_mph_id_seq OWNER TO anzwa;

--
-- Name: files_related_mph_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.files_related_mph_id_seq OWNED BY public.files_related_mph.id;


--
-- Name: fitness_classes; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.fitness_classes (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    duration integer NOT NULL,
    level character varying NOT NULL,
    instructor text,
    max_capacity integer DEFAULT 20,
    image_url text,
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.fitness_classes OWNER TO anzwa;

--
-- Name: i18n_locale; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.i18n_locale (
    id integer NOT NULL,
    document_id character varying(255),
    name character varying(255),
    code character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.i18n_locale OWNER TO anzwa;

--
-- Name: i18n_locale_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.i18n_locale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.i18n_locale_id_seq OWNER TO anzwa;

--
-- Name: i18n_locale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.i18n_locale_id_seq OWNED BY public.i18n_locale.id;


--
-- Name: membership_plans; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.membership_plans (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    duration integer NOT NULL,
    features jsonb NOT NULL,
    popular boolean DEFAULT false,
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.membership_plans OWNER TO anzwa;

--
-- Name: memberships; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.memberships (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    user_id character varying,
    plan_id character varying,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    status character varying DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.memberships OWNER TO anzwa;

--
-- Name: newsletter_subscriptions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.newsletter_subscriptions (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.newsletter_submissions OWNER TO anzwa;

--
-- Name: order_items; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.order_items (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    order_id character varying,
    product_id character varying,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO anzwa;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.orders (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    user_id character varying,
    total numeric(10,2) NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    shipping_address jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.orders OWNER TO anzwa;

--
-- Name: pages; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.pages (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    slug character varying NOT NULL,
    title text NOT NULL,
    content jsonb NOT NULL,
    meta_description text,
    published boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.pages OWNER TO anzwa;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.payments (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    order_id character varying,
    membership_id character varying,
    amount numeric(10,2) NOT NULL,
    currency character varying DEFAULT 'KES'::character varying,
    method character varying NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    transaction_id text,
    phone_number text,
    mpesa_data jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO anzwa;

--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.product_categories (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    image_url text,
    active boolean DEFAULT true
);


ALTER TABLE public.product_categories OWNER TO anzwa;

--
-- Name: products; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.products (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    category_id character varying,
    image_url text,
    stock integer DEFAULT 0,
    featured boolean DEFAULT false,
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.products OWNER TO anzwa;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.sessions (
    sid character varying NOT NULL,
    sess jsonb NOT NULL,
    expire timestamp without time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO anzwa;

--
-- Name: testimonials; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.testimonials (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    username text,
    text text NOT NULL,
    rating integer DEFAULT 5 NOT NULL,
    image_url text,
    featured boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.testimonials OWNER TO anzwa;

--
-- Name: up_permissions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.up_permissions (
    id integer NOT NULL,
    document_id character varying(255),
    action character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.up_permissions OWNER TO anzwa;

--
-- Name: up_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.up_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.up_permissions_id_seq OWNER TO anzwa;

--
-- Name: up_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.up_permissions_id_seq OWNED BY public.up_permissions.id;


--
-- Name: up_permissions_role_lnk; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.up_permissions_role_lnk (
    id integer NOT NULL,
    permission_id integer,
    role_id integer,
    permission_ord double precision
);


ALTER TABLE public.up_permissions_role_lnk OWNER TO anzwa;

--
-- Name: up_permissions_role_lnk_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.up_permissions_role_lnk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.up_permissions_role_lnk_id_seq OWNER TO anzwa;

--
-- Name: up_permissions_role_lnk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.up_permissions_role_lnk_id_seq OWNED BY public.up_permissions_role_lnk.id;


--
-- Name: up_roles; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.up_roles (
    id integer NOT NULL,
    document_id character varying(255),
    name character varying(255),
    description character varying(255),
    type character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.up_roles OWNER TO anzwa;

--
-- Name: up_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.up_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.up_roles_id_seq OWNER TO anzwa;

--
-- Name: up_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.up_roles_id_seq OWNED BY public.up_roles.id;


--
-- Name: up_users; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.up_users (
    id integer NOT NULL,
    document_id character varying(255),
    username character varying(255),
    email character varying(255),
    provider character varying(255),
    password character varying(255),
    reset_password_token character varying(255),
    confirmation_token character varying(255),
    confirmed boolean,
    blocked boolean,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.up_users OWNER TO anzwa;

--
-- Name: up_users_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.up_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.up_users_id_seq OWNER TO anzwa;

--
-- Name: up_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.up_users_id_seq OWNED BY public.up_users.id;


--
-- Name: up_users_role_lnk; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.up_users_role_lnk (
    id integer NOT NULL,
    user_id integer,
    role_id integer,
    user_ord double precision
);


ALTER TABLE public.up_users_role_lnk OWNER TO anzwa;

--
-- Name: up_users_role_lnk_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.up_users_role_lnk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.up_users_role_lnk_id_seq OWNER TO anzwa;

--
-- Name: up_users_role_lnk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.up_users_role_lnk_id_seq OWNED BY public.up_users_role_lnk.id;


--
-- Name: upload_folders; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.upload_folders (
    id integer NOT NULL,
    document_id character varying(255),
    name character varying(255),
    path_id integer,
    path character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    published_at timestamp(6) without time zone,
    created_by_id integer,
    updated_by_id integer,
    locale character varying(255)
);


ALTER TABLE public.upload_folders OWNER TO anzwa;

--
-- Name: upload_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.upload_folders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.upload_folders_id_seq OWNER TO anzwa;

--
-- Name: upload_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.upload_folders_id_seq OWNED BY public.upload_folders.id;


--
-- Name: upload_folders_parent_lnk; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.upload_folders_parent_lnk (
    id integer NOT NULL,
    folder_id integer,
    inv_folder_id integer,
    folder_ord double precision
);


ALTER TABLE public.upload_folders_parent_lnk OWNER TO anzwa;

--
-- Name: upload_folders_parent_lnk_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.upload_folders_parent_lnk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.upload_folders_parent_lnk_id_seq OWNER TO anzwa;

--
-- Name: upload_folders_parent_lnk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.upload_folders_parent_lnk_id_seq OWNED BY public.upload_folders_parent_lnk.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.users (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    email character varying,
    password character varying,
    first_name character varying,
    last_name character varying,
    profile_image_url character varying,
    auth_provider character varying DEFAULT 'replit'::character varying,
    email_verified boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    role character varying DEFAULT 'user'::character varying
);


ALTER TABLE public.users OWNER TO anzwa;

--
-- Name: admin_permissions id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.admin_permissions ALTER COLUMN id SET DEFAULT nextval('public.admin_permissions_id_seq'::regclass);


--
-- Name: admin_permissions_role_lnk id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.admin_permissions_role_lnk ALTER COLUMN id SET DEFAULT nextval('public.admin_permissions_role_lnk_id_seq'::regclass);


--
-- Name: admin_roles id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.admin_roles ALTER COLUMN id SET DEFAULT nextval('public.admin_roles_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: admin_users_roles_lnk id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.admin_users_roles_lnk ALTER COLUMN id SET DEFAULT nextval('public.admin_users_roles_lnk_id_seq'::regclass);


--
-- Name: files id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- Name: files_folder_lnk id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.files_folder_lnk ALTER COLUMN id SET DEFAULT nextval('public.files_folder_lnk_id_seq'::regclass);


--
-- Name: files_related_mph id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.files_related_mph ALTER COLUMN id SET DEFAULT nextval('public.files_related_mph_id_seq'::regclass);


--
-- Name: i18n_locale id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.i18n_locale ALTER COLUMN id SET DEFAULT nextval('public.i18n_locale_id_seq'::regclass);


--
-- Name: up_permissions id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.up_permissions ALTER COLUMN id SET DEFAULT nextval('public.up_permissions_id_seq'::regclass);


--
-- Name: up_permissions_role_lnk id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.up_permissions_role_lnk ALTER COLUMN id SET DEFAULT nextval('public.up_permissions_role_lnk_id_seq'::regclass);


--
-- Name: up_roles id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.up_roles ALTER COLUMN id SET DEFAULT nextval('public.up_roles_id_seq'::regclass);


--
-- Name: up_users id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.up_users ALTER COLUMN id SET DEFAULT nextval('public.up_users_id_seq'::regclass);


--
-- Name: up_users_role_lnk id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.up_users_role_lnk ALTER COLUMN id SET DEFAULT nextval('public.up_users_role_lnk_id_seq'::regclass);


--
-- Name: upload_folders id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.upload_folders ALTER COLUMN id SET DEFAULT nextval('public.upload_folders_id_seq'::regclass);


--
-- Name: upload_folders_parent_lnk id; Type: DEFAULT; Schema: public; Owner: anzwa
--
ALTER TABLE ONLY public.upload_folders_parent_lnk ALTER COLUMN id SET DEFAULT nextval('public.upload_folders_parent_lnk_id_seq'::regclass);


-- Sequences
SELECT pg_catalog.setval('public.admin_permissions_id_seq', 70, true);
SELECT pg_catalog.setval('public.admin_permissions_role_lnk_id_seq', 70, true);
SELECT pg_catalog.setval('public.admin_roles_id_seq', 3, true);
SELECT pg_catalog.setval('public.admin_users_id_seq', 1, true);
SELECT pg_catalog.setval('public.admin_users_roles_lnk_id_seq', 1, true);
SELECT pg_catalog.setval('public.files_folder_lnk_id_seq', 1, false);
SELECT pg_catalog.setval('public.files_id_seq', 1, false);
SELECT pg_catalog.setval('public.files_related_mph_id_seq', 1, false);
SELECT pg_catalog.setval('public.i18n_locale_id_seq', 1, true);
SELECT pg_catalog.setval('public.up_permissions_id_seq', 9, true);
SELECT pg_catalog.setval('public.up_permissions_role_lnk_id_seq', 9, true);
SELECT pg_catalog.setval('public.up_roles_id_seq', 2, true);
SELECT pg_catalog.setval('public.up_users_id_seq', 1, false);
SELECT pg_catalog.setval('public.up_users_role_lnk_id_seq', 1, false);
SELECT pg_catalog.setval('public.upload_folders_id_seq', 1, false);
SELECT pg_catalog.setval('public.upload_folders_parent_lnk_id_seq', 1, false);


-- Constraints
ALTER TABLE ONLY public.admin_permissions ADD CONSTRAINT admin_permissions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.admin_permissions_role_lnk ADD CONSTRAINT admin_permissions_role_lnk_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.admin_permissions_role_lnk ADD CONSTRAINT admin_permissions_role_lnk_uq UNIQUE (permission_id, role_id);
ALTER TABLE ONLY public.admin_roles ADD CONSTRAINT admin_roles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.admin_users ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.admin_users_roles_lnk ADD CONSTRAINT admin_users_roles_lnk_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.admin_users_roles_lnk ADD CONSTRAINT admin_users_roles_lnk_uq UNIQUE (user_id, role_id);
ALTER TABLE ONLY public.class_schedules ADD CONSTRAINT class_schedules_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.contact_submissions ADD CONSTRAINT contact_submissions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.files_folder_lnk ADD CONSTRAINT files_folder_lnk_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.files_folder_lnk ADD CONSTRAINT files_folder_lnk_uq UNIQUE (file_id, folder_id);
ALTER TABLE ONLY public.files ADD CONSTRAINT files_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.files_related_mph ADD CONSTRAINT files_related_mph_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.fitness_classes ADD CONSTRAINT fitness_classes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.i18n_locale ADD CONSTRAINT i18n_locale_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.membership_plans ADD CONSTRAINT membership_plans_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.memberships ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.newsletter_subscriptions ADD CONSTRAINT newsletter_subscriptions_email_unique UNIQUE (email);
ALTER TABLE ONLY public.newsletter_subscriptions ADD CONSTRAINT newsletter_subscriptions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.order_items ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pages ADD CONSTRAINT pages_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pages ADD CONSTRAINT pages_slug_unique UNIQUE (slug);
ALTER TABLE ONLY public.payments ADD CONSTRAINT payments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.product_categories ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.products ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_pkey PRIMARY KEY (sid);
ALTER TABLE ONLY public.testimonials ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.up_permissions ADD CONSTRAINT up_permissions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.up_permissions_role_lnk ADD CONSTRAINT up_permissions_role_lnk_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.up_permissions_role_lnk ADD CONSTRAINT up_permissions_role_lnk_uq UNIQUE (permission_id, role_id);
ALTER TABLE ONLY public.up_roles ADD CONSTRAINT up_roles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.up_users ADD CONSTRAINT up_users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.up_users_role_lnk ADD CONSTRAINT up_users_role_lnk_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.up_users_role_lnk ADD CONSTRAINT up_users_role_lnk_uq UNIQUE (user_id, role_id);
ALTER TABLE ONLY public.upload_folders_parent_lnk ADD CONSTRAINT upload_folders_parent_lnk_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.upload_folders_parent_lnk ADD CONSTRAINT upload_folders_parent_lnk_uq UNIQUE (folder_id, inv_folder_id);
ALTER TABLE ONLY public.upload_folders ADD CONSTRAINT upload_folders_path_id_index UNIQUE (path_id);
ALTER TABLE ONLY public.upload_folders ADD CONSTRAINT upload_folders_path_index UNIQUE (path);
ALTER TABLE ONLY public.upload_folders ADD CONSTRAINT upload_folders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_email_unique UNIQUE (email);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);

-- Indexes
CREATE INDEX "IDX_session_expire" ON public.sessions USING btree (expire);
CREATE INDEX admin_permissions_created_by_id_fk ON public.admin_permissions USING btree (created_by_id);
CREATE INDEX admin_permissions_documents_idx ON public.admin_permissions USING btree (document_id, locale, published_at);
CREATE INDEX admin_permissions_role_lnk_fk ON public.admin_permissions_role_lnk USING btree (permission_id);
CREATE INDEX admin_permissions_role_lnk_ifk ON public.admin_permissions_role_lnk USING btree (role_id);
CREATE INDEX admin_permissions_role_lnk_oifk ON public.admin_permissions_role_lnk USING btree (permission_ord);
CREATE INDEX admin_permissions_updated_by_id_fk ON public.admin_permissions USING btree (updated_by_id);
CREATE INDEX admin_roles_created_by_id_fk ON public.admin_roles USING btree (created_by_id);
CREATE INDEX admin_roles_documents_idx ON public.admin_roles USING btree (document_id, locale, published_at);
CREATE INDEX admin_roles_updated_by_id_fk ON public.admin_roles USING btree (updated_by_id);
CREATE INDEX admin_users_created_by_id_fk ON public.admin_users USING btree (created_by_id);
CREATE INDEX admin_users_documents_idx ON public.admin_users USING btree (document_id, locale, published_at);
CREATE INDEX admin_users_roles_lnk_fk ON public.admin_users_roles_lnk USING btree (user_id);
CREATE INDEX admin_users_roles_lnk_ifk ON public.admin_users_roles_lnk USING btree (role_id);
CREATE INDEX admin_users_roles_lnk_ofk ON public.admin_users_roles_lnk USING btree (role_ord);
CREATE INDEX admin_users_roles_lnk_oifk ON public.admin_users_roles_lnk USING btree (user_ord);
CREATE INDEX admin_users_updated_by_id_fk ON public.admin_users USING btree (updated_by_id);
CREATE INDEX files_created_by_id_fk ON public.files USING btree (created_by_id);
CREATE INDEX files_documents_idx ON public.files USING btree (document_id, locale, published_at);
CREATE INDEX files_folder_lnk_fk ON public.files_folder_lnk USING btree (file_id);
CREATE INDEX files_folder_lnk_ifk ON public.files_folder_lnk USING btree (folder_id);
CREATE INDEX files_folder_lnk_oifk ON public.files_folder_lnk USING btree (file_ord);
CREATE INDEX files_related_mph_fk ON public.files_related_mph USING btree (file_id);
CREATE INDEX files_related_mph_idix ON public.files_related_mph USING btree (related_id);
CREATE INDEX files_related_mph_oidx ON public.files_related_mph USING btree ("order");
CREATE INDEX files_updated_by_id_fk ON public.files USING btree (updated_by_id);
CREATE INDEX i18n_locale_created_by_id_fk ON public.i18n_locale USING btree (created_by_id);
CREATE INDEX i18n_locale_documents_idx ON public.i18n_locale USING btree (document_id, locale, published_at);
CREATE INDEX i18n_locale_updated_by_id_fk ON public.i18n_locale USING btree (updated_by_id);
CREATE INDEX up_permissions_created_by_id_fk ON public.up_permissions USING btree (created_by_id);
CREATE INDEX up_permissions_documents_idx ON public.up_permissions USING btree (document_id, locale, published_at);
CREATE INDEX up_permissions_role_lnk_fk ON public.up_permissions_role_lnk USING btree (permission_id);
CREATE INDEX up_permissions_role_lnk_ifk ON public.up_permissions_role_lnk USING btree (role_id);
CREATE INDEX up_permissions_role_lnk_oifk ON public.up_permissions_role_lnk USING btree (permission_ord);
CREATE INDEX up_permissions_updated_by_id_fk ON public.up_permissions USING btree (updated_by_id);
CREATE INDEX up_roles_created_by_id_fk ON public.up_roles USING btree (created_by_id);
CREATE INDEX up_roles_documents_idx ON public.up_roles USING btree (document_id, locale, published_at);
CREATE INDEX up_roles_updated_by_id_fk ON public.up_roles USING btree (updated_by_id);
CREATE INDEX up_users_created_by_id_fk ON public.up_users USING btree (created_by_id);
CREATE INDEX up_users_documents_idx ON public.up_users USING btree (document_id, locale, published_at);
CREATE INDEX up_users_role_lnk_fk ON public.up_users_role_lnk USING btree (user_id);
CREATE INDEX up_users_role_lnk_ifk ON public.up_users_role_lnk USING btree (role_id);
CREATE INDEX up_users_role_lnk_oifk ON public.up_users_role_lnk USING btree (user_ord);
CREATE INDEX up_users_updated_by_id_fk ON public.up_users USING btree (updated_by_id);
CREATE INDEX upload_files_created_at_index ON public.files USING btree (created_at);
CREATE INDEX upload_files_ext_index ON public.files USING btree (ext);
CREATE INDEX upload_files_folder_path_index ON public.files USING btree (folder_path);
CREATE INDEX upload_files_name_index ON public.files USING btree (name);
CREATE INDEX upload_files_size_index ON public.files USING btree (size);
CREATE INDEX upload_files_updated_at_index ON public.files USING btree (updated_at);

-- Foreign Key Constraints
ALTER TABLE ONLY public.admin_permissions ADD CONSTRAINT admin_permissions_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.admin_permissions ADD CONSTRAINT admin_permissions_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.admin_permissions_role_lnk ADD CONSTRAINT admin_permissions_role_lnk_fk FOREIGN KEY (permission_id) REFERENCES public.admin_permissions(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.admin_permissions_role_lnk ADD CONSTRAINT admin_permissions_role_lnk_ifk FOREIGN KEY (role_id) REFERENCES public.admin_roles(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.admin_roles ADD CONSTRAINT admin_roles_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.admin_roles ADD CONSTRAINT admin_roles_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.admin_users ADD CONSTRAINT admin_users_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.admin_users ADD CONSTRAINT admin_users_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.admin_users_roles_lnk ADD CONSTRAINT admin_users_roles_lnk_fk FOREIGN KEY (user_id) REFERENCES public.admin_users(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.admin_users_roles_lnk ADD CONSTRAINT admin_users_roles_lnk_ifk FOREIGN KEY (role_id) REFERENCES public.admin_roles(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.class_schedules ADD CONSTRAINT class_schedules_class_id_fitness_classes_id_fk FOREIGN KEY (class_id) REFERENCES public.fitness_classes(id);
ALTER TABLE ONLY public.files ADD CONSTRAINT files_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.files ADD CONSTRAINT files_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.files_folder_lnk ADD CONSTRAINT files_folder_lnk_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.files_folder_lnk ADD CONSTRAINT files_folder_lnk_ifk FOREIGN KEY (folder_id) REFERENCES public.upload_folders(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.files_related_mph ADD CONSTRAINT files_related_mph_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.i18n_locale ADD CONSTRAINT i18n_locale_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.i18n_locale ADD CONSTRAINT i18n_locale_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.memberships ADD CONSTRAINT memberships_plan_id_membership_plans_id_fk FOREIGN KEY (plan_id) REFERENCES public.membership_plans(id);
ALTER TABLE ONLY public.memberships ADD CONSTRAINT memberships_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.order_items ADD CONSTRAINT order_items_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id);
ALTER TABLE ONLY public.order_items ADD CONSTRAINT order_items_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);
ALTER TABLE ONLY public.orders ADD CONSTRAINT orders_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.payments ADD CONSTRAINT payments_membership_id_memberships_id_fk FOREIGN KEY (membership_id) REFERENCES public.memberships(id);
ALTER TABLE ONLY public.payments ADD CONSTRAINT payments_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id);
ALTER TABLE ONLY public.products ADD CONSTRAINT products_category_id_product_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.product_categories(id);
ALTER TABLE ONLY public.up_permissions ADD CONSTRAINT up_permissions_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.up_permissions ADD CONSTRAINT up_permissions_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.up_permissions_role_lnk ADD CONSTRAINT up_permissions_role_lnk_fk FOREIGN KEY (permission_id) REFERENCES public.up_permissions(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.up_permissions_role_lnk ADD CONSTRAINT up_permissions_role_lnk_ifk FOREIGN KEY (role_id) REFERENCES public.up_roles(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.up_roles ADD CONSTRAINT up_roles_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.up_roles ADD CONSTRAINT up_roles_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.up_users ADD CONSTRAINT up_users_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.up_users ADD CONSTRAINT up_users_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.up_users_role_lnk ADD CONSTRAINT up_users_role_lnk_fk FOREIGN KEY (user_id) REFERENCES public.up_users(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.up_users_role_lnk ADD CONSTRAINT up_users_role_lnk_ifk FOREIGN KEY (role_id) REFERENCES public.up_roles(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.upload_folders ADD CONSTRAINT upload_folders_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.upload_folders ADD CONSTRAINT upload_folders_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES public.admin_users(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.upload_folders_parent_lnk ADD CONSTRAINT upload_folders_parent_lnk_fk FOREIGN KEY (folder_id) REFERENCES public.upload_folders(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.upload_folders_parent_lnk ADD CONSTRAINT upload_folders_parent_lnk_ifk FOREIGN KEY (inv_folder_id) REFERENCES public.upload_folders(id) ON DELETE CASCADE;

-- Data for tables
INSERT INTO public.admin_permissions VALUES
	(1, 'ly4qenmt03vtuxqel0tfc9lh', 'plugin::upload.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.834', '2025-09-27 09:45:09.834', '2025-09-27 09:45:09.834', NULL, NULL, NULL),
	(2, 'es09az6np9jrp4qin1iofnpx', 'plugin::upload.configure-view', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.838', '2025-09-27 09:45:09.838', '2025-09-27 09:45:09.838', NULL, NULL, NULL),
	(3, 'ypmaqldu3nt0ujw2zes1fds9', 'plugin::upload.assets.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.841', '2025-09-27 09:45:09.841', '2025-09-27 09:45:09.842', NULL, NULL, NULL),
	(4, 'w0f0typc4btpmck6v8y8tijb', 'plugin::upload.assets.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.844', '2025-09-27 09:45:09.844', '2025-09-27 09:45:09.844', NULL, NULL, NULL),
	(5, 'jkrhbd1o5lm0qbu0k16t7gkk', 'plugin::upload.assets.download', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.847', '2025-09-27 09:45:09.847', '2025-09-27 09:45:09.847', NULL, NULL, NULL),
	(6, 'ijkp9krfbd69zfw8bcylmvx3', 'plugin::upload.assets.copy-link', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.866', '2025-09-27 09:45:09.866', '2025-09-27 09:45:09.866', NULL, NULL, NULL),
	(7, 'i2g6j9a031jndzhmpdy28qq2', 'plugin::upload.read', '{}', NULL, '{}', '[\"admin::is-creator\"]', '2025-09-27 09:45:09.873', '2025-09-27 09:45:09.873', '2025-09-27 09:45:09.873', NULL, NULL, NULL),
	(8, 'nsrp3madydpi5hhiztwadg7u', 'plugin::upload.configure-view', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.876', '2025-09-27 09:45:09.876', '2025-09-27 09:45:09.876', NULL, NULL, NULL),
	(9, 'd5k2i0q740y6x5abbe8qit7y', 'plugin::upload.assets.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.88', '2025-09-27 09:45:09.88', '2025-09-27 09:45:09.88', NULL, NULL, NULL),
	(10, 'hukbwekagqa9lnm5ga1df0rw', 'plugin::upload.assets.update', '{}', NULL, '{}', '[\"admin::is-creator\"]', '2025-09-27 09:45:09.883', '2025-09-27 09:45:09.883', '2025-09-27 09:45:09.883', NULL, NULL, NULL),
	(11, 'wsq4yuu44uisajl7bqnc2yxx', 'plugin::upload.assets.download', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.886', '2025-09-27 09:45:09.886', '2025-09-27 09:45:09.886', NULL, NULL, NULL),
	(12, 'n0y3vd65x71vw9b3slrglu6p', 'plugin::upload.assets.copy-link', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.89', '2025-09-27 09:45:09.89', '2025-09-27 09:45:09.89', NULL, NULL, NULL),
	(13, 'kt6lubgcxh5dbzzocw54hw5i', 'plugin::content-manager.explorer.create', '{}', 'plugin::users-permissions.user', '{\"fields\": [\"username\", \"email\", \"provider\", \"password\", \"resetPasswordToken\", \"confirmationToken\", \"confirmed\", \"blocked\", \"role\"]}', '[]', '2025-09-27 09:45:09.907', '2025-09-27 09:45:09.907', '2025-09-27 09:45:09.907', NULL, NULL, NULL),
	(14, 'hv3cynja6b532t5ra62o1rte', 'plugin::content-manager.explorer.read', '{}', 'plugin::users-permissions.user', '{\"fields\": [\"username\", \"email\", \"provider\", \"password\", \"resetPasswordToken\", \"confirmationToken\", \"confirmed\", \"blocked\", \"role\"]}', '[]', '2025-09-27 09:45:09.911', '2025-09-27 09:45:09.911', '2025-09-27 09:45:09.911', NULL, NULL, NULL),
	(15, 'o2am87l30qssptiza0g2clqu', 'plugin::content-manager.explorer.update', '{}', 'plugin::users-permissions.user', '{\"fields\": [\"username\", \"email\", \"provider\", \"password\", \"resetPasswordToken\", \"confirmationToken\", \"confirmed\", \"blocked\", \"role\"]}', '[]', '2025-09-27 09:45:09.914', '2025-09-27 09:45:09.914', '2025-09-27 09:45:09.914', NULL, NULL, NULL),
	(16, 'w9cz4h787zuu0nkb18ydgzld', 'plugin::content-manager.explorer.delete', '{}', 'plugin::users-permissions.user', '{}', '[]', '2025-09-27 09:45:09.918', '2025-09-27 09:45:09.918', '2025-09-27 09:45:09.918', NULL, NULL, NULL),
	(17, 'dhbouq3ol6cv20xho509orn7', 'plugin::content-manager.explorer.publish', '{}', 'plugin::users-permissions.user', '{}', '[]', '2025-09-27 09:45:09.922', '2025-09-27 09:45:09.922', '2025-09-27 09:45:09.922', NULL, NULL, NULL),
	(18, 'arfgzwk6fd51o93s0yyoj2zj', 'plugin::content-manager.single-types.configure-view', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.924', '2025-09-27 09:45:09.924', '2025-09-27 09:45:09.924', NULL, NULL, NULL),
	(19, 'qh0c5mz9nlvxfosxugvnod6t', 'plugin::content-manager.collection-types.configure-view', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.928', '2025-09-27 09:45:09.928', '2025-09-27 09:45:09.928', NULL, NULL, NULL),
	(20, 'awm8sxgg2e6dlddcvhbxjln3', 'plugin::content-type-builder.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.93', '2025-09-27 09:45:09.93', '2025-09-27 09:45:09.93', NULL, NULL, NULL),
	(21, 'wp6xl06qa82wnzzyzxkzpm1n', 'plugin::email.settings.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.934', '2025-09-27 09:45:09.934', '2025-09-27 09:45:09.934', NULL, NULL, NULL),
	(22, 'xtgp6qtt00wielvugzg3ggnz', 'plugin::upload.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.94', '2025-09-27 09:45:09.94', '2025-09-27 09:45:09.94', NULL, NULL, NULL),
	(23, 'rwe7w288sja89pubt8ekmsu6', 'plugin::upload.assets.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.943', '2025-09-27 09:45:09.943', '2025-09-27 09:45:09.943', NULL, NULL, NULL),
	(24, 'ckesm0tch3z8aqyzdxoo87ox', 'plugin::upload.assets.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.945', '2025-09-27 09:45:09.945', '2025-09-27 09:45:09.945', NULL, NULL, NULL),
	(25, 'n2hzueqo0bjcmvfdrh2lor9h', 'plugin::upload.assets.download', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.948', '2025-09-27 09:45:09.948', '2025-09-27 09:45:09.948', NULL, NULL, NULL),
	(26, 'v2o4oojpda096zkx1twkntan', 'plugin::upload.assets.copy-link', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.951', '2025-09-27 09:45:09.951', '2025-09-27 09:45:09.951', NULL, NULL, NULL),
	(27, 'rheuacjselg74vcaa9y7be8a', 'plugin::upload.configure-view', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.954', '2025-09-27 09:45:09.954', '2025-09-27 09:45:09.954', NULL, NULL, NULL),
	(28, 'r9ysw1msta25un98hi0k7fa6', 'plugin::upload.settings.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.957', '2025-09-27 09:45:09.957', '2025-09-27 09:45:09.957', NULL, NULL, NULL),
	(29, 'svrje36v1zxh7qk7xwlwdpok', 'plugin::i18n.locale.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.96', '2025-09-27 09:45:09.96', '2025-09-27 09:45:09.96', NULL, NULL, NULL),
	(30, 'bu405411xaj7pbsize3qudis', 'plugin::i18n.locale.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.962', '2025-09-27 09:45:09.962', '2025-09-27 09:45:09.963', NULL, NULL, NULL),
	(31, 'iv2f269blvivajc2iqq2uglt', 'plugin::i18n.locale.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.966', '2025-09-27 09:45:09.966', '2025-09-27 09:45:09.967', NULL, NULL, NULL),
	(32, 'rh41wm0s7zzxkrfpqtgs4vlc', 'plugin::i18n.locale.delete', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.971', '2025-09-27 09:45:09.971', '2025-09-27 09:45:09.971', NULL, NULL, NULL),
	(33, 'x688xu3644aynzkm5k2x134n', 'plugin::users-permissions.roles.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.977', '2025-09-27 09:45:09.977', '2025-09-27 09:45:09.977', NULL, NULL, NULL),
	(34, 'plfksoh3j3qrig5f3m3nltjc', 'plugin::users-permissions.roles.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.982', '2025-09-27 09:45:09.982', '2025-09-27 09:45:09.983', NULL, NULL, NULL),
	(35, 'h2n1thhhpljzvwwyyi688nio', 'plugin::users-permissions.roles.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.989', '2025-09-27 09:45:09.989', '2025-09-27 09:45:09.989', NULL, NULL, NULL),
	(36, 'xii2a4qcez66ilpb581nfgi1', 'plugin::users-permissions.roles.delete', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.991', '2025-09-27 09:45:09.991', '2025-09-27 09:45:09.992', NULL, NULL, NULL),
	(37, 'mun47off1xrljk3yhur0md9m', 'plugin::users-permissions.providers.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.995', '2025-09-27 09:45:09.995', '2025-09-27 09:45:09.995', NULL, NULL, NULL),
	(38, 'yreto644rrwawyhvefhs487s', 'plugin::users-permissions.providers.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:09.997', '2025-09-27 09:45:09.997', '2025-09-27 09:45:09.997', NULL, NULL, NULL),
	(39, 'bqb2vh5nhenn39su2z5ck1xu', 'plugin::users-permissions.email-templates.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.001', '2025-09-27 09:45:10.001', '2025-09-27 09:45:10.001', NULL, NULL, NULL),
	(40, 'xopxnp40qp5p7a79fd64xxxr', 'plugin::users-permissions.email-templates.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.004', '2025-09-27 09:45:10.004', '2025-09-27 09:45:10.004', NULL, NULL, NULL),
	(41, 'ogp3dm1351ypte6i4qya94ht', 'plugin::users-permissions.advanced-settings.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.007', '2025-09-27 09:45:10.007', '2025-09-27 09:45:10.007', NULL, NULL, NULL),
	(42, 'zusgau4j3cv61x9v9pbg3jqg', 'plugin::users-permissions.advanced-settings.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.01', '2025-09-27 09:45:10.01', '2025-09-27 09:45:10.01', NULL, NULL, NULL),
	(43, 'wpxb3lwoaa3mfcvxnc04kyox', 'admin::marketplace.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.013', '2025-09-27 09:45:10.013', '2025-09-27 09:45:10.013', NULL, NULL, NULL),
	(44, 'w4d5zxxkru7rb9ulyx7jmm0c', 'admin::webhooks.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.015', '2025-09-27 09:45:10.015', '2025-09-27 09:45:10.015', NULL, NULL, NULL),
	(45, 'if30o9dy86x2fixvmzzjeu22', 'admin::webhooks.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.018', '2025-09-27 09:45:10.018', '2025-09-27 09:45:10.019', NULL, NULL, NULL),
	(46, 'nmp306t17o182c6n5d3j5vie', 'admin::webhooks.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.022', '2025-09-27 09:45:10.022', '2025-09-27 09:45:10.022', NULL, NULL, NULL),
	(47, 'kn67aje38w34adh5f6bfr3fg', 'admin::webhooks.delete', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.024', '2025-09-27 09:45:10.024', '2025-09-27 09:45:10.024', NULL, NULL, NULL),
	(48, 'lul0rklzk7fnfuuiehiio439', 'admin::users.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.027', '2025-09-27 09:45:10.027', '2025-09-27 09:45:10.027', NULL, NULL, NULL),
	(49, 'auf0z4jg7iiezpnsz4wjwlio', 'admin::users.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.029', '2025-09-27 09:45:10.029', '2025-09-27 09:45:10.029', NULL, NULL, NULL),
	(50, 'o71umdnanz381o7mchvn0ach', 'admin::users.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.032', '2025-09-27 09:45:10.032', '2025-09-27 09:45:10.032', NULL, NULL, NULL),
	(51, 'fcjv8f22tv4uf1uu4u3x69qx', 'admin::users.delete', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.034', '2025-09-27 09:45:10.034', '2025-09-27 09:45:10.034', NULL, NULL, NULL),
	(52, 'hrool9begrliyrzjgsgs9kf3', 'admin::roles.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.037', '2025-09-27 09:45:10.037', '2025-09-27 09:45:10.037', NULL, NULL, NULL),
	(53, 'wfifnrt7ia68ytc9tyn6869w', 'admin::roles.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.039', '2025-09-27 09:45:10.039', '2025-09-27 09:45:10.039', NULL, NULL, NULL),
	(54, 'knqxf68xbrrlpvk9bkvdefdh', 'admin::roles.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.042', '2025-09-27 09:45:10.042', '2025-09-27 09:45:10.042', NULL, NULL, NULL),
	(55, 'ehcpyg3qp9dlopoazywsuvl9', 'admin::roles.delete', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.045', '2025-09-27 09:45:10.045', '2025-09-27 09:45:10.045', NULL, NULL, NULL),
	(56, 'y9xbutxiuhw8spb7lop25afy', 'admin::api-tokens.access', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.047', '2025-09-27 09:45:10.047', '2025-09-27 09:45:10.047', NULL, NULL, NULL),
	(57, 'jvzbny4grnth7y5qbard32r8', 'admin::api-tokens.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.05', '2025-09-27 09:45:10.05', '2025-09-27 09:45:10.05', NULL, NULL, NULL),
	(58, 'n453h8zxux7wqslpgh8juyhg', 'admin::api-tokens.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.053', '2025-09-27 09:45:10.053', '2025-09-27 09:45:10.053', NULL, NULL, NULL),
	(59, 'a05pc2f3s0uw51qw0uygn5yv', 'admin::api-tokens.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.056', '2025-09-27 09:45:10.056', '2025-09-27 09:45:10.056', NULL, NULL, NULL),
	(60, 'ekrcyfkmjvzw325j8yef1xxh', 'admin::api-tokens.regenerate', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.059', '2025-09-27 09:45:10.059', '2025-09-27 09:45:10.059', NULL, NULL, NULL),
	(61, 'jf4qelq6oxc3lmq2greb00pt', 'admin::api-tokens.delete', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.062', '2025-09-27 09:45:10.062', '2025-09-27 09:45:10.062', NULL, NULL, NULL),
	(62, 'tpheekrc65qy38wyhv6ea07a', 'admin::project-settings.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.064', '2025-09-27 09:45:10.064', '2025-09-27 09:45:10.064', NULL, NULL, NULL),
	(63, 'emt6og9csdtycy4p88rslnbe', 'admin::project-settings.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.067', '2025-09-27 09:45:10.067', '2025-09-27 09:45:10.067', NULL, NULL, NULL),
	(64, 'kov9ibfihw0w6oa7cem1duzw', 'admin::transfer.tokens.access', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.069', '2025-09-27 09:45:10.069', '2025-09-27 09:45:10.069', NULL, NULL, NULL),
	(65, 'guppi43cxp4elnkfe44vzzay', 'admin::transfer.tokens.create', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.072', '2025-09-27 09:45:10.072', '2025-09-27 09:45:10.073', NULL, NULL, NULL),
	(66, 'ji740zlle9qzli1ac1d7rmwv', 'admin::transfer.tokens.read', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.075', '2025-09-27 09:45:10.075', '2025-09-27 09:45:10.075', NULL, NULL, NULL),
	(67, 'r236yio0spivjdpsuevgb4n0', 'admin::transfer.tokens.update', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.077', '2025-09-27 09:45:10.077', '2025-09-27 09:45:10.077', NULL, NULL, NULL),
	(68, 'pw5rqlp9apu90cn58qtwhq8a', 'admin::transfer.tokens.regenerate', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.079', '2025-09-27 09:45:10.079', '2025-09-27 09:45:10.079', NULL, NULL, NULL),
	(69, 'w9kxi4l1pgvp9ekaijsgz9f8', 'admin::transfer.tokens.delete', '{}', NULL, '{}', '[]', '2025-09-27 09:45:10.082', '2025-09-27 09:45:10.082', '2025-09-27 09:45:10.082', NULL, NULL, NULL);

INSERT INTO public.admin_permissions_role_lnk VALUES
	(1, 1, 2, 1),
	(2, 2, 2, 2),
	(3, 3, 2, 3),
	(4, 4, 2, 4),
	(5, 5, 2, 5),
	(6, 6, 2, 6),
	(7, 7, 3, 1),
	(8, 8, 3, 2),
	(9, 9, 3, 3),
	(10, 10, 3, 4),
	(11, 11, 3, 5),
	(12, 12, 3, 6),
	(13, 13, 1, 1),
	(14, 14, 1, 2),
	(15, 15, 1, 3),
	(16, 16, 1, 4),
	(17, 17, 1, 5),
	(18, 18, 1, 6),
	(19, 19, 1, 7),
	(20, 20, 1, 8),
	(21, 21, 1, 9),
	(22, 22, 1, 10),
	(23, 23, 1, 11),
	(24, 24, 1, 12),
	(25, 25, 1, 13),
	(26, 26, 1, 14),
	(27, 27, 1, 15),
	(28, 28, 1, 16),
	(29, 29, 1, 17),
	(30, 30, 1, 18),
	(31, 31, 1, 19),
	(32, 32, 1, 20),
	(33, 33, 1, 21),
	(34, 34, 1, 22),
	(35, 35, 1, 23),
	(36, 36, 1, 24),
	(37, 37, 1, 25),
	(38, 38, 1, 26),
	(39, 39, 1, 27),
	(40, 40, 1, 28),
	(41, 41, 1, 29),
	(42, 42, 1, 30),
	(43, 43, 1, 31),
	(44, 44, 1, 32),
	(45, 45, 1, 33),
	(46, 46, 1, 34),
	(47, 47, 1, 35),
	(48, 48, 1, 36),
	(49, 49, 1, 37),
	(50, 50, 1, 38),
	(51, 51, 1, 39),
	(52, 52, 1, 40),
	(53, 53, 1, 41),
	(54, 54, 1, 42),
	(55, 55, 1, 43),
	(56, 56, 1, 44),
	(57, 57, 1, 45),
	(58, 58, 1, 46),
	(59, 59, 1, 47),
	(60, 60, 1, 48),
	(61, 61, 1, 49),
	(62, 62, 1, 50),
	(63, 63, 1, 51),
	(64, 64, 1, 52),
	(65, 65, 1, 53),
	(66, 66, 1, 54),
	(67, 67, 1, 55),
	(68, 68, 1, 56),
	(69, 69, 1, 57),
	(70, 70, 1, 58);

INSERT INTO public.admin_roles VALUES
	(1, 'soei2zk14grfyhfjggkkm0rq', 'Super Admin', 'strapi-super-admin', 'Super Admins can access and manage all features and settings.', '2025-09-27 09:45:09.825', '2025-09-27 09:45:09.825', '2025-09-27 09:45:09.825', NULL, NULL, NULL),
	(2, 'n04om30oyqk16kypjpb8sdgp', 'Editor', 'strapi-editor', 'Editors can manage and publish contents including those of other users.', '2025-09-27 09:45:09.829', '2025-09-27 09:45:09.829', '2025-09-27 09:45:09.829', NULL, NULL, NULL),
	(3, 'b79oalflmazy597q3jj6qnyn', 'Author', 'strapi-author', 'Authors can manage the content they have created.', '2025-09-27 09:45:09.831', '2025-09-27 09:45:09.831', '2025-09-27 09:45:09.831', NULL, NULL, NULL);

INSERT INTO public.admin_users VALUES
	(1, 'c4c0m0aeqb7igfevlnel8lay', 'Femina', 'FIt', NULL, 'opurexortus@gmail.com', '$2a$10$CVvFO2BnnZTiJxRero0WveWDp/7BtHyXctPF9hA/TNYuVB.jSHUR.', NULL, NULL, true, false, NULL, '2025-09-27 09:51:31.5', '2025-09-27 09:51:31.5', '2025-09-27 09:51:31.501', NULL, NULL, NULL);

INSERT INTO public.admin_users_roles_lnk VALUES
	(1, 1, 1, 1, 1);

INSERT INTO public.class_schedules VALUES
	('93d42cc5-a235-4f49-acb8-8f0773803ec0', 'e0fbe966-dbeb-412e-b838-aca5cc69ce76', 1, '07:00', '08:00', '2025-10-01 05:31:16.622242'),
	('27d5a5c1-5d0d-4c23-9e69-cfbb477d117b', 'e0fbe966-dbeb-412e-b838-aca5cc69ce76', 3, '07:00', '08:00', '2025-10-01 05:31:16.625845'),
	('70a1a912-a2cb-4d70-bbf0-36d55bcb64ff', '80430703-0bee-43eb-aaae-acbfb1c4fe5b', 2, '18:00', '18:45', '2025-10-01 05:31:16.627192'),
	('4bbe7ac5-3acd-478f-aa9a-66e574f817b6', '80430703-0bee-43eb-aaae-acbfb1c4fe5b', 4, '18:00', '18:45', '2025-10-01 05:31:16.629039'),
	('d28aafb1-0fd7-4a98-ba5e-7f6e132d8604', 'f9981712-f76b-4397-a524-bb53acba657a', 5, '19:00', '19:50', '2025-10-01 05:31:16.631627');

INSERT INTO public.contact_submissions VALUES
	('d9424e8d-41a7-42d7-bf4d-91626a8c079f', 'Test User', 'test@example.com', '123456789', 'This is a test message', 'new', '2025-10-01 05:31:16.632627');

INSERT INTO public.fitness_classes VALUES
	('e0fbe966-dbeb-412e-b838-aca5cc69ce76', 'Morning Yoga', 'Start your day with calming yoga poses and breathing techniques', 60, 'beginner', 'Sarah Johnson', 20, NULL, true, '2025-10-01 05:31:16.591451'),
	('80430703-0bee-43eb-aaae-acbfb1c4fe5b', 'HIIT Training', 'High-intensity interval training to burn calories and build strength', 45, 'intermediate', 'Mike Williams', 15, NULL, true, '2025-10-01 05:31:16.592543'),
	('f9981712-f76b-4397-a524-bb53acba657a', 'Pilates Core', 'Focus on core strength and stability with pilates exercises', 50, 'advanced', 'Emma Davis', 12, NULL, true, '2025-10-01 05:31:16.593299');

INSERT INTO public.i18n_locale VALUES
	(1, 'nhk9fzkct7uluah55ed9dmfh', 'English (en)', 'en', '2025-09-27 09:45:09.765', '2025-09-27 09:45:09.765', '2025-09-27 09:45:09.765', NULL, NULL, NULL);

INSERT INTO public.membership_plans VALUES
	('1adcbbfd-85cc-49c2-911b-624f1239f4a5', 'Basic Plan', 'Access to gym facilities during standard hours', 1500.00, 30, '[\"Gym access 6am-10pm\", \"1 free class per week\", \"Locker access\"]', false, true, '2025-10-01 05:31:16.633784'),
	('48b29d11-3d08-4b43-8fdf-9e7d44163e52', 'Premium Plan', 'Unlimited access to all facilities and classes', 3000.00, 30, '[\"24/7 gym access\", \"Unlimited classes\", \"Personal locker\", \"1 personal training session/month\"]', true, true, '2025-10-01 05:31:16.635392'),
	('7b86054a-5409-4f02-8da3-66067b6ca66b', 'VIP Plan', 'Premium access with additional perks', 5000.00, 30, '[\"24/7 gym access\", \"Unlimited classes\", \"Premium locker\", \"3 personal training sessions/month\", \"Access to VIP lounge\"]', false, true, '2025-10-01 05:31:16.636761');

INSERT INTO public.newsletter_subscriptions VALUES
	('a307e3c1-7132-4638-b6b9-6727572e74c5', 'subscriber@example.com', true, '2025-10-01 05:31:16.637764');

INSERT INTO public.order_items VALUES
	('b450b5c6-268d-45e3-840f-330335454f4e', 'c450b5c6-268d-45e3-840f-330335454f4e', '1346ed4f-ce2e-4992-81cb-c0a18c68711c', 2, 2500.00);

INSERT INTO public.orders VALUES
	('c450b5c6-268d-45e3-840f-330335454f4e', '8e4c9771-b8bb-45c1-ba5c-100167b50ff1', 5000.00, 'completed', '{}', '2025-10-01 05:31:16.638765', '2025-10-01 05:31:16.638765');

INSERT INTO public.pages VALUES
	('a44ba82d-bef3-4ddf-96d1-aaa73ef7ecf5', 'about', 'About Us', '{"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Welcome to FeminaFit Gym"}]},{"type":"paragraph","content":[{"type":"text","text":"At FeminaFit, we''re dedicated to providing a supportive and empowering environment for women to achieve their fitness goals. Our state-of-the-art facility offers a wide range of equipment, classes, and personalized training programs designed specifically with women''s health and fitness in mind."}]}]}', 'Learn about FeminaFit Gym and our mission to empower women through fitness', true, '2025-10-01 05:31:16.649762', '2025-10-01 05:31:16.649762'),
	('bf8594ad-dd2d-4966-910e-f1c841cb558a', 'contact', 'Contact Us', '{"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Get in Touch"}]},{"type":"paragraph","content":[{"type":"text","text":"We''d love to hear from you! Reach out to us with any questions or to schedule a tour of our facility."}]}]}', 'Contact information for FeminaFit Gym', true, '2025-10-01 05:31:16.651276', '2025-10-01 05:31:16.651276'),
	('ae7df5dd-81f8-4702-b3e1-91ffebafc9d2', 'privacy', 'Privacy Policy', '{"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Privacy Policy"}]},{"type":"paragraph","content":[{"type":"text","text":"At FeminaFit, we are committed to protecting your privacy and safeguarding your personal information. This Privacy Policy explains how we collect, use, and protect your information when you use our website and services."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Information We Collect"}]},{"type":"paragraph","content":[{"type":"text","text":"We collect information you provide directly to us, such as when you create an account, purchase a membership, or contact us. This may include your name, email address, phone number, and payment information."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"How We Use Your Information"}]},{"type":"paragraph","content":[{"type":"text","text":"We use your information to provide and improve our services, process transactions, communicate with you, and personalize your experience at our facilities."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Data Security"}]},{"type":"paragraph","content":[{"type":"text","text":"We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction."}]},{"type":"paragraph","content":[{"type":"text","text":"For more details about our privacy practices, please contact us at feminafit59@gmail.com"}]}]}', 'Privacy policy for FeminaFit Gym - how we protect your personal information', true, '2025-10-01 05:31:16.652623', '2025-10-01 05:31:16.652623'),
	('4ac9080f-0729-4025-a976-a826816d4be6', 'terms', 'Terms of Service', '{"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Terms of Service"}]},{"type":"paragraph","content":[{"type":"text","text":"Welcome to FeminaFit! These Terms of Service govern your use of our website and services. By accessing or using FeminaFit, you agree to be bound by these terms."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Membership Terms"}]},{"type":"paragraph","content":[{"type":"text","text":"Memberships are personal to you and cannot be transferred. All memberships are subject to our current rates and terms, which may be updated from time to time."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Use of Facilities"}]},{"type":"paragraph","content":[{"type":"text","text":"Members agree to use our facilities safely and responsibly. Members must follow all posted rules and guidelines during their visit."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Cancellation Policy"}]},{"type":"paragraph","content":[{"type":"text","text":"You may cancel your membership with 30 days written notice. Refunds are subject to our refund policy and may vary depending on the type of membership and circumstances of cancellation."}]},{"type":"paragraph","content":[{"type":"text","text":"For questions about our Terms of Service, please contact us at feminafit59@gmail.com"}]}]}', 'Terms of service for FeminaFit Gym - rules and conditions for using our facilities', true, '2025-10-01 05:31:16.653444', '2025-10-01 05:31:16.653444'),
	('a6b03c1f-a6cc-4edb-82b2-178e34e37065', 'refund', 'Refund Policy', '{"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Refund Policy"}]},{"type":"paragraph","content":[{"type":"text","text":"At FeminaFit, we want you to be satisfied with your membership and purchases. Here''s our policy regarding refunds:"}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Membership Refunds"}]},{"type":"paragraph","content":[{"type":"text","text":"Membership fees are generally non-refundable after the first 30 days of membership. Exceptions may be made for documented medical reasons or relocation more than 50km from the facility."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Product Purchases"}]},{"type":"paragraph","content":[{"type":"text","text":"Unopened retail products may be returned within 14 days for a full refund. Opened items may be returned within 7 days if found to be defective."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Class Passes"}]},{"type":"paragraph","content":[{"type":"text","text":"Class passes are non-refundable but may be frozen under documented medical circumstances for up to 3 months."}]},{"type":"paragraph","content":[{"type":"text","text":"To request a refund, please contact our membership services team with your receipt and reason for request."}]}]}', 'Refund policy for FeminaFit Gym - information about returning products and memberships', true, '2025-10-01 05:31:16.654169', '2025-10-01 05:31:16.654169'),
	('81a9d1aa-72a9-4c91-bcc7-7d6c07779c31', 'faq', 'Frequently Asked Questions', '{"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Frequently Asked Questions"}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"What are your operating hours?"}]},{"type":"paragraph","content":[{"type":"text","text":"We are open Monday through Friday from 5:00 AM to 10:00 PM and on weekends from 6:00 AM to 8:00 PM. Holiday hours may vary."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Do you offer day passes?"}]},{"type":"paragraph","content":[{"type":"text","text":"Yes, we offer day passes for KES 500. These can be purchased at the front desk or through our mobile app."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Can I bring a guest?"}]},{"type":"paragraph","content":[{"type":"text","text":"Members can bring guests for KES 700 per visit. VIP members receive 2 complimentary guest passes per month."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Are personal trainers available?"}]},{"type":"paragraph","content":[{"type":"text","text":"Yes, certified personal trainers are available for one-on-one sessions and small group training. Book in advance for the best availability."}]},{"type":"paragraph","content":[{"type":"text","text":"For additional questions not covered here, please contact us directly."}]}]}', 'Frequently asked questions about FeminaFit Gym membership, classes, and services', true, '2025-10-01 05:31:16.655041', '2025-10-01 05:31:16.655041');

INSERT INTO public.payments VALUES
	('d450b5c6-268d-45e3-840f-330335454f4e', 'c450b5c6-268d-45e3-840f-330335454f4e', NULL, 5000.00, 'KES', 'card', 'completed', 'txn_123456', NULL, '{}', '2025-10-01 05:31:16.639765', '2025-10-01 05:31:16.639765');

INSERT INTO public.product_categories VALUES
	('e4a7f7cf-855e-4c02-9290-5a61bb6dd5fc', 'Supplements', 'Protein powders, vitamins and other supplements', NULL, true),
	('dfec4cfe-3b07-4dd5-a1b3-85a2a9f4aada', 'Apparel', 'Gym wear and accessories', NULL, true);

INSERT INTO public.products VALUES
	('1346ed4f-ce2e-4992-81cb-c0a18c68711c', 'Whey Protein 2lbs', 'Premium whey protein powder for muscle recovery', 2500.00, 'e4a7f7cf-855e-4c02-9290-5a61bb6dd5fc', NULL, 25, true, true, '2025-10-01 05:31:16.640769'),
	('b1ed5a83-0b1c-4156-8725-b71a01676b97', 'BCAA 30 Servings', 'Branched-chain amino acids for muscle recovery', 1800.00, 'e4a7f7cf-855e-4c02-9290-5a61bb6dd5fc', NULL, 15, false, true, '2025-10-01 05:31:16.642161'),
	('11e150fc-6201-45d1-99e4-747c4bfab1c2', 'Women''s Sports Bra', 'High-impact sports bra with moisture-wicking fabric', 800.00, 'dfec4cfe-3b07-4dd5-a1b3-85a2a9f4aada', NULL, 30, true, true, '2025-10-01 05:31:16.64341'),
	('ca73b2d3-f4d3-42fc-a09b-5a171ebfc2aa', 'Men''s Gym Shorts', 'Comfortable and flexible gym shorts', 600.00, 'dfec4cfe-3b07-4dd5-a1b3-85a2a9f4aada', NULL, 20, false, true, '2025-10-01 05:31:16.644203');

INSERT INTO public.testimonials VALUES
	('6713045a-fdf6-48b1-b38d-f0f411cbb5aa', 'Lisa Anderson', '@lisa_fit', 'I''ve been a member for 6 months and have seen incredible results. The trainers are knowledgeable and the equipment is top-notch!', 5, NULL, true, '2025-10-01 05:31:16.645243'),
	('05f4a716-6b8f-44fd-9dd1-90297a5e0982', 'Tom Wilson', '@tom_gym_rat', 'The variety of classes keeps me motivated. The HIIT sessions with Mike are particularly challenging and effective.', 4, NULL, true, '2025-10-01 05:31:16.647274'),
	('4a69fa81-43f4-4b29-a093-2f78a5da2624', 'Emma Thompson', '@emma_health', 'As a beginner, I appreciated the welcoming atmosphere. The staff took time to show me how to use the equipment properly.', 5, NULL, false, '2025-10-01 05:31:16.648974');

INSERT INTO public.up_permissions VALUES
	(1, 'jtfmk46rhgsdvupoxl9qkn3h', 'plugin::users-permissions.user.me', '2025-09-27 09:45:09.799', '2025-09-27 09:45:09.799', '2025-09-27 09:45:09.799', NULL, NULL, NULL),
	(2, 'o3rnp1yf40t319ahuvd3m0ow', 'plugin::users-permissions.auth.changePassword', '2025-09-27 09:45:09.799', '2025-09-27 09:45:09.799', '2025-09-27 09:45:09.8', NULL, NULL, NULL),
	(3, 'ox0264eid0o5wa9belwj0kls', 'plugin::users-permissions.auth.callback', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', NULL, NULL, NULL),
	(4, 'x8gd0mqg01y9zapqqqyeqp60', 'plugin::users-permissions.auth.connect', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', NULL, NULL, NULL),
	(5, 'n4z26k4hu9gii72otahnua19', 'plugin::users-permissions.auth.resetPassword', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', NULL, NULL, NULL),
	(6, 'q89iru9mkhs4hc1ou5cxy7oo', 'plugin::users-permissions.auth.forgotPassword', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', NULL, NULL, NULL),
	(7, 'z3z5m4fi0w7jj7qzz9ch77al', 'plugin::users-permissions.auth.register', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', NULL, NULL, NULL),
	(8, 'vezgw0l4p65n9vdiga0eaxax', 'plugin::users-permissions.auth.emailConfirmation', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', NULL, NULL, NULL),
	(9, 'acd6btf34p3sf6i70e5k1zjy', 'plugin::users-permissions.auth.sendEmailConfirmation', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', '2025-09-27 09:45:09.805', NULL, NULL, NULL);

INSERT INTO public.up_permissions_role_lnk VALUES
	(1, 2, 1, 1),
	(2, 1, 1, 1),
	(3, 3, 2, 1),
	(4, 6, 2, 1),
	(5, 7, 2, 1),
	(6, 9, 2, 1),
	(7, 5, 2, 1),
	(8, 4, 2, 1),
	(9, 8, 2, 1);

INSERT INTO public.up_roles VALUES
	(1, 'yugezfwj76wqclc2saezbkrn', 'Authenticated', 'Default role given to authenticated user.', 'authenticated', '2025-09-27 09:45:09.792', '2025-09-27 09:45:09.792', '2025-09-27 09:45:09.793', NULL, NULL, NULL),
	(2, 'ekcxa1t2grfbj8jl1vc3s6cf', 'Public', 'Default role given to unauthenticated user.', 'public', '2025-09-27 09:45:09.795', '2025-09-27 09:45:09.795', '2025-09-27 09:45:09.796', NULL, NULL, NULL);

INSERT INTO public.users VALUES
	('8e4c9771-b8bb-45c1-ba5c-100167b50ff1', 'admin@example.com', '$2b$10$Pe7jFR3jacbXvtqFGTrrbuKnlhj.eZvuaxHr5OiMEbqMSOWb3kIbq', 'Admin', 'User', NULL, 'email', true, '2025-10-01 05:31:16.587389', '2025-10-01 05:31:16.587389', 'admin'),  -- Setting role to admin
	('305663a9-60f5-4d97-b917-4730283b2dc9', 'member@example.com', '$2b$10$Pe7jFR3jacbXvtqFGTrrbuKnlhj.eZvuaxHr5OiMEbqMSOWb3kIbq', 'John', 'Doe', NULL, 'email', true, '2025-10-01 05:31:16.590028', '2025-10-01 05:31:16.590028', 'user');

-- PostgreSQL database dump complete