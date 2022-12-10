-- task 1 DONE ------------------------------------------------------
SELECT  *
FROM DEPARTMENTS;


-- task 2 DONE ------------------------------------------------------
SELECT  c1.CUSTOMER_ID,
        c1.CUST_FIRST_NAME || ' ' || C1.CUST_LAST_NAME  AS NAME,
        c1.CUST_EMAIL
    FROM CUSTOMERS c1;


-- task 3 DONE ------------------------------------------------------
SELECT  e.LAST_NAME,
        e.FIRST_NAME,
        e.JOB_ID,
        e.EMAIL,
        e.PHONE_NUMBER,
        e.SALARY,
        CASE
          WHEN e.SALARY * 12 BETWEEN 100000 AND 150000 THEN e.SALARY * 0.3 -- typo in pdf, should be 0.7 (там выводится отчесление, а нужно вывести зарплату)
          WHEN e.SALARY * 12 > 150000 THEN e.SALARY * 0.35                 -- typo in pdf, should be 0.65 (там выводится отчесление, а нужно вывести зарплату)
        END AS SALARY
  FROM  EMPLOYEES e
  WHERE e.SALARY * 12 BETWEEN 100000 AND 200000
  ORDER BY e.JOB_ID;


-- task 4 DONE ------------------------------------------------------
SELECT  c.COUNTRY_ID AS "Код страны",
        c.COUNTRY_NAME AS "Название страны"
  FROM  COUNTRIES c
  WHERE c.COUNTRY_ID IN ('DE', 'IT', 'RU')
  ORDER BY c.COUNTRY_NAME;


-- task 5 DONE ------------------------------------------------------
SELECT  e.FIRST_NAME || ' ' || e.LAST_NAME
  FROM  EMPLOYEES e
  WHERE lower(e.LAST_NAME) LIKE '_a%' AND LOWER(e.FIRST_NAME) LIKE '%d%'


-- task 6 DONE ------------------------------------------------------
SELECT  *
  FROM  EMPLOYEES e
  WHERE length(e.FIRST_NAME) < 5 OR length(e.LAST_NAME) < 5
  ORDER BY  length(e.FIRST_NAME) + length(e.LAST_NAME),
            length(e.LAST_NAME),
            length(e.FIRST_NAME);


-- task 7 DONE ------------------------------------------------------
SELECT  j.JOB_ID,
        j.JOB_TITLE,
        ROUND((j.MIN_SALARY + j.MAX_SALARY) / 2 * 0.82, -2) AS AVG_SALARY
  FROM  JOBS j
  ORDER BY AVG_SALARY DESC, j.JOB_ID;


-- task 8 DONE ------------------------------------------------------
SELECT  c.CUST_LAST_NAME,
        c.CUST_FIRST_NAME,
        CASE
          WHEN c.CREDIT_LIMIT >= 3500 THEN
            'A'
          WHEN c.CREDIT_LIMIT >= 1000 THEN
            'B'
          ELSE
            'C'
        END
        AS CATEGORY,
        CASE
           WHEN c.CREDIT_LIMIT >= 3500 THEN 'Внимание, VIP-клиенты'
        END AS COMMENTS
  FROM CUSTOMERS c
  ORDER BY CATEGORY, c.CUST_LAST_NAME;


-- task 9 DONE ------------------------------------------------------
SELECT  DECODE(
          EXTRACT(MONTH FROM o.ORDER_DATE),
          '1', 'Январь',
          '2', 'Февраль',
          '3', 'Март',
          '4', 'Апрель',
          '5', 'Май',
          '6', 'Июнь',
          '7', 'Июль',
          '8', 'Август',
          '9', 'Сентябрь',
          '10', 'Октябрь',
          '11', 'Ноябрь',
          '12', 'Декабрь'
        ) AS MONTH
  FROM  ORDERS o
--   WHERE EXTRACT(YEAR FROM ORDER_DATE) = 1998 -- bad for indexes
  WHERE date'1998-01-01' <= o.ORDER_DATE AND o.ORDER_DATE < date'1999-01-01'
  GROUP BY EXTRACT(MONTH FROM o.ORDER_DATE)
  ORDER BY EXTRACT(MONTH FROM o.ORDER_DATE);


-- task 10 DONE -----------------------------------------------------
SELECT DISTINCT TO_CHAR(o.ORDER_DATE, 'Month', 'nls_date_language=russian') AS MONTH
--   ORDER_DATE -- MM
  FROM  ORDERS o
--   WHERE TO_CHAR(o.ORDER_DATE, 'YYYY', 'nls_date_language=russian') = 1998
  WHERE date'1998-01-01' <= o.ORDER_DATE AND o.ORDER_DATE < date'1999-01-01'
--   ORDER BY EXTRACT(MONTH FROM ORDER_DATE);
  ORDER BY to_date(to_char(o.ORDER_DATE, 'Month', 'nls_date_language=russian'), 'Month'); -- bad alphabetical order, ,


select distinct to_char(O.ORDER_DATE, 'Month', 'nls_date_language=russian') AS MONTH
    from ORDERS O
    where to_char(O.ORDER_DATE, 'YYYY', 'nls_date_language=russian') = '1998'
    order by to_date(MONTH, 'Month', 'nls_date_language=russian')
;


select distinct to_char(o.ORDER_DATE, 'Month')
  from  ORDERS o
  --where to_char(o.ORDER_DATE, 'yyyy') = '1998'
  where date'1998-01-01' <= o.ORDER_DATE and o.ORDER_DATE < date'1999-01-01'
  order by to_date(to_char(o.ORDER_DATE, 'Month'),'Month')
;


-- task 11 DONE -----------------------------------------------------
SELECT  to_char(trunc(SYSDATE, 'MONTH') + ROWNUM - 1, 'DD.MM.YY') as DT,
        CASE TO_CHAR(trunc(SYSDATE, 'MONTH') + ROWNUM - 1, 'D')
          WHEN '6' THEN 'Выходной'
          WHEN '7' THEN 'Выходной'
        END AS COMMENTS
  FROM ORDERS
  WHERE ROWNUM <= 31;


-- task 12 DONE -----------------------------------------------------
SELECT  e.EMPLOYEE_ID,
        e.LAST_NAME ||' '|| e.FIRST_NAME  AS EMP_NAME,
        e.JOB_ID,
        e.SALARY,
        e.COMMISSION_PCT
  FROM  EMPLOYEES e
  WHERE e.COMMISSION_PCT IS NOT NULL
  ORDER BY e.COMMISSION_PCT DESC, e.EMPLOYEE_ID;


-- task 13 DONE -----------------------------------------------------
-- http://sqlhints.com/2014/03/08/how-to-get-quarterly-data-in-sql-server/
-- SELECT  EXTRACT(YEAR FROM ORDER_DATE) AS YEAR,
--         SUM(ORDER_TOTAL) AS YEAR_SUM,
--
--         SUM(Q1.ORDER_TOTAL CASE WHEN EXTRACT(MONTH FROM ORDER_DATE) = 1 THEN 1 ELSE 1 END AS Q1)
-- --         CASE WHEN EXTRACT(MONTH FROM ord.ORDER_DATE) IN (1, 2, 3, 4) THEN SUM(ord.ORDER_TOTAL) ELSE 1 END AS Q1
--
-- --         CASE
-- --           WHEN EXTRACT(MONTH FROM ORDER_DATE) IN (1, 2, 3, 4) THEN SUM(ORDER_TOTAL) ELSE NULL
-- --         END AS Q1
--   FROM  ORDERS ord
--   WHERE EXTRACT(YEAR FROM ORDER_DATE) BETWEEN 1995 AND 2000
--   GROUP BY
--     EXTRACT(YEAR FROM ORDER_DATE),
--     EXTRACT(MONTH FROM ORDER_DATE)
--   ORDER BY EXTRACT(YEAR FROM ORDER_DATE);

SELECT  to_char(o.ORDER_DATE, 'YYYY') AS YEAR,
        sum(
          DECODE(
            to_char(o.ORDER_DATE, 'mm'),
            '01', o.ORDER_TOTAL,
            '02', o.ORDER_TOTAL,
            '03', o.ORDER_TOTAL
          )
        ) AS q1_sum,

        sum(
          DECODE(
            to_char(o.ORDER_DATE, 'mm'),
            '04', o.ORDER_TOTAL,
            '05', o.ORDER_TOTAL,
            '06', o.ORDER_TOTAL
          )
        ) AS q3_sum,

        sum(
          DECODE(
            to_char(o.ORDER_DATE, 'mm'),
            '07', o.ORDER_TOTAL,
            '08', o.ORDER_TOTAL,
            '09', o.ORDER_TOTAL
          )
        ) AS q2_sum,
        sum(
          DECODE(
            to_char(o.ORDER_DATE, 'mm'),
            '10', o.ORDER_TOTAL,
            '11', o.ORDER_TOTAL,
            '12', o.ORDER_TOTAL
          )
        ) AS q4_sum,
  sum(o.ORDER_TOTAL) as YEAR_SUM
  FROM ORDERS o
WHERE to_char(o.ORDER_DATE, 'YYYY') BETWEEN 1995 AND 2000
GROUP BY to_char(o.ORDER_DATE, 'YYYY')
ORDER BY to_char(o.ORDER_DATE, 'YYYY');


-- task 14 DONE -----------------------------------------------------
SELECT  p.PRODUCT_ID,
        p.PRODUCT_NAME,
        12 * EXTRACT(YEAR FROM p.WARRANTY_PERIOD) + EXTRACT(MONTH FROM p.WARRANTY_PERIOD) AS WARRANTY_MONTHS,
        p.LIST_PRICE,
        p.CATALOG_URL
  FROM  PRODUCT_INFORMATION p
  WHERE REGEXP_LIKE(p.PRODUCT_NAME, '(\d+)\s*(mb|gb)', 'i') AND NOT
        REGEXP_LIKE(p.PRODUCT_NAME, '^hd', 'i') AND NOT
        REGEXP_LIKE(SUBSTR(p.PRODUCT_DESCRIPTION, 1, 30), 'disk|drive|hard', 'i')
  ORDER BY  regexp_substr(p.PRODUCT_NAME, '(\d+)\s*(mb|gb)', 1, 1, 'i', 1) *
            decode(lower(regexp_substr(p.PRODUCT_NAME, '(\d+)\s*(mb|gb)', 1, 1, 'i', 2)), 'mb', 1, 1024) DESC,
        LIST_PRICE;


-- task 15 DONE -----------------------------------------------------
SELECT  sysdate,
        trunc((to_date('21:30', 'HH24:MI') - to_date(to_char(sysdate, 'HH24:MI'), 'HH24:MI')) * 24 * 60) AS MINUTES
  from dual;


---------------------------------------------------------------------

-- task  1 DONE
-- task  2 DONE
-- task  3 DONE
-- task  4 DONE
-- task  5 DONE
-- task  6 DONE
-- task  7 DONE
-- task  8 DONE
-- task  9 DONE
-- task 10 DONE~
-- task 11 DONE
-- task 12 DONE
-- task 13 DONE~
-- task 14 DONE
-- task 15 DONE~

-- ---------------------------------------------------------------------
-- для каждого товара найти product_id, product_name, sales_count (количество продаж в 1999 году)
-- from OREDERS JOIN ORDER_items, (типа ON year = 1999) потом групировку