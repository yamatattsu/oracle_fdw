/*
 * Test JOIN pushdown

Note: Create typetest2 on Oracle before execute this regression test.

CREATE TABLE scott.typetest2 (
   id  NUMBER(5)
      CONSTRAINT typetest2_pkey PRIMARY KEY,
   c   CHAR(10 CHAR),
   nc  NCHAR(10),
   vc  VARCHAR2(10 CHAR),
   nvc NVARCHAR2(10),
   lc  CLOB,
   r   RAW(10),
   u   RAW(16),
   lb  BLOB,
   lr  LONG RAW,
   b   NUMBER(1),
   num NUMBER(7,5),
   fl  BINARY_FLOAT,
   db  BINARY_DOUBLE,
   d   DATE,
   ts  TIMESTAMP WITH TIME ZONE,
   ids INTERVAL DAY TO SECOND,
   iym INTERVAL YEAR TO MONTH
) SEGMENT CREATION IMMEDIATE;

 */

SET client_min_messages = WARNING;

CREATE FOREIGN TABLE typetest2 (
   id  integer OPTIONS (key 'yes') NOT NULL,
   c   character(10),
   nc  character(10),
   vc  character varying(10),
   nvc character varying(10),
   lc  text,
   r   bytea,
   u   uuid,
   lb  bytea,
   lr  bytea,
   b   boolean,
   num numeric(7,5),
   fl  float,
   db  double precision,
   d   date,
   ts  timestamp with time zone,
   ids interval,
   iym interval
) SERVER oracle OPTIONS (table 'TYPETEST2');

INSERT INTO typetest2 SELECT * FROM typetest1;
INSERT INTO typetest2 (id, c) VALUES (2, NULL);

\x
SELECT id, c, nc, vc, nvc, r, u, lb, lr, b, num, fl, db, d, ts, ids, iym FROM typetest1 order by id;
SELECT id, c, nc, vc, nvc, r, u, lb, lr, b, num, fl, db, d, ts, ids, iym FROM typetest2 order by id;
\x

EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.c = t2.c;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.nc = t2.nc;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.vc = t2.vc;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.nvc = t2.nvc;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.lc = t2.lc;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.r = t2.r;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.u = t2.u;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.lb = t2.lb;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.lr = t2.lr;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.b = t2.b;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.num = t2.num;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.fl = t2.fl;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.db = t2.db;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.d = t2.d;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.ts = t2.ts;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.ids = t2.ids;
EXPLAIN (VERBOSE on, COSTS off) SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.iym = t2.iym;

SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.c = t2.c;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.nc = t2.nc;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.vc = t2.vc;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.nvc = t2.nvc;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.lc = t2.lc;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.r = t2.r;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.u = t2.u;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.lb = t2.lb;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.lr = t2.lr;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.b = t2.b;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.num = t2.num;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.fl = t2.fl;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.db = t2.db;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.d = t2.d;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.ts = t2.ts;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.ids = t2.ids;
SELECT t1.id, t2.id FROM typetest1 t1, typetest2 t2 WHERE t1.iym = t2.iym;

DELETE FROM typetest2;

