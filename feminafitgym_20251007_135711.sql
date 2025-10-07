--
-- PostgreSQL database dump
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
-- Name: enum_contact_submissions_status; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_contact_submissions_status AS ENUM (
    'new',
    'responded',
    'closed'
);


ALTER TYPE public.enum_contact_submissions_status OWNER TO anzwa;

--
-- Name: enum_fitness_classes_level; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_fitness_classes_level AS ENUM (
    'beginner',
    'intermediate',
    'advanced'
);


ALTER TYPE public.enum_fitness_classes_level OWNER TO anzwa;

--
-- Name: enum_memberships_status; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_memberships_status AS ENUM (
    'active',
    'expired',
    'cancelled'
);


ALTER TYPE public.enum_memberships_status OWNER TO anzwa;

--
-- Name: enum_orders_status; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_orders_status AS ENUM (
    'pending',
    'paid',
    'shipped',
    'delivered',
    'cancelled'
);


ALTER TYPE public.enum_orders_status OWNER TO anzwa;

--
-- Name: enum_payments_method; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_payments_method AS ENUM (
    'mpesa',
    'card',
    'cash'
);


ALTER TYPE public.enum_payments_method OWNER TO anzwa;

--
-- Name: enum_payments_status; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_payments_status AS ENUM (
    'pending',
    'completed',
    'failed',
    'refunded'
);


ALTER TYPE public.enum_payments_status OWNER TO anzwa;

--
-- Name: enum_users_auth_provider; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_users_auth_provider AS ENUM (
    'replit',
    'email'
);


ALTER TYPE public.enum_users_auth_provider OWNER TO anzwa;

--
-- Name: enum_users_role; Type: TYPE; Schema: public; Owner: anzwa
--

CREATE TYPE public.enum_users_role AS ENUM (
    'user',
    'admin'
);


ALTER TYPE public.enum_users_role OWNER TO anzwa;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: class_schedules; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.class_schedules (
    id integer NOT NULL,
    class_id_id integer NOT NULL,
    day_of_week numeric NOT NULL,
    start_time character varying NOT NULL,
    end_time character varying NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.class_schedules OWNER TO anzwa;

--
-- Name: class_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.class_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.class_schedules_id_seq OWNER TO anzwa;

--
-- Name: class_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.class_schedules_id_seq OWNED BY public.class_schedules.id;


--
-- Name: contact_submissions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.contact_submissions (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying,
    message character varying NOT NULL,
    status public.enum_contact_submissions_status DEFAULT 'new'::public.enum_contact_submissions_status,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.contact_submissions OWNER TO anzwa;

--
-- Name: contact_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.contact_submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contact_submissions_id_seq OWNER TO anzwa;

--
-- Name: contact_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.contact_submissions_id_seq OWNED BY public.contact_submissions.id;


--
-- Name: fitness_classes; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.fitness_classes (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    duration numeric NOT NULL,
    level public.enum_fitness_classes_level NOT NULL,
    instructor character varying,
    max_capacity numeric DEFAULT 20,
    image_url character varying,
    active boolean DEFAULT true,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.fitness_classes OWNER TO anzwa;

--
-- Name: fitness_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.fitness_classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fitness_classes_id_seq OWNER TO anzwa;

--
-- Name: fitness_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.fitness_classes_id_seq OWNED BY public.fitness_classes.id;


--
-- Name: membership_plans; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.membership_plans (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    price numeric NOT NULL,
    duration numeric NOT NULL,
    features jsonb,
    popular boolean DEFAULT false,
    active boolean DEFAULT true,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.membership_plans OWNER TO anzwa;

--
-- Name: membership_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.membership_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membership_plans_id_seq OWNER TO anzwa;

--
-- Name: membership_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.membership_plans_id_seq OWNED BY public.membership_plans.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.memberships (
    id integer NOT NULL,
    user_id_id integer NOT NULL,
    plan_id_id integer NOT NULL,
    start_date timestamp(3) with time zone NOT NULL,
    end_date timestamp(3) with time zone NOT NULL,
    status public.enum_memberships_status DEFAULT 'active'::public.enum_memberships_status NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.memberships OWNER TO anzwa;

--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.memberships_id_seq OWNER TO anzwa;

--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: newsletter_subscriptions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.newsletter_subscriptions (
    id integer NOT NULL,
    email character varying NOT NULL,
    active boolean DEFAULT true,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.newsletter_subscriptions OWNER TO anzwa;

--
-- Name: newsletter_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.newsletter_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.newsletter_subscriptions_id_seq OWNER TO anzwa;

--
-- Name: newsletter_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.newsletter_subscriptions_id_seq OWNED BY public.newsletter_subscriptions.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id_id integer NOT NULL,
    product_id_id integer NOT NULL,
    quantity numeric NOT NULL,
    price numeric NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_items OWNER TO anzwa;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO anzwa;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id_id integer NOT NULL,
    total numeric NOT NULL,
    status public.enum_orders_status DEFAULT 'pending'::public.enum_orders_status NOT NULL,
    shipping_address jsonb,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.orders OWNER TO anzwa;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO anzwa;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    slug character varying NOT NULL,
    title character varying NOT NULL,
    content jsonb NOT NULL,
    meta_description character varying,
    published boolean DEFAULT true,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pages OWNER TO anzwa;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pages_id_seq OWNER TO anzwa;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: payload_locked_documents; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.payload_locked_documents (
    id integer NOT NULL,
    global_slug character varying,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payload_locked_documents OWNER TO anzwa;

--
-- Name: payload_locked_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.payload_locked_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_locked_documents_id_seq OWNER TO anzwa;

--
-- Name: payload_locked_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.payload_locked_documents_id_seq OWNED BY public.payload_locked_documents.id;


--
-- Name: payload_locked_documents_rels; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.payload_locked_documents_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    users_id integer,
    pages_id integer,
    products_id integer,
    product_categories_id integer,
    fitness_classes_id integer,
    class_schedules_id integer,
    membership_plans_id integer,
    testimonials_id integer,
    memberships_id integer,
    orders_id integer,
    order_items_id integer,
    payments_id integer,
    newsletter_subscriptions_id integer,
    contact_submissions_id integer
);


ALTER TABLE public.payload_locked_documents_rels OWNER TO anzwa;

--
-- Name: payload_locked_documents_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.payload_locked_documents_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_locked_documents_rels_id_seq OWNER TO anzwa;

--
-- Name: payload_locked_documents_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.payload_locked_documents_rels_id_seq OWNED BY public.payload_locked_documents_rels.id;


--
-- Name: payload_migrations; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.payload_migrations (
    id integer NOT NULL,
    name character varying,
    batch numeric,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payload_migrations OWNER TO anzwa;

--
-- Name: payload_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.payload_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_migrations_id_seq OWNER TO anzwa;

--
-- Name: payload_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.payload_migrations_id_seq OWNED BY public.payload_migrations.id;


--
-- Name: payload_preferences; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.payload_preferences (
    id integer NOT NULL,
    key character varying,
    value jsonb,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payload_preferences OWNER TO anzwa;

--
-- Name: payload_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.payload_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_preferences_id_seq OWNER TO anzwa;

--
-- Name: payload_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.payload_preferences_id_seq OWNED BY public.payload_preferences.id;


--
-- Name: payload_preferences_rels; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.payload_preferences_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    users_id integer
);


ALTER TABLE public.payload_preferences_rels OWNER TO anzwa;

--
-- Name: payload_preferences_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.payload_preferences_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_preferences_rels_id_seq OWNER TO anzwa;

--
-- Name: payload_preferences_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.payload_preferences_rels_id_seq OWNED BY public.payload_preferences_rels.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    order_id_id integer,
    membership_id_id integer,
    amount numeric NOT NULL,
    currency character varying DEFAULT 'KES'::character varying,
    method public.enum_payments_method NOT NULL,
    status public.enum_payments_status DEFAULT 'pending'::public.enum_payments_status NOT NULL,
    transaction_id character varying,
    phone_number character varying,
    mpesa_data jsonb,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payments OWNER TO anzwa;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO anzwa;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.product_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    image_url character varying,
    active boolean DEFAULT true,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_categories OWNER TO anzwa;

--
-- Name: product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.product_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_categories_id_seq OWNER TO anzwa;

--
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.product_categories_id_seq OWNED BY public.product_categories.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    price numeric NOT NULL,
    category_id_id integer,
    image_url character varying,
    stock numeric DEFAULT 0,
    featured boolean DEFAULT false,
    active boolean DEFAULT true,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.products OWNER TO anzwa;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO anzwa;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: testimonials; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.testimonials (
    id integer NOT NULL,
    name character varying NOT NULL,
    username character varying,
    text character varying NOT NULL,
    rating numeric DEFAULT 5,
    image_url character varying,
    featured boolean DEFAULT false,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.testimonials OWNER TO anzwa;

--
-- Name: testimonials_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.testimonials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.testimonials_id_seq OWNER TO anzwa;

--
-- Name: testimonials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.testimonials_id_seq OWNED BY public.testimonials.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    profile_image_url character varying,
    auth_provider public.enum_users_auth_provider DEFAULT 'replit'::public.enum_users_auth_provider,
    email_verified boolean DEFAULT false,
    role public.enum_users_role DEFAULT 'user'::public.enum_users_role,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    email character varying NOT NULL,
    reset_password_token character varying,
    reset_password_expiration timestamp(3) with time zone,
    salt character varying,
    hash character varying,
    login_attempts numeric DEFAULT 0,
    lock_until timestamp(3) with time zone
);


ALTER TABLE public.users OWNER TO anzwa;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: anzwa
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO anzwa;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anzwa
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_sessions; Type: TABLE; Schema: public; Owner: anzwa
--

CREATE TABLE public.users_sessions (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    created_at timestamp(3) with time zone,
    expires_at timestamp(3) with time zone NOT NULL
);


ALTER TABLE public.users_sessions OWNER TO anzwa;

--
-- Name: class_schedules id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.class_schedules ALTER COLUMN id SET DEFAULT nextval('public.class_schedules_id_seq'::regclass);


--
-- Name: contact_submissions id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.contact_submissions ALTER COLUMN id SET DEFAULT nextval('public.contact_submissions_id_seq'::regclass);


--
-- Name: fitness_classes id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.fitness_classes ALTER COLUMN id SET DEFAULT nextval('public.fitness_classes_id_seq'::regclass);


--
-- Name: membership_plans id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.membership_plans ALTER COLUMN id SET DEFAULT nextval('public.membership_plans_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: newsletter_subscriptions id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.newsletter_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.newsletter_subscriptions_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: payload_locked_documents id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents ALTER COLUMN id SET DEFAULT nextval('public.payload_locked_documents_id_seq'::regclass);


--
-- Name: payload_locked_documents_rels id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels ALTER COLUMN id SET DEFAULT nextval('public.payload_locked_documents_rels_id_seq'::regclass);


--
-- Name: payload_migrations id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_migrations ALTER COLUMN id SET DEFAULT nextval('public.payload_migrations_id_seq'::regclass);


--
-- Name: payload_preferences id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_preferences ALTER COLUMN id SET DEFAULT nextval('public.payload_preferences_id_seq'::regclass);


--
-- Name: payload_preferences_rels id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_preferences_rels ALTER COLUMN id SET DEFAULT nextval('public.payload_preferences_rels_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: product_categories id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.product_categories ALTER COLUMN id SET DEFAULT nextval('public.product_categories_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: testimonials id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.testimonials ALTER COLUMN id SET DEFAULT nextval('public.testimonials_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: class_schedules; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: contact_submissions; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: fitness_classes; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: membership_plans; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: memberships; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: newsletter_subscriptions; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: payload_locked_documents; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: payload_locked_documents_rels; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: payload_migrations; Type: TABLE DATA; Schema: public; Owner: anzwa
--

INSERT INTO public.payload_migrations VALUES
	(1, '20251001_185011', 1, '2025-10-02 15:24:37.768+03', '2025-10-02 15:24:37.766+03'),
	(2, 'dev', -1, '2025-10-05 05:33:16.022+03', '2025-10-02 15:41:25.959+03');


--
-- Data for Name: payload_preferences; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: payload_preferences_rels; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: testimonials; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: anzwa
--

INSERT INTO public.users VALUES
	(1, 'Admin', 'User', NULL, 'email', true, 'admin', '2025-10-02 16:13:17.937+03', '2025-10-02 16:13:17.937+03', 'admin@example.com', NULL, NULL, '10', '$2b$10$wDSiSonIQwEZMcB90sJvcu0032gq2CDs.AxVvtOhrghOKMk2yvWP.', 0, NULL);


--
-- Data for Name: users_sessions; Type: TABLE DATA; Schema: public; Owner: anzwa
--



--
-- Name: class_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.class_schedules_id_seq', 1, false);


--
-- Name: contact_submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.contact_submissions_id_seq', 1, false);


--
-- Name: fitness_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.fitness_classes_id_seq', 1, false);


--
-- Name: membership_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.membership_plans_id_seq', 1, false);


--
-- Name: memberships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.memberships_id_seq', 1, false);


--
-- Name: newsletter_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.newsletter_subscriptions_id_seq', 1, false);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.pages_id_seq', 1, false);


--
-- Name: payload_locked_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.payload_locked_documents_id_seq', 1, false);


--
-- Name: payload_locked_documents_rels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.payload_locked_documents_rels_id_seq', 1, false);


--
-- Name: payload_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.payload_migrations_id_seq', 2, true);


--
-- Name: payload_preferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.payload_preferences_id_seq', 1, false);


--
-- Name: payload_preferences_rels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.payload_preferences_rels_id_seq', 1, false);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: product_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.product_categories_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.products_id_seq', 1, false);


--
-- Name: testimonials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.testimonials_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anzwa
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: class_schedules class_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.class_schedules
    ADD CONSTRAINT class_schedules_pkey PRIMARY KEY (id);


--
-- Name: contact_submissions contact_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.contact_submissions
    ADD CONSTRAINT contact_submissions_pkey PRIMARY KEY (id);


--
-- Name: fitness_classes fitness_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.fitness_classes
    ADD CONSTRAINT fitness_classes_pkey PRIMARY KEY (id);


--
-- Name: membership_plans membership_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.membership_plans
    ADD CONSTRAINT membership_plans_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: newsletter_subscriptions newsletter_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.newsletter_subscriptions
    ADD CONSTRAINT newsletter_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: payload_locked_documents payload_locked_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents
    ADD CONSTRAINT payload_locked_documents_pkey PRIMARY KEY (id);


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_pkey PRIMARY KEY (id);


--
-- Name: payload_migrations payload_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_migrations
    ADD CONSTRAINT payload_migrations_pkey PRIMARY KEY (id);


--
-- Name: payload_preferences payload_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_preferences
    ADD CONSTRAINT payload_preferences_pkey PRIMARY KEY (id);


--
-- Name: payload_preferences_rels payload_preferences_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_preferences_rels
    ADD CONSTRAINT payload_preferences_rels_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: testimonials testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.testimonials
    ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_sessions users_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.users_sessions
    ADD CONSTRAINT users_sessions_pkey PRIMARY KEY (id);


--
-- Name: class_schedules_class_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX class_schedules_class_id_idx ON public.class_schedules USING btree (class_id_id);


--
-- Name: class_schedules_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX class_schedules_created_at_idx ON public.class_schedules USING btree (created_at);


--
-- Name: class_schedules_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX class_schedules_updated_at_idx ON public.class_schedules USING btree (updated_at);


--
-- Name: contact_submissions_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX contact_submissions_created_at_idx ON public.contact_submissions USING btree (created_at);


--
-- Name: contact_submissions_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX contact_submissions_updated_at_idx ON public.contact_submissions USING btree (updated_at);


--
-- Name: fitness_classes_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX fitness_classes_created_at_idx ON public.fitness_classes USING btree (created_at);


--
-- Name: fitness_classes_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX fitness_classes_updated_at_idx ON public.fitness_classes USING btree (updated_at);


--
-- Name: membership_plans_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX membership_plans_created_at_idx ON public.membership_plans USING btree (created_at);


--
-- Name: membership_plans_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX membership_plans_updated_at_idx ON public.membership_plans USING btree (updated_at);


--
-- Name: memberships_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX memberships_created_at_idx ON public.memberships USING btree (created_at);


--
-- Name: memberships_plan_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX memberships_plan_id_idx ON public.memberships USING btree (plan_id_id);


--
-- Name: memberships_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX memberships_updated_at_idx ON public.memberships USING btree (updated_at);


--
-- Name: memberships_user_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX memberships_user_id_idx ON public.memberships USING btree (user_id_id);


--
-- Name: newsletter_subscriptions_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX newsletter_subscriptions_created_at_idx ON public.newsletter_subscriptions USING btree (created_at);


--
-- Name: newsletter_subscriptions_email_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE UNIQUE INDEX newsletter_subscriptions_email_idx ON public.newsletter_subscriptions USING btree (email);


--
-- Name: newsletter_subscriptions_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX newsletter_subscriptions_updated_at_idx ON public.newsletter_subscriptions USING btree (updated_at);


--
-- Name: order_items_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX order_items_created_at_idx ON public.order_items USING btree (created_at);


--
-- Name: order_items_order_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX order_items_order_id_idx ON public.order_items USING btree (order_id_id);


--
-- Name: order_items_product_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX order_items_product_id_idx ON public.order_items USING btree (product_id_id);


--
-- Name: order_items_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX order_items_updated_at_idx ON public.order_items USING btree (updated_at);


--
-- Name: orders_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX orders_created_at_idx ON public.orders USING btree (created_at);


--
-- Name: orders_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX orders_updated_at_idx ON public.orders USING btree (updated_at);


--
-- Name: orders_user_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX orders_user_id_idx ON public.orders USING btree (user_id_id);


--
-- Name: pages_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX pages_created_at_idx ON public.pages USING btree (created_at);


--
-- Name: pages_slug_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE UNIQUE INDEX pages_slug_idx ON public.pages USING btree (slug);


--
-- Name: pages_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX pages_updated_at_idx ON public.pages USING btree (updated_at);


--
-- Name: payload_locked_documents_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_created_at_idx ON public.payload_locked_documents USING btree (created_at);


--
-- Name: payload_locked_documents_global_slug_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_global_slug_idx ON public.payload_locked_documents USING btree (global_slug);


--
-- Name: payload_locked_documents_rels_class_schedules_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_class_schedules_id_idx ON public.payload_locked_documents_rels USING btree (class_schedules_id);


--
-- Name: payload_locked_documents_rels_contact_submissions_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_contact_submissions_id_idx ON public.payload_locked_documents_rels USING btree (contact_submissions_id);


--
-- Name: payload_locked_documents_rels_fitness_classes_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_fitness_classes_id_idx ON public.payload_locked_documents_rels USING btree (fitness_classes_id);


--
-- Name: payload_locked_documents_rels_membership_plans_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_membership_plans_id_idx ON public.payload_locked_documents_rels USING btree (membership_plans_id);


--
-- Name: payload_locked_documents_rels_memberships_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_memberships_id_idx ON public.payload_locked_documents_rels USING btree (memberships_id);


--
-- Name: payload_locked_documents_rels_newsletter_subscriptions_i_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_newsletter_subscriptions_i_idx ON public.payload_locked_documents_rels USING btree (newsletter_subscriptions_id);


--
-- Name: payload_locked_documents_rels_order_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_order_idx ON public.payload_locked_documents_rels USING btree ("order");


--
-- Name: payload_locked_documents_rels_order_items_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_order_items_id_idx ON public.payload_locked_documents_rels USING btree (order_items_id);


--
-- Name: payload_locked_documents_rels_orders_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_orders_id_idx ON public.payload_locked_documents_rels USING btree (orders_id);


--
-- Name: payload_locked_documents_rels_pages_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_pages_id_idx ON public.payload_locked_documents_rels USING btree (pages_id);


--
-- Name: payload_locked_documents_rels_parent_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_parent_idx ON public.payload_locked_documents_rels USING btree (parent_id);


--
-- Name: payload_locked_documents_rels_path_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_path_idx ON public.payload_locked_documents_rels USING btree (path);


--
-- Name: payload_locked_documents_rels_payments_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_payments_id_idx ON public.payload_locked_documents_rels USING btree (payments_id);


--
-- Name: payload_locked_documents_rels_product_categories_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_product_categories_id_idx ON public.payload_locked_documents_rels USING btree (product_categories_id);


--
-- Name: payload_locked_documents_rels_products_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_products_id_idx ON public.payload_locked_documents_rels USING btree (products_id);


--
-- Name: payload_locked_documents_rels_testimonials_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_testimonials_id_idx ON public.payload_locked_documents_rels USING btree (testimonials_id);


--
-- Name: payload_locked_documents_rels_users_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_rels_users_id_idx ON public.payload_locked_documents_rels USING btree (users_id);


--
-- Name: payload_locked_documents_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_locked_documents_updated_at_idx ON public.payload_locked_documents USING btree (updated_at);


--
-- Name: payload_migrations_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_migrations_created_at_idx ON public.payload_migrations USING btree (created_at);


--
-- Name: payload_migrations_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_migrations_updated_at_idx ON public.payload_migrations USING btree (updated_at);


--
-- Name: payload_preferences_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_preferences_created_at_idx ON public.payload_preferences USING btree (created_at);


--
-- Name: payload_preferences_key_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_preferences_key_idx ON public.payload_preferences USING btree (key);


--
-- Name: payload_preferences_rels_order_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_preferences_rels_order_idx ON public.payload_preferences_rels USING btree ("order");


--
-- Name: payload_preferences_rels_parent_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_preferences_rels_parent_idx ON public.payload_preferences_rels USING btree (parent_id);


--
-- Name: payload_preferences_rels_path_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_preferences_rels_path_idx ON public.payload_preferences_rels USING btree (path);


--
-- Name: payload_preferences_rels_users_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_preferences_rels_users_id_idx ON public.payload_preferences_rels USING btree (users_id);


--
-- Name: payload_preferences_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payload_preferences_updated_at_idx ON public.payload_preferences USING btree (updated_at);


--
-- Name: payments_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payments_created_at_idx ON public.payments USING btree (created_at);


--
-- Name: payments_membership_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payments_membership_id_idx ON public.payments USING btree (membership_id_id);


--
-- Name: payments_order_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payments_order_id_idx ON public.payments USING btree (order_id_id);


--
-- Name: payments_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX payments_updated_at_idx ON public.payments USING btree (updated_at);


--
-- Name: product_categories_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX product_categories_created_at_idx ON public.product_categories USING btree (created_at);


--
-- Name: product_categories_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX product_categories_updated_at_idx ON public.product_categories USING btree (updated_at);


--
-- Name: products_category_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX products_category_id_idx ON public.products USING btree (category_id_id);


--
-- Name: products_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX products_created_at_idx ON public.products USING btree (created_at);


--
-- Name: products_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX products_updated_at_idx ON public.products USING btree (updated_at);


--
-- Name: testimonials_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX testimonials_created_at_idx ON public.testimonials USING btree (created_at);


--
-- Name: testimonials_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX testimonials_updated_at_idx ON public.testimonials USING btree (updated_at);


--
-- Name: users_created_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX users_created_at_idx ON public.users USING btree (created_at);


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE UNIQUE INDEX users_email_idx ON public.users USING btree (email);


--
-- Name: users_sessions_order_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX users_sessions_order_idx ON public.users_sessions USING btree (_order);


--
-- Name: users_sessions_parent_id_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX users_sessions_parent_id_idx ON public.users_sessions USING btree (_parent_id);


--
-- Name: users_updated_at_idx; Type: INDEX; Schema: public; Owner: anzwa
--

CREATE INDEX users_updated_at_idx ON public.users USING btree (updated_at);


--
-- Name: class_schedules class_schedules_class_id_id_fitness_classes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.class_schedules
    ADD CONSTRAINT class_schedules_class_id_id_fitness_classes_id_fk FOREIGN KEY (class_id_id) REFERENCES public.fitness_classes(id) ON DELETE SET NULL;


--
-- Name: memberships memberships_plan_id_id_membership_plans_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_plan_id_id_membership_plans_id_fk FOREIGN KEY (plan_id_id) REFERENCES public.membership_plans(id) ON DELETE SET NULL;


--
-- Name: memberships memberships_user_id_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_user_id_id_users_id_fk FOREIGN KEY (user_id_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_order_id_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_id_orders_id_fk FOREIGN KEY (order_id_id) REFERENCES public.orders(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_product_id_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_id_products_id_fk FOREIGN KEY (product_id_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: orders orders_user_id_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_id_users_id_fk FOREIGN KEY (user_id_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_class_schedules_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_class_schedules_fk FOREIGN KEY (class_schedules_id) REFERENCES public.class_schedules(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_contact_submissions_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_contact_submissions_fk FOREIGN KEY (contact_submissions_id) REFERENCES public.contact_submissions(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_fitness_classes_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_fitness_classes_fk FOREIGN KEY (fitness_classes_id) REFERENCES public.fitness_classes(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_membership_plans_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_membership_plans_fk FOREIGN KEY (membership_plans_id) REFERENCES public.membership_plans(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_memberships_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_memberships_fk FOREIGN KEY (memberships_id) REFERENCES public.memberships(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_newsletter_subscriptions_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_newsletter_subscriptions_fk FOREIGN KEY (newsletter_subscriptions_id) REFERENCES public.newsletter_subscriptions(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_order_items_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_order_items_fk FOREIGN KEY (order_items_id) REFERENCES public.order_items(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_orders_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_orders_fk FOREIGN KEY (orders_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_pages_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_pages_fk FOREIGN KEY (pages_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.payload_locked_documents(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_payments_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_payments_fk FOREIGN KEY (payments_id) REFERENCES public.payments(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_product_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_product_categories_fk FOREIGN KEY (product_categories_id) REFERENCES public.product_categories(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_products_fk FOREIGN KEY (products_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_testimonials_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_testimonials_fk FOREIGN KEY (testimonials_id) REFERENCES public.testimonials(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_users_fk FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payload_preferences_rels payload_preferences_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_preferences_rels
    ADD CONSTRAINT payload_preferences_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.payload_preferences(id) ON DELETE CASCADE;


--
-- Name: payload_preferences_rels payload_preferences_rels_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payload_preferences_rels
    ADD CONSTRAINT payload_preferences_rels_users_fk FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payments payments_membership_id_id_memberships_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_membership_id_id_memberships_id_fk FOREIGN KEY (membership_id_id) REFERENCES public.memberships(id) ON DELETE SET NULL;


--
-- Name: payments payments_order_id_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_id_orders_id_fk FOREIGN KEY (order_id_id) REFERENCES public.orders(id) ON DELETE SET NULL;


--
-- Name: products products_category_id_id_product_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_id_product_categories_id_fk FOREIGN KEY (category_id_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;


--
-- Name: users_sessions users_sessions_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: anzwa
--

ALTER TABLE ONLY public.users_sessions
    ADD CONSTRAINT users_sessions_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

