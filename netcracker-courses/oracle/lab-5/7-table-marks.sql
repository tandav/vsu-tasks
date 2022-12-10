-- MARKS -------------------------------------------------
DROP table MARKS;
CREATE TABLE MARKS (
  id NUMBER NOT NULL PRIMARY KEY,
  student_id NUMBER REFERENCES STUDENTS(id),
  subject_id NUMBER REFERENCES SUBJECTS(id),
  mark_date DATE,
  mark NUMBER
);


DROP SEQUENCE MARKS_seq;
CREATE SEQUENCE MARKS_seq START WITH 1;
CREATE OR REPLACE TRIGGER marks_autoincrement
  BEFORE INSERT ON MARKS
  FOR EACH ROW
  BEGIN
    SELECT MARKS_seq.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;


-- computer science students
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  1, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  2, to_date('17-12-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  3, to_date('27-05-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  4, to_date('01-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  5, to_date('01-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  6, to_date('01-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  7, to_date('01-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (1,  8, to_date('01-10-2015', 'dd-mm-yyyy'), 3);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  1, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  2, to_date('05-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  3, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  4, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  5, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  6, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  7, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (2,  8, to_date('17-10-2015', 'dd-mm-yyyy'), 5);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  1, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  2, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  3, to_date('12-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  4, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  5, to_date('23-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  6, to_date('23-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  7, to_date('23-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (3,  8, to_date('23-10-2015', 'dd-mm-yyyy'), null);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  1, to_date('11-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  2, to_date('25-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  3, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  4, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  5, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  6, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  7, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (4,  8, to_date('04-10-2015', 'dd-mm-yyyy'), 5);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  1, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  2, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  3, to_date('13-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  4, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  5, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  6, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  7, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (5,  8, to_date('17-10-2015', 'dd-mm-yyyy'), null);


-- geology students
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6,  9, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6, 10, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6, 11, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6, 12, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6, 13, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6, 14, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6, 15, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (6, 16, to_date('17-10-2015', 'dd-mm-yyyy'), 3);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7,  9, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7, 10, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7, 11, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7, 12, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7, 13, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7, 14, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7, 15, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (7, 16, to_date('17-10-2015', 'dd-mm-yyyy'), null);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8,  9, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8, 10, to_date('14-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8, 11, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8, 12, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8, 13, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8, 14, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8, 15, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (8, 16, to_date('17-10-2015', 'dd-mm-yyyy'), 5);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9,  9, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9, 10, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9, 11, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9, 12, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9, 13, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9, 14, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9, 15, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (9, 16, to_date('17-10-2015', 'dd-mm-yyyy'), 5);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10,  9, to_date('06-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10, 10, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10, 11, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10, 12, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10, 13, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10, 14, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10, 15, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (10, 16, to_date('17-10-2015', 'dd-mm-yyyy'), 5);

-- mathematics students
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 17, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 18, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 19, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 20, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 21, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 22, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 23, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (11, 24, to_date('17-10-2015', 'dd-mm-yyyy'), 5);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 17, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 18, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 19, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 20, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 21, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 22, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 23, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (12, 24, to_date('17-10-2015', 'dd-mm-yyyy'), 3);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 17, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 18, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 19, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 20, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 21, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 22, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 23, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (13, 24, to_date('17-10-2015', 'dd-mm-yyyy'), 4);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 17, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 18, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 19, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 20, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 21, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 22, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 23, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (14, 24, to_date('17-10-2015', 'dd-mm-yyyy'), 4);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 17, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 18, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 19, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 20, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 21, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 22, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 23, to_date('17-10-2015', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (15, 24, to_date('17-10-2015', 'dd-mm-yyyy'), 3);

-- physics
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 25, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 26, to_date('17-10-2015', 'dd-mm-yyyy'), 4);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 27, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 28, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 29, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 30, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 31, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (16, 32, to_date('17-10-2015', 'dd-mm-yyyy'), 2);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 25, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 26, to_date('12-12-2012', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 27, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 28, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 29, to_date('17-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 30, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 31, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (17, 32, to_date('17-10-2015', 'dd-mm-yyyy'), null);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 25, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 26, to_date('17-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 27, to_date('07-10-2015', 'dd-mm-yyyy'), 5);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 28, to_date('07-10-2015', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 29, to_date('07-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 30, to_date('07-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 31, to_date('07-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (18, 32, to_date('07-10-2015', 'dd-mm-yyyy'), 2);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 25, to_date('17-10-2015', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 26, to_date('17-10-2017', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 27, to_date('04-10-2017', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 28, to_date('04-10-2017', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 29, to_date('04-10-2017', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 30, to_date('04-10-2017', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 31, to_date('04-10-2017', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (19, 32, to_date('04-10-2017', 'dd-mm-yyyy'), 2);

INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 25, to_date('01-10-2011', 'dd-mm-yyyy'), 3);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 26, to_date('12-12-2012', 'dd-mm-yyyy'), null);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 27, to_date('13-10-2013', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 28, to_date('13-10-2013', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 29, to_date('13-10-2013', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 30, to_date('13-10-2013', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 31, to_date('13-10-2013', 'dd-mm-yyyy'), 2);
INSERT INTO MARKS (student_id, subject_id, mark_date, mark) VALUES (20, 32, to_date('13-10-2013', 'dd-mm-yyyy'), 2);

COMMIT;