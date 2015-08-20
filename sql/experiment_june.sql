--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.6
-- Dumped by pg_dump version 9.4.0
-- Started on 2015-08-19 20:39:42 PDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 231 (class 3079 OID 11787)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2479 (class 0 OID 0)
-- Dependencies: 231
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 230 (class 3079 OID 16714)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2480 (class 0 OID 0)
-- Dependencies: 230
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 192 (class 1259 OID 18595)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE auth_group OWNER TO bayen;

--
-- TOC entry 191 (class 1259 OID 18593)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_id_seq OWNER TO bayen;

--
-- TOC entry 2481 (class 0 OID 0)
-- Dependencies: 191
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- TOC entry 194 (class 1259 OID 18605)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_group_permissions OWNER TO bayen;

--
-- TOC entry 193 (class 1259 OID 18603)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_permissions_id_seq OWNER TO bayen;

--
-- TOC entry 2482 (class 0 OID 0)
-- Dependencies: 193
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- TOC entry 190 (class 1259 OID 18585)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE auth_permission OWNER TO bayen;

--
-- TOC entry 189 (class 1259 OID 18583)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_permission_id_seq OWNER TO bayen;

--
-- TOC entry 2483 (class 0 OID 0)
-- Dependencies: 189
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- TOC entry 196 (class 1259 OID 18615)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone NOT NULL,
    is_superuser boolean NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE auth_user OWNER TO bayen;

--
-- TOC entry 198 (class 1259 OID 18625)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE auth_user_groups OWNER TO bayen;

--
-- TOC entry 197 (class 1259 OID 18623)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_groups_id_seq OWNER TO bayen;

--
-- TOC entry 2484 (class 0 OID 0)
-- Dependencies: 197
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- TOC entry 195 (class 1259 OID 18613)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_id_seq OWNER TO bayen;

--
-- TOC entry 2485 (class 0 OID 0)
-- Dependencies: 195
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- TOC entry 200 (class 1259 OID 18635)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_user_user_permissions OWNER TO bayen;

--
-- TOC entry 199 (class 1259 OID 18633)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_user_permissions_id_seq OWNER TO bayen;

--
-- TOC entry 2486 (class 0 OID 0)
-- Dependencies: 199
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- TOC entry 173 (class 1259 OID 18114)
-- Name: celery_taskmeta; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE celery_taskmeta (
    id integer NOT NULL,
    task_id character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    result text,
    date_done timestamp with time zone NOT NULL,
    traceback text,
    hidden boolean NOT NULL,
    meta text
);


ALTER TABLE celery_taskmeta OWNER TO bayen;

--
-- TOC entry 172 (class 1259 OID 18112)
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE celery_taskmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE celery_taskmeta_id_seq OWNER TO bayen;

--
-- TOC entry 2487 (class 0 OID 0)
-- Dependencies: 172
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE celery_taskmeta_id_seq OWNED BY celery_taskmeta.id;


--
-- TOC entry 175 (class 1259 OID 18127)
-- Name: celery_tasksetmeta; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE celery_tasksetmeta (
    id integer NOT NULL,
    taskset_id character varying(255) NOT NULL,
    result text NOT NULL,
    date_done timestamp with time zone NOT NULL,
    hidden boolean NOT NULL
);


ALTER TABLE celery_tasksetmeta OWNER TO bayen;

--
-- TOC entry 174 (class 1259 OID 18125)
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE celery_tasksetmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE celery_tasksetmeta_id_seq OWNER TO bayen;

--
-- TOC entry 2488 (class 0 OID 0)
-- Dependencies: 174
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE celery_tasksetmeta_id_seq OWNED BY celery_tasksetmeta.id;


--
-- TOC entry 188 (class 1259 OID 18575)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE django_content_type OWNER TO bayen;

--
-- TOC entry 187 (class 1259 OID 18573)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_content_type_id_seq OWNER TO bayen;

--
-- TOC entry 2489 (class 0 OID 0)
-- Dependencies: 187
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- TOC entry 171 (class 1259 OID 18103)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE django_migrations OWNER TO bayen;

--
-- TOC entry 170 (class 1259 OID 18101)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_migrations_id_seq OWNER TO bayen;

--
-- TOC entry 2490 (class 0 OID 0)
-- Dependencies: 170
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- TOC entry 202 (class 1259 OID 18693)
-- Name: django_session; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE django_session OWNER TO bayen;

--
-- TOC entry 179 (class 1259 OID 18148)
-- Name: djcelery_crontabschedule; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE djcelery_crontabschedule (
    id integer NOT NULL,
    minute character varying(64) NOT NULL,
    hour character varying(64) NOT NULL,
    day_of_week character varying(64) NOT NULL,
    day_of_month character varying(64) NOT NULL,
    month_of_year character varying(64) NOT NULL
);


ALTER TABLE djcelery_crontabschedule OWNER TO bayen;

--
-- TOC entry 178 (class 1259 OID 18146)
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE djcelery_crontabschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE djcelery_crontabschedule_id_seq OWNER TO bayen;

--
-- TOC entry 2491 (class 0 OID 0)
-- Dependencies: 178
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE djcelery_crontabschedule_id_seq OWNED BY djcelery_crontabschedule.id;


--
-- TOC entry 177 (class 1259 OID 18140)
-- Name: djcelery_intervalschedule; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE djcelery_intervalschedule (
    id integer NOT NULL,
    every integer NOT NULL,
    period character varying(24) NOT NULL
);


ALTER TABLE djcelery_intervalschedule OWNER TO bayen;

--
-- TOC entry 176 (class 1259 OID 18138)
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE djcelery_intervalschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE djcelery_intervalschedule_id_seq OWNER TO bayen;

--
-- TOC entry 2492 (class 0 OID 0)
-- Dependencies: 176
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE djcelery_intervalschedule_id_seq OWNED BY djcelery_intervalschedule.id;


--
-- TOC entry 182 (class 1259 OID 18161)
-- Name: djcelery_periodictask; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE djcelery_periodictask (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    task character varying(200) NOT NULL,
    interval_id integer,
    crontab_id integer,
    args text NOT NULL,
    kwargs text NOT NULL,
    queue character varying(200),
    exchange character varying(200),
    routing_key character varying(200),
    expires timestamp with time zone,
    enabled boolean NOT NULL,
    last_run_at timestamp with time zone,
    total_run_count integer NOT NULL,
    date_changed timestamp with time zone NOT NULL,
    description text NOT NULL,
    CONSTRAINT djcelery_periodictask_total_run_count_check CHECK ((total_run_count >= 0))
);


ALTER TABLE djcelery_periodictask OWNER TO bayen;

--
-- TOC entry 181 (class 1259 OID 18159)
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE djcelery_periodictask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE djcelery_periodictask_id_seq OWNER TO bayen;

--
-- TOC entry 2493 (class 0 OID 0)
-- Dependencies: 181
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE djcelery_periodictask_id_seq OWNED BY djcelery_periodictask.id;


--
-- TOC entry 180 (class 1259 OID 18154)
-- Name: djcelery_periodictasks; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE djcelery_periodictasks (
    ident smallint NOT NULL,
    last_update timestamp with time zone NOT NULL
);


ALTER TABLE djcelery_periodictasks OWNER TO bayen;

--
-- TOC entry 186 (class 1259 OID 18195)
-- Name: djcelery_taskstate; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE djcelery_taskstate (
    id integer NOT NULL,
    state character varying(64) NOT NULL,
    task_id character varying(36) NOT NULL,
    name character varying(200),
    tstamp timestamp with time zone NOT NULL,
    args text,
    kwargs text,
    eta timestamp with time zone,
    expires timestamp with time zone,
    result text,
    traceback text,
    runtime double precision,
    retries integer NOT NULL,
    worker_id integer,
    hidden boolean NOT NULL
);


ALTER TABLE djcelery_taskstate OWNER TO bayen;

--
-- TOC entry 185 (class 1259 OID 18193)
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE djcelery_taskstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE djcelery_taskstate_id_seq OWNER TO bayen;

--
-- TOC entry 2494 (class 0 OID 0)
-- Dependencies: 185
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE djcelery_taskstate_id_seq OWNED BY djcelery_taskstate.id;


--
-- TOC entry 184 (class 1259 OID 18185)
-- Name: djcelery_workerstate; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE djcelery_workerstate (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    last_heartbeat timestamp with time zone
);


ALTER TABLE djcelery_workerstate OWNER TO bayen;

--
-- TOC entry 183 (class 1259 OID 18183)
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE djcelery_workerstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE djcelery_workerstate_id_seq OWNER TO bayen;

--
-- TOC entry 2495 (class 0 OID 0)
-- Dependencies: 183
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE djcelery_workerstate_id_seq OWNED BY djcelery_workerstate.id;


--
-- TOC entry 208 (class 1259 OID 20097)
-- Name: graph_edge; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_edge (
    edge_id text NOT NULL,
    graph_id text NOT NULL,
    from_node_id text NOT NULL,
    to_node_id text NOT NULL,
    cost_function text NOT NULL
);


ALTER TABLE graph_edge OWNER TO bayen;

--
-- TOC entry 222 (class 1259 OID 20230)
-- Name: graph_edgecost; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_edgecost (
    id integer NOT NULL,
    edge_id text NOT NULL,
    cost double precision NOT NULL
);


ALTER TABLE graph_edgecost OWNER TO bayen;

--
-- TOC entry 221 (class 1259 OID 20228)
-- Name: graph_edgecost_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_edgecost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_edgecost_id_seq OWNER TO bayen;

--
-- TOC entry 2496 (class 0 OID 0)
-- Dependencies: 221
-- Name: graph_edgecost_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_edgecost_id_seq OWNED BY graph_edgecost.id;


--
-- TOC entry 220 (class 1259 OID 20202)
-- Name: graph_flowdistribution; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_flowdistribution (
    id integer NOT NULL,
    username text,
    turn_id integer
);


ALTER TABLE graph_flowdistribution OWNER TO bayen;

--
-- TOC entry 219 (class 1259 OID 20200)
-- Name: graph_flowdistribution_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_flowdistribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_flowdistribution_id_seq OWNER TO bayen;

--
-- TOC entry 2497 (class 0 OID 0)
-- Dependencies: 219
-- Name: graph_flowdistribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_flowdistribution_id_seq OWNED BY graph_flowdistribution.id;


--
-- TOC entry 218 (class 1259 OID 20187)
-- Name: graph_flowdistribution_path_assignments; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_flowdistribution_path_assignments (
    id integer NOT NULL,
    flowdistribution_id integer NOT NULL,
    pathflowassignment_id integer NOT NULL
);


ALTER TABLE graph_flowdistribution_path_assignments OWNER TO bayen;

--
-- TOC entry 217 (class 1259 OID 20185)
-- Name: graph_flowdistribution_path_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_flowdistribution_path_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_flowdistribution_path_assignments_id_seq OWNER TO bayen;

--
-- TOC entry 2498 (class 0 OID 0)
-- Dependencies: 217
-- Name: graph_flowdistribution_path_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_flowdistribution_path_assignments_id_seq OWNED BY graph_flowdistribution_path_assignments.id;


--
-- TOC entry 229 (class 1259 OID 20303)
-- Name: graph_game; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_game (
    name text NOT NULL,
    current_turn_id integer,
    graph_id text,
    started boolean NOT NULL,
    game_loop_time timestamp with time zone,
    stopped boolean NOT NULL,
    edge_highlight boolean NOT NULL
);


ALTER TABLE graph_game OWNER TO bayen;

--
-- TOC entry 228 (class 1259 OID 20287)
-- Name: graph_game_turns; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_game_turns (
    id integer NOT NULL,
    game_id text NOT NULL,
    gameturn_id integer NOT NULL
);


ALTER TABLE graph_game_turns OWNER TO bayen;

--
-- TOC entry 227 (class 1259 OID 20285)
-- Name: graph_game_turns_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_game_turns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_game_turns_id_seq OWNER TO bayen;

--
-- TOC entry 2499 (class 0 OID 0)
-- Dependencies: 227
-- Name: graph_game_turns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_game_turns_id_seq OWNED BY graph_game_turns.id;


--
-- TOC entry 216 (class 1259 OID 20179)
-- Name: graph_gameturn; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_gameturn (
    id integer NOT NULL,
    iteration integer NOT NULL,
    graph_cost_id integer
);


ALTER TABLE graph_gameturn OWNER TO bayen;

--
-- TOC entry 215 (class 1259 OID 20177)
-- Name: graph_gameturn_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_gameturn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_gameturn_id_seq OWNER TO bayen;

--
-- TOC entry 2500 (class 0 OID 0)
-- Dependencies: 215
-- Name: graph_gameturn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_gameturn_id_seq OWNED BY graph_gameturn.id;


--
-- TOC entry 203 (class 1259 OID 20030)
-- Name: graph_graph; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_graph (
    name text NOT NULL,
    graph_ui text NOT NULL
);


ALTER TABLE graph_graph OWNER TO bayen;

--
-- TOC entry 226 (class 1259 OID 20261)
-- Name: graph_graphcost; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_graphcost (
    id integer NOT NULL,
    graph_id text NOT NULL
);


ALTER TABLE graph_graphcost OWNER TO bayen;

--
-- TOC entry 224 (class 1259 OID 20246)
-- Name: graph_graphcost_edge_costs; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_graphcost_edge_costs (
    id integer NOT NULL,
    graphcost_id integer NOT NULL,
    edgecost_id integer NOT NULL
);


ALTER TABLE graph_graphcost_edge_costs OWNER TO bayen;

--
-- TOC entry 223 (class 1259 OID 20244)
-- Name: graph_graphcost_edge_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_graphcost_edge_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_graphcost_edge_costs_id_seq OWNER TO bayen;

--
-- TOC entry 2501 (class 0 OID 0)
-- Dependencies: 223
-- Name: graph_graphcost_edge_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_graphcost_edge_costs_id_seq OWNED BY graph_graphcost_edge_costs.id;


--
-- TOC entry 225 (class 1259 OID 20259)
-- Name: graph_graphcost_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_graphcost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_graphcost_id_seq OWNER TO bayen;

--
-- TOC entry 2502 (class 0 OID 0)
-- Dependencies: 225
-- Name: graph_graphcost_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_graphcost_id_seq OWNED BY graph_graphcost.id;


--
-- TOC entry 204 (class 1259 OID 20038)
-- Name: graph_node; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_node (
    graph_id text NOT NULL,
    node_id text NOT NULL,
    ui_id integer NOT NULL
);


ALTER TABLE graph_node OWNER TO bayen;

--
-- TOC entry 212 (class 1259 OID 20140)
-- Name: graph_path; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_path (
    id integer NOT NULL,
    graph_id text NOT NULL,
    player_model_id text NOT NULL
);


ALTER TABLE graph_path OWNER TO bayen;

--
-- TOC entry 210 (class 1259 OID 20122)
-- Name: graph_path_edges; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_path_edges (
    id integer NOT NULL,
    path_id integer NOT NULL,
    edge_id text NOT NULL
);


ALTER TABLE graph_path_edges OWNER TO bayen;

--
-- TOC entry 209 (class 1259 OID 20120)
-- Name: graph_path_edges_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_path_edges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_path_edges_id_seq OWNER TO bayen;

--
-- TOC entry 2503 (class 0 OID 0)
-- Dependencies: 209
-- Name: graph_path_edges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_path_edges_id_seq OWNED BY graph_path_edges.id;


--
-- TOC entry 211 (class 1259 OID 20138)
-- Name: graph_path_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_path_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_path_id_seq OWNER TO bayen;

--
-- TOC entry 2504 (class 0 OID 0)
-- Dependencies: 211
-- Name: graph_path_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_path_id_seq OWNED BY graph_path.id;


--
-- TOC entry 214 (class 1259 OID 20166)
-- Name: graph_pathflowassignment; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_pathflowassignment (
    id integer NOT NULL,
    path_id integer NOT NULL,
    flow double precision NOT NULL
);


ALTER TABLE graph_pathflowassignment OWNER TO bayen;

--
-- TOC entry 213 (class 1259 OID 20164)
-- Name: graph_pathflowassignment_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_pathflowassignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_pathflowassignment_id_seq OWNER TO bayen;

--
-- TOC entry 2505 (class 0 OID 0)
-- Dependencies: 213
-- Name: graph_pathflowassignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_pathflowassignment_id_seq OWNED BY graph_pathflowassignment.id;


--
-- TOC entry 207 (class 1259 OID 20076)
-- Name: graph_player; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_player (
    id integer NOT NULL,
    user_id integer,
    player_model_id text,
    game_id text,
    flow_distribution_id integer
);


ALTER TABLE graph_player OWNER TO bayen;

--
-- TOC entry 206 (class 1259 OID 20074)
-- Name: graph_player_id_seq; Type: SEQUENCE; Schema: public; Owner: bayen
--

CREATE SEQUENCE graph_player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE graph_player_id_seq OWNER TO bayen;

--
-- TOC entry 2506 (class 0 OID 0)
-- Dependencies: 206
-- Name: graph_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bayen
--

ALTER SEQUENCE graph_player_id_seq OWNED BY graph_player.id;


--
-- TOC entry 205 (class 1259 OID 20051)
-- Name: graph_playermodel; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE graph_playermodel (
    name text NOT NULL,
    graph_id text,
    start_node_id text,
    destination_node_id text,
    flow double precision,
    in_use boolean NOT NULL,
    normalization_const double precision
);


ALTER TABLE graph_playermodel OWNER TO bayen;

--
-- TOC entry 201 (class 1259 OID 18687)
-- Name: id_counter_user; Type: TABLE; Schema: public; Owner: bayen; Tablespace: 
--

CREATE TABLE id_counter_user (
    user_id character varying(15) NOT NULL,
    logged_in boolean NOT NULL,
    completed_task boolean NOT NULL,
    entered_number double precision
);


ALTER TABLE id_counter_user OWNER TO bayen;

--
-- TOC entry 2071 (class 2604 OID 18598)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- TOC entry 2072 (class 2604 OID 18608)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 2070 (class 2604 OID 18588)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- TOC entry 2073 (class 2604 OID 18618)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- TOC entry 2074 (class 2604 OID 18628)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- TOC entry 2075 (class 2604 OID 18638)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 2061 (class 2604 OID 18117)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY celery_taskmeta ALTER COLUMN id SET DEFAULT nextval('celery_taskmeta_id_seq'::regclass);


--
-- TOC entry 2062 (class 2604 OID 18130)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY celery_tasksetmeta ALTER COLUMN id SET DEFAULT nextval('celery_tasksetmeta_id_seq'::regclass);


--
-- TOC entry 2069 (class 2604 OID 18578)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- TOC entry 2060 (class 2604 OID 18106)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- TOC entry 2064 (class 2604 OID 18151)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_crontabschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_crontabschedule_id_seq'::regclass);


--
-- TOC entry 2063 (class 2604 OID 18143)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_intervalschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_intervalschedule_id_seq'::regclass);


--
-- TOC entry 2065 (class 2604 OID 18164)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_periodictask ALTER COLUMN id SET DEFAULT nextval('djcelery_periodictask_id_seq'::regclass);


--
-- TOC entry 2068 (class 2604 OID 18198)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_taskstate ALTER COLUMN id SET DEFAULT nextval('djcelery_taskstate_id_seq'::regclass);


--
-- TOC entry 2067 (class 2604 OID 18188)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_workerstate ALTER COLUMN id SET DEFAULT nextval('djcelery_workerstate_id_seq'::regclass);


--
-- TOC entry 2083 (class 2604 OID 20233)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_edgecost ALTER COLUMN id SET DEFAULT nextval('graph_edgecost_id_seq'::regclass);


--
-- TOC entry 2082 (class 2604 OID 20205)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_flowdistribution ALTER COLUMN id SET DEFAULT nextval('graph_flowdistribution_id_seq'::regclass);


--
-- TOC entry 2081 (class 2604 OID 20190)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_flowdistribution_path_assignments ALTER COLUMN id SET DEFAULT nextval('graph_flowdistribution_path_assignments_id_seq'::regclass);


--
-- TOC entry 2086 (class 2604 OID 20290)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_game_turns ALTER COLUMN id SET DEFAULT nextval('graph_game_turns_id_seq'::regclass);


--
-- TOC entry 2080 (class 2604 OID 20182)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_gameturn ALTER COLUMN id SET DEFAULT nextval('graph_gameturn_id_seq'::regclass);


--
-- TOC entry 2085 (class 2604 OID 20264)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_graphcost ALTER COLUMN id SET DEFAULT nextval('graph_graphcost_id_seq'::regclass);


--
-- TOC entry 2084 (class 2604 OID 20249)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_graphcost_edge_costs ALTER COLUMN id SET DEFAULT nextval('graph_graphcost_edge_costs_id_seq'::regclass);


--
-- TOC entry 2078 (class 2604 OID 20143)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_path ALTER COLUMN id SET DEFAULT nextval('graph_path_id_seq'::regclass);


--
-- TOC entry 2077 (class 2604 OID 20125)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_path_edges ALTER COLUMN id SET DEFAULT nextval('graph_path_edges_id_seq'::regclass);


--
-- TOC entry 2079 (class 2604 OID 20169)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_pathflowassignment ALTER COLUMN id SET DEFAULT nextval('graph_pathflowassignment_id_seq'::regclass);


--
-- TOC entry 2076 (class 2604 OID 20079)
-- Name: id; Type: DEFAULT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_player ALTER COLUMN id SET DEFAULT nextval('graph_player_id_seq'::regclass);


--
-- TOC entry 2436 (class 0 OID 18595)
-- Dependencies: 192
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 2507 (class 0 OID 0)
-- Dependencies: 191
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- TOC entry 2438 (class 0 OID 18605)
-- Dependencies: 194
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 2508 (class 0 OID 0)
-- Dependencies: 193
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 2434 (class 0 OID 18585)
-- Dependencies: 190
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add content type	4	add_contenttype
11	Can change content type	4	change_contenttype
12	Can delete content type	4	delete_contenttype
13	Can add session	5	add_session
14	Can change session	5	change_session
15	Can delete session	5	delete_session
16	Can add task state	6	add_taskmeta
17	Can change task state	6	change_taskmeta
18	Can delete task state	6	delete_taskmeta
19	Can add saved group result	7	add_tasksetmeta
20	Can change saved group result	7	change_tasksetmeta
21	Can delete saved group result	7	delete_tasksetmeta
22	Can add interval	8	add_intervalschedule
23	Can change interval	8	change_intervalschedule
24	Can delete interval	8	delete_intervalschedule
25	Can add crontab	9	add_crontabschedule
26	Can change crontab	9	change_crontabschedule
27	Can delete crontab	9	delete_crontabschedule
28	Can add periodic tasks	10	add_periodictasks
29	Can change periodic tasks	10	change_periodictasks
30	Can delete periodic tasks	10	delete_periodictasks
31	Can add periodic task	11	add_periodictask
32	Can change periodic task	11	change_periodictask
33	Can delete periodic task	11	delete_periodictask
34	Can add worker	12	add_workerstate
35	Can change worker	12	change_workerstate
36	Can delete worker	12	delete_workerstate
37	Can add task	13	add_taskstate
38	Can change task	13	change_taskstate
39	Can delete task	13	delete_taskstate
40	Can add user	14	add_user
41	Can change user	14	change_user
42	Can delete user	14	delete_user
43	Can add graph	15	add_graph
44	Can change graph	15	change_graph
45	Can delete graph	15	delete_graph
46	Can add node	16	add_node
47	Can change node	16	change_node
48	Can delete node	16	delete_node
49	Can add player model	17	add_playermodel
50	Can change player model	17	change_playermodel
51	Can delete player model	17	delete_playermodel
52	Can add player	18	add_player
53	Can change player	18	change_player
54	Can delete player	18	delete_player
55	Can add edge	19	add_edge
56	Can change edge	19	change_edge
57	Can delete edge	19	delete_edge
58	Can add path	20	add_path
59	Can change path	20	change_path
60	Can delete path	20	delete_path
61	Can add path flow assignment	21	add_pathflowassignment
62	Can change path flow assignment	21	change_pathflowassignment
63	Can delete path flow assignment	21	delete_pathflowassignment
64	Can add game turn	22	add_gameturn
65	Can change game turn	22	change_gameturn
66	Can delete game turn	22	delete_gameturn
67	Can add flow distribution	23	add_flowdistribution
68	Can change flow distribution	23	change_flowdistribution
69	Can delete flow distribution	23	delete_flowdistribution
70	Can add edge cost	24	add_edgecost
71	Can change edge cost	24	change_edgecost
72	Can delete edge cost	24	delete_edgecost
73	Can add graph cost	25	add_graphcost
74	Can change graph cost	25	change_graphcost
75	Can delete graph cost	25	delete_graphcost
76	Can add game	26	add_game
77	Can change game	26	change_game
78	Can delete game	26	delete_game
\.


--
-- TOC entry 2509 (class 0 OID 0)
-- Dependencies: 189
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('auth_permission_id_seq', 78, true);


--
-- TOC entry 2440 (class 0 OID 18615)
-- Dependencies: 196
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
2	pbkdf2_sha256$15000$zZDTr1A5jUwE$dxkTHxrUDQF2gi4XYHEX5/I8QoDZM1VdeSK/lDQ/MdA=	2015-06-26 17:44:43.809471-04	f	wildy123				f	t	2015-06-26 17:44:37.715453-04
3	pbkdf2_sha256$15000$qdLpYkiKEj67$2YvVdP8HDIjRRSd2XpqjR/RVc4dxZUXgFbbW+OMurfU=	2015-06-26 17:44:48.0856-04	f	julien				f	t	2015-06-26 17:44:45.173961-04
4	pbkdf2_sha256$15000$hvZXXKCjJFNR$sIzeJyVG/dhYcr5QHYSX7WDWhId4GWB25xXmficBPBI=	2015-06-26 17:44:48.981596-04	f	xyz				f	t	2015-06-26 17:44:46.055737-04
1	pbkdf2_sha256$15000$eeYJEsv7etzs$8/zcTeAiIxIekHnyK7TR08Sa4yavF8fOBumwIuy33H0=	2015-06-26 17:44:50.177973-04	f	DoctorKrichene				f	t	2015-06-26 17:44:32.743817-04
5	pbkdf2_sha256$15000$5ulxfIFkMSP7$YAmbW8WKxZhrYT6Aoq69vbX3FJiBAk3zhEaZ7PZgg4c=	2015-06-26 17:44:56.642269-04	f	Walid_Supreme_Ruler_o_t_U				f	t	2015-06-26 17:44:49.906252-04
6	pbkdf2_sha256$15000$8SEP99m3HEF2$KFV3CiL0/sTj9SPN91hVQOOhN/kAtc6JI4ITvhi+tZc=	2015-06-26 17:44:57.520681-04	f	SN				f	t	2015-06-26 17:44:52.008188-04
7	pbkdf2_sha256$15000$QbjKr7RQ3Y9X$zk/JiWjvvOAb9fuAjUHq+U1S/+WJtFhr9PSqzG7EZkw=	2015-06-26 17:44:59.775626-04	f	walidussnake				f	t	2015-06-26 17:44:54.447785-04
8	pbkdf2_sha256$15000$zSCJtEBXvBAx$isT6+83uEToGyEMQZ1YQekIxfVynB/oFHd6AAsRKG1k=	2015-06-26 17:45:43.798208-04	f	Batmobile_Incorporated				f	t	2015-06-26 17:45:39.59201-04
9	pbkdf2_sha256$15000$VVxhYONmKBTi$1cUxSiEp/X/KN6vPFQwp0xdNJqiltiVoGSGS92KdF7I=	2015-07-01 14:59:26.729342-04	f	root				f	t	2015-06-26 17:45:52.821401-04
\.


--
-- TOC entry 2442 (class 0 OID 18625)
-- Dependencies: 198
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 2510 (class 0 OID 0)
-- Dependencies: 197
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- TOC entry 2511 (class 0 OID 0)
-- Dependencies: 195
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('auth_user_id_seq', 9, true);


--
-- TOC entry 2444 (class 0 OID 18635)
-- Dependencies: 200
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 2512 (class 0 OID 0)
-- Dependencies: 199
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 2417 (class 0 OID 18114)
-- Dependencies: 173
-- Data for Name: celery_taskmeta; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY celery_taskmeta (id, task_id, status, result, date_done, traceback, hidden, meta) FROM stdin;
\.


--
-- TOC entry 2513 (class 0 OID 0)
-- Dependencies: 172
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('celery_taskmeta_id_seq', 1, false);


--
-- TOC entry 2419 (class 0 OID 18127)
-- Dependencies: 175
-- Data for Name: celery_tasksetmeta; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY celery_tasksetmeta (id, taskset_id, result, date_done, hidden) FROM stdin;
\.


--
-- TOC entry 2514 (class 0 OID 0)
-- Dependencies: 174
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('celery_tasksetmeta_id_seq', 1, false);


--
-- TOC entry 2432 (class 0 OID 18575)
-- Dependencies: 188
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY django_content_type (id, name, app_label, model) FROM stdin;
1	permission	auth	permission
2	group	auth	group
3	user	auth	user
4	content type	contenttypes	contenttype
5	session	sessions	session
6	task state	djcelery	taskmeta
7	saved group result	djcelery	tasksetmeta
8	interval	djcelery	intervalschedule
9	crontab	djcelery	crontabschedule
10	periodic tasks	djcelery	periodictasks
11	periodic task	djcelery	periodictask
12	worker	djcelery	workerstate
13	task	djcelery	taskstate
14	user	id_counter	user
15	graph	graph	graph
16	node	graph	node
17	player model	graph	playermodel
18	player	graph	player
19	edge	graph	edge
20	path	graph	path
21	path flow assignment	graph	pathflowassignment
22	game turn	graph	gameturn
23	flow distribution	graph	flowdistribution
24	edge cost	graph	edgecost
25	graph cost	graph	graphcost
26	game	graph	game
\.


--
-- TOC entry 2515 (class 0 OID 0)
-- Dependencies: 187
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('django_content_type_id_seq', 26, true);


--
-- TOC entry 2415 (class 0 OID 18103)
-- Dependencies: 171
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2015-06-24 00:03:02.357991-04
2	auth	0001_initial	2015-06-24 00:03:02.622726-04
3	id_counter	0001_initial	2015-06-24 00:03:02.718051-04
4	sessions	0001_initial	2015-06-24 00:03:02.78838-04
\.


--
-- TOC entry 2516 (class 0 OID 0)
-- Dependencies: 170
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('django_migrations_id_seq', 4, true);


--
-- TOC entry 2446 (class 0 OID 18693)
-- Dependencies: 202
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
6ie6re9rfr61sojj1g4pngwa2aw7z3be	ZjRlMWI5OTgxZDA3OTlmNzczNjgxOTg0YjMyMmFhM2NiNmJiNzE5MDp7fQ==	2015-07-10 17:44:23.357009-04
q4x5pp78hsiwfh13oqo9bl94xsajkcvh	ZjRlMWI5OTgxZDA3OTlmNzczNjgxOTg0YjMyMmFhM2NiNmJiNzE5MDp7fQ==	2015-07-10 17:44:35.530933-04
jk6do3wjtrro26izybz0qtjvopk8mkgg	YWJmN2VkOGI2MzgxMzg0ZTZlNjc0YWZkNWYzY2IyOTEzY2E5NTQ5NTp7Il9hdXRoX3VzZXJfaGFzaCI6IjVjMjY1ZDJiOTI1YmFmNTNlYmZlOTZhOTA2ZjU4MjExYmVjMDRkYjMiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjJ9	2015-07-10 17:44:43.81179-04
0nty1ylg02fvoy8xihe1ad7aca9amua1	ZWEzMmY4NjI4YmE5MWZlYmQ2N2MxNzExM2ZjZTU3M2Q1ZGEwN2Q2ODp7Il9hdXRoX3VzZXJfaGFzaCI6IjgzZTQ3YmJlYTI2ODkwOGJkOWI3OWYwZjc1Y2EzMWNlMmE2YjMwMTMiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjN9	2015-07-10 17:44:48.087671-04
0zjquph33hzb96la5gwoga0a971hezro	MTg3NTYwZWQxYWViMGEyYTJkNjNkZWE5NWQ2ZWVhMzNmOGQ3NTUwMjp7Il9hdXRoX3VzZXJfaGFzaCI6ImE2MWI3NjQ4ZDUwMDljNzc3YmJhNWU5OTdkMjBjMGFmYThmNTU4NTQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjR9	2015-07-10 17:44:48.983769-04
9ankf83uif5ozw4oecjq6zcorsf1lk0s	NjVjMGI0ZTNlM2U5YTY4YmM5OTA4NDFkMzVmOGMyYzUwZWY3NGE1Yzp7Il9hdXRoX3VzZXJfaGFzaCI6IjQwNWZmNjM4MWUxMTI0ZTNjZDZjNWNmM2ZhNTA3YzkzZWEyYTY0NjUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9	2015-07-10 17:44:50.184028-04
xq44xapjb8ijcv4m41ju65vgfo64qesm	OWJlZGZlOTViZGNhN2JkYTA5Yzc5MjAyOTI0ODkxNDMxYWY4ZTNmYTp7Il9hdXRoX3VzZXJfaGFzaCI6IjJkYWNhNzkwN2UwNDgyNmIyZjgzZjg4YWFiY2NjZDAzMTg3YjJjNGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjV9	2015-07-10 17:44:56.646286-04
dpog1txavn2iq50gird1kpo40a7u7pom	MzViNTJlYjQ3NzMyODIyYTFlYTljNzBmOTFjMTcxZjJhOGIzZDIyMzp7Il9hdXRoX3VzZXJfaGFzaCI6IjMwNDhmNmU1NzZmZjFlZTExMzg3NDM0M2JjYzAzOTY5Y2UyYTk3ODgiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjZ9	2015-07-10 17:44:57.525563-04
t63exrvz9b5mfm6b9zje3f2yrtpprnyz	M2QwZWMyODVhOTE4NzM1MzAzM2NkYzg3Mzc5Y2NiMGU0MjU5NDhmYjp7Il9hdXRoX3VzZXJfaGFzaCI6IjU0ZDY0YWZjYTMyNmVhNzBjOGY4ZWQzYTBkYzc1YzUzOTUwNGM2MDMiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjd9	2015-07-10 17:44:59.778022-04
gj95tuvzereml94fnmma31pg94j1jkvj	OTRlZmYyM2U3MDFhMDEyNzI0YzVhYzA3MzBiMzg2ODZlZDQ2ZTQ5NTp7Il9hdXRoX3VzZXJfaGFzaCI6IjY5ZWExYWIwMmJkZjk3YzdiZGU5Y2FkNWU3ODMyNmM1NDNhNWU1MTAiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjh9	2015-07-10 17:45:43.80041-04
93y4zfssoc2ipfddlztnrxwp9qzriah8	MTA3ODRmOTRmYjM4ZTRiYTI2YjNiNDAzY2RkYmNkMGQxNjYwNjJjOTp7Il9hdXRoX3VzZXJfaGFzaCI6IjU2YThjZmUxMWMyNGFkMTM4ZmQ5NWQ0ZmRiZDcxZGY1Y2JhZjRjYjAiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjl9	2015-07-10 17:45:55.726656-04
ru4gp22f8a8srd8ei9zk5p9xkjp10m7z	MTA3ODRmOTRmYjM4ZTRiYTI2YjNiNDAzY2RkYmNkMGQxNjYwNjJjOTp7Il9hdXRoX3VzZXJfaGFzaCI6IjU2YThjZmUxMWMyNGFkMTM4ZmQ5NWQ0ZmRiZDcxZGY1Y2JhZjRjYjAiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjl9	2015-07-15 14:59:26.733174-04
c1nwq08mgyenefjpdmyqgh9oszkf6q30	ZjRlMWI5OTgxZDA3OTlmNzczNjgxOTg0YjMyMmFhM2NiNmJiNzE5MDp7fQ==	2015-08-09 16:19:09.374926-04
\.


--
-- TOC entry 2423 (class 0 OID 18148)
-- Dependencies: 179
-- Data for Name: djcelery_crontabschedule; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY djcelery_crontabschedule (id, minute, hour, day_of_week, day_of_month, month_of_year) FROM stdin;
\.


--
-- TOC entry 2517 (class 0 OID 0)
-- Dependencies: 178
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('djcelery_crontabschedule_id_seq', 1, false);


--
-- TOC entry 2421 (class 0 OID 18140)
-- Dependencies: 177
-- Data for Name: djcelery_intervalschedule; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY djcelery_intervalschedule (id, every, period) FROM stdin;
\.


--
-- TOC entry 2518 (class 0 OID 0)
-- Dependencies: 176
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('djcelery_intervalschedule_id_seq', 1, false);


--
-- TOC entry 2426 (class 0 OID 18161)
-- Dependencies: 182
-- Data for Name: djcelery_periodictask; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY djcelery_periodictask (id, name, task, interval_id, crontab_id, args, kwargs, queue, exchange, routing_key, expires, enabled, last_run_at, total_run_count, date_changed, description) FROM stdin;
\.


--
-- TOC entry 2519 (class 0 OID 0)
-- Dependencies: 181
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('djcelery_periodictask_id_seq', 1, false);


--
-- TOC entry 2424 (class 0 OID 18154)
-- Dependencies: 180
-- Data for Name: djcelery_periodictasks; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY djcelery_periodictasks (ident, last_update) FROM stdin;
\.


--
-- TOC entry 2430 (class 0 OID 18195)
-- Dependencies: 186
-- Data for Name: djcelery_taskstate; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY djcelery_taskstate (id, state, task_id, name, tstamp, args, kwargs, eta, expires, result, traceback, runtime, retries, worker_id, hidden) FROM stdin;
\.


--
-- TOC entry 2520 (class 0 OID 0)
-- Dependencies: 185
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('djcelery_taskstate_id_seq', 1, false);


--
-- TOC entry 2428 (class 0 OID 18185)
-- Dependencies: 184
-- Data for Name: djcelery_workerstate; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY djcelery_workerstate (id, hostname, last_heartbeat) FROM stdin;
\.


--
-- TOC entry 2521 (class 0 OID 0)
-- Dependencies: 183
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('djcelery_workerstate_id_seq', 1, false);


--
-- TOC entry 2452 (class 0 OID 20097)
-- Dependencies: 208
-- Data for Name: graph_edge; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_edge (edge_id, graph_id, from_node_id, to_node_id, cost_function) FROM stdin;
116ed7997e89102eaa94c80b25a70ecb	test	bdac6aee-609f-492b-b97b-b7ba53ecafb7	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	1+(x/1.5)**4
15215427d89211e2b6b1eaf93f40ee25	test	978b0218-bc23-424c-9119-3a3c2306d455	735118ca-7dbc-486d-aa23-88bc48811537	0+(x/2.)**4
1baff48576c39d0fb71e0e19171f6d33	test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	377bd411-45cc-449b-90d0-31d7ce4da47d	2+(x/2.)**4
35eba9f65a898ba0d7a8c099d312d2b8	test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	978b0218-bc23-424c-9119-3a3c2306d455	1+(x/1.)**4
503ea356c90777f1a6dcfb872be9d951	test	6a15327a-caca-4a47-b495-322560259fc9	275a8e51-f197-451e-abd4-1057bd5cff74	2+(x/.3)**4
5ce3019ae5ba925c4abb669e6073ffa5	test	3f3c5d37-3335-404f-b318-a3ed55aef26f	bdac6aee-609f-492b-b97b-b7ba53ecafb7	.1+(x/1.)**4
67cde4149526b913e132a266e9c8509d	test	377bd411-45cc-449b-90d0-31d7ce4da47d	bdac6aee-609f-492b-b97b-b7ba53ecafb7	1+(x/1.)**4
834c742c1707eef884e5fa247807c1d3	test	735118ca-7dbc-486d-aa23-88bc48811537	877d1ba3-9fef-49f3-ad28-2042d9b894e7	0
92e224e5a0cfbd18fc8d469bfe15fe72	test	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	275a8e51-f197-451e-abd4-1057bd5cff74	1+(x/1.)**4
c6e2871cecbf193dc758bec1f3c5d120	test	770e5312-5104-4880-a94e-cd259acb19ec	275a8e51-f197-451e-abd4-1057bd5cff74	1+(x/.2)**4
d1c7a3af68e8b0b85bec3806cfde14cd	test	770e5312-5104-4880-a94e-cd259acb19ec	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	1+(x/1.)**4
d5d28e0f5f45f4bb648f92c650bece05	test	0f3687e3-c1b7-4f22-9ea5-8c26fe719bf6	3f3c5d37-3335-404f-b318-a3ed55aef26f	.5+(x/3.)**4
ded0d6e804fc4768200ff41734b3da11	test	377bd411-45cc-449b-90d0-31d7ce4da47d	770e5312-5104-4880-a94e-cd259acb19ec	2+(x/1.)**4
e446581e4fb1bc4cc694ff659207ef45	test	978b0218-bc23-424c-9119-3a3c2306d455	0f3687e3-c1b7-4f22-9ea5-8c26fe719bf6	.1+(x/1.)**4
e7968a8522dc48a4180f846e01e2bf8b	test	3f3c5d37-3335-404f-b318-a3ed55aef26f	6a15327a-caca-4a47-b495-322560259fc9	4+(x/.3)**4
fa5cf435b1a6fc838329d7169389160a	test	978b0218-bc23-424c-9119-3a3c2306d455	bdac6aee-609f-492b-b97b-b7ba53ecafb7	1+(x/1.2)**4
\.


--
-- TOC entry 2466 (class 0 OID 20230)
-- Dependencies: 222
-- Data for Name: graph_edgecost; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_edgecost (id, edge_id, cost) FROM stdin;
1	116ed7997e89102eaa94c80b25a70ecb	31.1475980067445484
2	15215427d89211e2b6b1eaf93f40ee25	0.0474271604938273014
3	1baff48576c39d0fb71e0e19171f6d33	15.6114415033327028
4	35eba9f65a898ba0d7a8c099d312d2b8	20.1456538898644695
5	503ea356c90777f1a6dcfb872be9d951	2.30713490321597137
6	5ce3019ae5ba925c4abb669e6073ffa5	4.73032803885448683
7	67cde4149526b913e132a266e9c8509d	7.22744110290847619
8	834c742c1707eef884e5fa247807c1d3	0
9	92e224e5a0cfbd18fc8d469bfe15fe72	1.13845841000000081
10	c6e2871cecbf193dc758bec1f3c5d120	1158.88966049382839
11	d1c7a3af68e8b0b85bec3806cfde14cd	2.43854912990499528
12	d5d28e0f5f45f4bb648f92c650bece05	0.600765083870309913
13	ded0d6e804fc4768200ff41734b3da11	28.1724425764043431
14	e446581e4fb1bc4cc694ff659207ef45	8.26197179349510158
15	e7968a8522dc48a4180f846e01e2bf8b	4.30713490321597092
16	fa5cf435b1a6fc838329d7169389160a	18.8980306718350377
17	116ed7997e89102eaa94c80b25a70ecb	32.7592403083020542
18	15215427d89211e2b6b1eaf93f40ee25	0.0535361561038045913
19	1baff48576c39d0fb71e0e19171f6d33	18.1589291463823841
20	35eba9f65a898ba0d7a8c099d312d2b8	15.5226045226056222
21	503ea356c90777f1a6dcfb872be9d951	20.4638887425097309
22	5ce3019ae5ba925c4abb669e6073ffa5	5.22190458075484543
23	67cde4149526b913e132a266e9c8509d	24.1146052025764241
24	834c742c1707eef884e5fa247807c1d3	0
25	92e224e5a0cfbd18fc8d469bfe15fe72	3.42968423899323449
26	c6e2871cecbf193dc758bec1f3c5d120	1.17648066765643056
27	d1c7a3af68e8b0b85bec3806cfde14cd	9.11116475818133686
28	d5d28e0f5f45f4bb648f92c650bece05	0.752334161236167143
29	ded0d6e804fc4768200ff41734b3da11	12.9054609166212142
30	e446581e4fb1bc4cc694ff659207ef45	20.5390670601295433
31	e7968a8522dc48a4180f846e01e2bf8b	22.4638887425097309
32	fa5cf435b1a6fc838329d7169389160a	6.81993345284750774
33	116ed7997e89102eaa94c80b25a70ecb	30.0824815311263016
34	15215427d89211e2b6b1eaf93f40ee25	0.110037482308728909
35	1baff48576c39d0fb71e0e19171f6d33	12.283174691600351
36	35eba9f65a898ba0d7a8c099d312d2b8	44.6537061615320496
37	503ea356c90777f1a6dcfb872be9d951	2.80082704110224467
38	5ce3019ae5ba925c4abb669e6073ffa5	6.49974325190225155
39	67cde4149526b913e132a266e9c8509d	4.30810158931942588
40	834c742c1707eef884e5fa247807c1d3	0
41	92e224e5a0cfbd18fc8d469bfe15fe72	3.25248752814002229
42	c6e2871cecbf193dc758bec1f3c5d120	37.3608438448802573
43	d1c7a3af68e8b0b85bec3806cfde14cd	10.2025985531551626
44	d5d28e0f5f45f4bb648f92c650bece05	0.652367075616853365
45	ded0d6e804fc4768200ff41734b3da11	26.8558677471023444
46	e446581e4fb1bc4cc694ff659207ef45	12.4417331249651166
47	e7968a8522dc48a4180f846e01e2bf8b	4.80082704110224512
48	fa5cf435b1a6fc838329d7169389160a	21.2061348379510726
49	116ed7997e89102eaa94c80b25a70ecb	36.8518520773754474
50	15215427d89211e2b6b1eaf93f40ee25	0.0458639278464944566
51	1baff48576c39d0fb71e0e19171f6d33	18.0415008362442038
52	35eba9f65a898ba0d7a8c099d312d2b8	14.6733786845901282
53	503ea356c90777f1a6dcfb872be9d951	4.79532887373248062
54	5ce3019ae5ba925c4abb669e6073ffa5	5.79764885755452664
55	67cde4149526b913e132a266e9c8509d	19.0413354062463327
56	834c742c1707eef884e5fa247807c1d3	0
57	92e224e5a0cfbd18fc8d469bfe15fe72	3.51416817099523149
58	c6e2871cecbf193dc758bec1f3c5d120	10.6914511169275386
59	d1c7a3af68e8b0b85bec3806cfde14cd	7.37141563186227966
60	d5d28e0f5f45f4bb648f92c650bece05	0.672323982565698142
61	ded0d6e804fc4768200ff41734b3da11	16.2127200483989959
62	e446581e4fb1bc4cc694ff659207ef45	14.0582425878215513
63	e7968a8522dc48a4180f846e01e2bf8b	6.79532887373248062
64	fa5cf435b1a6fc838329d7169389160a	9.76089082115321283
65	116ed7997e89102eaa94c80b25a70ecb	19.1233886344445665
66	15215427d89211e2b6b1eaf93f40ee25	0.087590757255189014
67	1baff48576c39d0fb71e0e19171f6d33	15.5256482497140187
68	35eba9f65a898ba0d7a8c099d312d2b8	26.7457941815329008
69	503ea356c90777f1a6dcfb872be9d951	37.8402217812410626
70	5ce3019ae5ba925c4abb669e6073ffa5	1.44421324619689262
71	67cde4149526b913e132a266e9c8509d	8.674904386843723
72	834c742c1707eef884e5fa247807c1d3	0
73	92e224e5a0cfbd18fc8d469bfe15fe72	1.64968878480285164
74	c6e2871cecbf193dc758bec1f3c5d120	12.4842981890983253
75	d1c7a3af68e8b0b85bec3806cfde14cd	11.5645071257564904
76	d5d28e0f5f45f4bb648f92c650bece05	0.632734271278040272
77	ded0d6e804fc4768200ff41734b3da11	24.2161884457656491
78	e446581e4fb1bc4cc694ff659207ef45	10.8514759735212607
79	e7968a8522dc48a4180f846e01e2bf8b	39.8402217812410626
80	fa5cf435b1a6fc838329d7169389160a	15.8015159872248407
81	116ed7997e89102eaa94c80b25a70ecb	48.4095039049390934
82	15215427d89211e2b6b1eaf93f40ee25	0.0313169076944331826
83	1baff48576c39d0fb71e0e19171f6d33	17.1634846970212465
84	35eba9f65a898ba0d7a8c099d312d2b8	13.8869109065042853
85	503ea356c90777f1a6dcfb872be9d951	2.26950501529972071
86	5ce3019ae5ba925c4abb669e6073ffa5	4.86443822982439222
87	67cde4149526b913e132a266e9c8509d	20.4050547014458026
88	834c742c1707eef884e5fa247807c1d3	0
89	92e224e5a0cfbd18fc8d469bfe15fe72	4.37098780062500047
90	c6e2871cecbf193dc758bec1f3c5d120	22.1390806167200402
91	d1c7a3af68e8b0b85bec3806cfde14cd	5.05416667492580451
92	d5d28e0f5f45f4bb648f92c650bece05	0.601561212006178847
93	ded0d6e804fc4768200ff41734b3da11	13.6584751966646092
94	e446581e4fb1bc4cc694ff659207ef45	8.32645817250048559
95	e7968a8522dc48a4180f846e01e2bf8b	4.26950501529972026
96	fa5cf435b1a6fc838329d7169389160a	15.9538586964767486
97	116ed7997e89102eaa94c80b25a70ecb	14.30092518056275
98	15215427d89211e2b6b1eaf93f40ee25	0.0905477517318785396
99	1baff48576c39d0fb71e0e19171f6d33	20.36741012917539
100	35eba9f65a898ba0d7a8c099d312d2b8	15.6590859206848823
101	503ea356c90777f1a6dcfb872be9d951	43.600479279139293
102	5ce3019ae5ba925c4abb669e6073ffa5	2.31529455131329165
103	67cde4149526b913e132a266e9c8509d	10.7460015113119187
104	834c742c1707eef884e5fa247807c1d3	0
105	92e224e5a0cfbd18fc8d469bfe15fe72	1.39387782174805097
106	c6e2871cecbf193dc758bec1f3c5d120	25.7061516781755799
107	d1c7a3af68e8b0b85bec3806cfde14cd	14.8067116029712569
108	d5d28e0f5f45f4bb648f92c650bece05	0.690473174563571268
109	ded0d6e804fc4768200ff41734b3da11	33.737347338817159
110	e446581e4fb1bc4cc694ff659207ef45	15.5283271396492708
111	e7968a8522dc48a4180f846e01e2bf8b	45.600479279139293
112	fa5cf435b1a6fc838329d7169389160a	6.99502853757196164
113	116ed7997e89102eaa94c80b25a70ecb	71.8040749306766486
114	15215427d89211e2b6b1eaf93f40ee25	0.0139367261149084664
115	1baff48576c39d0fb71e0e19171f6d33	8.84620394809187616
116	35eba9f65a898ba0d7a8c099d312d2b8	37.1504027707040336
117	503ea356c90777f1a6dcfb872be9d951	2.63357236814902951
118	5ce3019ae5ba925c4abb669e6073ffa5	5.9282862910988543
119	67cde4149526b913e132a266e9c8509d	12.8139924917673582
120	834c742c1707eef884e5fa247807c1d3	0
121	92e224e5a0cfbd18fc8d469bfe15fe72	6.77322929462556544
122	c6e2871cecbf193dc758bec1f3c5d120	1.68976755438218995
123	d1c7a3af68e8b0b85bec3806cfde14cd	3.06610649492211662
124	d5d28e0f5f45f4bb648f92c650bece05	0.635878900617459886
125	ded0d6e804fc4768200ff41734b3da11	5.6391640768460265
126	e446581e4fb1bc4cc694ff659207ef45	11.1061909500142431
127	e7968a8522dc48a4180f846e01e2bf8b	4.63357236814902951
128	fa5cf435b1a6fc838329d7169389160a	37.1993352699256121
129	116ed7997e89102eaa94c80b25a70ecb	12.0439092285603415
130	15215427d89211e2b6b1eaf93f40ee25	0.190954476016253621
131	1baff48576c39d0fb71e0e19171f6d33	32.3563351807546979
132	35eba9f65a898ba0d7a8c099d312d2b8	8.01698023999623288
133	503ea356c90777f1a6dcfb872be9d951	12.3496594758274192
134	5ce3019ae5ba925c4abb669e6073ffa5	1.62106390327562799
135	67cde4149526b913e132a266e9c8509d	15.9723487726274271
136	834c742c1707eef884e5fa247807c1d3	0
137	92e224e5a0cfbd18fc8d469bfe15fe72	2.48299062804109383
138	c6e2871cecbf193dc758bec1f3c5d120	11.3100877786494571
139	d1c7a3af68e8b0b85bec3806cfde14cd	32.5000046909607221
140	d5d28e0f5f45f4bb648f92c650bece05	0.59120363156525102
141	ded0d6e804fc4768200ff41734b3da11	57.338491892328797
142	e446581e4fb1bc4cc694ff659207ef45	7.48749415678533392
143	e7968a8522dc48a4180f846e01e2bf8b	14.3496594758274192
144	fa5cf435b1a6fc838329d7169389160a	4.63404719968840695
145	116ed7997e89102eaa94c80b25a70ecb	20.6776421866329052
146	15215427d89211e2b6b1eaf93f40ee25	0.292047225904033092
147	1baff48576c39d0fb71e0e19171f6d33	13.6586104990744328
148	35eba9f65a898ba0d7a8c099d312d2b8	60.2654182431413972
149	503ea356c90777f1a6dcfb872be9d951	18.349220372115461
150	5ce3019ae5ba925c4abb669e6073ffa5	4.68571768875291106
151	67cde4149526b913e132a266e9c8509d	5.52083975760699897
152	834c742c1707eef884e5fa247807c1d3	0
153	92e224e5a0cfbd18fc8d469bfe15fe72	4.36302716945309932
154	c6e2871cecbf193dc758bec1f3c5d120	1.00204931428919219
155	d1c7a3af68e8b0b85bec3806cfde14cd	24.211058450632752
156	d5d28e0f5f45f4bb648f92c650bece05	0.725189847838527246
157	ded0d6e804fc4768200ff41734b3da11	27.0640437834881311
158	e446581e4fb1bc4cc694ff659207ef45	18.3403776749207097
159	e7968a8522dc48a4180f846e01e2bf8b	20.349220372115461
160	fa5cf435b1a6fc838329d7169389160a	13.0922772151201929
161	116ed7997e89102eaa94c80b25a70ecb	41.2871879275644886
162	15215427d89211e2b6b1eaf93f40ee25	0.0860851900077159587
163	1baff48576c39d0fb71e0e19171f6d33	32.6498098349153096
164	35eba9f65a898ba0d7a8c099d312d2b8	4.60048464764573239
165	503ea356c90777f1a6dcfb872be9d951	2.00892096714123136
166	5ce3019ae5ba925c4abb669e6073ffa5	0.708644209383614054
167	67cde4149526b913e132a266e9c8509d	45.1080567109755322
168	834c742c1707eef884e5fa247807c1d3	0
169	92e224e5a0cfbd18fc8d469bfe15fe72	8.08002666668953751
170	c6e2871cecbf193dc758bec1f3c5d120	4.65815408835126377
171	d1c7a3af68e8b0b85bec3806cfde14cd	12.7681178894939329
172	d5d28e0f5f45f4bb648f92c650bece05	0.511177860487585844
173	ded0d6e804fc4768200ff41734b3da11	22.5351201268672838
174	e446581e4fb1bc4cc694ff659207ef45	1.00540669949445749
175	e7968a8522dc48a4180f846e01e2bf8b	4.00892096714123181
176	fa5cf435b1a6fc838329d7169389160a	14.9396719377097131
177	116ed7997e89102eaa94c80b25a70ecb	19.354548791037022
178	15215427d89211e2b6b1eaf93f40ee25	0.0559805712736457309
179	1baff48576c39d0fb71e0e19171f6d33	12.3138995137355352
180	35eba9f65a898ba0d7a8c099d312d2b8	33.5565594654031827
181	503ea356c90777f1a6dcfb872be9d951	105.240458600371397
182	5ce3019ae5ba925c4abb669e6073ffa5	8.07127011477991019
183	67cde4149526b913e132a266e9c8509d	8.32572740188430238
184	834c742c1707eef884e5fa247807c1d3	0
185	92e224e5a0cfbd18fc8d469bfe15fe72	1.39044078136167393
186	c6e2871cecbf193dc758bec1f3c5d120	3.57072465117597071
187	d1c7a3af68e8b0b85bec3806cfde14cd	9.07502869814811852
188	d5d28e0f5f45f4bb648f92c650bece05	1.09657389694707796
189	ded0d6e804fc4768200ff41734b3da11	16.1345980820308554
190	e446581e4fb1bc4cc694ff659207ef45	48.4224856527133198
191	e7968a8522dc48a4180f846e01e2bf8b	107.240458600371397
192	fa5cf435b1a6fc838329d7169389160a	5.83356633424165683
193	116ed7997e89102eaa94c80b25a70ecb	29.7552494935125971
194	15215427d89211e2b6b1eaf93f40ee25	0.364001534482127631
195	1baff48576c39d0fb71e0e19171f6d33	27.4547511573084044
196	35eba9f65a898ba0d7a8c099d312d2b8	19.0482014072784303
197	503ea356c90777f1a6dcfb872be9d951	2.00028080578304479
198	5ce3019ae5ba925c4abb669e6073ffa5	3.78940263909743935
199	67cde4149526b913e132a266e9c8509d	17.1508229116583699
200	834c742c1707eef884e5fa247807c1d3	0
201	92e224e5a0cfbd18fc8d469bfe15fe72	4.70861137439631783
202	c6e2871cecbf193dc758bec1f3c5d120	68.5830395659760796
203	d1c7a3af68e8b0b85bec3806cfde14cd	14.4260026340436909
204	d5d28e0f5f45f4bb648f92c650bece05	0.550872021320583549
205	ded0d6e804fc4768200ff41734b3da11	40.295656299331867
206	e446581e4fb1bc4cc694ff659207ef45	4.22063372696727157
207	e7968a8522dc48a4180f846e01e2bf8b	4.00028080578304479
208	fa5cf435b1a6fc838329d7169389160a	10.0772472382405898
209	116ed7997e89102eaa94c80b25a70ecb	28.787861010618073
210	15215427d89211e2b6b1eaf93f40ee25	0.129441660172094575
211	1baff48576c39d0fb71e0e19171f6d33	25.0935608454209742
212	35eba9f65a898ba0d7a8c099d312d2b8	11.859298144282242
213	503ea356c90777f1a6dcfb872be9d951	3.01515245799900633
214	5ce3019ae5ba925c4abb669e6073ffa5	2.74120439877998923
215	67cde4149526b913e132a266e9c8509d	21.5599149360836755
216	834c742c1707eef884e5fa247807c1d3	0
217	92e224e5a0cfbd18fc8d469bfe15fe72	2.57579244589935996
218	c6e2871cecbf193dc758bec1f3c5d120	70.9826641112003074
219	d1c7a3af68e8b0b85bec3806cfde14cd	8.89917297692029585
220	d5d28e0f5f45f4bb648f92c650bece05	0.576153531094912852
221	ded0d6e804fc4768200ff41734b3da11	27.8544628716475238
222	e446581e4fb1bc4cc694ff659207ef45	6.26843601868794131
223	e7968a8522dc48a4180f846e01e2bf8b	5.01515245799900633
224	fa5cf435b1a6fc838329d7169389160a	9.34752129416629529
225	116ed7997e89102eaa94c80b25a70ecb	27.6637416566228431
226	15215427d89211e2b6b1eaf93f40ee25	0.0937048663294422213
227	1baff48576c39d0fb71e0e19171f6d33	25.2262410131666783
228	35eba9f65a898ba0d7a8c099d312d2b8	9.66978748299827906
229	503ea356c90777f1a6dcfb872be9d951	11.137847460831054
230	5ce3019ae5ba925c4abb669e6073ffa5	1.48894392278872512
231	67cde4149526b913e132a266e9c8509d	30.0085512007780615
232	834c742c1707eef884e5fa247807c1d3	0
233	92e224e5a0cfbd18fc8d469bfe15fe72	1.97239184914734533
234	c6e2871cecbf193dc758bec1f3c5d120	35.6905710370759692
235	d1c7a3af68e8b0b85bec3806cfde14cd	7.30268926548105757
236	d5d28e0f5f45f4bb648f92c650bece05	0.582374228068767485
237	ded0d6e804fc4768200ff41734b3da11	20.3547560365951021
238	e446581e4fb1bc4cc694ff659207ef45	6.77231247357016386
239	e7968a8522dc48a4180f846e01e2bf8b	13.137847460831054
240	fa5cf435b1a6fc838329d7169389160a	8.74996981032090737
241	116ed7997e89102eaa94c80b25a70ecb	26.8833810765156151
242	15215427d89211e2b6b1eaf93f40ee25	0.0637698143949493867
243	1baff48576c39d0fb71e0e19171f6d33	22.6851560171649105
244	35eba9f65a898ba0d7a8c099d312d2b8	10.1619164768163213
245	503ea356c90777f1a6dcfb872be9d951	16.3888902290180027
246	5ce3019ae5ba925c4abb669e6073ffa5	1.28098847201691668
247	67cde4149526b913e132a266e9c8509d	25.8581017448677812
248	834c742c1707eef884e5fa247807c1d3	0
249	92e224e5a0cfbd18fc8d469bfe15fe72	2.13356009124456403
250	c6e2871cecbf193dc758bec1f3c5d120	14.5716337601195907
251	d1c7a3af68e8b0b85bec3806cfde14cd	8.38491708857785589
252	d5d28e0f5f45f4bb648f92c650bece05	0.586457539176978293
253	ded0d6e804fc4768200ff41734b3da11	19.0610500377636463
254	e446581e4fb1bc4cc694ff659207ef45	7.10306067333524194
255	e7968a8522dc48a4180f846e01e2bf8b	18.3888902290180027
256	fa5cf435b1a6fc838329d7169389160a	10.5225271143782173
257	116ed7997e89102eaa94c80b25a70ecb	31.2936418658525106
258	15215427d89211e2b6b1eaf93f40ee25	0.0478888596957040558
259	1baff48576c39d0fb71e0e19171f6d33	6.7577520324415099
260	35eba9f65a898ba0d7a8c099d312d2b8	80.0523120275127553
261	503ea356c90777f1a6dcfb872be9d951	16.3888902290180027
262	5ce3019ae5ba925c4abb669e6073ffa5	5.78115283408337621
263	67cde4149526b913e132a266e9c8509d	2.249025270259148
264	834c742c1707eef884e5fa247807c1d3	0
265	92e224e5a0cfbd18fc8d469bfe15fe72	2.13356009124456403
266	c6e2871cecbf193dc758bec1f3c5d120	14.5716337601195907
267	d1c7a3af68e8b0b85bec3806cfde14cd	6.23693132194984123
268	d5d28e0f5f45f4bb648f92c650bece05	0.753236908472391553
269	ded0d6e804fc4768200ff41734b3da11	14.9399021194683641
270	e446581e4fb1bc4cc694ff659207ef45	20.612189586263721
271	e7968a8522dc48a4180f846e01e2bf8b	18.3888902290180027
272	fa5cf435b1a6fc838329d7169389160a	35.966025969480647
273	116ed7997e89102eaa94c80b25a70ecb	30.6039809235839897
274	15215427d89211e2b6b1eaf93f40ee25	0.0534324035186335353
275	1baff48576c39d0fb71e0e19171f6d33	10.1705996814078361
276	35eba9f65a898ba0d7a8c099d312d2b8	45.3210229016774164
277	503ea356c90777f1a6dcfb872be9d951	15.8286873425998813
278	5ce3019ae5ba925c4abb669e6073ffa5	9.04198283644861256
279	67cde4149526b913e132a266e9c8509d	5.5284447976583273
280	834c742c1707eef884e5fa247807c1d3	0
281	92e224e5a0cfbd18fc8d469bfe15fe72	2.04735886747066731
282	c6e2871cecbf193dc758bec1f3c5d120	18.6347334365252983
283	d1c7a3af68e8b0b85bec3806cfde14cd	6.23693132194984123
284	d5d28e0f5f45f4bb648f92c650bece05	0.850175054799502172
285	ded0d6e804fc4768200ff41734b3da11	15.6634354915378005
286	e446581e4fb1bc4cc694ff659207ef45	28.4641794387596754
287	e7968a8522dc48a4180f846e01e2bf8b	17.8286873425998813
288	fa5cf435b1a6fc838329d7169389160a	14.751967572578911
289	116ed7997e89102eaa94c80b25a70ecb	25.9307610104797952
290	15215427d89211e2b6b1eaf93f40ee25	0.0693578738989136245
291	1baff48576c39d0fb71e0e19171f6d33	11.5799031618915738
292	35eba9f65a898ba0d7a8c099d312d2b8	40.5501993403396028
293	503ea356c90777f1a6dcfb872be9d951	16.6799438766512758
294	5ce3019ae5ba925c4abb669e6073ffa5	3.8941050004013662
295	67cde4149526b913e132a266e9c8509d	5.51394422257243555
296	834c742c1707eef884e5fa247807c1d3	0
297	92e224e5a0cfbd18fc8d469bfe15fe72	1.66740527190752763
298	c6e2871cecbf193dc758bec1f3c5d120	42.9273877061037084
299	d1c7a3af68e8b0b85bec3806cfde14cd	6.80297612302020127
300	d5d28e0f5f45f4bb648f92c650bece05	0.69085170443251942
301	ded0d6e804fc4768200ff41734b3da11	20.0431598765005283
302	e446581e4fb1bc4cc694ff659207ef45	15.5589880590340748
303	e7968a8522dc48a4180f846e01e2bf8b	18.6799438766512758
304	fa5cf435b1a6fc838329d7169389160a	19.7935107604165168
305	116ed7997e89102eaa94c80b25a70ecb	25.3517275174079657
306	15215427d89211e2b6b1eaf93f40ee25	0.0997196755931062523
307	1baff48576c39d0fb71e0e19171f6d33	12.3318441214472099
308	35eba9f65a898ba0d7a8c099d312d2b8	42.504591299940742
309	503ea356c90777f1a6dcfb872be9d951	10.4215675488744939
310	5ce3019ae5ba925c4abb669e6073ffa5	4.10389420576177955
311	67cde4149526b913e132a266e9c8509d	5.16882153696410196
312	834c742c1707eef884e5fa247807c1d3	0
313	92e224e5a0cfbd18fc8d469bfe15fe72	2.44794259614262977
314	c6e2871cecbf193dc758bec1f3c5d120	15.7564285684900227
315	d1c7a3af68e8b0b85bec3806cfde14cd	10.7004263558963686
316	d5d28e0f5f45f4bb648f92c650bece05	0.6697433048704865
317	ded0d6e804fc4768200ff41734b3da11	23.639086103847756
318	e446581e4fb1bc4cc694ff659207ef45	13.8492076945094027
319	e7968a8522dc48a4180f846e01e2bf8b	12.4215675488744939
320	fa5cf435b1a6fc838329d7169389160a	19.4991576003297666
321	116ed7997e89102eaa94c80b25a70ecb	30.1746884687585606
322	15215427d89211e2b6b1eaf93f40ee25	0.127679357858979992
323	1baff48576c39d0fb71e0e19171f6d33	15.6386784662200409
324	35eba9f65a898ba0d7a8c099d312d2b8	31.6052369128806596
325	503ea356c90777f1a6dcfb872be9d951	2.71304587951811271
326	5ce3019ae5ba925c4abb669e6073ffa5	2.88913759426649142
327	67cde4149526b913e132a266e9c8509d	7.64032417202811853
328	834c742c1707eef884e5fa247807c1d3	0
329	92e224e5a0cfbd18fc8d469bfe15fe72	4.21371689539243466
330	c6e2871cecbf193dc758bec1f3c5d120	14.7904357778295861
331	d1c7a3af68e8b0b85bec3806cfde14cd	12.7842691499373622
332	d5d28e0f5f45f4bb648f92c650bece05	0.574625532977743547
333	ded0d6e804fc4768200ff41734b3da11	27.0954413492104358
334	e446581e4fb1bc4cc694ff659207ef45	6.14466817119723085
335	e7968a8522dc48a4180f846e01e2bf8b	4.71304587951811271
336	fa5cf435b1a6fc838329d7169389160a	22.6519737616171248
337	116ed7997e89102eaa94c80b25a70ecb	25.0380605125450231
338	15215427d89211e2b6b1eaf93f40ee25	0.128925360793086891
339	1baff48576c39d0fb71e0e19171f6d33	20.3607256634482958
340	35eba9f65a898ba0d7a8c099d312d2b8	18.9527858292722478
341	503ea356c90777f1a6dcfb872be9d951	2.71699316950869152
342	5ce3019ae5ba925c4abb669e6073ffa5	1.48243680652293475
343	67cde4149526b913e132a266e9c8509d	10.1125194994003582
344	834c742c1707eef884e5fa247807c1d3	0
345	92e224e5a0cfbd18fc8d469bfe15fe72	4.18502694578466716
346	c6e2871cecbf193dc758bec1f3c5d120	15.1689050134794403
347	d1c7a3af68e8b0b85bec3806cfde14cd	17.4707728547896508
348	d5d28e0f5f45f4bb648f92c650bece05	0.542282961861887736
349	ded0d6e804fc4768200ff41734b3da11	35.3205468066251953
350	e446581e4fb1bc4cc694ff659207ef45	3.5249199108129039
351	e7968a8522dc48a4180f846e01e2bf8b	4.71699316950869196
352	fa5cf435b1a6fc838329d7169389160a	19.825729559453606
353	116ed7997e89102eaa94c80b25a70ecb	19.0391480048480304
354	15215427d89211e2b6b1eaf93f40ee25	0.122141701815974016
355	1baff48576c39d0fb71e0e19171f6d33	36.4548852326218196
356	35eba9f65a898ba0d7a8c099d312d2b8	4.1935302951375375
357	503ea356c90777f1a6dcfb872be9d951	6.60183698868370783
358	5ce3019ae5ba925c4abb669e6073ffa5	0.600867453588258105
359	67cde4149526b913e132a266e9c8509d	32.8847022331137211
360	834c742c1707eef884e5fa247807c1d3	0
361	92e224e5a0cfbd18fc8d469bfe15fe72	1.61197239472266673
362	c6e2871cecbf193dc758bec1f3c5d120	131.622259426227913
363	d1c7a3af68e8b0b85bec3806cfde14cd	11.3384925267049148
364	d5d28e0f5f45f4bb648f92c650bece05	0.533208048728102346
365	ded0d6e804fc4768200ff41734b3da11	39.1774077729369452
366	e446581e4fb1bc4cc694ff659207ef45	2.78985194697629479
367	e7968a8522dc48a4180f846e01e2bf8b	8.60183698868370783
368	fa5cf435b1a6fc838329d7169389160a	6.9452129970846892
369	116ed7997e89102eaa94c80b25a70ecb	26.3363839085647449
370	15215427d89211e2b6b1eaf93f40ee25	0.135508949947933166
371	1baff48576c39d0fb71e0e19171f6d33	36.0484299102380064
372	35eba9f65a898ba0d7a8c099d312d2b8	4.65054096139612572
373	503ea356c90777f1a6dcfb872be9d951	2.3884638699825822
374	5ce3019ae5ba925c4abb669e6073ffa5	0.672645770253413655
375	67cde4149526b913e132a266e9c8509d	36.0612042104477482
376	834c742c1707eef884e5fa247807c1d3	0
377	92e224e5a0cfbd18fc8d469bfe15fe72	4.15011028331623866
378	c6e2871cecbf193dc758bec1f3c5d120	22.5511706356895374
379	d1c7a3af68e8b0b85bec3806cfde14cd	15.9670706328408887
380	d5d28e0f5f45f4bb648f92c650bece05	0.518522840061448664
381	ded0d6e804fc4768200ff41734b3da11	35.0577568672700863
382	e446581e4fb1bc4cc694ff659207ef45	1.60035004497733824
383	e7968a8522dc48a4180f846e01e2bf8b	4.38846386998258176
384	fa5cf435b1a6fc838329d7169389160a	9.71930287056379072
385	116ed7997e89102eaa94c80b25a70ecb	24.1208552753764032
386	15215427d89211e2b6b1eaf93f40ee25	0.080364079601678573
387	1baff48576c39d0fb71e0e19171f6d33	32.0491007560978929
388	35eba9f65a898ba0d7a8c099d312d2b8	4.65054096139612572
389	503ea356c90777f1a6dcfb872be9d951	7.60204474633243521
390	5ce3019ae5ba925c4abb669e6073ffa5	0.672645770253413655
391	67cde4149526b913e132a266e9c8509d	36.0612042104477482
392	834c742c1707eef884e5fa247807c1d3	0
393	92e224e5a0cfbd18fc8d469bfe15fe72	1.92164437923247622
394	c6e2871cecbf193dc758bec1f3c5d120	61.8767122673572345
395	d1c7a3af68e8b0b85bec3806cfde14cd	9.16876076471756285
396	d5d28e0f5f45f4bb648f92c650bece05	0.538797619621388946
397	ded0d6e804fc4768200ff41734b3da11	27.5946039859138672
398	e446581e4fb1bc4cc694ff659207ef45	3.24260718933250525
399	e7968a8522dc48a4180f846e01e2bf8b	9.60204474633243521
400	fa5cf435b1a6fc838329d7169389160a	8.50147960367128164
\.


--
-- TOC entry 2522 (class 0 OID 0)
-- Dependencies: 221
-- Name: graph_edgecost_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_edgecost_id_seq', 400, true);


--
-- TOC entry 2464 (class 0 OID 20202)
-- Dependencies: 220
-- Data for Name: graph_flowdistribution; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_flowdistribution (id, username, turn_id) FROM stdin;
25	DoctorKrichene	3
26	Batmobile_Incorporated	3
27	wildy123	3
28	julien	3
29	xyz	3
30	Walid_Supreme_Ruler_o_t_U	3
31	SN	3
32	walidussnake	3
33	DoctorKrichene	4
34	Batmobile_Incorporated	4
35	wildy123	4
36	julien	4
9	DoctorKrichene	1
10	Batmobile_Incorporated	1
11	wildy123	1
12	julien	1
13	xyz	1
14	Walid_Supreme_Ruler_o_t_U	1
15	SN	1
16	walidussnake	1
17	DoctorKrichene	2
18	Batmobile_Incorporated	2
19	wildy123	2
20	julien	2
21	xyz	2
22	Walid_Supreme_Ruler_o_t_U	2
23	SN	2
24	walidussnake	2
37	xyz	4
38	Walid_Supreme_Ruler_o_t_U	4
39	SN	4
40	walidussnake	4
41	DoctorKrichene	5
42	Batmobile_Incorporated	5
43	wildy123	5
44	julien	5
45	xyz	5
46	Walid_Supreme_Ruler_o_t_U	5
47	SN	5
48	walidussnake	5
49	DoctorKrichene	6
50	Batmobile_Incorporated	6
51	wildy123	6
52	julien	6
53	xyz	6
54	Walid_Supreme_Ruler_o_t_U	6
55	SN	6
56	walidussnake	6
57	DoctorKrichene	7
58	Batmobile_Incorporated	7
59	wildy123	7
60	julien	7
61	xyz	7
62	Walid_Supreme_Ruler_o_t_U	7
63	SN	7
64	walidussnake	7
65	DoctorKrichene	8
66	Batmobile_Incorporated	8
67	wildy123	8
68	julien	8
69	xyz	8
70	Walid_Supreme_Ruler_o_t_U	8
71	SN	8
72	walidussnake	8
73	DoctorKrichene	9
74	Batmobile_Incorporated	9
75	wildy123	9
76	julien	9
77	xyz	9
78	Walid_Supreme_Ruler_o_t_U	9
79	SN	9
80	walidussnake	9
81	DoctorKrichene	10
82	Batmobile_Incorporated	10
83	wildy123	10
84	julien	10
85	xyz	10
86	Walid_Supreme_Ruler_o_t_U	10
87	SN	10
88	walidussnake	10
89	DoctorKrichene	11
90	Batmobile_Incorporated	11
91	wildy123	11
92	julien	11
93	xyz	11
94	Walid_Supreme_Ruler_o_t_U	11
95	SN	11
96	walidussnake	11
97	DoctorKrichene	12
98	Batmobile_Incorporated	12
99	wildy123	12
100	julien	12
101	xyz	12
102	Walid_Supreme_Ruler_o_t_U	12
103	SN	12
104	walidussnake	12
105	DoctorKrichene	13
106	Batmobile_Incorporated	13
107	wildy123	13
108	julien	13
109	xyz	13
110	Walid_Supreme_Ruler_o_t_U	13
111	SN	13
112	walidussnake	13
113	DoctorKrichene	14
114	Batmobile_Incorporated	14
115	wildy123	14
116	julien	14
117	xyz	14
118	Walid_Supreme_Ruler_o_t_U	14
119	SN	14
120	walidussnake	14
121	DoctorKrichene	15
122	Batmobile_Incorporated	15
123	wildy123	15
124	julien	15
125	xyz	15
126	Walid_Supreme_Ruler_o_t_U	15
127	SN	15
128	walidussnake	15
129	DoctorKrichene	16
130	Batmobile_Incorporated	16
131	wildy123	16
132	julien	16
133	xyz	16
134	Walid_Supreme_Ruler_o_t_U	16
135	SN	16
136	walidussnake	16
137	DoctorKrichene	17
138	Batmobile_Incorporated	17
139	wildy123	17
140	julien	17
141	xyz	17
142	Walid_Supreme_Ruler_o_t_U	17
143	SN	17
144	walidussnake	17
145	DoctorKrichene	18
146	Batmobile_Incorporated	18
147	wildy123	18
148	julien	18
149	xyz	18
150	Walid_Supreme_Ruler_o_t_U	18
151	SN	18
152	walidussnake	18
153	DoctorKrichene	19
154	Batmobile_Incorporated	19
155	wildy123	19
156	julien	19
157	xyz	19
158	Walid_Supreme_Ruler_o_t_U	19
159	SN	19
160	walidussnake	19
161	DoctorKrichene	20
162	Batmobile_Incorporated	20
163	wildy123	20
164	julien	20
165	xyz	20
166	Walid_Supreme_Ruler_o_t_U	20
167	SN	20
168	walidussnake	20
169	DoctorKrichene	21
170	Batmobile_Incorporated	21
171	wildy123	21
172	julien	21
173	xyz	21
174	Walid_Supreme_Ruler_o_t_U	21
175	SN	21
176	walidussnake	21
177	DoctorKrichene	22
178	Batmobile_Incorporated	22
179	wildy123	22
180	julien	22
181	xyz	22
182	Walid_Supreme_Ruler_o_t_U	22
183	SN	22
184	walidussnake	22
185	DoctorKrichene	23
186	Batmobile_Incorporated	23
187	wildy123	23
188	julien	23
189	xyz	23
190	Walid_Supreme_Ruler_o_t_U	23
191	SN	23
192	walidussnake	23
193	DoctorKrichene	24
194	Batmobile_Incorporated	24
195	wildy123	24
196	julien	24
197	xyz	24
198	Walid_Supreme_Ruler_o_t_U	24
199	SN	24
200	walidussnake	24
201	DoctorKrichene	25
202	Batmobile_Incorporated	25
203	wildy123	25
204	julien	25
205	xyz	25
206	Walid_Supreme_Ruler_o_t_U	25
207	SN	25
208	walidussnake	25
\.


--
-- TOC entry 2523 (class 0 OID 0)
-- Dependencies: 219
-- Name: graph_flowdistribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_flowdistribution_id_seq', 208, true);


--
-- TOC entry 2462 (class 0 OID 20187)
-- Dependencies: 218
-- Data for Name: graph_flowdistribution_path_assignments; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_flowdistribution_path_assignments (id, flowdistribution_id, pathflowassignment_id) FROM stdin;
1803	9	1
1804	9	2
1805	9	3
1806	10	4
1807	10	5
1808	10	6
1809	10	7
1810	10	8
1811	10	9
1812	11	10
1813	11	11
1814	11	12
1815	11	13
1816	12	14
1817	12	15
1818	12	16
1819	12	17
1820	13	18
1821	13	19
1822	13	20
1823	13	21
1824	13	22
1825	13	23
1826	14	24
1827	14	25
1828	14	26
1829	15	27
1830	15	28
1831	15	29
1832	15	30
1833	16	31
1834	16	32
1835	16	33
1836	16	34
1837	17	35
1838	17	36
1839	17	37
1840	18	38
1841	18	39
1842	18	40
1843	18	41
1844	18	42
1845	18	43
1846	19	44
1847	19	45
1848	19	46
1849	19	47
1850	20	48
1851	20	49
1852	20	50
1853	20	51
1854	21	52
1855	21	53
1856	21	54
1857	21	55
1858	21	56
1859	21	57
1860	22	58
1861	22	59
1862	22	60
1863	23	61
1864	23	62
1865	23	63
1866	23	64
1867	24	65
1868	24	66
1869	24	67
1870	24	68
1871	25	69
1872	25	70
1873	25	71
1874	26	72
1875	26	73
1876	26	74
1877	26	75
1878	26	76
1879	26	77
1880	27	78
1881	27	79
1882	27	80
1883	27	81
1884	28	82
1885	28	83
1886	28	84
1887	28	85
1888	29	86
1889	29	87
1890	29	88
1891	29	89
1892	29	90
1893	29	91
1894	30	92
1895	30	93
1896	30	94
1897	31	95
1898	31	96
1899	31	97
1900	31	98
1901	32	99
1902	32	100
1903	32	101
1904	32	102
1905	33	103
1906	33	104
1907	33	105
1908	34	106
1909	34	107
1910	34	108
1911	34	109
1912	34	110
1913	34	111
1914	35	112
1915	35	113
1916	35	114
1917	35	115
1918	36	116
1919	36	117
1920	36	118
1921	36	119
1922	37	120
1923	37	121
1924	37	122
1925	37	123
1926	37	124
1927	37	125
1928	38	126
1929	38	127
1930	38	128
1931	39	129
1932	39	130
1933	39	131
1934	39	132
1935	40	133
1936	40	134
1937	40	135
1938	40	136
1939	41	137
1940	41	138
1941	41	139
1942	42	140
1943	42	141
1944	42	142
1945	42	143
1946	42	144
1947	42	145
1948	43	146
1949	43	147
1950	43	148
1951	43	149
1952	44	150
1953	44	151
1954	44	152
1955	44	153
1956	45	154
1957	45	155
1958	45	156
1959	45	157
1960	45	158
1961	45	159
1962	46	160
1963	46	161
1964	46	162
1965	47	163
1966	47	164
1967	47	165
1968	47	166
1969	48	167
1970	48	168
1971	48	169
1972	48	170
1973	49	171
1974	49	172
1975	49	173
1976	50	174
1977	50	175
1978	50	176
1979	50	177
1980	50	178
1981	50	179
1982	51	180
1983	51	181
1984	51	182
1985	51	183
1986	52	184
1987	52	185
1988	52	186
1989	52	187
1990	53	188
1991	53	189
1992	53	190
1993	53	191
1994	53	192
1995	53	193
1996	54	194
1997	54	195
1998	54	196
1999	55	197
2000	55	198
2001	55	199
2002	55	200
2003	56	201
2004	56	202
2005	56	203
2006	56	204
2007	57	205
2008	57	206
2009	57	207
2010	58	208
2011	58	209
2012	58	210
2013	58	211
2014	58	212
2015	58	213
2016	59	214
2017	59	215
2018	59	216
2019	59	217
2020	60	218
2021	60	219
2022	60	220
2023	60	221
2024	61	222
2025	61	223
2026	61	224
2027	61	225
2028	61	226
2029	61	227
2030	62	228
2031	62	229
2032	62	230
2033	63	231
2034	63	232
2035	63	233
2036	63	234
2037	64	235
2038	64	236
2039	64	237
2040	64	238
2041	65	239
2042	65	240
2043	65	241
2044	66	242
2045	66	243
2046	66	244
2047	66	245
2048	66	246
2049	66	247
2050	67	248
2051	67	249
2052	67	250
2053	67	251
2054	68	252
2055	68	253
2056	68	254
2057	68	255
2058	69	256
2059	69	257
2060	69	258
2061	69	259
2062	69	260
2063	69	261
2064	70	262
2065	70	263
2066	70	264
2067	71	265
2068	71	266
2069	71	267
2070	71	268
2071	72	269
2072	72	270
2073	72	271
2074	72	272
2075	73	273
2076	73	274
2077	73	275
2078	74	276
2079	74	277
2080	74	278
2081	74	279
2082	74	280
2083	74	281
2084	75	282
2085	75	283
2086	75	284
2087	75	285
2088	76	286
2089	76	287
2090	76	288
2091	76	289
2092	77	290
2093	77	291
2094	77	292
2095	77	293
2096	77	294
2097	77	295
2098	78	296
2099	78	297
2100	78	298
2101	79	299
2102	79	300
2103	79	301
2104	79	302
2105	80	303
2106	80	304
2107	80	305
2108	80	306
2109	81	307
2110	81	308
2111	81	309
2112	82	310
2113	82	311
2114	82	312
2115	82	313
2116	82	314
2117	82	315
2118	83	316
2119	83	317
2120	83	318
2121	83	319
2122	84	320
2123	84	321
2124	84	322
2125	84	323
2126	85	324
2127	85	325
2128	85	326
2129	85	327
2130	85	328
2131	85	329
2132	86	330
2133	86	331
2134	86	332
2135	87	333
2136	87	334
2137	87	335
2138	87	336
2139	88	337
2140	88	338
2141	88	339
2142	88	340
2143	89	341
2144	89	342
2145	89	343
2146	90	344
2147	90	345
2148	90	346
2149	90	347
2150	90	348
2151	90	349
2152	91	350
2153	91	351
2154	91	352
2155	91	353
2156	92	354
2157	92	355
2158	92	356
2159	92	357
2160	93	358
2161	93	359
2162	93	360
2163	93	361
2164	93	362
2165	93	363
2166	94	364
2167	94	365
2168	94	366
2169	95	367
2170	95	368
2171	95	369
2172	95	370
2173	96	371
2174	96	372
2175	96	373
2176	96	374
2177	97	375
2178	97	376
2179	97	377
2180	98	378
2181	98	379
2182	98	380
2183	98	381
2184	98	382
2185	98	383
2186	99	384
2187	99	385
2188	99	386
2189	99	387
2190	100	388
2191	100	389
2192	100	390
2193	100	391
2194	101	392
2195	101	393
2196	101	394
2197	101	395
2198	101	396
2199	101	397
2200	102	398
2201	102	399
2202	102	400
2203	103	401
2204	103	402
2205	103	403
2206	103	404
2207	104	405
2208	104	406
2209	104	407
2210	104	408
2211	105	409
2212	105	410
2213	105	411
2214	106	412
2215	106	413
2216	106	414
2217	106	415
2218	106	416
2219	106	417
2220	107	418
2221	107	419
2222	107	420
2223	107	421
2224	108	422
2225	108	423
2226	108	424
2227	108	425
2228	109	426
2229	109	427
2230	109	428
2231	109	429
2232	109	430
2233	109	431
2234	110	432
2235	110	433
2236	110	434
2237	111	435
2238	111	436
2239	111	437
2240	111	438
2241	112	439
2242	112	440
2243	112	441
2244	112	442
2245	113	443
2246	113	444
2247	113	445
2248	114	446
2249	114	447
2250	114	448
2251	114	449
2252	114	450
2253	114	451
2254	115	452
2255	115	453
2256	115	454
2257	115	455
2258	116	456
2259	116	457
2260	116	458
2261	116	459
2262	117	460
2263	117	461
2264	117	462
2265	117	463
2266	117	464
2267	117	465
2268	118	466
2269	118	467
2270	118	468
2271	119	469
2272	119	470
2273	119	471
2274	119	472
2275	120	473
2276	120	474
2277	120	475
2278	120	476
2279	121	477
2280	121	478
2281	121	479
2282	122	480
2283	122	481
2284	122	482
2285	122	483
2286	122	484
2287	122	485
2288	123	486
2289	123	487
2290	123	488
2291	123	489
2292	124	490
2293	124	491
2294	124	492
2295	124	493
2296	125	494
2297	125	495
2298	125	496
2299	125	497
2300	125	498
2301	125	499
2302	126	500
2303	126	501
2304	126	502
2305	127	503
2306	127	504
2307	127	505
2308	127	506
2309	128	507
2310	128	508
2311	128	509
2312	128	510
2313	129	511
2314	129	512
2315	129	513
2316	130	514
2317	130	515
2318	130	516
2319	130	517
2320	130	518
2321	130	519
2322	131	520
2323	131	521
2324	131	522
2325	131	523
2326	132	524
2327	132	525
2328	132	526
2329	132	527
2330	133	528
2331	133	529
2332	133	530
2333	133	531
2334	133	532
2335	133	533
2336	134	534
2337	134	535
2338	134	536
2339	135	537
2340	135	538
2341	135	539
2342	135	540
2343	136	541
2344	136	542
2345	136	543
2346	136	544
2347	137	545
2348	137	546
2349	137	547
2350	138	548
2351	138	549
2352	138	550
2353	138	551
2354	138	552
2355	138	553
2356	139	554
2357	139	555
2358	139	556
2359	139	557
2360	140	558
2361	140	559
2362	140	560
2363	140	561
2364	141	562
2365	141	563
2366	141	564
2367	141	565
2368	141	566
2369	141	567
2370	142	568
2371	142	569
2372	142	570
2373	143	571
2374	143	572
2375	143	573
2376	143	574
2377	144	575
2378	144	576
2379	144	577
2380	144	578
2381	145	579
2382	145	580
2383	145	581
2384	146	582
2385	146	583
2386	146	584
2387	146	585
2388	146	586
2389	146	587
2390	147	588
2391	147	589
2392	147	590
2393	147	591
2394	148	592
2395	148	593
2396	148	594
2397	148	595
2398	149	596
2399	149	597
2400	149	598
2401	149	599
2402	149	600
2403	149	601
2404	150	602
2405	150	603
2406	150	604
2407	151	605
2408	151	606
2409	151	607
2410	151	608
2411	152	609
2412	152	610
2413	152	611
2414	152	612
2415	153	613
2416	153	614
2417	153	615
2418	154	616
2419	154	617
2420	154	618
2421	154	619
2422	154	620
2423	154	621
2424	155	622
2425	155	623
2426	155	624
2427	155	625
2428	156	626
2429	156	627
2430	156	628
2431	156	629
2432	157	630
2433	157	631
2434	157	632
2435	157	633
2436	157	634
2437	157	635
2438	158	636
2439	158	637
2440	158	638
2441	159	639
2442	159	640
2443	159	641
2444	159	642
2445	160	643
2446	160	644
2447	160	645
2448	160	646
2449	161	647
2450	161	648
2451	161	649
2452	162	650
2453	162	651
2454	162	652
2455	162	653
2456	162	654
2457	162	655
2458	163	656
2459	163	657
2460	163	658
2461	163	659
2462	164	660
2463	164	661
2464	164	662
2465	164	663
2466	165	664
2467	165	665
2468	165	666
2469	165	667
2470	165	668
2471	165	669
2472	166	670
2473	166	671
2474	166	672
2475	167	673
2476	167	674
2477	167	675
2478	167	676
2479	168	677
2480	168	678
2481	168	679
2482	168	680
2483	169	681
2484	169	682
2485	169	683
2486	170	684
2487	170	685
2488	170	686
2489	170	687
2490	170	688
2491	170	689
2492	171	690
2493	171	691
2494	171	692
2495	171	693
2496	172	694
2497	172	695
2498	172	696
2499	172	697
2500	173	698
2501	173	699
2502	173	700
2503	173	701
2504	173	702
2505	173	703
2506	174	704
2507	174	705
2508	174	706
2509	175	707
2510	175	708
2511	175	709
2512	175	710
2513	176	711
2514	176	712
2515	176	713
2516	176	714
2517	177	715
2518	177	716
2519	177	717
2520	178	718
2521	178	719
2522	178	720
2523	178	721
2524	178	722
2525	178	723
2526	179	724
2527	179	725
2528	179	726
2529	179	727
2530	180	728
2531	180	729
2532	180	730
2533	180	731
2534	181	732
2535	181	733
2536	181	734
2537	181	735
2538	181	736
2539	181	737
2540	182	738
2541	182	739
2542	182	740
2543	183	741
2544	183	742
2545	183	743
2546	183	744
2547	184	745
2548	184	746
2549	184	747
2550	184	748
2551	185	749
2552	185	750
2553	185	751
2554	186	752
2555	186	753
2556	186	754
2557	186	755
2558	186	756
2559	186	757
2560	187	758
2561	187	759
2562	187	760
2563	187	761
2564	188	762
2565	188	763
2566	188	764
2567	188	765
2568	189	766
2569	189	767
2570	189	768
2571	189	769
2572	189	770
2573	189	771
2574	190	772
2575	190	773
2576	190	774
2577	191	775
2578	191	776
2579	191	777
2580	191	778
2581	192	779
2582	192	780
2583	192	781
2584	192	782
2585	193	783
2586	193	784
2587	193	785
2588	194	786
2589	194	787
2590	194	788
2591	194	789
2592	194	790
2593	194	791
2594	195	792
2595	195	793
2596	195	794
2597	195	795
2598	196	796
2599	196	797
2600	196	798
2601	196	799
2602	197	800
2603	197	801
2604	197	802
2605	197	803
2606	197	804
2607	197	805
2608	198	806
2609	198	807
2610	198	808
2611	199	809
2612	199	810
2613	199	811
2614	199	812
2615	200	813
2616	200	814
2617	200	815
2618	200	816
2619	201	817
2620	201	818
2621	201	819
2622	202	820
2623	202	821
2624	202	822
2625	202	823
2626	202	824
2627	202	825
2628	203	826
2629	203	827
2630	203	828
2631	203	829
2632	204	830
2633	204	831
2634	204	832
2635	204	833
2636	205	834
2637	205	835
2638	205	836
2639	205	837
2640	205	838
2641	205	839
2642	206	840
2643	206	841
2644	206	842
2645	207	843
2646	207	844
2647	207	845
2648	207	846
2649	208	847
2650	208	848
2651	208	849
2652	208	850
\.


--
-- TOC entry 2524 (class 0 OID 0)
-- Dependencies: 217
-- Name: graph_flowdistribution_path_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_flowdistribution_path_assignments_id_seq', 2652, true);


--
-- TOC entry 2473 (class 0 OID 20303)
-- Dependencies: 229
-- Data for Name: graph_game; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_game (name, current_turn_id, graph_id, started, game_loop_time, stopped, edge_highlight) FROM stdin;
game	26	test	t	2015-06-26 18:00:51.655228-04	t	f
\.


--
-- TOC entry 2472 (class 0 OID 20287)
-- Dependencies: 228
-- Data for Name: graph_game_turns; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_game_turns (id, game_id, gameturn_id) FROM stdin;
54	game	1
55	game	2
56	game	3
57	game	4
58	game	5
59	game	6
60	game	7
61	game	8
62	game	9
63	game	10
64	game	11
65	game	12
66	game	13
67	game	14
68	game	15
69	game	16
70	game	17
71	game	18
72	game	19
73	game	20
74	game	21
75	game	22
76	game	23
77	game	24
78	game	25
\.


--
-- TOC entry 2525 (class 0 OID 0)
-- Dependencies: 227
-- Name: graph_game_turns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_game_turns_id_seq', 78, true);


--
-- TOC entry 2460 (class 0 OID 20179)
-- Dependencies: 216
-- Data for Name: graph_gameturn; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_gameturn (id, iteration, graph_cost_id) FROM stdin;
18	17	18
1	0	1
2	1	2
19	18	19
3	2	3
4	3	4
20	19	20
5	4	5
6	5	6
21	20	21
7	6	7
8	7	8
22	21	22
9	8	9
10	9	10
23	22	23
11	10	11
12	11	12
24	23	24
13	12	13
14	13	14
25	24	25
15	14	15
26	25	\N
16	15	16
17	16	17
\.


--
-- TOC entry 2526 (class 0 OID 0)
-- Dependencies: 215
-- Name: graph_gameturn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_gameturn_id_seq', 26, true);


--
-- TOC entry 2447 (class 0 OID 20030)
-- Dependencies: 203
-- Data for Name: graph_graph; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_graph (name, graph_ui) FROM stdin;
test	{"graph": "test", "nodes": [{"index": 0, "reflexive": false, "weight": 3, "px": 202, "py": 18, "y": 18, "x": 202, "id": 1}, {"index": 1, "reflexive": false, "weight": 2, "px": 143, "py": 15, "y": 15, "x": 143, "id": 2}, {"index": 2, "reflexive": false, "weight": 4, "px": 68, "py": 125, "y": 125, "x": 68, "id": 3}, {"index": 3, "reflexive": false, "weight": 2, "px": 27, "py": 187, "y": 187, "x": 27, "id": 4}, {"index": 4, "reflexive": false, "weight": 4, "px": 235, "py": 290, "y": 290, "x": 235, "id": 5}, {"index": 5, "reflexive": false, "weight": 3, "px": 181, "py": 354, "y": 354, "x": 181, "id": 6}, {"index": 6, "reflexive": false, "weight": 3, "px": 339, "py": 325, "y": 325, "x": 339, "id": 7}, {"index": 7, "reflexive": false, "weight": 3, "px": 427, "py": 320, "y": 320, "x": 427, "id": 8}, {"index": 8, "reflexive": false, "weight": 3, "px": 440, "py": 259, "y": 259, "x": 440, "id": 9}, {"index": 9, "reflexive": false, "weight": 3, "px": 351, "py": 100, "y": 100, "x": 351, "id": 10}, {"index": 10, "reflexive": false, "weight": 2, "px": 370, "py": 398, "y": 398, "x": 370, "id": 11}], "links": [{"id": "35eba9f65a898ba0d7a8c099d312d2b8", "source": {"index": 0, "reflexive": false, "weight": 3, "px": 202, "py": 18, "y": 18, "x": 202, "id": 1}, "right": true, "target": {"index": 2, "reflexive": false, "weight": 4, "px": 68, "py": 125, "y": 125, "x": 68, "id": 3}, "left": false}, {"id": "15215427d89211e2b6b1eaf93f40ee25", "source": {"index": 1, "reflexive": false, "weight": 2, "px": 143, "py": 15, "y": 15, "x": 143, "id": 2}, "right": false, "target": {"index": 2, "reflexive": false, "weight": 4, "px": 68, "py": 125, "y": 125, "x": 68, "id": 3}, "left": true}, {"id": "834c742c1707eef884e5fa247807c1d3", "source": {"index": 0, "reflexive": false, "weight": 3, "px": 202, "py": 18, "y": 18, "x": 202, "id": 1}, "right": false, "target": {"index": 1, "reflexive": false, "weight": 2, "px": 143, "py": 15, "y": 15, "x": 143, "id": 2}, "left": true}, {"id": "1baff48576c39d0fb71e0e19171f6d33", "source": {"index": 0, "reflexive": false, "weight": 3, "px": 202, "py": 18, "y": 18, "x": 202, "id": 1}, "right": true, "target": {"index": 9, "reflexive": false, "weight": 3, "px": 351, "py": 100, "y": 100, "x": 351, "id": 10}, "left": false}, {"id": "e446581e4fb1bc4cc694ff659207ef45", "source": {"index": 2, "reflexive": false, "weight": 4, "px": 68, "py": 125, "y": 125, "x": 68, "id": 3}, "right": true, "target": {"index": 3, "reflexive": false, "weight": 2, "px": 27, "py": 187, "y": 187, "x": 27, "id": 4}, "left": false}, {"id": "d5d28e0f5f45f4bb648f92c650bece05", "source": {"index": 3, "reflexive": false, "weight": 2, "px": 27, "py": 187, "y": 187, "x": 27, "id": 4}, "right": true, "target": {"index": 5, "reflexive": false, "weight": 3, "px": 181, "py": 354, "y": 354, "x": 181, "id": 6}, "left": false}, {"id": "fa5cf435b1a6fc838329d7169389160a", "source": {"index": 2, "reflexive": false, "weight": 4, "px": 68, "py": 125, "y": 125, "x": 68, "id": 3}, "right": true, "target": {"index": 4, "reflexive": false, "weight": 4, "px": 235, "py": 290, "y": 290, "x": 235, "id": 5}, "left": false}, {"id": "5ce3019ae5ba925c4abb669e6073ffa5", "source": {"index": 4, "reflexive": false, "weight": 4, "px": 235, "py": 290, "y": 290, "x": 235, "id": 5}, "right": false, "target": {"index": 5, "reflexive": false, "weight": 3, "px": 181, "py": 354, "y": 354, "x": 181, "id": 6}, "left": true}, {"id": "116ed7997e89102eaa94c80b25a70ecb", "source": {"index": 4, "reflexive": false, "weight": 4, "px": 235, "py": 290, "y": 290, "x": 235, "id": 5}, "right": true, "target": {"index": 6, "reflexive": false, "weight": 3, "px": 339, "py": 325, "y": 325, "x": 339, "id": 7}, "left": false}, {"id": "e7968a8522dc48a4180f846e01e2bf8b", "source": {"index": 5, "reflexive": false, "weight": 3, "px": 181, "py": 354, "y": 354, "x": 181, "id": 6}, "right": true, "target": {"index": 10, "reflexive": false, "weight": 2, "px": 370, "py": 398, "y": 398, "x": 370, "id": 11}, "left": false}, {"id": "503ea356c90777f1a6dcfb872be9d951", "source": {"index": 7, "reflexive": false, "weight": 3, "px": 427, "py": 320, "y": 320, "x": 427, "id": 8}, "right": false, "target": {"index": 10, "reflexive": false, "weight": 2, "px": 370, "py": 398, "y": 398, "x": 370, "id": 11}, "left": true}, {"id": "92e224e5a0cfbd18fc8d469bfe15fe72", "source": {"index": 6, "reflexive": false, "weight": 3, "px": 339, "py": 325, "y": 325, "x": 339, "id": 7}, "right": true, "target": {"index": 7, "reflexive": false, "weight": 3, "px": 427, "py": 320, "y": 320, "x": 427, "id": 8}, "left": false}, {"id": "c6e2871cecbf193dc758bec1f3c5d120", "source": {"index": 7, "reflexive": false, "weight": 3, "px": 427, "py": 320, "y": 320, "x": 427, "id": 8}, "right": false, "target": {"index": 8, "reflexive": false, "weight": 3, "px": 440, "py": 259, "y": 259, "x": 440, "id": 9}, "left": true}, {"id": "ded0d6e804fc4768200ff41734b3da11", "source": {"index": 8, "reflexive": false, "weight": 3, "px": 440, "py": 259, "y": 259, "x": 440, "id": 9}, "right": false, "target": {"index": 9, "reflexive": false, "weight": 3, "px": 351, "py": 100, "y": 100, "x": 351, "id": 10}, "left": true}, {"id": "67cde4149526b913e132a266e9c8509d", "source": {"index": 4, "reflexive": false, "weight": 4, "px": 235, "py": 290, "y": 290, "x": 235, "id": 5}, "right": false, "target": {"index": 9, "reflexive": false, "weight": 3, "px": 351, "py": 100, "y": 100, "x": 351, "id": 10}, "left": true}, {"id": "d1c7a3af68e8b0b85bec3806cfde14cd", "source": {"index": 6, "reflexive": false, "weight": 3, "px": 339, "py": 325, "y": 325, "x": 339, "id": 7}, "right": false, "target": {"index": 8, "reflexive": false, "weight": 3, "px": 440, "py": 259, "y": 259, "x": 440, "id": 9}, "left": true}]}
\.


--
-- TOC entry 2470 (class 0 OID 20261)
-- Dependencies: 226
-- Data for Name: graph_graphcost; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_graphcost (id, graph_id) FROM stdin;
1	test
2	test
3	test
4	test
5	test
6	test
7	test
8	test
9	test
10	test
11	test
12	test
13	test
14	test
15	test
16	test
17	test
18	test
19	test
20	test
21	test
22	test
23	test
24	test
25	test
\.


--
-- TOC entry 2468 (class 0 OID 20246)
-- Dependencies: 224
-- Data for Name: graph_graphcost_edge_costs; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_graphcost_edge_costs (id, graphcost_id, edgecost_id) FROM stdin;
849	1	1
850	1	2
851	1	3
852	1	4
853	1	5
854	1	6
855	1	7
856	1	8
857	1	9
858	1	10
859	1	11
860	1	12
861	1	13
862	1	14
863	1	15
864	1	16
865	2	17
866	2	18
867	2	19
868	2	20
869	2	21
870	2	22
871	2	23
872	2	24
873	2	25
874	2	26
875	2	27
876	2	28
877	2	29
878	2	30
879	2	31
880	2	32
881	3	33
882	3	34
883	3	35
884	3	36
885	3	37
886	3	38
887	3	39
888	3	40
889	3	41
890	3	42
891	3	43
892	3	44
893	3	45
894	3	46
895	3	47
896	3	48
897	4	49
898	4	50
899	4	51
900	4	52
901	4	53
902	4	54
903	4	55
904	4	56
905	4	57
906	4	58
907	4	59
908	4	60
909	4	61
910	4	62
911	4	63
912	4	64
913	5	65
914	5	66
915	5	67
916	5	68
917	5	69
918	5	70
919	5	71
920	5	72
921	5	73
922	5	74
923	5	75
924	5	76
925	5	77
926	5	78
927	5	79
928	5	80
929	6	81
930	6	82
931	6	83
932	6	84
933	6	85
934	6	86
935	6	87
936	6	88
937	6	89
938	6	90
939	6	91
940	6	92
941	6	93
942	6	94
943	6	95
944	6	96
945	7	97
946	7	98
947	7	99
948	7	100
949	7	101
950	7	102
951	7	103
952	7	104
953	7	105
954	7	106
955	7	107
956	7	108
957	7	109
958	7	110
959	7	111
960	7	112
961	8	113
962	8	114
963	8	115
964	8	116
965	8	117
966	8	118
967	8	119
968	8	120
969	8	121
970	8	122
971	8	123
972	8	124
973	8	125
974	8	126
975	8	127
976	8	128
977	9	129
978	9	130
979	9	131
980	9	132
981	9	133
982	9	134
983	9	135
984	9	136
985	9	137
986	9	138
987	9	139
988	9	140
989	9	141
990	9	142
991	9	143
992	9	144
993	10	145
994	10	146
995	10	147
996	10	148
997	10	149
998	10	150
999	10	151
1000	10	152
1001	10	153
1002	10	154
1003	10	155
1004	10	156
1005	10	157
1006	10	158
1007	10	159
1008	10	160
1009	11	161
1010	11	162
1011	11	163
1012	11	164
1013	11	165
1014	11	166
1015	11	167
1016	11	168
1017	11	169
1018	11	170
1019	11	171
1020	11	172
1021	11	173
1022	11	174
1023	11	175
1024	11	176
1025	12	177
1026	12	178
1027	12	179
1028	12	180
1029	12	181
1030	12	182
1031	12	183
1032	12	184
1033	12	185
1034	12	186
1035	12	187
1036	12	188
1037	12	189
1038	12	190
1039	12	191
1040	12	192
1041	13	193
1042	13	194
1043	13	195
1044	13	196
1045	13	197
1046	13	198
1047	13	199
1048	13	200
1049	13	201
1050	13	202
1051	13	203
1052	13	204
1053	13	205
1054	13	206
1055	13	207
1056	13	208
1057	14	209
1058	14	210
1059	14	211
1060	14	212
1061	14	213
1062	14	214
1063	14	215
1064	14	216
1065	14	217
1066	14	218
1067	14	219
1068	14	220
1069	14	221
1070	14	222
1071	14	223
1072	14	224
1073	15	225
1074	15	226
1075	15	227
1076	15	228
1077	15	229
1078	15	230
1079	15	231
1080	15	232
1081	15	233
1082	15	234
1083	15	235
1084	15	236
1085	15	237
1086	15	238
1087	15	239
1088	15	240
1089	16	241
1090	16	242
1091	16	243
1092	16	244
1093	16	245
1094	16	246
1095	16	247
1096	16	248
1097	16	249
1098	16	250
1099	16	251
1100	16	252
1101	16	253
1102	16	254
1103	16	255
1104	16	256
1105	17	257
1106	17	258
1107	17	259
1108	17	260
1109	17	261
1110	17	262
1111	17	263
1112	17	264
1113	17	265
1114	17	266
1115	17	267
1116	17	268
1117	17	269
1118	17	270
1119	17	271
1120	17	272
1121	18	273
1122	18	274
1123	18	275
1124	18	276
1125	18	277
1126	18	278
1127	18	279
1128	18	280
1129	18	281
1130	18	282
1131	18	283
1132	18	284
1133	18	285
1134	18	286
1135	18	287
1136	18	288
1137	19	289
1138	19	290
1139	19	291
1140	19	292
1141	19	293
1142	19	294
1143	19	295
1144	19	296
1145	19	297
1146	19	298
1147	19	299
1148	19	300
1149	19	301
1150	19	302
1151	19	303
1152	19	304
1153	20	305
1154	20	306
1155	20	307
1156	20	308
1157	20	309
1158	20	310
1159	20	311
1160	20	312
1161	20	313
1162	20	314
1163	20	315
1164	20	316
1165	20	317
1166	20	318
1167	20	319
1168	20	320
1169	21	321
1170	21	322
1171	21	323
1172	21	324
1173	21	325
1174	21	326
1175	21	327
1176	21	328
1177	21	329
1178	21	330
1179	21	331
1180	21	332
1181	21	333
1182	21	334
1183	21	335
1184	21	336
1185	22	337
1186	22	338
1187	22	339
1188	22	340
1189	22	341
1190	22	342
1191	22	343
1192	22	344
1193	22	345
1194	22	346
1195	22	347
1196	22	348
1197	22	349
1198	22	350
1199	22	351
1200	22	352
1201	23	353
1202	23	354
1203	23	355
1204	23	356
1205	23	357
1206	23	358
1207	23	359
1208	23	360
1209	23	361
1210	23	362
1211	23	363
1212	23	364
1213	23	365
1214	23	366
1215	23	367
1216	23	368
1217	24	369
1218	24	370
1219	24	371
1220	24	372
1221	24	373
1222	24	374
1223	24	375
1224	24	376
1225	24	377
1226	24	378
1227	24	379
1228	24	380
1229	24	381
1230	24	382
1231	24	383
1232	24	384
1233	25	385
1234	25	386
1235	25	387
1236	25	388
1237	25	389
1238	25	390
1239	25	391
1240	25	392
1241	25	393
1242	25	394
1243	25	395
1244	25	396
1245	25	397
1246	25	398
1247	25	399
1248	25	400
\.


--
-- TOC entry 2527 (class 0 OID 0)
-- Dependencies: 223
-- Name: graph_graphcost_edge_costs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_graphcost_edge_costs_id_seq', 1248, true);


--
-- TOC entry 2528 (class 0 OID 0)
-- Dependencies: 225
-- Name: graph_graphcost_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_graphcost_id_seq', 25, true);


--
-- TOC entry 2448 (class 0 OID 20038)
-- Dependencies: 204
-- Data for Name: graph_node; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_node (graph_id, node_id, ui_id) FROM stdin;
test	0f3687e3-c1b7-4f22-9ea5-8c26fe719bf6	4
test	275a8e51-f197-451e-abd4-1057bd5cff74	8
test	377bd411-45cc-449b-90d0-31d7ce4da47d	10
test	3f3c5d37-3335-404f-b318-a3ed55aef26f	6
test	6a15327a-caca-4a47-b495-322560259fc9	11
test	735118ca-7dbc-486d-aa23-88bc48811537	2
test	770e5312-5104-4880-a94e-cd259acb19ec	9
test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	1
test	978b0218-bc23-424c-9119-3a3c2306d455	3
test	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	7
test	bdac6aee-609f-492b-b97b-b7ba53ecafb7	5
\.


--
-- TOC entry 2456 (class 0 OID 20140)
-- Dependencies: 212
-- Data for Name: graph_path; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_path (id, graph_id, player_model_id) FROM stdin;
1	test	m1
2	test	m1
3	test	m1
4	test	m2
5	test	m2
6	test	m2
7	test	m2
8	test	m3
9	test	m3
10	test	m3
11	test	m3
12	test	m4
13	test	m4
14	test	m4
15	test	m4
16	test	m4
17	test	m4
18	test	m5
19	test	m5
20	test	m5
21	test	m6
22	test	m6
23	test	m6
24	test	m6
25	test	m7
26	test	m7
27	test	m7
28	test	m7
29	test	m8
30	test	m8
31	test	m8
32	test	m8
33	test	m8
34	test	m8
\.


--
-- TOC entry 2454 (class 0 OID 20122)
-- Dependencies: 210
-- Data for Name: graph_path_edges; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_path_edges (id, path_id, edge_id) FROM stdin;
525	1	1baff48576c39d0fb71e0e19171f6d33
526	1	67cde4149526b913e132a266e9c8509d
527	2	35eba9f65a898ba0d7a8c099d312d2b8
528	2	d5d28e0f5f45f4bb648f92c650bece05
529	2	5ce3019ae5ba925c4abb669e6073ffa5
530	2	e446581e4fb1bc4cc694ff659207ef45
531	3	35eba9f65a898ba0d7a8c099d312d2b8
532	3	fa5cf435b1a6fc838329d7169389160a
533	4	d1c7a3af68e8b0b85bec3806cfde14cd
534	4	1baff48576c39d0fb71e0e19171f6d33
535	4	ded0d6e804fc4768200ff41734b3da11
536	5	116ed7997e89102eaa94c80b25a70ecb
537	5	67cde4149526b913e132a266e9c8509d
538	5	1baff48576c39d0fb71e0e19171f6d33
539	6	35eba9f65a898ba0d7a8c099d312d2b8
540	6	d5d28e0f5f45f4bb648f92c650bece05
541	6	116ed7997e89102eaa94c80b25a70ecb
542	6	5ce3019ae5ba925c4abb669e6073ffa5
543	6	e446581e4fb1bc4cc694ff659207ef45
544	7	35eba9f65a898ba0d7a8c099d312d2b8
545	7	116ed7997e89102eaa94c80b25a70ecb
546	7	fa5cf435b1a6fc838329d7169389160a
547	8	d1c7a3af68e8b0b85bec3806cfde14cd
548	8	1baff48576c39d0fb71e0e19171f6d33
549	8	ded0d6e804fc4768200ff41734b3da11
550	9	116ed7997e89102eaa94c80b25a70ecb
551	9	67cde4149526b913e132a266e9c8509d
552	9	1baff48576c39d0fb71e0e19171f6d33
553	10	35eba9f65a898ba0d7a8c099d312d2b8
554	10	d5d28e0f5f45f4bb648f92c650bece05
555	10	116ed7997e89102eaa94c80b25a70ecb
556	10	5ce3019ae5ba925c4abb669e6073ffa5
557	10	e446581e4fb1bc4cc694ff659207ef45
558	11	35eba9f65a898ba0d7a8c099d312d2b8
559	11	116ed7997e89102eaa94c80b25a70ecb
560	11	fa5cf435b1a6fc838329d7169389160a
561	12	1baff48576c39d0fb71e0e19171f6d33
562	12	ded0d6e804fc4768200ff41734b3da11
563	12	c6e2871cecbf193dc758bec1f3c5d120
564	13	d1c7a3af68e8b0b85bec3806cfde14cd
565	13	1baff48576c39d0fb71e0e19171f6d33
566	13	92e224e5a0cfbd18fc8d469bfe15fe72
567	13	ded0d6e804fc4768200ff41734b3da11
568	14	116ed7997e89102eaa94c80b25a70ecb
569	14	67cde4149526b913e132a266e9c8509d
570	14	92e224e5a0cfbd18fc8d469bfe15fe72
571	14	1baff48576c39d0fb71e0e19171f6d33
572	15	35eba9f65a898ba0d7a8c099d312d2b8
573	15	503ea356c90777f1a6dcfb872be9d951
574	15	e7968a8522dc48a4180f846e01e2bf8b
575	15	e446581e4fb1bc4cc694ff659207ef45
576	15	d5d28e0f5f45f4bb648f92c650bece05
577	16	e446581e4fb1bc4cc694ff659207ef45
578	16	35eba9f65a898ba0d7a8c099d312d2b8
579	16	5ce3019ae5ba925c4abb669e6073ffa5
580	16	d5d28e0f5f45f4bb648f92c650bece05
581	16	92e224e5a0cfbd18fc8d469bfe15fe72
582	16	116ed7997e89102eaa94c80b25a70ecb
583	17	35eba9f65a898ba0d7a8c099d312d2b8
584	17	116ed7997e89102eaa94c80b25a70ecb
585	17	92e224e5a0cfbd18fc8d469bfe15fe72
586	17	fa5cf435b1a6fc838329d7169389160a
587	18	1baff48576c39d0fb71e0e19171f6d33
588	18	67cde4149526b913e132a266e9c8509d
589	19	35eba9f65a898ba0d7a8c099d312d2b8
590	19	d5d28e0f5f45f4bb648f92c650bece05
591	19	5ce3019ae5ba925c4abb669e6073ffa5
592	19	e446581e4fb1bc4cc694ff659207ef45
593	20	35eba9f65a898ba0d7a8c099d312d2b8
594	20	fa5cf435b1a6fc838329d7169389160a
595	21	834c742c1707eef884e5fa247807c1d3
596	21	15215427d89211e2b6b1eaf93f40ee25
597	21	1baff48576c39d0fb71e0e19171f6d33
598	21	ded0d6e804fc4768200ff41734b3da11
599	21	d1c7a3af68e8b0b85bec3806cfde14cd
600	22	15215427d89211e2b6b1eaf93f40ee25
601	22	116ed7997e89102eaa94c80b25a70ecb
602	22	67cde4149526b913e132a266e9c8509d
603	22	1baff48576c39d0fb71e0e19171f6d33
604	22	834c742c1707eef884e5fa247807c1d3
605	23	d5d28e0f5f45f4bb648f92c650bece05
606	23	116ed7997e89102eaa94c80b25a70ecb
607	23	5ce3019ae5ba925c4abb669e6073ffa5
608	23	e446581e4fb1bc4cc694ff659207ef45
609	24	116ed7997e89102eaa94c80b25a70ecb
610	24	fa5cf435b1a6fc838329d7169389160a
611	25	834c742c1707eef884e5fa247807c1d3
612	25	15215427d89211e2b6b1eaf93f40ee25
613	25	1baff48576c39d0fb71e0e19171f6d33
614	25	ded0d6e804fc4768200ff41734b3da11
615	25	d1c7a3af68e8b0b85bec3806cfde14cd
616	26	15215427d89211e2b6b1eaf93f40ee25
617	26	116ed7997e89102eaa94c80b25a70ecb
618	26	67cde4149526b913e132a266e9c8509d
619	26	1baff48576c39d0fb71e0e19171f6d33
620	26	834c742c1707eef884e5fa247807c1d3
621	27	d5d28e0f5f45f4bb648f92c650bece05
622	27	116ed7997e89102eaa94c80b25a70ecb
623	27	5ce3019ae5ba925c4abb669e6073ffa5
624	27	e446581e4fb1bc4cc694ff659207ef45
625	28	116ed7997e89102eaa94c80b25a70ecb
626	28	fa5cf435b1a6fc838329d7169389160a
627	29	15215427d89211e2b6b1eaf93f40ee25
628	29	1baff48576c39d0fb71e0e19171f6d33
629	29	ded0d6e804fc4768200ff41734b3da11
630	29	c6e2871cecbf193dc758bec1f3c5d120
631	29	834c742c1707eef884e5fa247807c1d3
632	30	834c742c1707eef884e5fa247807c1d3
633	30	d1c7a3af68e8b0b85bec3806cfde14cd
634	30	1baff48576c39d0fb71e0e19171f6d33
635	30	15215427d89211e2b6b1eaf93f40ee25
636	30	92e224e5a0cfbd18fc8d469bfe15fe72
637	30	ded0d6e804fc4768200ff41734b3da11
638	31	834c742c1707eef884e5fa247807c1d3
639	31	67cde4149526b913e132a266e9c8509d
640	31	1baff48576c39d0fb71e0e19171f6d33
641	31	15215427d89211e2b6b1eaf93f40ee25
642	31	116ed7997e89102eaa94c80b25a70ecb
643	31	92e224e5a0cfbd18fc8d469bfe15fe72
644	32	503ea356c90777f1a6dcfb872be9d951
645	32	d5d28e0f5f45f4bb648f92c650bece05
646	32	e7968a8522dc48a4180f846e01e2bf8b
647	32	e446581e4fb1bc4cc694ff659207ef45
648	33	d5d28e0f5f45f4bb648f92c650bece05
649	33	116ed7997e89102eaa94c80b25a70ecb
650	33	92e224e5a0cfbd18fc8d469bfe15fe72
651	33	e446581e4fb1bc4cc694ff659207ef45
652	33	5ce3019ae5ba925c4abb669e6073ffa5
653	34	116ed7997e89102eaa94c80b25a70ecb
654	34	92e224e5a0cfbd18fc8d469bfe15fe72
655	34	fa5cf435b1a6fc838329d7169389160a
\.


--
-- TOC entry 2529 (class 0 OID 0)
-- Dependencies: 209
-- Name: graph_path_edges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_path_edges_id_seq', 655, true);


--
-- TOC entry 2530 (class 0 OID 0)
-- Dependencies: 211
-- Name: graph_path_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_path_id_seq', 34, true);


--
-- TOC entry 2458 (class 0 OID 20166)
-- Dependencies: 214
-- Data for Name: graph_pathflowassignment; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_pathflowassignment (id, path_id, flow) FROM stdin;
1	3	0.5
2	2	0
3	1	0.5
4	34	0.276666666666666672
5	33	0.166666666666666657
6	32	0.223333333333333356
7	31	0
8	30	0.166666666666666657
9	29	0.166666666666666657
10	7	0.25
11	6	0.25
12	5	0.25
13	4	0.25
14	11	0.241545893719806726
15	10	0.183574879227053123
16	9	0.246376811594202882
17	8	0.328502415458937158
18	17	0
19	16	0
20	15	0
21	14	0
22	13	0
23	12	1
24	20	0.333333333333333315
25	19	0.333333333333333315
26	18	0.333333333333333315
27	24	0.200000000000000011
28	23	0.200000000000000011
29	22	0.25
30	21	0.349999999999999978
31	28	0.66666666666666663
32	27	0.333333333333333315
33	26	0
34	25	0
35	3	0.358974358974358976
36	2	0
37	1	0.641025641025640969
38	34	0.212962962962962965
39	33	0.231481481481481455
40	32	0.310185185185185175
41	31	0
42	30	0.115740740740740727
43	29	0.129629629629629622
44	7	0.110465116279069756
45	6	0.215116279069767408
46	5	0.290697674418604612
47	4	0.3837209302325581
48	11	0.169312169312169303
49	10	0.201058201058201047
50	9	0.269841269841269826
51	8	0.359788359788359768
52	17	0
53	16	0
54	15	0.311688311688311681
55	14	0.376623376623376582
56	13	0.311688311688311681
57	12	0
58	20	0.256578947368421073
59	19	0.328947368421052655
60	18	0.414473684210526327
61	24	0.200000000000000011
62	23	0.25
63	22	0.200000000000000011
64	21	0.349999999999999978
65	28	0.55555555555555558
66	27	0.27777777777777779
67	26	0
68	25	0.166666666666666657
69	3	0.333333333333333315
70	2	0.333333333333333315
71	1	0.333333333333333315
72	34	0.270588235294117685
73	33	0.294117647058823539
74	32	0.170588235294117652
75	31	0
76	30	0
77	29	0.26470588235294118
78	7	0.297297297297297314
79	6	0.135135135135135143
80	5	0.121621621621621614
81	4	0.445945945945945998
82	11	0.241545893719806726
83	10	0.183574879227053123
84	9	0.246376811594202882
85	8	0.328502415458937158
86	17	0.226415094339622619
87	16	0.0943396226415094408
88	15	0.113207547169811309
89	14	0.113207547169811309
90	13	0.226415094339622619
91	12	0.226415094339622619
92	20	0.306122448979591844
93	19	0.306122448979591844
94	18	0.387755102040816313
95	24	0.243902439024390266
96	23	0.243902439024390266
97	22	0.146341463414634165
98	21	0.365853658536585413
99	28	0.625
100	27	0
101	26	0
102	25	0.374999999999999944
103	3	0.216931216931216919
104	2	0.253968253968253954
105	1	0.529100529100529182
106	34	0.280487804878048808
107	33	0.25
108	32	0.371951219512195119
109	31	0
110	30	0
111	29	0.0975609756097561009
112	7	0.178571428571428575
113	6	0.142857142857142877
114	5	0.335714285714285743
115	4	0.34285714285714286
116	11	0.186274509803921573
117	10	0.186274509803921573
118	9	0.294117647058823539
119	8	0.33333333333333337
120	17	0.154255319148936171
121	16	0.10638297872340427
122	15	0.015957446808510637
123	14	0.21276595744680854
124	13	0.255319148936170193
125	12	0.255319148936170193
126	20	0.27777777777777779
127	19	0.203703703703703692
128	18	0.51851851851851849
129	24	0.243902439024390266
130	23	0.243902439024390266
131	22	0.170731707317073184
132	21	0.341463414634146367
133	28	0.526315789473684181
134	27	0.157894736842105254
135	26	0
136	25	0.315789473684210509
137	3	0.216931216931216919
138	2	0.253968253968253954
139	1	0.529100529100529182
140	34	0.37398373983739841
141	33	0
142	32	0.495934959349593474
143	31	0
144	30	0
145	29	0.130081300813008144
146	7	0.265060240963855387
147	6	0.15662650602409639
148	5	0.168674698795180711
149	4	0.409638554216867457
150	11	0.232673267326732658
151	10	0.188118811881188119
152	9	0.242574257425742568
153	8	0.336633663366336655
154	17	0.103896103896103889
155	16	0.0606060606060606077
156	15	0.23809523809523811
157	14	0.125541125541125537
158	13	0.233766233766233789
159	12	0.23809523809523811
160	20	0.335365853658536606
161	19	0.201219512195121936
162	18	0.463414634146341431
163	24	0.270270270270270285
164	23	0.216216216216216256
165	22	0.135135135135135143
166	21	0.378378378378378399
167	28	0.55555555555555558
168	27	0
169	26	0
170	25	0.444444444444444475
171	3	0.25
172	2	0.125
173	1	0.625
174	34	0.442307692307692291
175	33	0.307692307692307709
176	32	0.0961538461538461592
177	31	0
178	30	0
179	29	0.153846153846153855
180	7	0.144654088050314489
181	6	0.163522012578616371
182	5	0.415094339622641584
183	4	0.276729559748427723
184	11	0.239795918367346927
185	10	0.193877551020408156
186	9	0.25
187	8	0.316326530612244916
188	17	0.119999999999999996
189	16	0.0700000000000000067
190	15	0.119999999999999996
191	14	0.14499999999999999
192	13	0.270000000000000018
193	12	0.275000000000000022
194	20	0.274853801169590628
195	19	0.192982456140350894
196	18	0.532163742690058506
197	24	0.263157894736842091
198	23	0.236842105263157909
199	22	0.131578947368421045
200	21	0.368421052631578927
201	28	0.625
202	27	0.187499999999999972
203	26	0
204	25	0.187499999999999972
205	3	0.112676056338028172
206	2	0.183098591549295781
207	1	0.704225352112676117
208	34	0
209	33	0.114942528735632182
210	32	0.528735632183907955
211	31	0
212	30	0.195402298850574696
213	29	0.160919540229885055
214	7	0.201219512195121936
215	6	0.207317073170731697
216	5	0.128048780487804853
217	4	0.463414634146341431
218	11	0.224598930481283404
219	10	0.2032085561497326
220	9	0.240641711229946514
221	8	0.331550802139037426
222	17	0.0518134715025906772
223	16	0.0518134715025906772
224	15	0.233160621761658055
225	14	0.0466321243523316054
226	13	0.331606217616580323
227	12	0.284974093264248718
228	20	0.286585365853658514
229	19	0.201219512195121936
230	18	0.512195121951219412
231	24	0.243243243243243257
232	23	0.243243243243243257
233	22	0.135135135135135143
234	21	0.378378378378378399
235	28	0.757575757575757569
236	27	0.0151515151515151519
237	26	0
238	25	0.227272727272727265
239	3	0.363636363636363646
240	2	0.131313131313131326
241	1	0.505050505050505083
242	34	0.517241379310344862
243	33	0.298850574712643702
244	32	0.183908045977011492
245	31	0
246	30	0
247	29	0
248	7	0.366834170854271335
249	6	0.216080402010050243
250	5	0.266331658291457274
251	4	0.150753768844221092
252	11	0.224598930481283404
253	10	0.2032085561497326
254	9	0.240641711229946514
255	8	0.331550802139037426
256	17	0.187192118226601006
257	16	0.152709359605911338
258	15	0.0837438423645320285
259	14	0.236453201970443366
260	13	0.157635467980295596
261	12	0.182266009852216776
262	20	0.335227272727272763
263	19	0.187500000000000028
264	18	0.477272727272727293
265	24	0.282051282051282104
266	23	0.230769230769230782
267	22	0.128205128205128221
268	21	0.358974358974358976
269	28	0.66666666666666663
270	27	0.133333333333333331
271	26	0
272	25	0.199999999999999983
273	3	0.176470588235294129
274	2	0.169934640522875824
275	1	0.653594771241830075
276	34	0.148514851485148508
277	33	0
278	32	0.376237623762376239
279	31	0
280	30	0.475247524752475226
281	29	0
282	7	0.0671140939597315439
283	6	0.11409395973154364
284	5	0.28859060402684561
285	4	0.530201342281879207
286	11	0.219895287958115165
287	10	0.19895287958115182
288	9	0.235602094240837695
289	8	0.345549738219895264
290	17	0.0635838150289017301
291	16	0.0404624277456647474
292	15	0.16184971098265899
293	14	0.0693641618497109758
294	13	0.306358381502890187
295	12	0.358381502890173398
296	20	0.204678362573099404
297	19	0.210526315789473673
298	18	0.584795321637426868
299	24	0.243243243243243257
300	23	0.243243243243243257
301	22	0.135135135135135143
302	21	0.378378378378378399
303	28	0.533333333333333326
304	27	0.133333333333333331
305	26	0
306	25	0.333333333333333315
307	3	0.245454545454545453
308	2	0.236363636363636359
309	1	0.518181818181818077
310	34	0.421052631578947345
311	33	0
312	32	0.294736842105263186
313	31	0
314	30	0.284210526315789469
315	29	0
316	7	0.251572327044025212
317	6	0.245283018867924557
318	5	0.138364779874213861
319	4	0.364779874213836508
320	11	0.2068965517241379
321	10	0.187192118226600951
322	9	0.221674876847290619
323	8	0.384236453201970418
324	17	0.24468085106382978
325	16	0.303191489361702093
326	15	0.308510638297872286
327	14	0.0478723404255319077
328	13	0.0531914893617021281
329	12	0.0425531914893617011
330	20	0.272727272727272763
331	19	0.272727272727272763
332	18	0.454545454545454586
333	24	0.0620155038759689914
334	23	0.0852713178294573632
335	22	0.0775193798449612392
336	21	0.775193798449612337
337	28	0.533333333333333326
338	27	0.133333333333333331
339	26	0
340	25	0.333333333333333315
341	3	0
342	2	0
343	1	1
344	34	1
345	33	0
346	32	0
347	31	0
348	30	0
349	29	0
350	7	0.145833333333333343
351	6	0.125
352	5	0.326388888888888895
353	4	0.40277777777777779
354	11	0.221052631578947362
355	10	0.200000000000000011
356	9	0.236842105263157909
357	8	0.342105263157894746
358	17	0.106382978723404242
359	16	0.106382978723404242
360	15	0.0921985815602836822
361	14	0.269503546099290781
362	13	0.14893617021276595
363	12	0.276595744680851019
364	20	0.187096774193548393
365	19	0.193548387096774216
366	18	0.619354838709677447
367	24	0.125
368	23	0.125
369	22	0.125
370	21	0.625
371	28	0.533333333333333326
372	27	0.133333333333333331
373	26	0
374	25	0.333333333333333315
375	3	0
376	2	0.5
377	1	0.5
378	34	0.433333333333333293
379	33	0
380	32	0.566666666666666652
381	31	0
382	30	0
383	29	0
384	7	0.134615384615384609
385	6	0.314102564102564097
386	5	0.134615384615384609
387	4	0.416666666666666685
388	11	0.186666666666666647
389	10	0.168888888888888894
390	9	0.355555555555555569
391	8	0.288888888888888917
392	17	0.0974025974025973934
393	16	0.0974025974025973934
394	15	0.389610389610389574
395	14	0.0259740259740259723
396	13	0.136363636363636354
397	12	0.253246753246753276
398	20	0.166666666666666685
399	19	0.33333333333333337
400	18	0.500000000000000111
401	24	0.129032258064516125
402	23	0.161290322580645157
403	22	0.129032258064516125
404	21	0.58064516129032262
405	28	0.631578947368421018
406	27	0.10526315789473685
407	26	0
408	25	0.263157894736842091
409	3	0
410	2	0.350649350649350655
411	1	0.649350649350649345
412	34	0.41935483870967738
413	33	0
414	32	0
415	31	0
416	30	0.274193548387096753
417	29	0.306451612903225756
418	7	0.23118279569892472
419	6	0.0698924731182795633
420	5	0.322580645161290314
421	4	0.37634408602150532
422	11	0.267515923566878977
423	10	0.426751592356687914
424	9	0.152866242038216554
425	8	0.152866242038216554
426	17	0.160194174757281566
427	16	0.0339805825242718504
428	15	0.0388349514563106762
429	14	0.233009708737864057
430	13	0.266990291262135915
431	12	0.266990291262135915
432	20	0.244047619047619013
433	19	0.238095238095238082
434	18	0.517857142857142794
435	24	0.129032258064516125
436	23	0.161290322580645157
437	22	0.129032258064516125
438	21	0.58064516129032262
439	28	0.631578947368421018
440	27	0.10526315789473685
441	26	0
442	25	0.263157894736842091
443	3	0
444	2	0.346405228758169925
445	1	0.653594771241830075
446	34	0.426229508196721285
447	33	0
448	32	0.262295081967213073
449	31	0
450	30	0
451	29	0.311475409836065531
452	7	0.194805194805194787
453	6	0.162337662337662336
454	5	0.311688311688311681
455	4	0.331168831168831168
456	11	0.187878787878787895
457	10	0.193939393939393967
458	9	0.303030303030303039
459	8	0.315151515151515182
460	17	0.160194174757281566
461	16	0.0339805825242718504
462	15	0.0388349514563106762
463	14	0.233009708737864057
464	13	0.266990291262135915
465	12	0.266990291262135915
466	20	0.251533742331288335
467	19	0.245398773006134996
468	18	0.503067484662576669
469	24	0.187499999999999972
470	23	0.187499999999999972
471	22	0.125
472	21	0.5
473	28	0.631578947368421018
474	27	0.10526315789473685
475	26	0
476	25	0.263157894736842091
477	3	0
478	2	0
479	1	1
480	34	0.298850574712643702
481	33	0
482	32	0.482758620689655193
483	31	0
484	30	0
485	29	0.218390804597701188
486	7	0.282352941176470529
487	6	0.329411764705882348
488	5	0.152941176470588219
489	4	0.23529411764705882
490	11	0.190184049079754613
491	10	0.184049079754601219
492	9	0.306748466257668717
493	8	0.319018404907975506
494	17	0.160194174757281566
495	16	0.0339805825242718504
496	15	0.0388349514563106762
497	14	0.233009708737864057
498	13	0.266990291262135915
499	12	0.266990291262135915
500	20	0.251533742331288335
501	19	0.245398773006134996
502	18	0.503067484662576669
503	24	0.187499999999999972
504	23	0.187499999999999972
505	22	0.125
506	21	0.5
507	28	0.631578947368421018
508	27	0.10526315789473685
509	26	0
510	25	0.263157894736842091
511	3	0
512	2	0.00990099009900990111
513	1	0.99009900990099009
514	34	0.337662337662337719
515	33	0
516	32	0.545454545454545525
517	31	0
518	30	0
519	29	0.116883116883116894
520	7	0.29629629629629628
521	6	0.29629629629629628
522	5	0.160493827160493818
523	4	0.246913580246913567
524	11	0.221428571428571447
525	10	0.142857142857142877
526	9	0.26428571428571429
527	8	0.371428571428571441
528	17	0.160194174757281566
529	16	0.0339805825242718504
530	15	0.0388349514563106762
531	14	0.233009708737864057
532	13	0.266990291262135915
533	12	0.266990291262135915
534	20	0.273333333333333317
535	19	0.266666666666666663
536	18	0.459999999999999964
537	24	0.187499999999999972
538	23	0.187499999999999972
539	22	0.125
540	21	0.5
541	28	0.631578947368421018
542	27	0.10526315789473685
543	26	0
544	25	0.263157894736842091
545	3	0.671140939597315467
546	2	0.328859060402684533
547	1	0
548	34	0.337662337662337719
549	33	0
550	32	0.545454545454545525
551	31	0
552	30	0
553	29	0.116883116883116894
554	7	0.35164835164835162
555	6	0.357142857142857151
556	5	0.104395604395604399
557	4	0.186813186813186816
558	11	0.270270270270270285
559	10	0.229729729729729742
560	9	0.148648648648648657
561	8	0.351351351351351371
562	17	0.160194174757281566
563	16	0.0339805825242718504
564	15	0.0388349514563106762
565	14	0.233009708737864057
566	13	0.266990291262135915
567	12	0.266990291262135915
568	20	0.273333333333333317
569	19	0.266666666666666663
570	18	0.459999999999999964
571	24	0.222222222222222238
572	23	0.222222222222222238
573	22	0.111111111111111119
574	21	0.444444444444444475
575	28	0.631578947368421018
576	27	0.10526315789473685
577	26	0
578	25	0.263157894736842091
579	3	0.401606425702811187
580	2	0.196787148594377487
581	1	0.401606425702811187
582	34	0
583	33	0.317460317460317498
584	32	0.539682539682539764
585	31	0
586	30	0
587	29	0.142857142857142849
588	7	0.35164835164835162
589	6	0.357142857142857151
590	5	0.104395604395604399
591	4	0.186813186813186816
592	11	0.270270270270270285
593	10	0.229729729729729742
594	9	0.148648648648648657
595	8	0.351351351351351371
596	17	0.160194174757281566
597	16	0.0339805825242718504
598	15	0.0388349514563106762
599	14	0.233009708737864057
600	13	0.266990291262135915
601	12	0.266990291262135915
602	20	0.273333333333333317
603	19	0.266666666666666663
604	18	0.459999999999999964
605	24	0.222222222222222238
606	23	0.222222222222222238
607	22	0.111111111111111119
608	21	0.444444444444444475
609	28	0.631578947368421018
610	27	0.10526315789473685
611	26	0
612	25	0.263157894736842091
613	3	0.401606425702811187
614	2	0.196787148594377487
615	1	0.401606425702811187
616	34	0.209677419354838718
617	33	0
618	32	0.548387096774193616
619	31	0
620	30	0
621	29	0.241935483870967721
622	7	0.3125
623	6	0.323863636363636354
624	5	0.107954545454545456
625	4	0.255681818181818177
626	11	0.270270270270270285
627	10	0.229729729729729742
628	9	0.148648648648648657
629	8	0.351351351351351371
630	17	0.160194174757281566
631	16	0.0339805825242718504
632	15	0.0388349514563106762
633	14	0.233009708737864057
634	13	0.266990291262135915
635	12	0.266990291262135915
636	20	0.273333333333333317
637	19	0.266666666666666663
638	18	0.459999999999999964
639	24	0.239361702127659559
640	23	0.239361702127659559
641	22	0.106382978723404256
642	21	0.414893617021276584
643	28	0.631578947368421018
644	27	0.10526315789473685
645	26	0
646	25	0.263157894736842091
647	3	0.401606425702811187
648	2	0.196787148594377487
649	1	0.401606425702811187
650	34	0.18055555555555558
651	33	0
652	32	0.472222222222222265
653	31	0
654	30	0.222222222222222238
655	29	0.125
656	7	0.3125
657	6	0.323863636363636354
658	5	0.107954545454545456
659	4	0.255681818181818177
660	11	0.270270270270270285
661	10	0.229729729729729742
662	9	0.148648648648648657
663	8	0.351351351351351371
664	17	0.160194174757281566
665	16	0.0339805825242718504
666	15	0.0388349514563106762
667	14	0.233009708737864057
668	13	0.266990291262135915
669	12	0.266990291262135915
670	20	0.288732394366197187
671	19	0.281690140845070436
672	18	0.429577464788732433
673	24	0.243243243243243229
674	23	0.243243243243243229
675	22	0.108108108108108114
676	21	0.405405405405405372
677	28	0.631578947368421018
678	27	0.10526315789473685
679	26	0
680	25	0.263157894736842091
681	3	0.401606425702811187
682	2	0.196787148594377487
683	1	0.401606425702811187
684	34	0.368421052631578982
685	33	0
686	32	0.236842105263157882
687	31	0
688	30	0.276315789473684181
689	29	0.118421052631578941
690	7	0.297297297297297314
691	6	0.30810810810810807
692	5	0.129729729729729709
693	4	0.264864864864864824
694	11	0.270270270270270285
695	10	0.229729729729729742
696	9	0.148648648648648657
697	8	0.351351351351351371
698	17	0.160194174757281566
699	16	0.0339805825242718504
700	15	0.0388349514563106762
701	14	0.233009708737864057
702	13	0.266990291262135915
703	12	0.266990291262135915
704	20	0.211864406779661035
705	19	0.203389830508474589
706	18	0.584745762711864403
707	24	0.24731182795698925
708	23	0.215053763440860218
709	22	0.107526881720430109
710	21	0.430107526881720437
711	28	0.631578947368421018
712	27	0.10526315789473685
713	26	0
714	25	0.263157894736842091
715	3	0.401606425702811187
716	2	0.196787148594377487
717	1	0.401606425702811187
718	34	0.368421052631578982
719	33	0
720	32	0.236842105263157882
721	31	0
722	30	0.276315789473684181
723	29	0.118421052631578941
724	7	0.210843373493975889
725	6	0.108433734939759038
726	5	0.259036144578313254
727	4	0.421686746987951777
728	11	0.270270270270270285
729	10	0.229729729729729742
730	9	0.148648648648648657
731	8	0.351351351351351371
732	17	0.161764705882352949
733	16	0.0245098039215686271
734	15	0.0392156862745098034
735	14	0.23529411764705882
736	13	0.269607843137254943
737	12	0.269607843137254943
738	20	0.211864406779661035
739	19	0.203389830508474589
740	18	0.584745762711864403
741	24	0.243243243243243229
742	23	0.216216216216216228
743	22	0.108108108108108114
744	21	0.432432432432432456
745	28	0.631578947368421018
746	27	0.10526315789473685
747	26	0
748	25	0.263157894736842091
749	3	0
750	2	0
751	1	1
752	34	0.196969696969696989
753	33	0
754	32	0.439393939393939392
755	31	0
756	30	0
757	29	0.363636363636363646
758	7	0.210843373493975889
759	6	0.108433734939759038
760	5	0.259036144578313254
761	4	0.421686746987951777
762	11	0.270270270270270285
763	10	0.229729729729729742
764	9	0.148648648648648657
765	8	0.351351351351351371
766	17	0.102272727272727265
767	16	0
768	15	0
769	14	0.272727272727272707
770	13	0.3125
771	12	0.3125
772	20	0.211864406779661035
773	19	0.203389830508474589
774	18	0.584745762711864403
775	24	0.25
776	23	0.19444444444444442
777	22	0.111111111111111119
778	21	0.444444444444444475
779	28	0.631578947368421018
780	27	0.10526315789473685
781	26	0
782	25	0.263157894736842091
783	3	0
784	2	0
785	1	1
786	34	0.368421052631578982
787	33	0
788	32	0.236842105263157882
789	31	0
790	30	0.276315789473684181
791	29	0.118421052631578941
792	7	0.210843373493975889
793	6	0.108433734939759038
794	5	0.259036144578313254
795	4	0.421686746987951777
796	11	0.287081339712918659
797	10	0.25837320574162681
798	9	0.205741626794258392
799	8	0.248803827751196194
800	17	0.102272727272727265
801	16	0
802	15	0
803	14	0.272727272727272707
804	13	0.3125
805	12	0.3125
806	20	0.211864406779661035
807	19	0.203389830508474589
808	18	0.584745762711864403
809	24	0.25
810	23	0.19444444444444442
811	22	0.111111111111111119
812	21	0.444444444444444475
813	28	0.631578947368421018
814	27	0.10526315789473685
815	26	0
816	25	0.263157894736842091
817	3	0
818	2	0
819	1	1
820	34	0.292307692307692324
821	33	0
822	32	0.461538461538461509
823	31	0
824	30	0
825	29	0.24615384615384614
826	7	0.210843373493975889
827	6	0.108433734939759038
828	5	0.259036144578313254
829	4	0.421686746987951777
830	11	0.287081339712918659
831	10	0.25837320574162681
832	9	0.205741626794258392
833	8	0.248803827751196194
834	17	0.102272727272727265
835	16	0
836	15	0
837	14	0.272727272727272707
838	13	0.3125
839	12	0.3125
840	20	0.211864406779661035
841	19	0.203389830508474589
842	18	0.584745762711864403
843	24	0.25
844	23	0.19444444444444442
845	22	0.111111111111111119
846	21	0.444444444444444475
847	28	0.631578947368421018
848	27	0.10526315789473685
849	26	0
850	25	0.263157894736842091
\.


--
-- TOC entry 2531 (class 0 OID 0)
-- Dependencies: 213
-- Name: graph_pathflowassignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_pathflowassignment_id_seq', 850, true);


--
-- TOC entry 2451 (class 0 OID 20076)
-- Dependencies: 207
-- Data for Name: graph_player; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_player (id, user_id, player_model_id, game_id, flow_distribution_id) FROM stdin;
1	1	m1	game	201
8	8	m8	game	202
2	2	m2	game	203
3	3	m3	game	204
4	4	m4	game	205
5	5	m5	game	206
6	6	m6	game	207
7	7	m7	game	208
\.


--
-- TOC entry 2532 (class 0 OID 0)
-- Dependencies: 206
-- Name: graph_player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bayen
--

SELECT pg_catalog.setval('graph_player_id_seq', 8, true);


--
-- TOC entry 2449 (class 0 OID 20051)
-- Dependencies: 205
-- Data for Name: graph_playermodel; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY graph_playermodel (name, graph_id, start_node_id, destination_node_id, flow, in_use, normalization_const) FROM stdin;
m5	test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	bdac6aee-609f-492b-b97b-b7ba53ecafb7	1	t	20.9515641093022928
m4	test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	275a8e51-f197-451e-abd4-1057bd5cff74	1	t	48.3202460098422222
m7	test	978b0218-bc23-424c-9119-3a3c2306d455	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	1	t	42.1399124496628019
m6	test	978b0218-bc23-424c-9119-3a3c2306d455	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	1	t	42.1399124496628019
m1	test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	bdac6aee-609f-492b-b97b-b7ba53ecafb7	1	t	20.9515641093022928
m3	test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	1	t	46.0160327768883377
m2	test	877d1ba3-9fef-49f3-ad28-2042d9b894e7	b01bd08f-9fd7-4a64-b5b1-2a25a82903e9	1	t	46.0160327768883377
m8	test	978b0218-bc23-424c-9119-3a3c2306d455	275a8e51-f197-451e-abd4-1057bd5cff74	1	t	44.4441261914335115
\.


--
-- TOC entry 2445 (class 0 OID 18687)
-- Dependencies: 201
-- Data for Name: id_counter_user; Type: TABLE DATA; Schema: public; Owner: bayen
--

COPY id_counter_user (user_id, logged_in, completed_task, entered_number) FROM stdin;
\.


--
-- TOC entry 2143 (class 2606 OID 18602)
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 2149 (class 2606 OID 18612)
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- TOC entry 2151 (class 2606 OID 18610)
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2145 (class 2606 OID 18600)
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 2138 (class 2606 OID 18592)
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- TOC entry 2140 (class 2606 OID 18590)
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 2160 (class 2606 OID 18630)
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 2162 (class 2606 OID 18632)
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- TOC entry 2153 (class 2606 OID 18620)
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 2166 (class 2606 OID 18640)
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2168 (class 2606 OID 18642)
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- TOC entry 2156 (class 2606 OID 18622)
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 2091 (class 2606 OID 18122)
-- Name: celery_taskmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id);


--
-- TOC entry 2093 (class 2606 OID 18124)
-- Name: celery_taskmeta_task_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id);


--
-- TOC entry 2097 (class 2606 OID 18135)
-- Name: celery_tasksetmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id);


--
-- TOC entry 2099 (class 2606 OID 18137)
-- Name: celery_tasksetmeta_taskset_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id);


--
-- TOC entry 2133 (class 2606 OID 18582)
-- Name: django_content_type_app_label_45f3b1d93ec8c61c_uniq; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_45f3b1d93ec8c61c_uniq UNIQUE (app_label, model);


--
-- TOC entry 2135 (class 2606 OID 18580)
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 2088 (class 2606 OID 18111)
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 2174 (class 2606 OID 18700)
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 2104 (class 2606 OID 18153)
-- Name: djcelery_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_crontabschedule
    ADD CONSTRAINT djcelery_crontabschedule_pkey PRIMARY KEY (id);


--
-- TOC entry 2102 (class 2606 OID 18145)
-- Name: djcelery_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_intervalschedule
    ADD CONSTRAINT djcelery_intervalschedule_pkey PRIMARY KEY (id);


--
-- TOC entry 2110 (class 2606 OID 18172)
-- Name: djcelery_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_name_key UNIQUE (name);


--
-- TOC entry 2113 (class 2606 OID 18170)
-- Name: djcelery_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_pkey PRIMARY KEY (id);


--
-- TOC entry 2106 (class 2606 OID 18158)
-- Name: djcelery_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_periodictasks
    ADD CONSTRAINT djcelery_periodictasks_pkey PRIMARY KEY (ident);


--
-- TOC entry 2124 (class 2606 OID 18203)
-- Name: djcelery_taskstate_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_pkey PRIMARY KEY (id);


--
-- TOC entry 2128 (class 2606 OID 18205)
-- Name: djcelery_taskstate_task_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_task_id_key UNIQUE (task_id);


--
-- TOC entry 2115 (class 2606 OID 18192)
-- Name: djcelery_workerstate_hostname_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_hostname_key UNIQUE (hostname);


--
-- TOC entry 2119 (class 2606 OID 18190)
-- Name: djcelery_workerstate_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_pkey PRIMARY KEY (id);


--
-- TOC entry 2208 (class 2606 OID 20104)
-- Name: graph_edge_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_edge
    ADD CONSTRAINT graph_edge_pkey PRIMARY KEY (edge_id);


--
-- TOC entry 2244 (class 2606 OID 20238)
-- Name: graph_edgecost_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_edgecost
    ADD CONSTRAINT graph_edgecost_pkey PRIMARY KEY (id);


--
-- TOC entry 2231 (class 2606 OID 20194)
-- Name: graph_flowdistribution_path_a_flowdistribution_id_pathflowa_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_flowdistribution_path_assignments
    ADD CONSTRAINT graph_flowdistribution_path_a_flowdistribution_id_pathflowa_key UNIQUE (flowdistribution_id, pathflowassignment_id);


--
-- TOC entry 2235 (class 2606 OID 20192)
-- Name: graph_flowdistribution_path_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_flowdistribution_path_assignments
    ADD CONSTRAINT graph_flowdistribution_path_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 2237 (class 2606 OID 20210)
-- Name: graph_flowdistribution_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_flowdistribution
    ADD CONSTRAINT graph_flowdistribution_pkey PRIMARY KEY (id);


--
-- TOC entry 2240 (class 2606 OID 20212)
-- Name: graph_flowdistribution_username_turn_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_flowdistribution
    ADD CONSTRAINT graph_flowdistribution_username_turn_id_key UNIQUE (username, turn_id);


--
-- TOC entry 2264 (class 2606 OID 20312)
-- Name: graph_game_graph_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_game
    ADD CONSTRAINT graph_game_graph_id_key UNIQUE (graph_id);


--
-- TOC entry 2268 (class 2606 OID 20310)
-- Name: graph_game_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_game
    ADD CONSTRAINT graph_game_pkey PRIMARY KEY (name);


--
-- TOC entry 2257 (class 2606 OID 20297)
-- Name: graph_game_turns_game_id_gameturn_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_game_turns
    ADD CONSTRAINT graph_game_turns_game_id_gameturn_id_key UNIQUE (game_id, gameturn_id);


--
-- TOC entry 2261 (class 2606 OID 20295)
-- Name: graph_game_turns_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_game_turns
    ADD CONSTRAINT graph_game_turns_pkey PRIMARY KEY (id);


--
-- TOC entry 2229 (class 2606 OID 20184)
-- Name: graph_gameturn_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_gameturn
    ADD CONSTRAINT graph_gameturn_pkey PRIMARY KEY (id);


--
-- TOC entry 2178 (class 2606 OID 20037)
-- Name: graph_graph_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_graph
    ADD CONSTRAINT graph_graph_pkey PRIMARY KEY (name);


--
-- TOC entry 2248 (class 2606 OID 20253)
-- Name: graph_graphcost_edge_costs_graphcost_id_edgecost_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_graphcost_edge_costs
    ADD CONSTRAINT graph_graphcost_edge_costs_graphcost_id_edgecost_id_key UNIQUE (graphcost_id, edgecost_id);


--
-- TOC entry 2250 (class 2606 OID 20251)
-- Name: graph_graphcost_edge_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_graphcost_edge_costs
    ADD CONSTRAINT graph_graphcost_edge_costs_pkey PRIMARY KEY (id);


--
-- TOC entry 2254 (class 2606 OID 20269)
-- Name: graph_graphcost_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_graphcost
    ADD CONSTRAINT graph_graphcost_pkey PRIMARY KEY (id);


--
-- TOC entry 2183 (class 2606 OID 20045)
-- Name: graph_node_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_node
    ADD CONSTRAINT graph_node_pkey PRIMARY KEY (node_id);


--
-- TOC entry 2215 (class 2606 OID 20132)
-- Name: graph_path_edges_path_id_edge_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_path_edges
    ADD CONSTRAINT graph_path_edges_path_id_edge_id_key UNIQUE (path_id, edge_id);


--
-- TOC entry 2217 (class 2606 OID 20130)
-- Name: graph_path_edges_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_path_edges
    ADD CONSTRAINT graph_path_edges_pkey PRIMARY KEY (id);


--
-- TOC entry 2221 (class 2606 OID 20148)
-- Name: graph_path_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_path
    ADD CONSTRAINT graph_path_pkey PRIMARY KEY (id);


--
-- TOC entry 2226 (class 2606 OID 20171)
-- Name: graph_pathflowassignment_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_pathflowassignment
    ADD CONSTRAINT graph_pathflowassignment_pkey PRIMARY KEY (id);


--
-- TOC entry 2197 (class 2606 OID 20084)
-- Name: graph_player_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_player
    ADD CONSTRAINT graph_player_pkey PRIMARY KEY (id);


--
-- TOC entry 2201 (class 2606 OID 20086)
-- Name: graph_player_user_id_key; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_player
    ADD CONSTRAINT graph_player_user_id_key UNIQUE (user_id);


--
-- TOC entry 2190 (class 2606 OID 20058)
-- Name: graph_playermodel_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY graph_playermodel
    ADD CONSTRAINT graph_playermodel_pkey PRIMARY KEY (name);


--
-- TOC entry 2170 (class 2606 OID 18691)
-- Name: id_counter_user_pkey; Type: CONSTRAINT; Schema: public; Owner: bayen; Tablespace: 
--

ALTER TABLE ONLY id_counter_user
    ADD CONSTRAINT id_counter_user_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2141 (class 1259 OID 18649)
-- Name: auth_group_name_253ae2a6331666e8_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_group_name_253ae2a6331666e8_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 2146 (class 1259 OID 18660)
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- TOC entry 2147 (class 1259 OID 18661)
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- TOC entry 2136 (class 1259 OID 18648)
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- TOC entry 2157 (class 1259 OID 18674)
-- Name: auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_user_groups_0e939a4f ON auth_user_groups USING btree (group_id);


--
-- TOC entry 2158 (class 1259 OID 18673)
-- Name: auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_user_groups_e8701ad4 ON auth_user_groups USING btree (user_id);


--
-- TOC entry 2163 (class 1259 OID 18686)
-- Name: auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_8373b171 ON auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 2164 (class 1259 OID 18685)
-- Name: auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_e8701ad4 ON auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 2154 (class 1259 OID 18662)
-- Name: auth_user_username_51b3b110094b8aae_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX auth_user_username_51b3b110094b8aae_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 2089 (class 1259 OID 18510)
-- Name: celery_taskmeta_hidden; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX celery_taskmeta_hidden ON celery_taskmeta USING btree (hidden);


--
-- TOC entry 2094 (class 1259 OID 18509)
-- Name: celery_taskmeta_task_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX celery_taskmeta_task_id_like ON celery_taskmeta USING btree (task_id varchar_pattern_ops);


--
-- TOC entry 2095 (class 1259 OID 18512)
-- Name: celery_tasksetmeta_hidden; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX celery_tasksetmeta_hidden ON celery_tasksetmeta USING btree (hidden);


--
-- TOC entry 2100 (class 1259 OID 18511)
-- Name: celery_tasksetmeta_taskset_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX celery_tasksetmeta_taskset_id_like ON celery_tasksetmeta USING btree (taskset_id varchar_pattern_ops);


--
-- TOC entry 2172 (class 1259 OID 18701)
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- TOC entry 2175 (class 1259 OID 18702)
-- Name: django_session_session_key_461cfeaa630ca218_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX django_session_session_key_461cfeaa630ca218_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 2107 (class 1259 OID 18515)
-- Name: djcelery_periodictask_crontab_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_periodictask_crontab_id ON djcelery_periodictask USING btree (crontab_id);


--
-- TOC entry 2108 (class 1259 OID 18514)
-- Name: djcelery_periodictask_interval_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_periodictask_interval_id ON djcelery_periodictask USING btree (interval_id);


--
-- TOC entry 2111 (class 1259 OID 18513)
-- Name: djcelery_periodictask_name_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_periodictask_name_like ON djcelery_periodictask USING btree (name varchar_pattern_ops);


--
-- TOC entry 2120 (class 1259 OID 18525)
-- Name: djcelery_taskstate_hidden; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_hidden ON djcelery_taskstate USING btree (hidden);


--
-- TOC entry 2121 (class 1259 OID 18521)
-- Name: djcelery_taskstate_name; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_name ON djcelery_taskstate USING btree (name);


--
-- TOC entry 2122 (class 1259 OID 18522)
-- Name: djcelery_taskstate_name_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_name_like ON djcelery_taskstate USING btree (name varchar_pattern_ops);


--
-- TOC entry 2125 (class 1259 OID 18518)
-- Name: djcelery_taskstate_state; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_state ON djcelery_taskstate USING btree (state);


--
-- TOC entry 2126 (class 1259 OID 18519)
-- Name: djcelery_taskstate_state_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_state_like ON djcelery_taskstate USING btree (state varchar_pattern_ops);


--
-- TOC entry 2129 (class 1259 OID 18520)
-- Name: djcelery_taskstate_task_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_task_id_like ON djcelery_taskstate USING btree (task_id varchar_pattern_ops);


--
-- TOC entry 2130 (class 1259 OID 18523)
-- Name: djcelery_taskstate_tstamp; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_tstamp ON djcelery_taskstate USING btree (tstamp);


--
-- TOC entry 2131 (class 1259 OID 18524)
-- Name: djcelery_taskstate_worker_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_taskstate_worker_id ON djcelery_taskstate USING btree (worker_id);


--
-- TOC entry 2116 (class 1259 OID 18516)
-- Name: djcelery_workerstate_hostname_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_workerstate_hostname_like ON djcelery_workerstate USING btree (hostname varchar_pattern_ops);


--
-- TOC entry 2117 (class 1259 OID 18517)
-- Name: djcelery_workerstate_last_heartbeat; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX djcelery_workerstate_last_heartbeat ON djcelery_workerstate USING btree (last_heartbeat);


--
-- TOC entry 2202 (class 1259 OID 20349)
-- Name: graph_edge_edge_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edge_edge_id_like ON graph_edge USING btree (edge_id text_pattern_ops);


--
-- TOC entry 2203 (class 1259 OID 20352)
-- Name: graph_edge_from_node_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edge_from_node_id ON graph_edge USING btree (from_node_id);


--
-- TOC entry 2204 (class 1259 OID 20353)
-- Name: graph_edge_from_node_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edge_from_node_id_like ON graph_edge USING btree (from_node_id text_pattern_ops);


--
-- TOC entry 2205 (class 1259 OID 20350)
-- Name: graph_edge_graph_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edge_graph_id ON graph_edge USING btree (graph_id);


--
-- TOC entry 2206 (class 1259 OID 20351)
-- Name: graph_edge_graph_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edge_graph_id_like ON graph_edge USING btree (graph_id text_pattern_ops);


--
-- TOC entry 2209 (class 1259 OID 20354)
-- Name: graph_edge_to_node_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edge_to_node_id ON graph_edge USING btree (to_node_id);


--
-- TOC entry 2210 (class 1259 OID 20355)
-- Name: graph_edge_to_node_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edge_to_node_id_like ON graph_edge USING btree (to_node_id text_pattern_ops);


--
-- TOC entry 2241 (class 1259 OID 20368)
-- Name: graph_edgecost_edge_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edgecost_edge_id ON graph_edgecost USING btree (edge_id);


--
-- TOC entry 2242 (class 1259 OID 20369)
-- Name: graph_edgecost_edge_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_edgecost_edge_id_like ON graph_edgecost USING btree (edge_id text_pattern_ops);


--
-- TOC entry 2232 (class 1259 OID 20365)
-- Name: graph_flowdistribution_path_assignments_flowdistribution_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_flowdistribution_path_assignments_flowdistribution_id ON graph_flowdistribution_path_assignments USING btree (flowdistribution_id);


--
-- TOC entry 2233 (class 1259 OID 20366)
-- Name: graph_flowdistribution_path_assignments_pathflowassignment_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_flowdistribution_path_assignments_pathflowassignment_id ON graph_flowdistribution_path_assignments USING btree (pathflowassignment_id);


--
-- TOC entry 2238 (class 1259 OID 20367)
-- Name: graph_flowdistribution_turn_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_flowdistribution_turn_id ON graph_flowdistribution USING btree (turn_id);


--
-- TOC entry 2262 (class 1259 OID 20378)
-- Name: graph_game_current_turn_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_game_current_turn_id ON graph_game USING btree (current_turn_id);


--
-- TOC entry 2265 (class 1259 OID 20379)
-- Name: graph_game_graph_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_game_graph_id_like ON graph_game USING btree (graph_id text_pattern_ops);


--
-- TOC entry 2266 (class 1259 OID 20377)
-- Name: graph_game_name_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_game_name_like ON graph_game USING btree (name text_pattern_ops);


--
-- TOC entry 2255 (class 1259 OID 20374)
-- Name: graph_game_turns_game_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_game_turns_game_id ON graph_game_turns USING btree (game_id);


--
-- TOC entry 2258 (class 1259 OID 20375)
-- Name: graph_game_turns_game_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_game_turns_game_id_like ON graph_game_turns USING btree (game_id text_pattern_ops);


--
-- TOC entry 2259 (class 1259 OID 20376)
-- Name: graph_game_turns_gameturn_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_game_turns_gameturn_id ON graph_game_turns USING btree (gameturn_id);


--
-- TOC entry 2227 (class 1259 OID 20364)
-- Name: graph_gameturn_graph_cost_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_gameturn_graph_cost_id ON graph_gameturn USING btree (graph_cost_id);


--
-- TOC entry 2176 (class 1259 OID 20333)
-- Name: graph_graph_name_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_graph_name_like ON graph_graph USING btree (name text_pattern_ops);


--
-- TOC entry 2245 (class 1259 OID 20371)
-- Name: graph_graphcost_edge_costs_edgecost_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_graphcost_edge_costs_edgecost_id ON graph_graphcost_edge_costs USING btree (edgecost_id);


--
-- TOC entry 2246 (class 1259 OID 20370)
-- Name: graph_graphcost_edge_costs_graphcost_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_graphcost_edge_costs_graphcost_id ON graph_graphcost_edge_costs USING btree (graphcost_id);


--
-- TOC entry 2251 (class 1259 OID 20372)
-- Name: graph_graphcost_graph_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_graphcost_graph_id ON graph_graphcost USING btree (graph_id);


--
-- TOC entry 2252 (class 1259 OID 20373)
-- Name: graph_graphcost_graph_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_graphcost_graph_id_like ON graph_graphcost USING btree (graph_id text_pattern_ops);


--
-- TOC entry 2179 (class 1259 OID 20334)
-- Name: graph_node_graph_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_node_graph_id ON graph_node USING btree (graph_id);


--
-- TOC entry 2180 (class 1259 OID 20335)
-- Name: graph_node_graph_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_node_graph_id_like ON graph_node USING btree (graph_id text_pattern_ops);


--
-- TOC entry 2181 (class 1259 OID 20336)
-- Name: graph_node_node_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_node_node_id_like ON graph_node USING btree (node_id text_pattern_ops);


--
-- TOC entry 2211 (class 1259 OID 20357)
-- Name: graph_path_edges_edge_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_path_edges_edge_id ON graph_path_edges USING btree (edge_id);


--
-- TOC entry 2212 (class 1259 OID 20358)
-- Name: graph_path_edges_edge_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_path_edges_edge_id_like ON graph_path_edges USING btree (edge_id text_pattern_ops);


--
-- TOC entry 2213 (class 1259 OID 20356)
-- Name: graph_path_edges_path_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_path_edges_path_id ON graph_path_edges USING btree (path_id);


--
-- TOC entry 2218 (class 1259 OID 20359)
-- Name: graph_path_graph_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_path_graph_id ON graph_path USING btree (graph_id);


--
-- TOC entry 2219 (class 1259 OID 20360)
-- Name: graph_path_graph_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_path_graph_id_like ON graph_path USING btree (graph_id text_pattern_ops);


--
-- TOC entry 2222 (class 1259 OID 20361)
-- Name: graph_path_player_model_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_path_player_model_id ON graph_path USING btree (player_model_id);


--
-- TOC entry 2223 (class 1259 OID 20362)
-- Name: graph_path_player_model_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_path_player_model_id_like ON graph_path USING btree (player_model_id text_pattern_ops);


--
-- TOC entry 2224 (class 1259 OID 20363)
-- Name: graph_pathflowassignment_path_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_pathflowassignment_path_id ON graph_pathflowassignment USING btree (path_id);


--
-- TOC entry 2193 (class 1259 OID 20348)
-- Name: graph_player_flow_distribution_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_player_flow_distribution_id ON graph_player USING btree (flow_distribution_id);


--
-- TOC entry 2194 (class 1259 OID 20346)
-- Name: graph_player_game_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_player_game_id ON graph_player USING btree (game_id);


--
-- TOC entry 2195 (class 1259 OID 20347)
-- Name: graph_player_game_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_player_game_id_like ON graph_player USING btree (game_id text_pattern_ops);


--
-- TOC entry 2198 (class 1259 OID 20344)
-- Name: graph_player_player_model_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_player_player_model_id ON graph_player USING btree (player_model_id);


--
-- TOC entry 2199 (class 1259 OID 20345)
-- Name: graph_player_player_model_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_player_player_model_id_like ON graph_player USING btree (player_model_id text_pattern_ops);


--
-- TOC entry 2184 (class 1259 OID 20342)
-- Name: graph_playermodel_destination_node_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_playermodel_destination_node_id ON graph_playermodel USING btree (destination_node_id);


--
-- TOC entry 2185 (class 1259 OID 20343)
-- Name: graph_playermodel_destination_node_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_playermodel_destination_node_id_like ON graph_playermodel USING btree (destination_node_id text_pattern_ops);


--
-- TOC entry 2186 (class 1259 OID 20338)
-- Name: graph_playermodel_graph_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_playermodel_graph_id ON graph_playermodel USING btree (graph_id);


--
-- TOC entry 2187 (class 1259 OID 20339)
-- Name: graph_playermodel_graph_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_playermodel_graph_id_like ON graph_playermodel USING btree (graph_id text_pattern_ops);


--
-- TOC entry 2188 (class 1259 OID 20337)
-- Name: graph_playermodel_name_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_playermodel_name_like ON graph_playermodel USING btree (name text_pattern_ops);


--
-- TOC entry 2191 (class 1259 OID 20340)
-- Name: graph_playermodel_start_node_id; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_playermodel_start_node_id ON graph_playermodel USING btree (start_node_id);


--
-- TOC entry 2192 (class 1259 OID 20341)
-- Name: graph_playermodel_start_node_id_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX graph_playermodel_start_node_id_like ON graph_playermodel USING btree (start_node_id text_pattern_ops);


--
-- TOC entry 2171 (class 1259 OID 18692)
-- Name: id_counter_user_user_id_cf6e47e852f650_like; Type: INDEX; Schema: public; Owner: bayen; Tablespace: 
--

CREATE INDEX id_counter_user_user_id_cf6e47e852f650_like ON id_counter_user USING btree (user_id varchar_pattern_ops);


--
-- TOC entry 2272 (class 2606 OID 18643)
-- Name: auth_content_type_id_508cf46651277a81_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_content_type_id_508cf46651277a81_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2273 (class 2606 OID 18650)
-- Name: auth_group_permissio_group_id_689710a9a73b7457_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_689710a9a73b7457_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2274 (class 2606 OID 18655)
-- Name: auth_group_permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2278 (class 2606 OID 18680)
-- Name: auth_user__permission_id_384b62483d7071f0_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user__permission_id_384b62483d7071f0_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2276 (class 2606 OID 18668)
-- Name: auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2275 (class 2606 OID 18663)
-- Name: auth_user_groups_user_id_4b5ed4ffdb8fd9b0_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_4b5ed4ffdb8fd9b0_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2277 (class 2606 OID 18675)
-- Name: auth_user_user_permiss_user_id_7f0938558328534a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permiss_user_id_7f0938558328534a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2270 (class 2606 OID 18178)
-- Name: djcelery_periodictask_crontab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_crontab_id_fkey FOREIGN KEY (crontab_id) REFERENCES djcelery_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2269 (class 2606 OID 18173)
-- Name: djcelery_periodictask_interval_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_interval_id_fkey FOREIGN KEY (interval_id) REFERENCES djcelery_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2271 (class 2606 OID 18206)
-- Name: djcelery_taskstate_worker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_worker_id_fkey FOREIGN KEY (worker_id) REFERENCES djcelery_workerstate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2285 (class 2606 OID 20218)
-- Name: flow_distribution_id_refs_id_0a4807d1; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_player
    ADD CONSTRAINT flow_distribution_id_refs_id_0a4807d1 FOREIGN KEY (flow_distribution_id) REFERENCES graph_flowdistribution(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2297 (class 2606 OID 20223)
-- Name: flowdistribution_id_refs_id_6cfbee99; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_flowdistribution_path_assignments
    ADD CONSTRAINT flowdistribution_id_refs_id_6cfbee99 FOREIGN KEY (flowdistribution_id) REFERENCES graph_flowdistribution(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2304 (class 2606 OID 20328)
-- Name: game_id_refs_name_0714be3b; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_game_turns
    ADD CONSTRAINT game_id_refs_name_0714be3b FOREIGN KEY (game_id) REFERENCES graph_game(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2286 (class 2606 OID 20323)
-- Name: game_id_refs_name_1450a27d; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_player
    ADD CONSTRAINT game_id_refs_name_1450a27d FOREIGN KEY (game_id) REFERENCES graph_game(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2295 (class 2606 OID 20275)
-- Name: graph_cost_id_refs_id_6eb49a68; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_gameturn
    ADD CONSTRAINT graph_cost_id_refs_id_6eb49a68 FOREIGN KEY (graph_cost_id) REFERENCES graph_graphcost(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2288 (class 2606 OID 20110)
-- Name: graph_edge_from_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_edge
    ADD CONSTRAINT graph_edge_from_node_id_fkey FOREIGN KEY (from_node_id) REFERENCES graph_node(node_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2287 (class 2606 OID 20105)
-- Name: graph_edge_graph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_edge
    ADD CONSTRAINT graph_edge_graph_id_fkey FOREIGN KEY (graph_id) REFERENCES graph_graph(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2289 (class 2606 OID 20115)
-- Name: graph_edge_to_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_edge
    ADD CONSTRAINT graph_edge_to_node_id_fkey FOREIGN KEY (to_node_id) REFERENCES graph_node(node_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2299 (class 2606 OID 20239)
-- Name: graph_edgecost_edge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_edgecost
    ADD CONSTRAINT graph_edgecost_edge_id_fkey FOREIGN KEY (edge_id) REFERENCES graph_edge(edge_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2296 (class 2606 OID 20195)
-- Name: graph_flowdistribution_path_assignme_pathflowassignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_flowdistribution_path_assignments
    ADD CONSTRAINT graph_flowdistribution_path_assignme_pathflowassignment_id_fkey FOREIGN KEY (pathflowassignment_id) REFERENCES graph_pathflowassignment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2298 (class 2606 OID 20213)
-- Name: graph_flowdistribution_turn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_flowdistribution
    ADD CONSTRAINT graph_flowdistribution_turn_id_fkey FOREIGN KEY (turn_id) REFERENCES graph_gameturn(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2305 (class 2606 OID 20313)
-- Name: graph_game_current_turn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_game
    ADD CONSTRAINT graph_game_current_turn_id_fkey FOREIGN KEY (current_turn_id) REFERENCES graph_gameturn(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2306 (class 2606 OID 20318)
-- Name: graph_game_graph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_game
    ADD CONSTRAINT graph_game_graph_id_fkey FOREIGN KEY (graph_id) REFERENCES graph_graph(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2303 (class 2606 OID 20298)
-- Name: graph_game_turns_gameturn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_game_turns
    ADD CONSTRAINT graph_game_turns_gameturn_id_fkey FOREIGN KEY (gameturn_id) REFERENCES graph_gameturn(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2300 (class 2606 OID 20254)
-- Name: graph_graphcost_edge_costs_edgecost_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_graphcost_edge_costs
    ADD CONSTRAINT graph_graphcost_edge_costs_edgecost_id_fkey FOREIGN KEY (edgecost_id) REFERENCES graph_edgecost(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2302 (class 2606 OID 20270)
-- Name: graph_graphcost_graph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_graphcost
    ADD CONSTRAINT graph_graphcost_graph_id_fkey FOREIGN KEY (graph_id) REFERENCES graph_graph(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2279 (class 2606 OID 20046)
-- Name: graph_node_graph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_node
    ADD CONSTRAINT graph_node_graph_id_fkey FOREIGN KEY (graph_id) REFERENCES graph_graph(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2290 (class 2606 OID 20133)
-- Name: graph_path_edges_edge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_path_edges
    ADD CONSTRAINT graph_path_edges_edge_id_fkey FOREIGN KEY (edge_id) REFERENCES graph_edge(edge_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2292 (class 2606 OID 20149)
-- Name: graph_path_graph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_path
    ADD CONSTRAINT graph_path_graph_id_fkey FOREIGN KEY (graph_id) REFERENCES graph_graph(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2293 (class 2606 OID 20154)
-- Name: graph_path_player_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_path
    ADD CONSTRAINT graph_path_player_model_id_fkey FOREIGN KEY (player_model_id) REFERENCES graph_playermodel(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2294 (class 2606 OID 20172)
-- Name: graph_pathflowassignment_path_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_pathflowassignment
    ADD CONSTRAINT graph_pathflowassignment_path_id_fkey FOREIGN KEY (path_id) REFERENCES graph_path(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2284 (class 2606 OID 20092)
-- Name: graph_player_player_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_player
    ADD CONSTRAINT graph_player_player_model_id_fkey FOREIGN KEY (player_model_id) REFERENCES graph_playermodel(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2283 (class 2606 OID 20087)
-- Name: graph_player_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_player
    ADD CONSTRAINT graph_player_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2282 (class 2606 OID 20069)
-- Name: graph_playermodel_destination_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_playermodel
    ADD CONSTRAINT graph_playermodel_destination_node_id_fkey FOREIGN KEY (destination_node_id) REFERENCES graph_node(node_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2280 (class 2606 OID 20059)
-- Name: graph_playermodel_graph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_playermodel
    ADD CONSTRAINT graph_playermodel_graph_id_fkey FOREIGN KEY (graph_id) REFERENCES graph_graph(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2281 (class 2606 OID 20064)
-- Name: graph_playermodel_start_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_playermodel
    ADD CONSTRAINT graph_playermodel_start_node_id_fkey FOREIGN KEY (start_node_id) REFERENCES graph_node(node_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2301 (class 2606 OID 20280)
-- Name: graphcost_id_refs_id_c0ee7321; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_graphcost_edge_costs
    ADD CONSTRAINT graphcost_id_refs_id_c0ee7321 FOREIGN KEY (graphcost_id) REFERENCES graph_graphcost(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2291 (class 2606 OID 20159)
-- Name: path_id_refs_id_241ea44f; Type: FK CONSTRAINT; Schema: public; Owner: bayen
--

ALTER TABLE ONLY graph_path_edges
    ADD CONSTRAINT path_id_refs_id_241ea44f FOREIGN KEY (path_id) REFERENCES graph_path(id) DEFERRABLE INITIALLY DEFERRED;


-- Completed on 2015-08-19 20:40:14 PDT

--
-- PostgreSQL database dump complete
--

