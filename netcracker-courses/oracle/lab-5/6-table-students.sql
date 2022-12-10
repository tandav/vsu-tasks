-- STUDENTS -------------------------------------------------
DROP table STUDENTS;
CREATE TABLE STUDENTS (
  id NUMBER NOT NULL PRIMARY KEY,
  first_name VARCHAR2(20),
  last_name  VARCHAR2(20),
  specialisation_id NUMBER REFERENCES SPECIALISATIONS(id),
  enroll_year DATE
);


DROP SEQUENCE STUDENTS_seq;
CREATE SEQUENCE STUDENTS_seq START WITH 1;
CREATE OR REPLACE TRIGGER stud_autoincrement
  BEFORE INSERT ON STUDENTS
  FOR EACH ROW
  BEGIN
    SELECT STUDENTS_seq.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Natividad'  ,'Heidler'    , 4, to_date('01-09-2012', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Eilene'     ,'Tufts'      , 2, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Alena'      ,'Clarkson'   , 3, to_date('01-09-2011', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Breanne'    ,'Hatton'     , 2, to_date('01-09-2016', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Delila'     ,'Churchwell' , 2, to_date('01-09-2011', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Loren'      ,'Berthelot'  , 4, to_date('01-09-2014', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Adelaida'   ,'Laviolette' , 2, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Russ'       ,'Brittan'    , 2, to_date('01-09-2017', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Sabra'      ,'Sidener'    , 3, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Lorri'      ,'Debellis'   , 2, to_date('01-09-2011', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Lashaunda'  ,'Cheyne'     , 1, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Marni'      ,'Fritze'     , 2, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Edith'      ,'Cifuentes'  , 1, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Luetta'     ,'Midyett'    , 2, to_date('01-09-2012', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Valencia'   ,'Vandergrift', 2, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Jeneva'     ,'Husband'    , 1, to_date('01-09-2014', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Iva'        ,'Bonneau'    , 4, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Guillermina','Mcvicker'   , 2, to_date('01-09-2015', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Elwood'     ,'Couch'      , 1, to_date('01-09-2014', 'dd-mm-yyyy'));
INSERT INTO STUDENTS (first_name, last_name, specialisation_id, enroll_year) VALUES ('Janette'    ,'Demarest'   , 3, to_date('01-09-2015', 'dd-mm-yyyy'));

COMMIT;