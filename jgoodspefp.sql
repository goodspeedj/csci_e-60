-- ******************************************************
-- 2015fp.sql
--
-- Loader for Final Project Database
--
-- Description: This script contains the DDL to load
--              the tables of the
--              PEASEWATER database
--
-- Author:  James Goodspeed
--
-- Student:  James Goodspeed
--
-- Date:   October, 2015
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool 2015fp.lst

-- ******************************************************
--    DROP TABLES
-- ******************************************************
DROP table tbAddress purge;
DROP table tbWellSample purge;
DROP table tbPersonPFCLevel purge;
DROP table tbStudyPFCLevel purge;
DROP table tbPerson purge;
DROP table tbWell purge;
DROP table tbStudy purge;
DROP table tbChemical purge;

-- ******************************************************
--    DROP SEQUENCES
-- ******************************************************
DROP sequence seq_address;
DROP sequence seq_person;
DROP sequence seq_chemical;
DROP sequence seq_well;
DROP sequence seq_sample;
DROP sequence seq_study;

-- ******************************************************
--    CREATE TABLES
-- ******************************************************


CREATE table tbChemical (
        chemID          number(11,0)            not null
            constraint pk_chemical primary key,
        shortName       varchar2(15)            not null,
        longName        varchar2(40)            not null,
        epaPHALevel     number(3,2)             not null
);


CREATE table tbStudy (
        studyID         number(11,0)            not null
            constraint pk_study primary key,
        name            varchar2(25)            not null,
        startDate       date                    null,
        endDate         date                    null,
        participants    number(11,0)            not null
);


CREATE table tbWell (
        wellID          number(11,0)            not null
            constraint pk_well primary key,
        name            varchar2(20)            not null,
        location        varchar2(30)            not null,
        active          char(1)                 not null,
            constraint  rg_active check (REGEXP_LIKE(active, '^Y|N$'))
);


CREATE table tbPerson (
        personID        number(11,0)            not null
            constraint pk_person primary key,
        nhHHSID         varchar2(10)            not null,
        age             number(3,0)             not null,
        yearsExposed    number(2,0)             not null,
        sex             char(1)                 not null,
            constraint  rg_sex check (REGEXP_LIKE(sex, '^M|F$'))
);


CREATE table tbStudyPFCLevel (
        studyID         number(11,0)            not null
            constraint  fk_studyID_tbStudyPFCLevel references tbStudy (studyID),
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbStudyPFCLevel references tbChemical (chemID),
        pfcLevel           number(3,3)          not null,
            constraint  pk_studypfclevel primary key (studyID, chemID)
);


CREATE table tbPersonPFCLevel (
        personID        number(11,0)            not null
            constraint  fk_personID_tbPersonPFCLevel references tbPerson (personID),
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbPersonPFCLevel references tbChemical (chemID),
        pfcLevel        number(3,3)             not null,
            constraint  pk_personpfclevel primary key (personID, chemID)
);


CREATE table tbWellSample (
        sampleID        number(11,0)            not null
            constraint pk_wellsample primary key,
        wellID          number(11,0)            not null
            constraint  fk_wellID_tbWellSample references tbWell (wellID),
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbWellSample references tbChemical (chemID),
        sampleDate      date                    not null,
        pfcLevel        number(3,3)             not null
);


CREATE table tbAddress (
        addressID        number(11,0)            not null
            constraint pk_address primary key,
        personID         number(11,0)            not null
            constraint  fk_personID_tbAddress references tbPerson (personID),
        address          varchar(45)             not null
);


-- ******************************************************
--    CREATE SEQUENCES
-- ******************************************************
CREATE sequence seq_person
    increment by 1
    start with 1;

CREATE sequence seq_chemical
    increment by 1
    start with 1;

CREATE sequence seq_well
    increment by 1
    start with 1;

CREATE sequence seq_sample
    increment by 1
    start with 1;

CREATE sequence seq_study
    increment by 1
    start with 1;


-- ******************************************************
--    POPULATE TABLES
-- ******************************************************

/* chemical table */
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFOA', 'Perfluorooctanoic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFOS', 'Perfluorooctanesulfonic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFHxS', 'Perfluorohexanesulphonic acid', 1.1);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFUA', 'Perfluoroundecanoic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFOSA', 'Perfluorooctane sulfonamide', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFNA', 'Perfluorononanoic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFDeA', 'Perfluorodecanoic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'PFOS', 'Perfluorooctanesulfonic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'Me-PFOSA-AcOH2', '2-(N-methyl-perfluorooctane sulfonamido) aetic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'Et-PFOSA-AcOH', '2-(N-ethyl-perfluorooctane sulfonamido) aetic acid', .09);

/* study table */
INSERT into tbStudy VALUES (seq_study.nextval, 'NHANES', '01-OCT-2015', '01-OCT-2015', 100);

/* well table */
INSERT into tbWell VALUES (seq_well.nextval, 'Haven', '43.076018, -70.818631', 'N');
INSERT into tbWell VALUES (seq_well.nextval, 'Smith', '43.061068, -70.804976', 'Y');
INSERT into tbWell VALUES (seq_well.nextval, 'Harrison', '43.065879, -70.804495', 'Y');

/* person table */
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0576', 40, 13, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0577', 4, 2, 'F');

/* person PFC level table */
INSERT INTO tbPersonPFCLevel VALUES (1, 1, 2.6);
INSERT INTO tbPersonPFCLevel VALUES (1, 2, 12.7);
INSERT INTO tbPersonPFCLevel VALUES (1, 3, 6.5);
INSERT INTO tbPersonPFCLevel VALUES (1, 4, 0);
INSERT INTO tbPersonPFCLevel VALUES (1, 5, 0);
INSERT INTO tbPersonPFCLevel VALUES (1, 6, .9);
INSERT INTO tbPersonPFCLevel VALUES (1, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (1, 8, .2);
INSERT INTO tbPersonPFCLevel VALUES (1, 9, 0);
INSERT INTO tbPersonPFCLevel VALUES (2, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (2, 2, 10.5);
INSERT INTO tbPersonPFCLevel VALUES (2, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (2, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (2, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (2, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (2, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (2, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (2, 9, .1);
