/*
 * Test local estimate for join pushdown

Note: Create testcost1 and testcost2 on Oracle before execute this regression test.

CREATE TABLE TESTCOST1(id integer, val integer, primary key(id)) SEGMENT CREATION IMMEDIATE;
CREATE TABLE TESTCOST2(id integer, val integer, primary key(id)) SEGMENT CREATION IMMEDIATE;
 */

SET client_min_messages = WARNING;
set enable_material to off;

CREATE FOREIGN TABLE fora_TESTCOST1 (
    id  integer OPTIONS (key 'yes'),
    val integer
) SERVER oracle OPTIONS (table 'TESTCOST1');;

CREATE FOREIGN TABLE fora_TESTCOST2 (
    id  integer OPTIONS (key 'yes'),
    val integer
) SERVER oracle OPTIONS (table 'TESTCOST2');;

/* High cardinality */
INSERT INTO fora_TESTCOST1(id, val) SELECT i, i from GENERATE_SERIES(1, 10000 ) as i;
INSERT INTO fora_TESTCOST2(id, val) SELECT * FROM fora_TESTCOST1;

SELECT * FROM fora_testcost1 order by 1 LIMIT 10;
SELECT * FROM fora_testcost2 order by 1 LIMIT 10;

select relname, relpages, reltuples from pg_class where relname like '%testcost%';
analyze fora_testcost1;
analyze fora_testcost2;
select relname, relpages, reltuples from pg_class where relname like '%testcost%';

EXPLAIN (verbose, costs off) SELECT T1.val FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val;
SELECT count(T1.val) FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val;

EXPLAIN (verbose, costs off) SELECT T1.val FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val and t1.val = 1;
SELECT count(T1.val) FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val and t1.val = 1;

/* Clean up */
DELETE FROM fora_testcost1;
DELETE FROM fora_testcost2;


/* Low cardinality */
INSERT INTO fora_TESTCOST1(id, val) SELECT i, i/100 from GENERATE_SERIES(1, 10000 ) as i;
INSERT INTO fora_TESTCOST2(id, val) SELECT * FROM fora_TESTCOST1;

SELECT * FROM fora_testcost1 order by 1 LIMIT 10;
SELECT * FROM fora_testcost2 order by 1 LIMIT 10;

select relname, relpages, reltuples from pg_class where relname like '%testcost%';
analyze fora_testcost1;
analyze fora_testcost2;
select relname, relpages, reltuples from pg_class where relname like '%testcost%';

EXPLAIN (verbose, costs off) SELECT T1.val FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val;
SELECT count(T1.val) FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val;

EXPLAIN (verbose, costs off) SELECT T1.val FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val and t1.val = 1;
SELECT count(T1.val) FROM fora_TESTCOST1 as T1, fora_TESTCOST2 as T2 WHERE T1.val = T2.val and t1.val = 1;

/* Clean up */
DELETE FROM fora_testcost1;
DELETE FROM fora_testcost2;
