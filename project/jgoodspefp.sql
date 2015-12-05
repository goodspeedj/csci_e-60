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
DROP table tbWellType;
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
DROP sequence seq_welltype;
DROP sequence seq_sample;
DROP sequence seq_study;
DROP sequence seq_exposure;
DROP sequence seq_samplenote;
DROP sequence seq_studypfclevel;

-- ******************************************************
--    CREATE TABLES
-- ******************************************************


CREATE table tbChemical (
        chemID          number(11,0)            not null
            constraint pk_chemical primary key,
        shortName       varchar2(15)            not null,
        longName        varchar2(60)            not null,
        epaPHALevel     number(6,3)             null
            constraint  rg_epaPHALevel check (epaPHALevel >= 0)
);


CREATE table tbExposureType (
        exposureID        number(11,0)          not null
            constraint pk_exposureType primary key,
        exposureType      varchar(45)           not null
);


CREATE table tbStudy (
        studyID         number(11,0)            not null
            constraint pk_study primary key,
        studyName            varchar2(30)       not null,
        studyStartDate       date               not null,
        studyEndDate         date               not null,
        participants    number(11,0)            not null
            constraint  rg_participants check (participants >= 0),
        exposureID      number(11,0)            not null
            constraint fk_exposureID_tbStudy references tbExposureType (exposureID) on delete set null
);


CREATE table tbWellType (
        wellTypeID      number(11,0)            not null
            constraint pk_welltype primary key,
        wellType        varchar2(20)            not null
);


CREATE table tbWell (
        wellID          number(11,0)            not null
            constraint pk_well primary key,
        wellTypeID      number(11,0)            not null
            constraint  fk_wellTypeID_tbWell references tbWellType (wellTypeID) on delete set null,
        wellName        varchar2(30)            not null,
        wellLat         number(10,8)            not null,
        wellLong        number(10,8)            not null,
        wellYeild       number(4,0)             null
            constraint  rg_wellyeild check (wellYeild >= 0),
        wellActive      char(1)                 not null
            constraint  rg_active check (REGEXP_LIKE(wellActive, '^Y|N$'))
);


CREATE table tbPerson (
        personID        number(11,0)            not null
            constraint pk_person primary key,
        nhHHSID         varchar2(10)            not null,
        age             number(3,0)             not null
            constraint  rg_age check (age >= 0),
        yearsExposed    number(2,0)             not null
            constraint  rg_yearsExposed check (yearsExposed >= 0),
        sex             char(1)                 not null,
            constraint  rg_sex check (REGEXP_LIKE(sex, '^M|F$'))
);


CREATE table tbStudyPFCLevel (
	    studyPfcLevelID number(11,0)            not null
	        constraint pk_studypfclevel primary key,
        studyID         number(11,0)            not null
            constraint  fk_studyID_tbStudyPFCLevel references tbStudy (studyID) on delete cascade,
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbStudyPFCLevel references tbChemical (chemID) on delete set null,
        pfcMin          number(10,3)            null
            constraint  rg_pfcMin check (pfcMin >= 0),
        pfcMax          number(10,3)            null
            constraint  rg_pfcMax check (pfcMax >= 0),
        pfcMean         number(10,3)            null
            constraint  rg_pfcMean check (pfcMean >= 0),
        pfcGeoMean      number(10,3)            null
            constraint  rg_pfcGeoMean check (pfcGeoMean >= 0),
        pfcMedian       number(10,3)            null
            constraint  rg_pfcMedian check (pfcMedian >= 0),
        ageRange        varchar2(20)            null, 
        adult           char(1)                 not null,
            constraint  rg_adult check (REGEXP_LIKE(adult, '^Y|N$'))
);


CREATE table tbPersonPFCLevel (
        personID        number(11,0)            not null
            constraint  fk_personID_tbPersonPFCLevel references tbPerson (personID) on delete cascade,
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbPersonPFCLevel references tbChemical (chemID) on delete set null,
        pfcLevel        number(6,3)             not null
            constraint  rg_personpfclevel check (pfcLevel >= 0),
            constraint  pk_personpfclevel primary key (personID, chemID)
);


CREATE table tbSampleNote (
        noteID          number(11,0)            not null
            constraint pk_samplenote primary key,
        noteAbr         char(1)                 not null,
        noteDescr       varchar2(40)            not null
);


CREATE table tbWellSample (
        sampleID        number(11,0)            not null
            constraint pk_wellsample primary key,
        wellID          number(11,0)            not null
            constraint  fk_wellID_tbWellSample references tbWell (wellID) on delete cascade,
        chemID          number(11,0)            not null
            constraint  fk_chemID_tbWellSample references tbChemical (chemID) on delete set null,
        sampleDate      date                    not null,
        pfcLevel        number(6,3)             null
            constraint  rg_wellpfclevel check (pfcLevel >= 0),
        noteID		    number(11,0)            null
            constraint  fk_noteID_tbWellSample references tbSampleNote (noteID) on delete set null
);


CREATE table tbAddress (
        addressID        number(11,0)           not null
            constraint pk_address primary key,
        personID         number(11,0)           not null
            constraint  fk_personID_tbAddress references tbPerson (personID) on delete cascade,
        address          varchar(45)            not null
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

CREATE sequence seq_welltype
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

CREATE sequence seq_studypfclevel
    increment by 1
    start with 1;


-- ******************************************************
--    POPULATE TABLES
-- ******************************************************

/* chemical table */
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFOA', 'Perfluorooctanoic acid', .4);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFOS', 'Perfluorooctanesulfonic acid', .2);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFHxS', 'Perfluorohexanesulphonic acid', null);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFUA', 'Perfluoroundecanoic acid', null);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFOSA', 'Perfluorooctane sulfonamide', null);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFNA', 'Perfluorononanoic acid', null);
INSERT INTO tbChemical VALUES (seq_chemical.nextval, 'PFDeA', 'Perfluorodecanoic acid', null);
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
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Ohio River Valley - C8', '01-JAN-2005', '31-DEC-2006', 69030, 2);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Decatur, Alabama', '01-JAN-2009', '31-DEC-2009', 153, 2);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'East Metro Minnesota Pilot', '01-JAN-2008', '31-DEC-2009', 196, 2);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Red Cross donors', '01-JAN-2006', '31-DEC-2006', 600, 3);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'NHANES 1', '01-JAN-2003', '31-DEC-2004', 2094, 3);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'NHANES 2', '01-JAN-2011', '31-DEC-2012', 1904, 3);
INSERT INTO tbStudy VALUES (seq_study.nextval, 'Schecter', '01-JAN-2009', '31-DEC-2009', 300, 3);

/* Well Type table */
INSERT INTO tbWellType VALUES (seq_welltype.nextval, 'Well');
INSERT INTO tbWellType VALUES (seq_welltype.nextval, 'Distribution Point');

/* well table */
INSERT INTO tbWell VALUES (seq_well.nextval, 1, 'Haven', 43.076018, -70.818631, 699, 'N');
INSERT INTO tbWell VALUES (seq_well.nextval, 1, 'Smith', 43.061068, -70.804976, 447, 'Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 1, 'Harrison', 43.065879, -70.804495, 331, 'Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 2, 'WWTP Distribution',43.083631, -70.795990, null, 'Y');
INSERT INTO tbWell VALUES (seq_well.nextval, 2, 'DES Office Distribution', 43.074757, -70.802534, null, 'Y');

/* sample note table */
INSERT INTO tbSampleNote VALUES (seq_samplenote.nextval, 'J', 'The result is an estimated value');
INSERT INTO tbSampleNote VALUES (seq_samplenote.nextval, 'B', 'Detected in Blank');
INSERT INTO tbSampleNote VALUES (seq_samplenote.nextval, 'D', 'duplicate sample');

/* person table */
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0576', 40, 13, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0577', 4, 2, 'F');

/* fake data */
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0001', 4, 3, 'F');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0002', 3, 1, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0003', 1, 1, 'F');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0004', 4, 2, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0005', 42, 2, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0006', 23, 5, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0007', 33, 4, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0008', 29, 10, 'M');
INSERT INTO tbPerson VALUES (seq_person.nextval, 'PT0009', 56, 3, 'M');

/* address table */
INSERT INTO tbAddress VALUES (seq_address.nextval, 1, '325 Corporate Drive Portsmouth, NH  03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 2, '81 New Hampshire Avenue Portsmouth, NH 03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 3, '81 New Hampshire Avenue Portsmouth, NH 03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 4, '30 Rye Streed Portsmouth, NH 03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 5, '30 Rye Street Portsmouth, NH 03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 6, '81 New Hampshire Avenue Portsmouth, NH 03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 7, '325 Corporate Drive Portsmouth, NH  03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 8, '325 Corporate Drive Portsmouth, NH  03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 9, '101 International Drive Portsmouth, NH  03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 10, '101 International Drive Portsmouth, NH  03801');
INSERT INTO tbAddress VALUES (seq_address.nextval, 11, '161 Corporate Drive Portsmouth, NH  03801');
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

/* fake data */
INSERT INTO tbPersonPFCLevel VALUES (3, 1, 9.2);
INSERT INTO tbPersonPFCLevel VALUES (3, 2, 23.5);
INSERT INTO tbPersonPFCLevel VALUES (3, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (3, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (3, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (3, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (3, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (3, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (3, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (4, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (4, 2, 17.5);
INSERT INTO tbPersonPFCLevel VALUES (4, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (4, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (4, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (4, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (4, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (4, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (4, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (5, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (5, 2, 4.5);
INSERT INTO tbPersonPFCLevel VALUES (5, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (5, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (5, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (5, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (5, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (5, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (5, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (6, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (6, 2, 13.5);
INSERT INTO tbPersonPFCLevel VALUES (6, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (6, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (6, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (6, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (6, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (6, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (6, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (7, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (7, 2, 16.5);
INSERT INTO tbPersonPFCLevel VALUES (7, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (7, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (7, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (7, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (7, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (7, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (7, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (8, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (8, 2, 6.5);
INSERT INTO tbPersonPFCLevel VALUES (8, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (8, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (8, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (8, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (8, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (8, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (8, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (9, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (9, 2, 14.5);
INSERT INTO tbPersonPFCLevel VALUES (9, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (9, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (9, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (9, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (9, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (9, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (9, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (10, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (10, 2, 3.5);
INSERT INTO tbPersonPFCLevel VALUES (10, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (10, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (10, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (10, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (10, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (10, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (10, 9, .1);
INSERT INTO tbPersonPFCLevel VALUES (11, 1, 7.2);
INSERT INTO tbPersonPFCLevel VALUES (11, 2, 23.5);
INSERT INTO tbPersonPFCLevel VALUES (11, 3, 9.8);
INSERT INTO tbPersonPFCLevel VALUES (11, 4, .1);
INSERT INTO tbPersonPFCLevel VALUES (11, 5, .1);
INSERT INTO tbPersonPFCLevel VALUES (11, 6, 2);
INSERT INTO tbPersonPFCLevel VALUES (11, 7, .2);
INSERT INTO tbPersonPFCLevel VALUES (11, 8, .6);
INSERT INTO tbPersonPFCLevel VALUES (11, 9, .1);

/* study level table */
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 1, 1, 40, 12700, 1780, 1130, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 1, 2, 60, 10060, 1320, 910, null, null, 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 2, 1, 72, 5100, 691, null, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 2, 2, 145, 3490, 799, null, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 2, 3, 16, 1295, 290, null, null, null, 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 3, 1, .0094, 3.709, null, null, .2448, null, 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 1, null, null, 77.6, 32.6, 36.9, '< 12 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 2, null, null, 23.6, 20.7, 20.6, '< 12 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 6, null, null, 1.9, 1.6, 1.7, '< 12 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 9, null, null, 1, .7, .7, '< 12 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 1, null, null, 58.1, 21.8, 25.2, '20 - 39 years', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 2, null, null, 20.1, 18.1, 16.8, '20 - 39 years', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 6, null, null, 1.5, 1.4, 1.4, '20 - 39 years', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 4, 9, null, null, .9, .5, .6, '20 - 39 years', 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 5, 1, 2.2, 144, 23.31, 16.3, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 5, 2, 5.4, 472, 56.60, 39.8, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 5, 3, .6, 59.1, 9.04, 6.4, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 5, 5, .1, .1, null, null, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 5, 6, .3, 5.5, 1.86, 1.7, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 5, 7, .2, 2.5, null, .4, null, null, 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 6, 1, 1.6, 177, null, 15.4, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 6, 2, 3.2, 448, null, 35.9, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 6, 3, .32, 316, null, 8.4, null, null, 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 7, 1, null, null, null, 3.4, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 7, 2, null, null, null, 14.5, null, null, 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 7, 3, null, null, null, 1.5, null, null, 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 1, null, null, null, 3.89, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 1, null, null, null, 3.96, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 2, null, null, null, 19.3, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 2, null, null, null, 20.9, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 3, null, null, null, 2.44, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 3, null, null, null, 1.86, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 6, null, null, null, .852, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 8, 6, null, null, null, .984, null, '20 years and older', 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 1, null, null, null, 1.8, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 1, null, null, null, 2.12, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 2, null, null, null, 4.16, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 2, null, null, null, 6.71, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 3, null, null, null, 1.28, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 3, null, null, null, 1.28, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 4, null, null, null, .146, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 6, null, null, null, .741, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 6, null, null, null, .903, null, '20 years and older', 'Y');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 7, null, null, null, .146, null, '12 - 19 years', 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 9, 7, null, null, null, .209, null, '20 years and older', 'Y');

INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 1, 0, 13.5, null, null, 2.9, null, 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 2, .1, 93.3, null, null, 4.1, null, 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 3, 0, 31.2, null, null, 1.2, null, 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 5, 0, .6, null, null, 0, null, 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 6, 0, 55.8, null, null, 1.2, null, 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 7, .1, 2.1, null, null, .1, null, 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 8, .1, 28.9, null, null, .1, null, 'N');
INSERT INTO tbStudyPFCLevel VALUES (seq_studypfclevel.nextval, 10, 9, .1, .7, null, null, .1, null, 'N');


/* well sample table */

/* PFOA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 1, '16-Apr-14', .35, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 1, '14-May-14', .32, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '16-Apr-14', .009, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '14-May-14', .0086, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '02-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '02-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '16-Jul-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '01-Oct-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '16-Oct-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '29-Oct-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '24-Nov-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '22-Dec-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '05-Jan-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '21-Jan-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '04-Feb-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '19-Feb-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '06-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '17-Mar-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '26-Mar-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 1, '11-Aug-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-Apr-14', .0035, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '14-May-14', .0036, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '24-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '01-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '08-Oct-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '22-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '06-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '19-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '04-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '30-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '05-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '13-Jan-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '26-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '04-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '19-Feb-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '25-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '06-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '11-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '17-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '26-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '02-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '30-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '15-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '27-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '12-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '24-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '08-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '21-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '05-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '11-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 1, '18-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '18-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 1, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 1, '16-Jun-15', 0, null);


/* PFOS */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 2, '16-Apr-14', 2.5, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 2, '14-May-14', 2.4, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Apr-14', .048, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '14-May-14', .041, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '18-Jun-14', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '25-Jun-14', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '02-Jul-14', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '02-Jul-14', 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '09-Jul-14', 0.02, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '16-Jul-14', 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '16-Jul-14', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '24-Jul-14', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '06-Aug-14', 0.02, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '21-Aug-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '04-Sep-14', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '17-Sep-14', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '01-Oct-14', 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '16-Oct-14', 0.035, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '29-Oct-14', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '12-Nov-14', 0.034, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '24-Nov-14', 0.038, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '12-Dec-14', 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '22-Dec-14', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '05-Jan-15', 0.038, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '21-Jan-15', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '04-Feb-15', 0.021, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '19-Feb-15', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '06-Mar-15', 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '17-Mar-15', 0.029, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '26-Mar-15', 0.028, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '09-Apr-15', 0.028, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '23-Apr-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '07-May-15', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '21-May-15', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '03-Jun-15', 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '16-Jun-15', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '30-Jun-15', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '16-Jul-15', 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '31-Jul-15', 0.028, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 2, '11-Aug-15', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Apr-14', .018, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '14-May-14', .015, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '18-Jun-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '25-Jun-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '02-Jul-14', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '09-Jul-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Jul-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '24-Jul-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '06-Aug-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '21-Aug-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '04-Sep-14', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '17-Sep-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '24-Sep-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '01-Oct-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '08-Oct-14', 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Oct-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '22-Oct-14', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '29-Oct-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '06-Nov-14', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '12-Nov-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '19-Nov-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '24-Nov-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '04-Dec-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '12-Dec-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Dec-14', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '22-Dec-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '30-Dec-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '05-Jan-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '13-Jan-15', 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '21-Jan-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '26-Jan-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '04-Feb-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '19-Feb-15', 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '25-Feb-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '06-Mar-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '11-Mar-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '17-Mar-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '26-Mar-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '02-Apr-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '09-Apr-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Apr-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '23-Apr-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '30-Apr-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '07-May-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '15-May-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '21-May-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '27-May-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '03-Jun-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '12-Jun-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Jun-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '24-Jun-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '30-Jun-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '08-Jul-15', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '16-Jul-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '21-Jul-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '31-Jul-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '05-Aug-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '11-Aug-15', 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 2, '18-Aug-15', 0.013, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '18-Jun-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '25-Jun-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '02-Jul-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '16-Jul-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '24-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '12-Dec-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '18-Mar-15', 0.016, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 2, '16-Jun-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '18-Jun-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '25-Jun-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '02-Jul-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '09-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '16-Jul-14', 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '24-Jul-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '12-Dec-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 2, '16-Jun-15', 0.010, 1);


/* PFHxS */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 3, '16-Apr-14', 0.83, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 3, '14-May-14', 0.96, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '16-Apr-14', 0.036, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '14-May-14', 0.032, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '18-Jun-14', 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '25-Jun-14', 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '02-Jul-14', 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '02-Jul-14', 0.02, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '09-Jul-14', 0.019, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '16-Jul-14', 0.028, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '16-Jul-14', 0.029, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '24-Jul-14', 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '06-Aug-14', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '21-Aug-14', 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '04-Sep-14', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '17-Sep-14', 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '01-Oct-14', 0.03, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '16-Oct-14', 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '29-Oct-14', 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '12-Nov-14', 0.029, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '24-Nov-14', 0.038, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '12-Dec-14', 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '22-Dec-14', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '05-Jan-15', 0.035, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '21-Jan-15', 0.031, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '04-Feb-15', 0.028, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '19-Feb-15', 0.024, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '06-Mar-15', 0.025, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '17-Mar-15', 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '26-Mar-15', 0.026, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '09-Apr-15', 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '23-Apr-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '07-May-15', 0.021, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '21-May-15', 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '03-Jun-15', 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '16-Jun-15', 0.022, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '30-Jun-15', 0.024, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '16-Jul-15', 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '31-Jul-15', 0.023, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 3, '11-Aug-15', 0.027, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-Apr-14', 0.013, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '14-May-14', 0.013, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '18-Jun-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '25-Jun-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '02-Jul-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '09-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '09-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-Jul-14', 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '24-Jul-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '06-Aug-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '21-Aug-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '04-Sep-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '17-Sep-14', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '24-Sep-14', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '01-Oct-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '08-Oct-14', 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-Oct-14', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '22-Oct-14', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '29-Oct-14', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '06-Nov-14', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '12-Nov-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '19-Nov-14', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '24-Nov-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '04-Dec-14', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '12-Dec-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-Dec-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '22-Dec-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '30-Dec-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '05-Jan-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '13-Jan-15', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '21-Jan-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '26-Jan-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '04-Feb-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '19-Feb-15', 0.013, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '25-Feb-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '06-Mar-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '11-Mar-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '17-Mar-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '26-Mar-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '02-Apr-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '09-Apr-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-Apr-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '23-Apr-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '30-Apr-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '07-May-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '15-May-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '21-May-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '27-May-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '03-Jun-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '12-Jun-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-Jun-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '24-Jun-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '30-Jun-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '08-Jul-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '16-Jul-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '21-Jul-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '31-Jul-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '05-Aug-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '11-Aug-15', 0.017, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 3, '18-Aug-15', 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '18-Jun-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '25-Jun-14', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '02-Jul-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '16-Jul-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '24-Jul-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '12-Dec-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '18-Mar-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 3, '16-Jun-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '18-Jun-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '25-Jun-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '02-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '09-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '16-Jul-14', 0.019, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '24-Jul-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '12-Dec-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 3, '16-Jun-15', 0.012, 1);

/* PFOSA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '01-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '16-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '05-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '04-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '19-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '06-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '17-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '26-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '23-Apr-15', 0.002, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 5, '11-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '02-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '24-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '01-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '08-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '16-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '22-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '06-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '19-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '04-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '16-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '30-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '05-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '13-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '26-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '04-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '19-Feb-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '25-Feb-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '06-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '11-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '17-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '26-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '02-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '16-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '23-Apr-15', 0.002, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '30-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '15-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '27-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '12-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '24-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '08-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '21-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '05-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '11-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 5, '18-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '18-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 5, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 5, '16-Jun-15', 0, null);

/* PFNA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 6, '16-Apr-14', 0.017, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 6, '14-May-14', 0.017, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '16-Apr-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '14-May-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '01-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '16-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '05-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '04-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '19-Feb-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '06-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '17-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '26-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 6, '11-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-Apr-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '14-May-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '24-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '01-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '08-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '22-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '06-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '19-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '04-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '30-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '05-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '13-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '26-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '04-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '19-Feb-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '25-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '06-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '11-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '17-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '26-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '02-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '30-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '15-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '27-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '12-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '24-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '08-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '21-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '05-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '11-Aug-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 6, '18-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '18-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 6, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 6, '16-Jun-15', 0, null);

/* PFPeA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '18-Jun-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '25-Jun-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '02-Jul-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '02-Jul-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '16-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '24-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '06-Aug-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '21-Aug-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '04-Sep-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '17-Sep-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '01-Oct-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '16-Oct-14', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '29-Oct-14', 0.015, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '12-Nov-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '24-Nov-14', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '12-Dec-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '22-Dec-14', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '05-Jan-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '21-Jan-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '04-Feb-15', 0.013, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '19-Feb-15', 0.014, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '06-Mar-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '17-Mar-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '26-Mar-15', 0.009, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '09-Apr-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '07-May-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '21-May-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '03-Jun-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '16-Jun-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '30-Jun-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '16-Jul-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '31-Jul-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 8, '11-Aug-15', 0.012, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '18-Jun-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '02-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '24-Sep-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '01-Oct-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '08-Oct-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '16-Oct-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '22-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '29-Oct-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '06-Nov-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '19-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '04-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '16-Dec-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '30-Dec-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '05-Jan-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '13-Jan-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '21-Jan-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '26-Jan-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '04-Feb-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '19-Feb-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '25-Feb-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '06-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '11-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '17-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '26-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '02-Apr-15', 0.005, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '16-Apr-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '30-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '07-May-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '15-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '27-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '03-Jun-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '12-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '24-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '30-Jun-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '08-Jul-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '21-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '05-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '11-Aug-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 8, '18-Aug-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '18-Jun-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '02-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '12-Dec-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '18-Mar-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 8, '16-Jun-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '18-Jun-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '02-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '12-Dec-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 8, '16-Jun-15', 0.004, 1);

/* PFHxA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 9, '16-Apr-14', 0.33, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 1, 9, '14-May-14', 0.35, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '16-Apr-14', 0.0087, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '14-May-14', 0.01, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '18-Jun-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '02-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '02-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '09-Jul-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '04-Sep-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '17-Sep-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '01-Oct-14', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '16-Oct-14', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '29-Oct-14', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '12-Nov-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '24-Nov-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '12-Dec-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '22-Dec-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '05-Jan-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '21-Jan-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '04-Feb-15', 0.010, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '19-Feb-15', 0.011, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '06-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '17-Mar-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '26-Mar-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '09-Apr-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '07-May-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '21-May-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '30-Jun-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '16-Jul-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '31-Jul-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 9, '11-Aug-15', 0.008, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-Apr-14', 0.0039, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '14-May-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '02-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '24-Sep-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '01-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '08-Oct-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-Oct-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '22-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '06-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '19-Nov-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '04-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '30-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '05-Jan-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '13-Jan-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '26-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '04-Feb-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '19-Feb-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '25-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '06-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '11-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '17-Mar-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '26-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '02-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '30-Apr-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '07-May-15', 0.002, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '15-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '27-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '12-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-Jun-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '24-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '08-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '21-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '05-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '11-Aug-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 9, '18-Aug-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '02-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '18-Mar-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 9, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '18-Jun-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '02-Jul-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '09-Jul-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 9, '16-Jun-15', 0, null);

/* PFBA */
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '18-Jun-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '02-Jul-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '02-Jul-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '09-Jul-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '04-Sep-14', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '01-Oct-14', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '16-Oct-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '12-Nov-14', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '24-Nov-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '22-Dec-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '05-Jan-15', 0.005, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '04-Feb-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '19-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '06-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '17-Mar-15', 0.004, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '26-Mar-15', 0.009, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '21-May-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '03-Jun-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '16-Jun-15', 0.005, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '30-Jun-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '16-Jul-15', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 3, 10, '11-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '02-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '06-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '21-Aug-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '04-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '17-Sep-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '24-Sep-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '01-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '08-Oct-14', 0.007, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '16-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '22-Oct-14', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '29-Oct-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '06-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '12-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '19-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '24-Nov-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '04-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '16-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '22-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '30-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '05-Jan-15', 0.005, 2);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '13-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '21-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '26-Jan-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '04-Feb-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '19-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '25-Feb-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '06-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '11-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '17-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '26-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '02-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '09-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '16-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '23-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '30-Apr-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '07-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '15-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '21-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '27-May-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '03-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '12-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '24-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '30-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '08-Jul-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '16-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '21-Jul-15', 0.003, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '31-Jul-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '05-Aug-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '11-Aug-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 2, 10, '18-Aug-15', 0.007, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '02-Jul-14', 0.006, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '18-Mar-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 4, 10, '16-Jun-15', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '18-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '25-Jun-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '02-Jul-14', 0.002, 1);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '09-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '16-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '24-Jul-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '12-Dec-14', 0, null);
INSERT INTO tbWellSample VALUES (seq_sample.nextval, 5, 10, '16-Jun-15', 0, null);


/* SELECT Statments on new tables */
SELECT * FROM tbChemical;
SELECT * FROM tbExposureType;
SELECT * FROM tbStudy;
SELECT * FROM tbWellType;
SELECT * FROM tbWell;
SELECT * FROM tbPerson;
SELECT * FROM tbAddress;
SELECT * FROM tbStudyPFCLevel WHERE ROWNUM <= 10;
SELECT * FROM tbPersonPFCLevel WHERE ROWNUM <= 10;
SELECT * FROM tbSampleNote;
SELECT * FROM tbWellSample WHERE ROWNUM <= 10;