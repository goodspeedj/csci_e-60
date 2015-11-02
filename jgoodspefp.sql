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
DROP table tbSampleNote purge;

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
DROP sequence seq_samplenote;

-- ******************************************************
--    CREATE TABLES
-- ******************************************************


CREATE table tbChemical (
        chemID          number(11,0)            not null
            constraint pk_chemical primary key,
        shortName       varchar2(15)            not null,
        longName        varchar2(60)            not null,
        epaPHALevel     number(6,3)             null
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


CREATE table tbSampleNote (
        noteID          number(11,0)            not null
            constraint pk_samplenote primary key,
        noteAbr         char(1)                 not null,
        noteDescr       varchar2(20)            not null
);


CREATE table tbWellSample (
        sampleID        number(11,0)            not null
            constraint pk_wellsample primary key,
        wellID          number(11,0)            not null
            constraint  fk_wellID_tbWellSample references tbWell (wellID),
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbWellSample references tbChemical (chemID),
        sampleDate      date                    not null,
        pfcLevel        number(6,3)             null,
        noteID		    number(11,0)            not null
            constraint  fk_noteID_tbWellSample references tbSampleNote (noteID)
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

CREATE sequence seq_samplenote
    increment by 1
    start with 1;


-- ******************************************************
--    POPULATE TABLES
-- ******************************************************

/* chemical table */
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFOA', 'Perfluorooctanoic acid', .4);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFOS', 'Perfluorooctanesulfonic acid', .2);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFHxS', 'Perfluorohexanesulphonic acid', 1.1);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFUA', 'Perfluoroundecanoic acid', .09);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFOSA', 'Perfluorooctane sulfonamide', .09);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFNA', 'Perfluorononanoic acid', .09);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFDeA', 'Perfluorodecanoic acid', .09);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFPeA', 'Perfluorotetradecanoic acid', null);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFHxA', 'Perfluorohexanoic acid', null);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFBA', 'Perfluorobutanoic acid', null);

/* exposure type table */
INSERT INTO tbExposureType VALUES (seq_exposure.nextval, 'Occupational');
INSERT INTO tbExposureType VALUES (seq_exposure.nextval, 'Environmental');
INSERT INTO tbExposureType VALUES (seq_exposure.nextval, 'General Population');

/* study table */
INSERT INTO tbStudy VALUES (seq_study.nextval, '3M Workers (PFOS and PFOA)', '01-JAN-2000', '31-DEC-2000', 263, 1);
INSERT INTO tbStudy VALUES (seq_study.nextval, '3M Workers (PFHxS)', '01-JAN-2004', '31-DEC-2004', 26, 1);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Dupont Workers', '01-JAN-2004', '31-DEC-2004', 1025, 1);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Ohio River Valley', '01-JAN-2005', '31-DEC-2006', 69030, 2);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Decatur, Alabama', '01-JAN-2009', '31-DEC-2009', 153, 2);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'East Metro Minnesota Pilot', '01-JAN-2008', '31-DEC-2009', 196, 2);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Red Cross donors', '01-JAN-2006', '31-DEC-2006', 600, 3);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'NHANES 1', '01-JAN-2005', '31-DEC-2006', 2120, 3);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'NHANES 2', '01-JAN-2011', '31-DEC-2012', 1904, 3);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Schecter', '01-JAN-2009', '31-DEC-2009', 300, 3);

/* well table */
INSERT INTO tbWell VALUES (seq_well.nextval, 'Haven', '43.076018, -70.818631', 'N');
INSERT INTO tbWell VALUES (seq_well.nextval, 'Smith', '43.061068, -70.804976', 'Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 'Harrison', '43.065879, -70.804495', 'Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 'WWTP Distribution','43.083631, -70.795990','Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 'DES Office Distribution', '43.074757, -70.802534', 'Y');

/* sample note table */
INSERT INTO tbSampleNote VALUES (seq_samplenote.nextval, 'J', 'The result is an estimated value');
INSERT INTO tbSampleNote VALUES (seq_samplenote.nextval, 'B', 'Detected in Blank');
INSERT INTO tbSampleNote VALUES (seq_samplenote.nextval, 'D', 'duplicate sample');

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

/* PFOA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 02-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 02-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 16-Jul-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 01-Oct-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 16-Oct-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 29-Oct-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 24-Nov-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 22-Dec-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 05-Jan-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 21-Jan-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 04-Feb-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 19-Feb-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 06-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 17-Mar-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 26-Mar-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, 11-Aug-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 24-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 01-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 08-Oct-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 16-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 22-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 06-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 19-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 04-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 16-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 30-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 05-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 13-Jan-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 26-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 04-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 19-Feb-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 25-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 06-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 11-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 17-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 26-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 02-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 16-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 30-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 15-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 27-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 12-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 24-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 08-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 21-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 05-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 11-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, 18-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 18-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, 16-Jun-15, 0, null);

/* PFOS */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 18-Jun-14, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 25-Jun-14, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 02-Jul-14, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 02-Jul-14, 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 09-Jul-14, 0.02, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 16-Jul-14, 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 16-Jul-14, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 24-Jul-14, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 06-Aug-14, 0.02, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 21-Aug-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 04-Sep-14, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 17-Sep-14, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 01-Oct-14, 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 16-Oct-14, 0.035, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 29-Oct-14, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 12-Nov-14, 0.034, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 24-Nov-14, 0.038, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 12-Dec-14, 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 22-Dec-14, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 05-Jan-15, 0.038, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 21-Jan-15, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 04-Feb-15, 0.021, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 19-Feb-15, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 06-Mar-15, 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 17-Mar-15, 0.029, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 26-Mar-15, 0.028, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 09-Apr-15, 0.028, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 23-Apr-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 07-May-15, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 21-May-15, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 03-Jun-15, 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 16-Jun-15, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 30-Jun-15, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 16-Jul-15, 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 31-Jul-15, 0.028, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, 11-Aug-15, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 18-Jun-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 25-Jun-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 02-Jul-14, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 09-Jul-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 16-Jul-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 24-Jul-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 06-Aug-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 21-Aug-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 04-Sep-14, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 17-Sep-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 24-Sep-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 01-Oct-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 08-Oct-14, 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 16-Oct-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 22-Oct-14, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 29-Oct-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 06-Nov-14, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 12-Nov-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 19-Nov-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 24-Nov-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 04-Dec-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 12-Dec-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 16-Dec-14, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 22-Dec-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 30-Dec-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 05-Jan-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 13-Jan-15, 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 21-Jan-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 26-Jan-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 04-Feb-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 19-Feb-15, 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 25-Feb-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 06-Mar-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 11-Mar-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 17-Mar-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 26-Mar-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 02-Apr-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 09-Apr-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 16-Apr-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 23-Apr-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 30-Apr-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 07-May-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 15-May-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 21-May-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 27-May-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 03-Jun-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 12-Jun-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 16-Jun-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 24-Jun-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 30-Jun-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 08-Jul-15, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 16-Jul-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 21-Jul-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 31-Jul-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 05-Aug-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 11-Aug-15, 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, 18-Aug-15, 0.013, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 18-Jun-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 25-Jun-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 02-Jul-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 16-Jul-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 24-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 12-Dec-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 18-Mar-15, 0.016, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, 16-Jun-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 18-Jun-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 25-Jun-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 02-Jul-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 09-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 16-Jul-14, 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 24-Jul-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 12-Dec-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, 16-Jun-15, 0.010, 1);

/* PFHxS */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 18-Jun-14, 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 25-Jun-14, 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 02-Jul-14, 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 02-Jul-14, 0.02, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 09-Jul-14, 0.019, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 16-Jul-14, 0.028, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 16-Jul-14, 0.029, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 24-Jul-14, 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 06-Aug-14, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 21-Aug-14, 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 04-Sep-14, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 17-Sep-14, 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 01-Oct-14, 0.03, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 16-Oct-14, 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 29-Oct-14, 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 12-Nov-14, 0.029, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 24-Nov-14, 0.038, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 12-Dec-14, 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 22-Dec-14, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 05-Jan-15, 0.035, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 21-Jan-15, 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 04-Feb-15, 0.028, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 19-Feb-15, 0.024, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 06-Mar-15, 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 17-Mar-15, 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 26-Mar-15, 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 09-Apr-15, 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 23-Apr-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 07-May-15, 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 21-May-15, 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 03-Jun-15, 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 16-Jun-15, 0.022, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 30-Jun-15, 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 16-Jul-15, 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 31-Jul-15, 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, 11-Aug-15, 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 18-Jun-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 25-Jun-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 02-Jul-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 09-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 09-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 16-Jul-14, 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 24-Jul-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 06-Aug-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 21-Aug-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 04-Sep-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 17-Sep-14, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 24-Sep-14, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 01-Oct-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 08-Oct-14, 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 16-Oct-14, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 22-Oct-14, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 29-Oct-14, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 06-Nov-14, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 12-Nov-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 19-Nov-14, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 24-Nov-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 04-Dec-14, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 12-Dec-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 16-Dec-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 22-Dec-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 30-Dec-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 05-Jan-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 13-Jan-15, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 21-Jan-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 26-Jan-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 04-Feb-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 19-Feb-15, 0.013, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 25-Feb-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 06-Mar-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 11-Mar-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 17-Mar-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 26-Mar-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 02-Apr-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 09-Apr-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 16-Apr-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 23-Apr-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 30-Apr-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 07-May-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 15-May-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 21-May-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 27-May-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 03-Jun-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 12-Jun-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 16-Jun-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 24-Jun-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 30-Jun-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 08-Jul-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 16-Jul-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 21-Jul-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 31-Jul-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 05-Aug-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 11-Aug-15, 0.017, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, 18-Aug-15, 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 18-Jun-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 25-Jun-14, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 02-Jul-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 16-Jul-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 24-Jul-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 12-Dec-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 18-Mar-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, 16-Jun-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 18-Jun-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 25-Jun-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 02-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 09-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 16-Jul-14, 0.019, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 24-Jul-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 12-Dec-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, 16-Jun-15, 0.012, 1);


/* PFOSA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 01-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 16-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 05-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 04-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 19-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 06-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 17-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 26-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 23-Apr-15, 0.002, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, 11-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 02-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 24-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 01-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 08-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 16-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 22-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 06-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 19-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 04-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 16-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 30-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 05-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 13-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 26-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 04-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 19-Feb-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 25-Feb-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 06-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 11-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 17-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 26-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 02-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 16-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 23-Apr-15, 0.002, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 30-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 15-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 27-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 12-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 24-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 08-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 21-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 05-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 11-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, 18-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 18-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, 16-Jun-15, 0, null);

/* PFNA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 01-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 16-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 05-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 04-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 19-Feb-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 06-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 17-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 26-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, 11-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 24-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 01-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 08-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 16-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 22-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 06-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 19-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 04-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 16-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 30-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 05-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 13-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 26-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 04-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 19-Feb-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 25-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 06-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 11-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 17-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 26-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 02-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 16-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 30-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 15-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 27-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 12-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 24-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 08-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 21-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 05-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 11-Aug-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, 18-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 18-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, 16-Jun-15, 0, null);

/* PFPeA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 18-Jun-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 25-Jun-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 02-Jul-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 02-Jul-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 16-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 24-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 06-Aug-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 21-Aug-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 04-Sep-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 17-Sep-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 01-Oct-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 16-Oct-14, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 29-Oct-14, 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 12-Nov-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 24-Nov-14, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 12-Dec-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 22-Dec-14, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 05-Jan-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 21-Jan-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 04-Feb-15, 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 19-Feb-15, 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 06-Mar-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 17-Mar-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 26-Mar-15, 0.009, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 09-Apr-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 07-May-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 21-May-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 03-Jun-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 16-Jun-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 30-Jun-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 16-Jul-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 31-Jul-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, 11-Aug-15, 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 18-Jun-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 02-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 24-Sep-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 01-Oct-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 08-Oct-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 16-Oct-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 22-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 29-Oct-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 06-Nov-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 19-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 04-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 16-Dec-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 30-Dec-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 05-Jan-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 13-Jan-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 21-Jan-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 26-Jan-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 04-Feb-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 19-Feb-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 25-Feb-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 06-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 11-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 17-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 26-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 02-Apr-15, 0.005, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 16-Apr-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 30-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 07-May-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 15-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 27-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 03-Jun-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 12-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 24-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 30-Jun-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 08-Jul-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 21-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 05-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 11-Aug-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, 18-Aug-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 18-Jun-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 02-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 12-Dec-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 18-Mar-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, 16-Jun-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 18-Jun-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 02-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 12-Dec-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, 16-Jun-15, 0.004, 1);

/* PFHxA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 18-Jun-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 02-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 02-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 09-Jul-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 04-Sep-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 17-Sep-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 01-Oct-14, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 16-Oct-14, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 29-Oct-14, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 12-Nov-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 24-Nov-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 12-Dec-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 22-Dec-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 05-Jan-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 21-Jan-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 04-Feb-15, 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 19-Feb-15, 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 06-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 17-Mar-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 26-Mar-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 09-Apr-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 07-May-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 21-May-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 30-Jun-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 16-Jul-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 31-Jul-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, 11-Aug-15, 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 02-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 24-Sep-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 01-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 08-Oct-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 16-Oct-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 22-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 06-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 19-Nov-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 04-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 16-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 30-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 05-Jan-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 13-Jan-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 26-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 04-Feb-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 19-Feb-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 25-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 06-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 11-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 17-Mar-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 26-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 02-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 16-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 30-Apr-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 07-May-15, 0.002, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 15-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 27-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 12-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 16-Jun-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 24-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 08-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 21-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 05-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 11-Aug-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, 18-Aug-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 02-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 18-Mar-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 18-Jun-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 02-Jul-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 09-Jul-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, 16-Jun-15, 0, null);

/* PFBA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 18-Jun-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 02-Jul-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 02-Jul-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 09-Jul-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 04-Sep-14, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 01-Oct-14, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 16-Oct-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 12-Nov-14, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 24-Nov-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 22-Dec-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 05-Jan-15, 0.005, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 04-Feb-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 19-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 06-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 17-Mar-15, 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 26-Mar-15, 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 21-May-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 03-Jun-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 16-Jun-15, 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 30-Jun-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 16-Jul-15, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, 11-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 02-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 06-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 21-Aug-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 04-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 17-Sep-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 24-Sep-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 01-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 08-Oct-14, 0.007, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 16-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 22-Oct-14, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 29-Oct-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 06-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 12-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 19-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 24-Nov-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 04-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 16-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 22-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 30-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 05-Jan-15, 0.005, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 13-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 21-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 26-Jan-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 04-Feb-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 19-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 25-Feb-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 06-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 11-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 17-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 26-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 02-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 09-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 16-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 23-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 30-Apr-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 07-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 15-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 21-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 27-May-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 03-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 12-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 24-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 30-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 08-Jul-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 16-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 21-Jul-15, 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 31-Jul-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 05-Aug-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 11-Aug-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, 18-Aug-15, 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 02-Jul-14, 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 18-Mar-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, 16-Jun-15, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 18-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 25-Jun-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 02-Jul-14, 0.002, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 09-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 16-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 24-Jul-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 12-Dec-14, 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, 16-Jun-15, 0, null);

