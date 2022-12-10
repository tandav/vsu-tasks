-- SUBJECTS -------------------------------------------------
DROP table SUBJECTS;
CREATE TABLE SUBJECTS (
  id   NUMBER        NOT NULL PRIMARY KEY,
  name VARCHAR2 (100) NOT NULL
);

DROP SEQUENCE SUBJECTS_seq;
CREATE SEQUENCE SUBJECTS_seq START WITH 1;
CREATE OR REPLACE TRIGGER SUBJECTS_id_autoincrement
  BEFORE INSERT ON SUBJECTS
  FOR EACH ROW
  BEGIN
    SELECT SUBJECTS_seq.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

INSERT INTO subjects (name) VALUES ('Continuous mathematics');
INSERT INTO subjects (name) VALUES ('Probability');
INSERT INTO subjects (name) VALUES ('Algorithms');
INSERT INTO subjects (name) VALUES ('Logic and proof');
INSERT INTO subjects (name) VALUES ('Computational complexity');
INSERT INTO subjects (name) VALUES ('Machine learning');
INSERT INTO subjects (name) VALUES ('Advanced security');
INSERT INTO subjects (name) VALUES ('Quantum computer science');
INSERT INTO subjects (name) VALUES ('Planet Earth');
INSERT INTO subjects (name) VALUES ('Local field courses');
INSERT INTO subjects (name) VALUES ('Earth deformation and materials');
INSERT INTO subjects (name) VALUES ('Assynt field course (mapping)');
INSERT INTO subjects (name) VALUES ('Natural resources');
INSERT INTO subjects (name) VALUES ('Earth materials, rock deformation and metamorphism');
INSERT INTO subjects (name) VALUES ('Anatomy of a mountain belt');
INSERT INTO subjects (name) VALUES ('Topics in volcanology');
INSERT INTO subjects (name) VALUES ('Algebra I');
INSERT INTO subjects (name) VALUES ('Multivariate calculus and mathematical models');
INSERT INTO subjects (name) VALUES ('Algebra II');
INSERT INTO subjects (name) VALUES ('Differential equations');
INSERT INTO subjects (name) VALUES ('Number theory');
INSERT INTO subjects (name) VALUES ('Topology');
INSERT INTO subjects (name) VALUES ('Fluid dynamics');
INSERT INTO subjects (name) VALUES ('Quantum theory');
INSERT INTO subjects (name) VALUES ('Classical mechanics and special relativity');
INSERT INTO subjects (name) VALUES ('Quantum ideas');
INSERT INTO subjects (name) VALUES ('Thermal physics');
INSERT INTO subjects (name) VALUES ('Introduction to biological physics');
INSERT INTO subjects (name) VALUES ('Flows, fluctuations and complexity');
INSERT INTO subjects (name) VALUES ('Plasma physics');
INSERT INTO subjects (name) VALUES ('Astrophysics');
INSERT INTO subjects (name) VALUES ('Biological physics');
COMMIT;