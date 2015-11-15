-- ******************************************************
-- 2015ps4.sql
--
-- Loader for PS-4 Database
--
-- Description: This script contains the DDL to load
--              the tables of the
--              INVENTORY database
--
-- There are 6 tables on this DB
--
-- Author:  Maria R. Garcia Altobello
--
-- Student:  James Goodspeed
--
-- Date:   November, 2015
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool 2015ps4.lst


-- ******************************************************
--    DROP TABLES
-- Note:  Issue the appropriate commands to drop tables
-- ******************************************************
DROP table tbShipment purge;
DROP table tbQuote purge;
DROP table tbComponent purge;
DROP table tbProduct purge;
DROP table tbPart purge;
DROP table tbVendor purge;


-- ******************************************************
--    DROP SEQUENCES
-- Note:  Issue the appropriate commands to drop sequences
-- ******************************************************
DROP sequence seq_shipment;


-- ******************************************************
--    CREATE TABLES
-- ******************************************************


CREATE table tbProduct (
        prodNo          char(3)                 not null
            constraint  pk_product primary key,
        productName     varchar2(15)            not null,
        schedule        number(2,0)             not null
);


CREATE table tbVendor (
        vendorNo        char(3)                 not null
            constraint  pk_vendor primary key,
            constraint  rg_vendorNo check (REGEXP_LIKE(vendorNo, '^[1-9][0-9][0-9]$')),
        vendorName      varchar2(25)            not null,
        vendorCity      varchar2(15)            null
);


CREATE table tbPart (
        partNo          char(2)                 not null
            constraint  pk_part primary key,
            constraint  rg_partNo check (REGEXP_LIKE(partNo, '^[[:digit:]]{2}$')),
        partDescr       varchar2(15)            not null,
        quantityOnHand  number(8,0)             not null
);


CREATE table tbComponent (
        prodNo          char (3)                not null
            constraint  fk_prodNo_tbComponent references tbProduct (prodNo) on delete cascade,
        compNo          char (2)                not null,
            constraint  rg_compNo check (REGEXP_LIKE(compNo, '^0[1-9]|10$')),
        partNo          char (2)                null
            constraint  fk_partNo_tbPart references tbPart (partNo) on delete set null,
        noPartsReq      number (2,0)            default 1     not null,
            constraint  pk_component primary key (prodNo, compNo) 
);


CREATE table tbQuote (
        vendorNo        char(3)                 not null
            constraint  fk_vendorNo_tbQuote references tbVendor (vendorNo),
        partNo          char(2)                 not null
            constraint  fk_partNo_tbQuote references tbPart (partNo) on delete cascade,
        priceQuote      number(11,2)            default 0     not null
            constraint  rg_priceQuote check (priceQuote >= 0),
            constraint  pk_quote primary key (vendorNo, partNo)
);


CREATE table tbShipment (
        shipmentNo      number (11,0)           not null
            constraint  pk_shipment primary key,
        vendorNo        char (3)                not null,
        partNo          char (2)                not null,
        quantity        number (4,0)            default 1,
        shipmentDate    date                    default CURRENT_DATE     null,
            constraint  fk_vendorNo_partNo_tbShipment foreign key (vendorNo, partNo) references tbQuote (vendorNo, partNo)
);





-- ******************************************************
--    CREATE SEQUENCES
-- ******************************************************

CREATE sequence seq_shipment
    increment by 1
    start with 1;



-- ******************************************************
--    CREATE TRIGGERS - PS-4
-- ******************************************************
CREATE OR REPLACE TRIGGER TR_new_shipDate_IN
   BEFORE INSERT ON tbShipment
   FOR EACH ROW

   BEGIN
      SELECT sysdate
           into :new.shipmentDate
            FROM dual;
   END TR_new_gift_IN;
.
/

    
-- ******************************************************
--    POPULATE TABLES
--
-- Note:  Follow instructions and data provided on PS-3
--        to populate the tables
--
-- These are the original insert statements for PS-3.  
-- A new insert statement for the PS-4 trigger is listed
-- above.
-- ******************************************************

/* inventory tbProduct */
INSERT INTO tbProduct VALUES ('100', 'Cart', 3);
INSERT INTO tbProduct VALUES ('101', 'Wheelbarrow', 3);


/* inventory tbVendor */
INSERT INTO tbVendor VALUES ('123', 'FirstOne', 'Boston');
INSERT INTO tbVendor VALUES ('225', 'SomeStuff', 'Cambridge');
INSERT INTO tbVendor VALUES ('747', 'LastChance', 'Belmont');
INSERT INTO tbVendor VALUES ('909', 'IHaveIt', 'Boston');


/* inventory tbPart */
INSERT INTO tbPart VALUES ('01', 'Tub', 10);
INSERT INTO tbPart VALUES ('05', 'Wheel', 45);
INSERT INTO tbPart VALUES ('97', 'Box', 15);
INSERT INTO tbPart VALUES ('98', 'Strut', 15);
INSERT INTO tbPart VALUES ('99', 'Handle', 55);

/* Insert for testing PS-4 project #2 */
INSERT INTO tbPart VALUES ('10', 'Axl', 12);
INSERT INTO tbPart VALUES ('12', 'Handle Covers', 20);

/* inventory tbComponent */
INSERT INTO tbComponent VALUES ('100', '01', '05', 2);
INSERT INTO tbComponent VALUES ('100', '02', '97', 1);
INSERT INTO tbComponent VALUES ('100', '03', '98', 1);
INSERT INTO tbComponent VALUES ('100', '04', '99', 1);
INSERT INTO tbComponent VALUES ('101', '01', '01', 1);
INSERT INTO tbComponent VALUES ('101', '02', '05', 2);
INSERT INTO tbComponent VALUES ('101', '03', '98', 1);
INSERT INTO tbComponent VALUES ('101', '04', '99', 2);


/* inventory tbQuote */
INSERT INTO tbQuote VALUES ('123', '01', 50.00);
INSERT INTO tbQuote VALUES ('123', '98', 20.00);
INSERT INTO tbQuote VALUES ('225', '99', 20.00);
INSERT INTO tbQuote VALUES ('747', '05', 28.00);
INSERT INTO tbQuote VALUES ('909', '01', 40.00);
INSERT INTO tbQuote VALUES ('909', '05', 30.00);
INSERT INTO tbQuote VALUES ('909', '97', 60.00);
INSERT INTO tbQuote VALUES ('909', '98', 22.00);
INSERT INTO tbQuote VALUES ('909', '99', 22.00);

/* Insert for testing PS-4 project #2 */
INSERT INTO tbQuote VALUES ('123', '05', 27);


/* inventory tbShipment 
INSERT INTO tbShipment VALUES (seq_shipment.nextval, '909', '01', 2, '01-OCT-2015');
INSERT INTO tbShipment VALUES (seq_shipment.nextval, '747', '05', 5, '02-OCT-2015');
INSERT INTO tbShipment VALUES (seq_shipment.nextval, '909', '97', 2, '03-OCT-2015');
INSERT INTO tbShipment VALUES (seq_shipment.nextval, '123', '98', 5, '07-OCT-2015');
INSERT INTO tbShipment VALUES (seq_shipment.nextval, '225', '99', 1, '07-OCT-2015');
*/

/* New tbShipment insert statements for PS-4 using Trigger */
INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '909', '01', 2);
INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '747', '05', 5);
INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '909', '97', 2);
INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '123', '98', 5);
INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '225', '99', 1);





-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropriate commands to show your data
-- ******************************************************

SELECT * FROM tbComponent;
SELECT * FROM tbPart;
SELECT * FROM tbProduct;
SELECT * FROM tbQuote;
SELECT * FROM tbShipment;
SELECT * FROM tbVendor;


-- ******************************************************
--    QUALITY CONTROLS
--
-- Note:  Test only 2 constraints of each of
--        the following types:
--        *) Entity integrity
--        *) Referential integrity
--        *) Column constraints
-- ******************************************************

-- Entity integrity
INSERT into tbVendor values (null, 'Vendor1', 'Portsmouth');
INSERT into tbProduct values (null, 'Mower', 1);

-- Referential integrity
INSERT into tbQuote values ('567', '01', 30.00);
INSERT into tbComponent values ('200', '02', '02', 1);

-- Column integrity.  Add negative number and non-number values
INSERT into tbQuote values ('225', '99', -20.00);
INSERT into tbPart values ('ff', 'Axl', 3);


-- ******************************************************
--    ASKING QUESTIONS TO THE DATABASE
-- 
-- ******************************************************

-- QUERY #1
-- Assumptions: We would want to know about all future 
-- Products/Parts not just the existing ones.
WITH v AS (
    SELECT partDescr, count(*) AS c 
    FROM tbComponent NATURAL JOIN tbPart GROUP BY partDescr) 
  SELECT partDescr 
    FROM v 
    WHERE c > 1;


-- QUERY #2
SELECT productName 
  FROM tbProduct 
  NATURAL JOIN tbComponent 
  NATURAL JOIN tbPart 
  WHERE partDescr = 'Box';


-- QUERY #3
-- I am assuming we do not want to see parts that pass the
-- requirement (e.g. have 2 or more quotes)
SELECT a.partNo, partDescr, count(priceQuote) AS numQuote 
  FROM tbQuote a JOIN tbPart ON a.partNo = tbPart.partNo 
  WHERE (SELECT count(priceQuote) 
    FROM tbQuote b 
    WHERE a.partNo = b.partNo GROUP BY a.partNo) < 2 
  GROUP BY a.partNo, partDescr;


-- QUERY #4
SELECT vendorName, partNo, priceQuote 
  FROM tbQuote a 
  NATURAL JOIN tbVendor 
  WHERE priceQuote = (
    SELECT MIN(priceQuote) 
    FROM tbQuote b 
    WHERE b.partNo = a.partNo) 
  ORDER BY partNo;


-- QUERY #5
SELECT a.prodNo, b.compNo, c.partNo, c.partDescr 
  FROM tbProduct a 
  RIGHT OUTER JOIN tbComponent b ON (a.prodNo = b.prodNo) 
  RIGHT OUTER JOIN tbPart c ON (b.partNo = c.partNo);


-- QUERY #6 
-- Written to remove redundant rows
SELECT a.vendorName AS Vendor1, b.vendorName AS Vendor2, b.vendorCity 
  FROM tbVendor a 
  JOIN tbVendor b ON (a.vendorNo > b.vendorNo) 
  WHERE a.vendorCity = b.vendorCity;


-- QUERY #7
-- I am making the following assumption:  my result shows the last week
-- there will be enough parts.  So the following result shows that the 2nd 
-- week is the last week there will be enough Struts - the 3rd week there
-- will not be enough Struts to build anything.
--
-- PARTDESCR             WEEK
-- --------------- ----------
-- Strut                    2
-- 
WITH v AS (
  SELECT DISTINCT b.partNo, partDescr, 
    FLOOR((
         (SELECT quantityOnHand 
          FROM tbPart 
          WHERE b.partNo = partNo) / 
         (SELECT SUM(schedule * noPartsReq) 
          FROM tbProduct 
          NATURAL JOIN tbComponent 
          WHERE b.partNo = tbComponent.partNo))
        ) AS week 
  FROM tbComponent b 
  JOIN tbPart d ON (b.partNo = d.partNo) 
  ORDER BY week
) 
SELECT * 
FROM (
  SELECT partDescr, MIN(week) AS week 
  FROM v 
  GROUP BY partDescr 
  ORDER BY week ASC) 
WHERE ROWNUM = 1;

-- ******************************************************
--    END SESSION
-- ******************************************************

spool off
