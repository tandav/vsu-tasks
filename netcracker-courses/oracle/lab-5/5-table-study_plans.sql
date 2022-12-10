-- STUDY_PLANS -------------------------------------------------
DROP table STUDY_PLANS;
CREATE TABLE STUDY_PLANS (
  id                NUMBER NOT NULL PRIMARY KEY          ,
  specialisation_id NUMBER REFERENCES SPECIALISATIONS(id),
  semester          NUMBER                               ,
  subject_id        NUMBER REFERENCES SUBJECTS(id)       ,
  report_id         NUMBER REFERENCES REPORTS(id)
);



DROP SEQUENCE STUDY_PLANS_seq;
CREATE SEQUENCE STUDY_PLANS_seq START WITH 1;
CREATE OR REPLACE TRIGGER sp_autoincrement
  BEFORE INSERT ON STUDY_PLANS
  FOR EACH ROW
  BEGIN
    SELECT STUDY_PLANS_seq.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

-- Computer Science
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 1, 1, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 1, 2, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 2, 3, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 2, 4, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 3, 5, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 3, 6, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 4, 7, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (1, 4, 8, 2);

-- Geology
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 1, 9, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 1, 10, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 2, 11, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 2, 12, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 3, 13, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 3, 14, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 4, 15, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (2, 4, 16, 1);

-- Mathematics
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 1, 17, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 1, 18, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 2, 19, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 2, 20, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 3, 21, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 3, 22, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 4, 23, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (3, 4, 24, 1);

-- Physics
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 1, 25, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 1, 26, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 2, 27, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 2, 28, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 3, 29, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 3, 30, 1);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 4, 31, 2);
INSERT INTO STUDY_PLANS (specialisation_id, semester, subject_id, report_id) VALUES (4, 4, 32, 1);

COMMIT;