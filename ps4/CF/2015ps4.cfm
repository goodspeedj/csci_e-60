<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Project #1 - 2015ps4.lst</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="css/prettify.css" rel="stylesheet">
    <script src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql"></script>
  </head>

  <body>

    <!-- HTML version of the lst file -->
    
    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <h3>Project #1 - 2015ps4.lst</h3>
        <p>This file is also included in the zip file</p>

        <pre class="prettyprint">
          <code class="language-sql">

SQL>
SQL>
SQL> -- ******************************************************
SQL> --    DROP TABLES
SQL> -- Note:  Issue the appropriate commands to drop tables
SQL> -- ******************************************************
SQL> DROP table tbShipment purge;

Table dropped.

SQL> DROP table tbQuote purge;

Table dropped.

SQL> DROP table tbComponent purge;

Table dropped.

SQL> DROP table tbProduct purge;

Table dropped.

SQL> DROP table tbPart purge;

Table dropped.

SQL> DROP table tbVendor purge;

Table dropped.

SQL>
SQL>
SQL> -- ******************************************************
SQL> --    DROP SEQUENCES
SQL> -- Note:  Issue the appropriate commands to drop sequences
SQL> -- ******************************************************
SQL> DROP sequence seq_shipment;

Sequence dropped.

SQL>
SQL>
SQL> -- ******************************************************
SQL> --    CREATE TABLES
SQL> -- ******************************************************
SQL>
SQL>
SQL> CREATE table tbProduct (
  2          prodNo      char(3)             not null
  3          constraint  pk_product primary key,
  4          productName     varchar2(15)        not null,
  5          schedule        number(2,0)         not null
  6  );

Table created.

SQL>
SQL>
SQL> CREATE table tbVendor (
  2          vendorNo        char(3)             not null
  3          constraint  pk_vendor primary key,
  4          constraint  rg_vendorNo check (REGEXP_LIKE(vendorNo, '^[1-9][0-9][0-9]$')),
  5          vendorName      varchar2(25)        not null,
  6          vendorCity      varchar2(15)        null
  7  );

Table created.

SQL>
SQL>
SQL> CREATE table tbPart (
  2          partNo      char(2)             not null
  3          constraint  pk_part primary key,
  4          constraint  rg_partNo check (REGEXP_LIKE(partNo, '^[[:digit:]]{2}$')),
  5          partDescr       varchar2(15)        not null,
  6          quantityOnHand  number(8,0)         not null
  7  );

Table created.

SQL>
SQL>
SQL> CREATE table tbComponent (
  2          prodNo      char (3)            not null
  3          constraint  fk_prodNo_tbComponent references tbProduct (prodNo) on delete cascade,
  4          compNo      char (2)            not null,
  5          constraint  rg_compNo check (REGEXP_LIKE(compNo, '^0[1-9]|10$')),
  6          partNo      char (2)            null
  7          constraint  fk_partNo_tbPart references tbPart (partNo) on delete set null,
  8          noPartsReq      number (2,0)        default 1     not null,
  9          constraint  pk_component primary key (prodNo, compNo)
 10  );

Table created.

SQL>
SQL>
SQL> CREATE table tbQuote (
  2          vendorNo        char(3)             not null
  3          constraint  fk_vendorNo_tbQuote references tbVendor (vendorNo),
  4          partNo      char(2)             not null
  5          constraint  fk_partNo_tbQuote references tbPart (partNo) on delete cascade,
  6          priceQuote      number(11,2)        default 0     not null
  7          constraint  rg_priceQuote check (priceQuote >= 0),
  8          constraint  pk_quote primary key (vendorNo, partNo)
  9  );

Table created.

SQL>
SQL>
SQL> CREATE table tbShipment (
  2          shipmentNo      number (11,0)       not null
  3          constraint  pk_shipment primary key,
  4          vendorNo        char (3)            not null,
  5          partNo      char (2)            not null,
  6          quantity        number (4,0)        default 1,
  7          shipmentDate    date            default CURRENT_DATE     null,
  8          constraint  fk_vendorNo_partNo_tbShipment foreign key (vendorNo, partNo) references tbQuote (vendorNo, partNo)
  9  );

Table created.

SQL>
SQL>
SQL>
SQL>
SQL>
SQL> -- ******************************************************
SQL> --    CREATE SEQUENCES
SQL> -- ******************************************************
SQL>
SQL> CREATE sequence seq_shipment
  2      increment by 1
  3      start with 1;

Sequence created.

SQL>
SQL>
SQL>
SQL> -- ******************************************************
SQL> --    CREATE TRIGGERS - PS-4
SQL> -- ******************************************************
SQL> CREATE OR REPLACE TRIGGER TR_new_shipDate_IN
  2     BEFORE INSERT ON tbShipment
  3     FOR EACH ROW
  4
  5     BEGIN
  6        SELECT sysdate
  7         into :new.shipmentDate
  8          FROM dual;
  9     END TR_new_gift_IN;
 10  .
SQL> /

Trigger created.

SQL>
SQL>
SQL> -- ******************************************************
SQL> --    POPULATE TABLES
SQL> --
SQL> -- Note:  Follow instructions and data provided on PS-3
SQL> --        to populate the tables
SQL> --
SQL> -- These are the original insert statements for PS-3.
SQL> -- A new insert statement for the PS-4 trigger is listed
SQL> -- above.
SQL> -- ******************************************************
SQL>
SQL> /* inventory tbProduct */
SQL> INSERT INTO tbProduct VALUES ('100', 'Cart', 3);

1 row created.

SQL> INSERT INTO tbProduct VALUES ('101', 'Wheelbarrow', 3);

1 row created.

SQL>
SQL>
SQL> /* inventory tbVendor */
SQL> INSERT INTO tbVendor VALUES ('123', 'FirstOne', 'Boston');

1 row created.

SQL> INSERT INTO tbVendor VALUES ('225', 'SomeStuff', 'Cambridge');

1 row created.

SQL> INSERT INTO tbVendor VALUES ('747', 'LastChance', 'Belmont');

1 row created.

SQL> INSERT INTO tbVendor VALUES ('909', 'IHaveIt', 'Boston');

1 row created.

SQL>
SQL>
SQL> /* inventory tbPart */
SQL> INSERT INTO tbPart VALUES ('01', 'Tub', 10);

1 row created.

SQL> INSERT INTO tbPart VALUES ('05', 'Wheel', 45);

1 row created.

SQL> INSERT INTO tbPart VALUES ('97', 'Box', 15);

1 row created.

SQL> INSERT INTO tbPart VALUES ('98', 'Strut', 15);

1 row created.

SQL> INSERT INTO tbPart VALUES ('99', 'Handle', 55);

1 row created.

SQL>
SQL> /* inventory tbComponent */
SQL> INSERT INTO tbComponent VALUES ('100', '01', '05', 2);

1 row created.

SQL> INSERT INTO tbComponent VALUES ('100', '02', '97', 1);

1 row created.

SQL> INSERT INTO tbComponent VALUES ('100', '03', '98', 1);

1 row created.

SQL> INSERT INTO tbComponent VALUES ('100', '04', '99', 1);

1 row created.

SQL> INSERT INTO tbComponent VALUES ('101', '01', '01', 1);

1 row created.

SQL> INSERT INTO tbComponent VALUES ('101', '02', '05', 2);

1 row created.

SQL> INSERT INTO tbComponent VALUES ('101', '03', '98', 1);

1 row created.

SQL> INSERT INTO tbComponent VALUES ('101', '04', '99', 2);

1 row created.

SQL>
SQL>
SQL> /* inventory tbQuote */
SQL> INSERT INTO tbQuote VALUES ('123', '01', 50.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('123', '98', 20.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('225', '99', 20.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('747', '05', 28.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('909', '01', 40.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('909', '05', 30.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('909', '97', 60.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('909', '98', 22.00);

1 row created.

SQL> INSERT INTO tbQuote VALUES ('909', '99', 22.00);

1 row created.

SQL>
SQL>
SQL> /* inventory tbShipment
SQL> INSERT INTO tbShipment VALUES (seq_shipment.nextval, '909', '01', 2, '01-OCT-2015');
SQL> INSERT INTO tbShipment VALUES (seq_shipment.nextval, '747', '05', 5, '02-OCT-2015');
SQL> INSERT INTO tbShipment VALUES (seq_shipment.nextval, '909', '97', 2, '03-OCT-2015');
SQL> INSERT INTO tbShipment VALUES (seq_shipment.nextval, '123', '98', 5, '07-OCT-2015');
SQL> INSERT INTO tbShipment VALUES (seq_shipment.nextval, '225', '99', 1, '07-OCT-2015');
SQL> */
SQL>
SQL> /* New tbShipment insert statements for PS-4 using Trigger */
SQL> INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '909', '01', 2);

1 row created.

SQL> INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '747', '05', 5);

1 row created.

SQL> INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '909', '97', 2);

1 row created.

SQL> INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '123', '98', 5);

1 row created.

SQL> INSERT INTO tbShipment (shipmentNo, vendorNo, partNo, quantity) VALUES (seq_shipment.nextval, '225', '99', 1);

1 row created.

SQL>
SQL>
SQL>
SQL>
SQL>
SQL> -- ******************************************************
SQL> --    VIEW TABLES
SQL> --
SQL> -- Note:  Issue the appropriate commands to show your data
SQL> -- ******************************************************
SQL>
SQL> SELECT * FROM tbComponent;

PRO CO PA NOPARTSREQ
--- -- -- ----------
100 01 05          2
100 02 97          1
100 03 98          1
100 04 99          1
101 01 01          1
101 02 05          2
101 03 98          1
101 04 99          2

8 rows selected.

SQL> SELECT * FROM tbPart;

PA PARTDESCR       QUANTITYONHAND
-- --------------- --------------
01 Tub                         10
05 Wheel                       45
97 Box                         15
98 Strut                       15
99 Handle                      55

SQL> SELECT * FROM tbProduct;

PRO PRODUCTNAME       SCHEDULE
--- --------------- ----------
100 Cart                     3
101 Wheelbarrow              3

SQL> SELECT * FROM tbQuote;

VEN PA PRICEQUOTE
--- -- ----------
123 01         50
123 98         20
225 99         20
747 05         28
909 01         40
909 05         30
909 97         60
909 98         22
909 99         22

9 rows selected.

SQL> SELECT * FROM tbShipment;

SHIPMENTNO VEN PA   QUANTITY SHIPMENTD
---------- --- -- ---------- ---------
         1 909 01          2 15-NOV-15
         2 747 05          5 15-NOV-15
         3 909 97          2 15-NOV-15
         4 123 98          5 15-NOV-15
         5 225 99          1 15-NOV-15

SQL> SELECT * FROM tbVendor;

VEN VENDORNAME                VENDORCITY
--- ------------------------- ---------------
123 FirstOne                  Boston
225 SomeStuff                 Cambridge
747 LastChance                Belmont
909 IHaveIt                   Boston

SQL>
SQL>
SQL> -- ******************************************************
SQL> --    QUALITY CONTROLS
SQL> --
SQL> -- Note:  Test only 2 constraints of each of
SQL> --        the following types:
SQL> --        *) Entity integrity
SQL> --        *) Referential integrity
SQL> --        *) Column constraints
SQL> -- ******************************************************
SQL>
SQL> -- Entity integrity
SQL> INSERT into tbVendor values (null, 'Vendor1', 'Portsmouth');
INSERT into tbVendor values (null, 'Vendor1', 'Portsmouth')
                             *
ERROR at line 1:
ORA-01400: cannot insert NULL into ("JGOODSPE"."TBVENDOR"."VENDORNO")


SQL> INSERT into tbProduct values (null, 'Mower', 1);
INSERT into tbProduct values (null, 'Mower', 1)
                              *
ERROR at line 1:
ORA-01400: cannot insert NULL into ("JGOODSPE"."TBPRODUCT"."PRODNO")


SQL>
SQL> -- Referential integrity
SQL> INSERT into tbQuote values ('567', '01', 30.00);
INSERT into tbQuote values ('567', '01', 30.00)
*
ERROR at line 1:
ORA-02291: integrity constraint (JGOODSPE.FK_VENDORNO_TBQUOTE) violated -
parent key not found


SQL> INSERT into tbComponent values ('200', '02', '02', 1);
INSERT into tbComponent values ('200', '02', '02', 1)
*
ERROR at line 1:
ORA-02291: integrity constraint (JGOODSPE.FK_PARTNO_TBPART) violated - parent
key not found


SQL>
SQL> -- Column integrity.  Add negative number and non-number values
SQL> INSERT into tbQuote values ('225', '99', -20.00);
INSERT into tbQuote values ('225', '99', -20.00)
*
ERROR at line 1:
ORA-02290: check constraint (JGOODSPE.RG_PRICEQUOTE) violated


SQL> INSERT into tbPart values ('ff', 'Axl', 3);
INSERT into tbPart values ('ff', 'Axl', 3)
*
ERROR at line 1:
ORA-02290: check constraint (JGOODSPE.RG_PARTNO) violated


SQL>
SQL>
SQL> -- ******************************************************
SQL> --    ASKING QUESTIONS TO THE DATABASE
SQL> --
SQL> -- ******************************************************
SQL>
SQL> -- QUERY #1
SQL> -- Assumptions: We would want to know about all future
SQL> -- Products/Parts not just the existing ones.
SQL> WITH v AS (
  2      SELECT partDescr, count(*) AS c
  3      FROM tbComponent NATURAL JOIN tbPart GROUP BY partDescr)
  4    SELECT partDescr
  5      FROM v
  6      WHERE c > 1;

PARTDESCR
---------------
Handle
Strut
Wheel

SQL>
SQL>
SQL> -- QUERY #2
SQL> SELECT productName
  2    FROM tbProduct
  3    NATURAL JOIN tbComponent
  4    NATURAL JOIN tbPart
  5    WHERE partDescr = 'Box';

PRODUCTNAME
---------------
Cart

SQL>
SQL>
SQL> -- QUERY #3
SQL> -- I am assuming we do not want to see parts that pass the
SQL> -- requirement (e.g. have 2 or more quotes)
SQL> SELECT a.partNo, partDescr, count(priceQuote) AS numQuote
  2    FROM tbQuote a JOIN tbPart ON a.partNo = tbPart.partNo
  3    WHERE (SELECT count(priceQuote)
  4      FROM tbQuote b
  5      WHERE a.partNo = b.partNo GROUP BY a.partNo) < 2
  6    GROUP BY a.partNo, partDescr;

PA PARTDESCR         NUMQUOTE
-- --------------- ----------
97 Box                      1

SQL>
SQL>
SQL> -- QUERY #4
SQL> SELECT vendorName, partNo, priceQuote
  2    FROM tbQuote a
  3    NATURAL JOIN tbVendor
  4    WHERE priceQuote = (
  5      SELECT MIN(priceQuote)
  6      FROM tbQuote b
  7      WHERE b.partNo = a.partNo)
  8    ORDER BY partNo;

VENDORNAME                PA PRICEQUOTE
------------------------- -- ----------
IHaveIt                   01         40
LastChance                05         28
IHaveIt                   97         60
FirstOne                  98         20
SomeStuff                 99         20

SQL>
SQL>
SQL> -- QUERY #5
SQL> SELECT a.prodNo, b.compNo, c.partNo, c.partDescr
  2    FROM tbProduct a
  3    RIGHT OUTER JOIN tbComponent b ON (a.prodNo = b.prodNo)
  4    RIGHT OUTER JOIN tbPart c ON (b.partNo = c.partNo);

PRO CO PA PARTDESCR
--- -- -- ---------------
100 01 05 Wheel
100 02 97 Box
100 03 98 Strut
100 04 99 Handle
101 01 01 Tub
101 02 05 Wheel
101 03 98 Strut
101 04 99 Handle

8 rows selected.

SQL>
SQL>
SQL> -- QUERY #6
SQL> -- Written to remove redundant rows
SQL> SELECT a.vendorName AS Vendor1, b.vendorName AS Vendor2, b.vendorCity
  2    FROM tbVendor a
  3    JOIN tbVendor b ON (a.vendorNo > b.vendorNo)
  4    WHERE a.vendorCity = b.vendorCity;

VENDOR1                   VENDOR2                   VENDORCITY
------------------------- ------------------------- ---------------
IHaveIt                   FirstOne                  Boston

SQL>
SQL>
SQL> -- QUERY #7
SQL> -- I am making the following assumption:  my result shows the last week
SQL> -- there will be enough parts.  So the following result shows that the 2nd
SQL> -- week is the last week there will be enough Struts - the 3rd week there
SQL> -- will not be enough Struts to build anything.
SQL> --
SQL> -- PARTDESCR         WEEK
SQL> -- --------------- ----------
SQL> -- Strut            2
SQL> --
SQL> WITH v AS (
  2    SELECT DISTINCT b.partNo, partDescr,
  3      FLOOR((
  4           (SELECT quantityOnHand
  5            FROM tbPart
  6            WHERE b.partNo = partNo) /
  7           (SELECT SUM(schedule * noPartsReq)
  8            FROM tbProduct
  9            NATURAL JOIN tbComponent
 10            WHERE b.partNo = tbComponent.partNo))
 11          ) AS week
 12    FROM tbComponent b
 13    JOIN tbPart d ON (b.partNo = d.partNo)
 14    ORDER BY week
 15  )
 16  SELECT *
 17  FROM (
 18    SELECT partDescr, MIN(week) AS week
 19    FROM v
 20    GROUP BY partDescr
 21    ORDER BY week ASC)
 22  WHERE ROWNUM = 1;

PARTDESCR             WEEK
--------------- ----------
Strut                    2

SQL>
SQL> -- ******************************************************
SQL> --    END SESSION
SQL> -- ******************************************************
SQL>
SQL> spool off

          </code>
        </pre>


      </div>
    </div><!-- /.container -->

    

     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>

  </body>
</html>