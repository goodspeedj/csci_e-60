-- ******************************************************
-- 2015ps3.sql
--
-- Loader for PS-3 Database
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
-- Date:   October, 2015
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool 2015ps3.lst


-- ******************************************************
--    DROP TABLES
-- Note:  Issue the appropiate commands to drop tables
-- ******************************************************
DROP table tbShipment purge;
DROP table tbQuote purge;
DROP table tbComponent purge;
DROP table tbProduct purge;
DROP table tbPart purge;
DROP table tbVendor purge;


-- ******************************************************
--    DROP SEQUENCES
-- Note:  Issue the appropiate commands to drop sequences
-- ******************************************************
DROP sequence seq_shipment


-- ******************************************************
--    CREATE TABLES
-- ******************************************************


CREATE table tbProduct (
        prodNo          char(3)                 not null
            constraint pk_product primary key,
        productName     varchar2(15)            not null,
        schedule        number(2,0)             not null
);


CREATE table tbVendor (
        vendorNo        char(3)                 not null
            constraint pk_vendor primary key,
        vendorName      varchar2(25)            not null,
        vendorCity      varchar2(15)            null
);


CREATE table tbPart (
        partNo          char(2)                 not null
            constraint  pk_part primary key,
        partDescr       varchar2(15)            not null,
        quantityOnHand  number(8,0)             not null
);


CREATE table tbComponent (
        prodNo          char (3)                not null
            constraint fk_prodNo_tbComponent references tbProduct (prodNo) on delete cascade,
        compNo          char (2)                not null,
        partNo          char (2)                null
            constraint fk_partNo_tbPart references tbPart (partNo) on delete set null,
        noPartsReq      number (2,0)            default 1     not null,
            constraint pk_component primary key (prodNo, compNo) 
);


CREATE table tbQuote (
        vendorNo        char(2)                 not null
            constraint fk_vendorNo_tbQuote references tbVendor (vendorNo),
        partNo          char(2)                 not null
            constraint fk_partNo_tbQuote references tbPart (partNo) on delete cascade,
        priceQuote      number(11,2)            default 0     not null
            constraint rg_priceQuote check (priceQuote >= 0),
            constraint pk_quote primary key (vendorNo, partNo)
);

-- shipmentDate origianlly not null - are we expected to correct mistakes in the script?
CREATE table tbShipment (
        shipmentNo      number (11,0)           not null
            constraint pk_shipment primary key,
        vendorNo        char (3)                not null,
        partNo          char (2)                not null,
        quantity        number (4,0)            default 1,
        shipmentDate    date                    default CURRENT_DATE     null,
            constraint fk_vendorNo_partNo_tbShipment foreign key (vendorNo, partNo) references tbQuote (vendorNo, partNo)
);





-- ******************************************************
--    CREATE SEQUENCES
-- ******************************************************

CREATE sequence seq_shipment
    increment by 1
    start with 1;
    
    
-- ******************************************************
--    POPULATE TABLES
--
-- Note:  Follow instructions and data provided on PS-3
--        to populate the tables
-- ******************************************************

/* inventory tbProduct */
INSERT into tbProduct values ('100', 'Cart', 3);
INSERT into tbProduct values ('101', 'Wheelbarrow', 3);


/* inventory tbVendor */
INSERT into tbVendor values ('123', 'FirstOne', 'Boston');
INSERT into tbVendor values ('225', 'SomeStuff', 'Cambridge');
INSERT into tbVendor values ('747', 'LastChance', 'Belmont');
INSERT into tbVendor values ('909', 'IHaveIt', 'Boston');


/* inventory tbPart */
INSERT into tbPart values ('01', 'Tub', 10);
INSERT into tbPart values ('05', 'Wheel', 45);
INSERT into tbPart values ('97', 'Box', 15);
INSERT into tbPart values ('98', 'Strut', 15);
INSERT into tbPart values ('99', 'Handle', 55);


/* inventory tbComponent */
INSERT into tbComponent values ('100', '01', '05', 2);
INSERT into tbComponent values ('100', '02', '97', 1);
INSERT into tbComponent values ('100', '03', '98', 1);
INSERT into tbComponent values ('100', '04', '99', 1);
INSERT into tbComponent values ('101', '01', '01', 1);
INSERT into tbComponent values ('101', '02', '05', 2);
INSERT into tbComponent values ('101', '03', '98', 1);
INSERT into tbComponent values ('101', '04', '99', 2);


/* inventory tbQuote */
INSERT into tbQuote values ('123', '01', 50.00);
INSERT into tbQuote values ('123', '98', 20.00);
INSERT into tbQuote values ('225', '99', 20.00);
INSERT into tbQuote values ('747', '05', 28.00);
INSERT into tbQuote values ('909', '01', 40.00);
INSERT into tbQuote values ('909', '05', 30.00);
INSERT into tbQuote values ('909', '97', 60.00);
INSERT into tbQuote values ('909', '98', 22.00);
INSERT into tbQuote values ('909', '99', 22.00);


/* inventory tbShipment */
INSERT into tbShipment values (seq_shipment.nextval, '909', '01', 2, '01-OCT-2015');
INSERT into tbShipment values (seq_shipment.nextval, '747', '05', 5, '02-OCT-2015');
INSERT into tbShipment values (seq_shipment.nextval, '909', '97', 2, '03-OCT-2015');
INSERT into tbShipment values (seq_shipment.nextval, '123', '98', 5, '07-OCT-2015');
INSERT into tbShipment values (seq_shipment.nextval, '225', '99', 1, '07-OCT-2015');






-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropiate commands to show your data
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
INSERT into tbComponent values ('100', '02', '02', 1);

-- Column integrity
INSERT into tbQuote values ('225', '99', -20.00);
INSERT into tbVendor values ('890', null, 'Dover')

-- ******************************************************
--    END SESSION
-- ******************************************************

spool off
