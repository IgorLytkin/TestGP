SELECT f.dx, f.item, f.product_name, f.store_id, s.store_address
FROM fact_table f, store_table s
WHERE f.store_id = s.id AND f.dx = 23
ORDER BY f.product_name;

CREATE TABLE new_foo AS SELECT * from foo
DISTRIBUTED BY (some_other_coummn);
DROP TABLE foo;
ALTER TABLE new_foo RENAME TO foo;

ALTER TABLE foo SET DISTRIBUTED BY (some_other_column);

CREATE TABLE foo (fid INT, ftype TEXT, fdate DATE)
DISTRIBUTED by (fid)
PARTITION BY RANGE(fdate)
(
PARTITION week START ('2015-11-01'::DATE)
END ('2016-01-31'::DATE)
EVERY ('1 week'::INTERVAL)
);

SELECT * FROM foo WHERE fdate > '2016-01-14'::DATE;

CREATE TABLE bar (bid integer, bloodtype text, bdate date)
DISTRIBUTED by (bid)
PARTITION BY LIST(bloodtype)
(PARTITION a values('A+', 'A', 'A-'),
PARTITION b values ('B+', 'B-', 'B'),
PARTITION ab values ('AB+', 'AB-', 'AB'),
PARTITION o values ('O+', 'O-', 'O')
DEFAULT PARTITION unknown);

CREATE TABLE gruz (bid INT, bloodtype TEXT, bdate DATE)
DISTRIBUTED by (bid)
PARTITION BY RANGE (bdate)
SUBPARTITION BY LIST(bloodtype)
SUBPARTITION TEMPLATE
(SUBPARTITION a VALUES('A+', 'A', 'A-'),
SUBPARTITION b VALUES ('B+', 'B-', 'B'),
SUBPARTITION ab VALUES ('AB+', 'AB-', 'AB'),
SUBPARTITION o VALUES ('O+', 'O-', 'O'),
DEFAULT SUBPARTITION unknown)
(START (DATE '2016-01-01')
END (DATE '2016-12-25')
EVERY (INTERVAL '1 week'));

SELECT
schemaname || '.' || tablename AS "Schema.Table"
,partitiontablename AS "PartTblName"
,partitiontype AS "Type"
,split_part(partitionrangestart, '::', 1) AS "Start"
,split_part(partitionrangeend, '::', 1) AS "End"
,partitionendinclusive AS "End Inclusive?"
FROM
pg_partitions;

CREATE TABLE foobar (fid INT, ft TEXT)
WITH (compresstype = quicklz,orientation=column,appendonly=true)
DISTRIBUTED by (fid);

CREATE TABLE gruz (gid INT, gt TEXT)
WITH (compresstype = quicklz,orientation=row)
DISTRIBUTED by (gid);
