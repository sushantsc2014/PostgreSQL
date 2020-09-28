--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

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
-- Name: production; Type: SCHEMA; Schema: -; Owner: store_admin
--

CREATE SCHEMA production;


ALTER SCHEMA production OWNER TO store_admin;

--
-- Name: sales; Type: SCHEMA; Schema: -; Owner: store_admin
--

CREATE SCHEMA sales;


ALTER SCHEMA sales OWNER TO store_admin;

--
-- Name: trigger_tables; Type: SCHEMA; Schema: -; Owner: store_admin
--

CREATE SCHEMA trigger_tables;


ALTER SCHEMA trigger_tables OWNER TO store_admin;

--
-- Name: model_year_check(); Type: FUNCTION; Schema: production; Owner: postgres
--

CREATE FUNCTION production.model_year_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
  IF NEW.model_year < 2009 THEN 
    RAISE EXCEPTION 'cannot have this olb bike'; 
  END IF; 
  return new; 
END;
$$;


ALTER FUNCTION production.model_year_check() OWNER TO postgres;

--
-- Name: quamtity_track_in_store(); Type: FUNCTION; Schema: production; Owner: postgres
--

CREATE FUNCTION production.quamtity_track_in_store() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	begin
		CASE
			when old.product_id='1245' and new.quantity<=10 then
				insert into production.quantity_track values (old.store_id,old.product_id,10-new.quantity);
			when old.product_id='1289' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,20-new.quantity);
			when old.product_id='1549' and new.quantity<=15 then
				insert into production.quantity_track values (old.store_id,old.product_id,15-new.quantity);				
			when old.product_id='1537' and new.quantity<=2 then
				insert into production.quantity_track values (old.store_id,old.product_id,2-new.quantity);
			when old.product_id='1149' and new.quantity<=20 then
				insert into production.quantity_track values (old.store_id,old.product_id,20-new.quantity);
			when old.product_id='1005' and new.quantity<=60 then
				insert into production.quantity_track values (old.store_id,old.product_id,60-new.quantity);
			else null;
				
		END CASE;
	return new;
END
$$;


ALTER FUNCTION production.quamtity_track_in_store() OWNER TO postgres;

--
-- Name: order_city_check(); Type: FUNCTION; Schema: sales; Owner: store_admin
--

CREATE FUNCTION sales.order_city_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	city_1 varchar(20) default (select city from sales.customer where customer_id=new.customer_id);
	city_2 varchar(20) default (select city from sales.stores where store_id=new.store_id);
	store_id_1 int default (select store_id from sales.stores where city=city_1); 	
	begin
		if city_1<>city_2 then
			insert into trigger_tables.order_city_check values (new.order_id, new.customer_id, new.store_id, city_1, city_2, store_id_1);
		end if;
	return new;
END
$$;


ALTER FUNCTION sales.order_city_check() OWNER TO store_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: products; Type: TABLE; Schema: production; Owner: store_admin
--

CREATE TABLE production.products (
    production_id integer NOT NULL,
    product_name character varying(50) NOT NULL,
    model_year integer NOT NULL,
    price numeric(9,2) NOT NULL
);


ALTER TABLE production.products OWNER TO store_admin;

--
-- Name: quantity_track; Type: TABLE; Schema: production; Owner: postgres
--

CREATE TABLE production.quantity_track (
    store_id integer,
    product_id integer,
    quantity_to_fill integer
);


ALTER TABLE production.quantity_track OWNER TO postgres;

--
-- Name: stocks; Type: TABLE; Schema: production; Owner: store_admin
--

CREATE TABLE production.stocks (
    store_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer
);


ALTER TABLE production.stocks OWNER TO store_admin;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: sales; Owner: store_admin
--

CREATE SEQUENCE sales.customer_id_seq
    START WITH 1101
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE sales.customer_id_seq OWNER TO store_admin;

--
-- Name: customer; Type: TABLE; Schema: sales; Owner: store_admin
--

CREATE TABLE sales.customer (
    customer_id integer DEFAULT nextval('sales.customer_id_seq'::regclass) NOT NULL,
    first_name character varying(10) NOT NULL,
    last_name character varying(15) NOT NULL,
    phone character varying(10) NOT NULL,
    email_id character varying(50),
    city character varying(20) NOT NULL,
    state character varying(20) NOT NULL
);


ALTER TABLE sales.customer OWNER TO store_admin;

--
-- Name: order_items; Type: TABLE; Schema: sales; Owner: store_admin
--

CREATE TABLE sales.order_items (
    order_id integer NOT NULL,
    item_id character varying(10) NOT NULL,
    product_id integer,
    quantity character varying(10) NOT NULL,
    price numeric(11,2) NOT NULL
);


ALTER TABLE sales.order_items OWNER TO store_admin;

--
-- Name: orders; Type: TABLE; Schema: sales; Owner: store_admin
--

CREATE TABLE sales.orders (
    order_id integer NOT NULL,
    customer_id integer,
    order_status text,
    order_date date DEFAULT CURRENT_DATE,
    store_id integer,
    product_id integer,
    CONSTRAINT order_check CHECK ((order_status = ANY (ARRAY['Pending'::text, 'Processing'::text, 'Rejected'::text, 'Completed'::text])))
);


ALTER TABLE sales.orders OWNER TO store_admin;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: sales; Owner: store_admin
--

CREATE SEQUENCE sales.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.orders_order_id_seq OWNER TO store_admin;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: store_admin
--

ALTER SEQUENCE sales.orders_order_id_seq OWNED BY sales.orders.order_id;


--
-- Name: stores; Type: TABLE; Schema: sales; Owner: store_admin
--

CREATE TABLE sales.stores (
    store_id integer NOT NULL,
    store_name character varying(20) NOT NULL,
    phone_no character varying(15),
    city character varying(20) NOT NULL,
    state character varying(20) NOT NULL
);


ALTER TABLE sales.stores OWNER TO store_admin;

--
-- Name: order_city_check; Type: TABLE; Schema: trigger_tables; Owner: store_admin
--

CREATE TABLE trigger_tables.order_city_check (
    order_id integer,
    customer_id integer,
    store_id integer,
    customer_city character varying(20),
    placed_store_city character varying(20),
    suggested_store integer
);


ALTER TABLE trigger_tables.order_city_check OWNER TO store_admin;

--
-- Name: orders order_id; Type: DEFAULT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.orders ALTER COLUMN order_id SET DEFAULT nextval('sales.orders_order_id_seq'::regclass);


--
-- Data for Name: products; Type: TABLE DATA; Schema: production; Owner: store_admin
--

COPY production.products (production_id, product_name, model_year, price) FROM stdin;
1245	Yamaha YZF R-15	2019	150000.00
1289	Bajaj Platina	2020	45000.00
1549	Honda Unicorn	2018	65000.00
1537	Honda Activa	2018	40000.00
1149	Yamaha RX-100	2012	30000.00
1005	Hero Splendor	2019	55000.00
\.


--
-- Data for Name: quantity_track; Type: TABLE DATA; Schema: production; Owner: postgres
--

COPY production.quantity_track (store_id, product_id, quantity_to_fill) FROM stdin;
102	1245	32
102	1245	2
\.


--
-- Data for Name: stocks; Type: TABLE DATA; Schema: production; Owner: store_admin
--

COPY production.stocks (store_id, product_id, quantity) FROM stdin;
101	1245	20
101	1289	10
101	1549	20
101	1537	10
101	1149	25
102	1289	100
102	1549	20
102	1537	150
102	1149	32
102	1005	170
103	1245	10
103	1289	50
103	1549	70
103	1537	5
103	1149	56
103	1005	100
104	1245	13
104	1289	180
104	1549	40
104	1537	126
104	1149	27
104	1005	200
105	1245	29
105	1289	154
105	1549	79
105	1537	189
105	1149	26
105	1005	259
106	1245	20
106	1289	26
106	1549	20
106	1537	18
106	1149	25
106	1005	10
107	1245	40
107	1289	125
107	1549	\N
107	1537	\N
107	1149	32
107	1005	170
108	1245	80
108	1289	50
108	1549	70
108	1537	24
108	1149	56
108	1005	100
109	1245	26
109	1289	\N
109	1549	40
109	1537	126
109	1149	27
109	1005	300
110	1245	29
110	1289	154
110	1549	170
110	1537	189
110	1149	26
102	1245	8
101	1005	61
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: sales; Owner: store_admin
--

COPY sales.customer (customer_id, first_name, last_name, phone, email_id, city, state) FROM stdin;
1103	Shirish	Patil	9423275234	\N	Pune	Maharahstra
1102	Sushant	Chavare	9423273722	sushantsc204@gmail.com	Sangli	Maharahstra
1104	Rohit	Pawar	8956234759	rohit@hotmail.com	Kolhapur	Maharahstra
1105	Jay	Shah	5423698758	\N	Jamnagar	Gujrat
1106	Ibrahim	Katir	7856458963	\N	Jalandhar	Panjab
1107	Manpreet	Singh	7895685452	\N	Bhatinda	Panjab
1108	Rahe	Goel	568947526	goel@hfr.com	Panchkula	Haryana
1109	Manjeet	Khattar	7856998526	\N	Jalandhar	Panjab
1110	Jay	Rahane	4589625363	\N	Kolhapur	Maharahstra
1111	Amit	Shah	4589745896	\N	Jamnagar	Gujrat
1112	Mohammad	Ali	4589623587	\N	Jalandhar	Panjab
1113	Ishpreet	Singh	1256897459	\N	Bhatinda	Panjab
1114	Akash	Mehata	2356745891	akash@hfr.com	Panchkula	Haryana
1115	Simreet	Dhillon	2586321458	\N	Jalandhar	Panjab
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: sales; Owner: store_admin
--

COPY sales.order_items (order_id, item_id, product_id, quantity, price) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: sales; Owner: store_admin
--

COPY sales.orders (order_id, customer_id, order_status, order_date, store_id, product_id) FROM stdin;
3	1102	Completed	2020-01-02	101	1549
4	1103	Rejected	2020-01-28	102	1537
5	1104	Completed	2020-02-02	103	1289
6	1105	Completed	2020-01-04	105	1005
7	1106	Rejected	2020-02-12	101	1245
8	1107	Completed	2020-02-12	107	1289
9	1108	Completed	2020-02-16	110	1549
10	1109	Completed	2020-02-25	109	1149
11	1110	Completed	2020-02-27	103	1245
12	1111	Completed	2020-02-27	105	1537
13	1112	Completed	2020-03-06	109	1549
14	1113	Pending	2020-04-28	107	1149
15	1114	Pending	2020-05-10	110	1245
16	1115	Processing	2020-08-20	109	1005
17	1104	Completed	2020-08-28	101	1245
23	1102	Pending	2020-09-20	110	1549
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: sales; Owner: store_admin
--

COPY sales.stores (store_id, store_name, phone_no, city, state) FROM stdin;
101	Rajashree Bikes	9856234578	Sangli	Maharashtra
102	Mohan Bikes	9856234589	Pune	Maharashtra
103	Raj Bikes	9845782145	Kolhapur	Maharashtra
104	Patel Bieks	7852634158	Vafi	Gujrat
105	Chowdhari Bikes	9987451236	Jamnagar	Gujrat
106	Kothari Bikes	9978451258	Kutch	Gujrat
107	Singh Bikes	7865894892	Bhatinda	Panjab
109	Singla Bikes	7589689875	Jalandhar	Panjab
110	KK Bikes	8987456325	Panchkula	Haryana
108	Arya Bikes	8987455578	Sonipath	Haryana
\.


--
-- Data for Name: order_city_check; Type: TABLE DATA; Schema: trigger_tables; Owner: store_admin
--

COPY trigger_tables.order_city_check (order_id, customer_id, store_id, customer_city, placed_store_city, suggested_store) FROM stdin;
23	1102	110	Sangli	Panchkula	101
\.


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: store_admin
--

SELECT pg_catalog.setval('sales.customer_id_seq', 1115, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: store_admin
--

SELECT pg_catalog.setval('sales.orders_order_id_seq', 23, true);


--
-- Name: products prod_id_pk; Type: CONSTRAINT; Schema: production; Owner: store_admin
--

ALTER TABLE ONLY production.products
    ADD CONSTRAINT prod_id_pk PRIMARY KEY (production_id);


--
-- Name: stocks stock_pk; Type: CONSTRAINT; Schema: production; Owner: store_admin
--

ALTER TABLE ONLY production.stocks
    ADD CONSTRAINT stock_pk PRIMARY KEY (store_id, product_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: order_items order_item_id_pk; Type: CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_item_id_pk PRIMARY KEY (order_id, item_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (store_id);


--
-- Name: products model_year_check_trig; Type: TRIGGER; Schema: production; Owner: store_admin
--

CREATE TRIGGER model_year_check_trig BEFORE INSERT ON production.products FOR EACH ROW EXECUTE FUNCTION production.model_year_check();


--
-- Name: stocks stock_tracker_trigger; Type: TRIGGER; Schema: production; Owner: store_admin
--

CREATE TRIGGER stock_tracker_trigger AFTER UPDATE OF quantity ON production.stocks FOR EACH ROW EXECUTE FUNCTION production.quamtity_track_in_store();


--
-- Name: orders order_city_check_trigger; Type: TRIGGER; Schema: sales; Owner: store_admin
--

CREATE TRIGGER order_city_check_trigger BEFORE INSERT ON sales.orders FOR EACH ROW EXECUTE FUNCTION sales.order_city_check();


--
-- Name: stocks stocks_product_id_fkey; Type: FK CONSTRAINT; Schema: production; Owner: store_admin
--

ALTER TABLE ONLY production.stocks
    ADD CONSTRAINT stocks_product_id_fkey FOREIGN KEY (product_id) REFERENCES production.products(production_id);


--
-- Name: stocks stocks_store_id_fkey; Type: FK CONSTRAINT; Schema: production; Owner: store_admin
--

ALTER TABLE ONLY production.stocks
    ADD CONSTRAINT stocks_store_id_fkey FOREIGN KEY (store_id) REFERENCES sales.stores(store_id);


--
-- Name: order_items fk_prod_id; Type: FK CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT fk_prod_id FOREIGN KEY (product_id) REFERENCES production.products(production_id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES sales.orders(order_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES sales.customer(customer_id);


--
-- Name: orders orders_store_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_store_id_fkey FOREIGN KEY (store_id) REFERENCES sales.stores(store_id);


--
-- Name: orders prod_id_fk; Type: FK CONSTRAINT; Schema: sales; Owner: store_admin
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT prod_id_fk FOREIGN KEY (product_id) REFERENCES production.products(production_id);


--
-- PostgreSQL database dump complete
--

