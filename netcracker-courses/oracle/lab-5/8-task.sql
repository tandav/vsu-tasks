SELECT * FROM STUDENTS;

CREATE OR REPLACE FUNCTION currentSemester(enroll_date IN DATE)
  RETURN number IS
  semesters number := 0;
  BEGIN
    SELECT CASE
            WHEN EXTRACT(MONTH FROM SYSDATE) < 9
             THEN 0 + 2 * (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM enroll_date))
            WHEN EXTRACT(MONTH FROM SYSDATE) >= 9
             THEN 1 + 2 * (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM enroll_date))
           END into semesters
    FROM dual;

    RETURN semesters;
  END;


select currentSemester(to_date('01-09-2015')) from dual;

CREATE OR REPLACE VIEW LOOSERS AS
  SELECT  S.ID AS STUDENT_ID,
          S.FIRST_NAME,
          S.LAST_NAME,
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM S.ENROLL_YEAR) as course,
          currentSemester(S.ENROLL_YEAR) as semester,
          M.SUBJECT_ID,
          SUB.NAME,
          M.MARK
    FROM MARKS M
      INNER JOIN STUDENTS S ON M.STUDENT_ID = S.ID
      INNER JOIN SUBJECTS SUB ON M.SUBJECT_ID = SUB.ID
    WHERE M.MARK = 2 OR M.MARK IS NULL;

SELECT * FROM LOOSERS;

SELECT  S.ID,
        S.FIRST_NAME,
        S.LAST_NAME,
        F.FAILS
  FROM STUDENTS S
    INNER JOIN (
      SELECT STUDENT_ID, COUNT(1) AS FAILS
      FROM LOOSERS
      GROUP BY STUDENT_ID
   ) F ON S.ID = F.STUDENT_ID
  WHERE F.FAILS >= 4;


















--------------------------------------------------------------------------------------------
-- SELECT  id,
--         FIRST_NAME,
--         LAST_NAME,
--         ENROLL_YEAR,
--         EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM ENROLL_YEAR) as course,
--         currentSemester(ENROLL_YEAR) as current_Semester
--   FROM STUDENTS;