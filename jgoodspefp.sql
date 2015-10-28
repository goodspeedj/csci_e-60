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
INSERT into tbChemical values (seq_chemical.nextval, 'PFOS', 'Perfluorooctanesulfonic acid', .09);
INSERT into tbChemical values (seq_chemical.nextval, 'PFHxS', 'Perfluorohexanesulphonic acid', 1.1);

/* study table */
INSERT into tbStudy values (seq_study.nextval, 'NHANES', '01-OCT-2015', '01-OCT-2015', 100);

/* well table */
INSERT into tbWell values (seq_well.nextval, 'Haven', '43.082087, -70.812584', 'N');
INSERT into tbWell values (seq_well.nextval, 'Smith', '43.082087, -70.812584', 'Y');
INSERT into tbWell values (seq_well.nextval, 'Harrison', '43.082087, -70.812584', 'Y');

/* person table */
INSERT INTO tbPerson values (seq_person.nextval, '123-p', 40, 13, 'M');
INSERT INTO tbPerson values (seq_person.nextval, '123-p', 4, 2, 'F');