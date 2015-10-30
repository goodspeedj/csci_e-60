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
DROP table tbExposureType purge;

-- ******************************************************
--    DROP SEQUENCES
-- ******************************************************
DROP sequence seq_address;
DROP sequence seq_person;
DROP sequence seq_chemical;
DROP sequence seq_well;
DROP sequence seq_sample;
DROP sequence seq_study;
DROP sequence seq_exposure;

-- ******************************************************
--    CREATE TABLES
-- ******************************************************


CREATE table tbChemical (
        chemID          number(11,0)            not null
            constraint pk_chemical primary key,
        shortName       varchar2(15)            not null,
        longName        varchar2(60)            not null,
        epaPHALevel     number(6,3)             not null
);


CREATE table tbExposureType (
        exposureID        number(11,0)            not null
            constraint pk_exposureType primary key,
        type              varchar(45)             not null
);


CREATE table tbStudy (
        studyID         number(11,0)            not null
            constraint pk_study primary key,
        name            varchar2(30)            not null,
        startDate       date                    not null,
        endDate         date                    not null,
        participants    number(11,0)            not null,
        exposureID      number(11,0)            not null
            constraint fk_exposureID_tbStudy references tbExposureType (exposureID)
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
        pfcMin          number(6,3)             null,
        pfcMax          number(6,3)             null,
        pfcMean         number(6,3)             null,
        pfcMedian       number(6,3)             null,
            constraint  pk_studypfclevel primary key (studyID, chemID)
);


CREATE table tbPersonPFCLevel (
        personID        number(11,0)            not null
            constraint  fk_personID_tbPersonPFCLevel references tbPerson (personID),
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbPersonPFCLevel references tbChemical (chemID),
        pfcLevel        number(6,3)             not null,
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
        pfcLevel        number(6,3)             null
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
CREATE sequence seq_address
    increment by 1
    start with 1;


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

CREATE sequence seq_exposure
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
INSERT into tbChemical VALUES (seq_chemical.nextval, 'Me-PFOSA-AcOH2', '2-(N-methyl-perfluorooctane sulfonamido) acetic acid', .09);
INSERT into tbChemical VALUES (seq_chemical.nextval, 'Et-PFOSA-AcOH', '2-(N-ethyl-perfluorooctane sulfonamido) acetic acid', .09);

/* exposure type table */
INSERT INTO tbExposureType VALUES (seq_exposure.nextval, 'Occupational');
INSERT INTO tbExposureType VALUES (seq_exposure.nextval, 'Environmental');
INSERT INTO tbExposureType VALUES (seq_exposure.nextval, 'General Population');

/* study table */
INSERT into tbStudy VALUES (seq_study.nextval, '3M Workers (PFOS and PFOA)', '01-JAN-2000', '31-DEC-2000', 263, 1);
INSERT into tbStudy VALUES (seq_study.nextval, '3M Workers (PFHxS)', '01-JAN-2004', '31-DEC-2004', 26, 1);
INSERT into tbStudy VALUES (seq_study.nextval, 'Dupont Workers', '01-JAN-2004', '31-DEC-2004', 1025, 1);
INSERT into tbStudy VALUES (seq_study.nextval, 'Ohio River Valley', '01-JAN-2005', '31-DEC-2006', 69030, 2);
INSERT into tbStudy VALUES (seq_study.nextval, 'Decatur, Alabama', '01-JAN-2009', '31-DEC-2009', 153, 2);
INSERT into tbStudy VALUES (seq_study.nextval, 'East Metro Minnesota Pilot', '01-JAN-2008', '31-DEC-2009', 196, 2);
INSERT into tbStudy VALUES (seq_study.nextval, 'Red Cross donors', '01-JAN-2006', '31-DEC-2006', 600, 3);
INSERT into tbStudy VALUES (seq_study.nextval, 'NHANES 1', '01-JAN-2005', '31-DEC-2006', 2120, 3);
INSERT into tbStudy VALUES (seq_study.nextval, 'NHANES 2', '01-JAN-2011', '31-DEC-2012', 1904, 3);
INSERT into tbStudy VALUES (seq_study.nextval, 'Schecter', '01-JAN-2009', '31-DEC-2009', 300, 3);

/* well table */
INSERT into tbWell VALUES (seq_well.nextval, 'Haven', '43.076018, -70.818631', 'N');
INSERT into tbWell VALUES (seq_well.nextval, 'Smith', '43.061068, -70.804976', 'Y');
INSERT into tbWell VALUES (seq_well.nextval, 'Harrison', '43.065879, -70.804495', 'Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 'WWTP Distribution','43.083631, -70.795990','Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 'DES Office Distribution', '43.074757, -70.802534', 'Y');

/* person table */
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0576', 40, 13, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0577', 4, 2, 'F');

/* address table */
INSERT INTO tbAddress VALUES (seq_address.nextval, 1, '325 Corporate Drive');
INSERT INTO tbAddress VALUES (seq_address.nextval, 2, '81 New Hampshire Avenue');

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

/* study level table */
INSERT INTO tbStudyPFCLevel VALUES (9, 1, 0, 43, 2.1, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 2, .1, 235, 6.3, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 3, 0, 47.8, 1.3, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 4, 0, 7, null, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 5, 0, .6, null, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 6, 0, 80.8, .9, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 7, 0, 17.8, .2, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 8, 0, 4.3, null, null);
INSERT INTO tbStudyPFCLevel VALUES (9, 9, 0, .7, null, null);
INSERT INTO tbStudyPFCLevel VALUES (10, 1, 0, 13.5, null, 2.9);
INSERT INTO tbStudyPFCLevel VALUES (10, 2, .1, 93.3, null, 4.1);
INSERT INTO tbStudyPFCLevel VALUES (10, 3, 0, 31.2, null, 1.2);
INSERT INTO tbStudyPFCLevel VALUES (10, 4, null, null, null, null);
INSERT INTO tbStudyPFCLevel VALUES (10, 5, 0, .6, null, 0);
INSERT INTO tbStudyPFCLevel VALUES (10, 6, 0, 55.8, null, 1.2);
INSERT INTO tbStudyPFCLevel VALUES (10, 7, .1, 2.1, null, .1);
INSERT INTO tbStudyPFCLevel VALUES (10, 8, .1, 28.9, null, .1);
INSERT INTO tbStudyPFCLevel VALUES (10, 9, .1, .7, null, .1);

/* well sample table */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 1, '16-APR-2014', .35);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 2, '16-APR-2014', 2.5);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 3, '16-APR-2014', .83);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 4, '16-APR-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 5, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 6, '16-APR-2014', .017);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 7, '16-APR-2014', .0049);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 8, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 9, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-APR-2014', .0035);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-APR-2014', .018);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-APR-2014', .013);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 4, '16-APR-2014', .017);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-APR-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 7, '16-APR-2014', .0044);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '16-APR-2014', .009);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '16-APR-2014', .048);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '16-APR-2014', .036);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 4, '16-APR-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '16-APR-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 7, '16-APR-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '16-APR-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '16-APR-2014', null);

INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 1, '14-MAY-2014', .32);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 2, '14-MAY-2014', 2.4);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 3, '14-MAY-2014', .96);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 4, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 5, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 6, '14-MAY-2014', .017);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 7, '14-MAY-2014', .0043);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 8, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 9, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '14-MAY-2014', .0036);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '14-MAY-2014', .015);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '14-MAY-2014', .013);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 4, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 7, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '14-MAY-2014', .0086);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '14-MAY-2014', .041);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '14-MAY-2014', .032);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 4, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 7, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '14-MAY-2014', null);

INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 1, '14-MAY-2014', .32);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 2, '14-MAY-2014', 2.4);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 3, '14-MAY-2014', .96);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 4, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 5, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 6, '14-MAY-2014', .017);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 7, '14-MAY-2014', .0043);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 8, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 9, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '14-MAY-2014', .0036);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '14-MAY-2014', .015);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '14-MAY-2014', .013);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 4, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 7, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '14-MAY-2014', .0086);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '14-MAY-2014', .041);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '14-MAY-2014', .032);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 4, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 7, '14-MAY-2014', 0);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '14-MAY-2014', null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '14-MAY-2014', null);