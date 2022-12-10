-- task  1 DONE
-- task  2 DONE
-- task  3 DONE
-- task  4 DONE
-- task  5 DONE
-- task  6 DONE
-- task  7 DONE
-- task  8 DONE
-- task  9 DONE
-- task 10 DONE
-- task 11 DONE
-- task 12 DONE
-- task 13 DONE
-- task 14 DONE
-- task 15 DONE
-- короче где то нужно объединять по двум полям, не только по ON X, но и по ON ..DATE???


-- task 1 -----------------------------------------------------
SELECT  c.*
  FROM  CUSTOMERS c
        INNER JOIN ORDERS o
          ON c.CUSTOMER_ID = o.CUSTOMER_ID
  WHERE date'1999-07-01' <= o.ORDER_DATE and o.ORDER_DATE < date'1999-08-01'
  ORDER BY c.CUSTOMER_ID;

-- task 2 -----------------------------------------------------
SELECT  c.CUSTOMER_ID,
        c.CUST_LAST_NAME ||' '|| c.CUST_FIRST_NAME,
        o2.ORDER_TOTAL
  FROM  CUSTOMERS c
        LEFT JOIN (
          SELECT  o1.CUSTOMER_ID,
                  sum(ORDER_TOTAL) AS ORDER_TOTAL
            FROM ORDERS o1
            WHERE date'2000-01-01' <= o1.ORDER_DATE and o1.ORDER_DATE < date'2001-01-01'
            GROUP BY o1.CUSTOMER_ID
        ) o2
          ON c.CUSTOMER_ID = o2.CUSTOMER_ID
  ORDER BY o2.ORDER_TOTAL, c.CUSTOMER_ID;

-- task 3 -----------------------------------------------------
SELECT e.*
  FROM EMPLOYEES e
    LEFT JOIN JOB_HISTORY jh
      ON e.EMPLOYEE_ID = jh.EMPLOYEE_ID
  WHERE jh.EMPLOYEE_ID IS NULL
  ORDER BY e.HIRE_DATE, e.EMPLOYEE_ID;

-- task 4 -----------------------------------------------------
SELECT  w.WAREHOUSE_ID,
        w.WAREHOUSE_NAME,
        i1.PRODUCTS_COUNT
  FROM  WAREHOUSES w
          INNER JOIN (
            SELECT  i0.WAREHOUSE_ID,
                    count(1) as PRODUCTS_COUNT
              FROM INVENTORIES i0
              GROUP BY i0.WAREHOUSE_ID
          ) i1
            ON w.WAREHOUSE_ID = i1.WAREHOUSE_ID
  ORDER BY i1.PRODUCTS_COUNT DESC, w.WAREHOUSE_ID;

-- task 5 -----------------------------------------------------
SELECT *
  FROM  EMPLOYEES E
          INNER JOIN (
            SELECT  D.DEPARTMENT_ID
              FROM  DEPARTMENTS D INNER JOIN LOCATIONS L
                      ON D.LOCATION_ID = L.LOCATION_ID
              WHERE L.COUNTRY_ID = 'US'
          ) D1
            ON E.DEPARTMENT_ID = D1.DEPARTMENT_ID;

-- task 6 -----------------------------------------------------
SELECT  P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P.LIST_PRICE,
        D1.RU_DESCRIPTION
  FROM  PRODUCT_INFORMATION P
          INNER JOIN (
            SELECT
              D.PRODUCT_ID,
              D.LANGUAGE_ID,
              CASE
              WHEN D.LANGUAGE_ID = 'RU' -- change language here
                THEN D.TRANSLATED_DESCRIPTION
                ELSE n'Нет описания'
              END AS RU_DESCRIPTION
            FROM PRODUCT_DESCRIPTIONS D
            WHERE D.LANGUAGE_ID = 'RU'
          ) D1
            ON P.PRODUCT_ID = D1.PRODUCT_ID
  ORDER BY P.CATEGORY_ID, PRODUCT_ID;

-- task 7 -----------------------------------------------------
WITH P_RU_DESCR AS (
  SELECT  P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P.LIST_PRICE,
        D1.RU_DESCRIPTION
    FROM  PRODUCT_INFORMATION P
            INNER JOIN (
              SELECT
                D.PRODUCT_ID,
                D.LANGUAGE_ID,
                CASE
                WHEN D.LANGUAGE_ID = 'RU' -- change language here
                  THEN D.TRANSLATED_DESCRIPTION
                  ELSE n'Нет описания'
                END AS RU_DESCRIPTION
              FROM PRODUCT_DESCRIPTIONS D
              WHERE D.LANGUAGE_ID = 'RU'
            ) D1
              ON P.PRODUCT_ID = D1.PRODUCT_ID
    ORDER BY P.CATEGORY_ID, PRODUCT_ID
)
SELECT *
  FROM P_RU_DESCR
  WHERE P_RU_DESCR.PRODUCT_ID NOT IN (
    SELECT DISTINCT O.PRODUCT_ID
      FROM ORDER_ITEMS O
    )
  ORDER BY P_RU_DESCR.LIST_PRICE DESC NULLS LAST, P_RU_DESCR.PRODUCT_ID;

-- task 8 -----------------------------------------------------
SELECT  C.CUSTOMER_ID,
        C.CUST_FIRST_NAME ||' '|| C.CUST_LAST_NAME AS CUST_NAME,
        O1.LARGE_CHECK_COUNT,
        O1.MAX_ORDER_SUM
  FROM  CUSTOMERS C
        INNER JOIN (
          SELECT  O.CUSTOMER_ID,
                  count(1) AS LARGE_CHECK_COUNT,
                  max(O.ORDER_TOTAL) AS MAX_ORDER_SUM
          FROM ORDERS O
          WHERE ORDER_TOTAL > 2 * (
            SELECT avg(ORDER_TOTAL) as ac
            FROM ORDERS
          )
          GROUP BY O.CUSTOMER_ID
        ) O1
          ON O1.CUSTOMER_ID = C.CUSTOMER_ID
  ORDER BY O1.LARGE_CHECK_COUNT DESC, C.CUSTOMER_ID;

-- task 9 -----------------------------------------------------
SELECT  C.CUSTOMER_ID,
        C.CUST_FIRST_NAME ||' '|| C.CUST_LAST_NAME AS CUST_NAME,
        O.ORDERS_2000_SUM
  FROM  CUSTOMERS C
          LEFT JOIN (
            SELECT  o1.CUSTOMER_ID,
                    sum(o1.ORDER_TOTAL) AS ORDERS_2000_SUM
            FROM ORDERS o1
            WHERE date'2000-01-01' <= o1.ORDER_DATE and o1.ORDER_DATE < date'2001-01-01'
            GROUP BY o1.CUSTOMER_ID
          ) O
            ON C.CUSTOMER_ID = O.CUSTOMER_ID
  ORDER BY O.ORDERS_2000_SUM DESC NULLS LAST, C.CUSTOMER_ID;

-- task 10 ----------------------------------------------------
SELECT  C.CUSTOMER_ID,
        C.CUST_FIRST_NAME ||' '|| C.CUST_LAST_NAME AS CUST_NAME,
        O.ORDERS_2000_SUM
  FROM  CUSTOMERS C
          LEFT JOIN (
            SELECT  o1.CUSTOMER_ID,
                    sum(o1.ORDER_TOTAL) AS ORDERS_2000_SUM
            FROM ORDERS o1
            WHERE date'2000-01-01' <= o1.ORDER_DATE and o1.ORDER_DATE < date'2001-01-01'
            GROUP BY o1.CUSTOMER_ID
          ) O
            ON C.CUSTOMER_ID = O.CUSTOMER_ID
  WHERE O.ORDERS_2000_SUM IS NOT NULL
  ORDER BY O.ORDERS_2000_SUM DESC NULLS LAST, C.CUSTOMER_ID;

-- task 11 ----------------------------------------------------
SELECT  E.EMPLOYEE_ID,
        E.FIRST_NAME ||' '|| E.LAST_NAME AS EMP_NAME,
        C.CUSTOMER_ID,
        C.CUST_FIRST_NAME ||' '|| C.CUST_LAST_NAME AS CUST_NAME,
        o3.CUSTOMER_ID, -- name
        o3.ORDER_DATE,
        o3.ORDER_TOTAL,
        oi.POSITONS
  FROM  EMPLOYEES E
          LEFT JOIN (
            SELECT o1.*
            FROM ORDERS o1 INNER JOIN (
              SELECT
                o0.SALES_REP_ID,
                max(o0.ORDER_DATE) AS LAST_ORDER
              FROM ORDERS o0
              GROUP BY o0.SALES_REP_ID
            ) o2
              ON o1.ORDER_DATE = o2.LAST_ORDER
          ) o3
            ON E.EMPLOYEE_ID = o3.SALES_REP_ID
          LEFT JOIN CUSTOMERS C
            ON o3.CUSTOMER_ID = C.CUSTOMER_ID
          LEFT JOIN (
            SELECT  oi0.ORDER_ID,
                    count(1) AS POSITONS
            FROM ORDER_ITEMS oi0
            GROUP BY oi0.ORDER_ID
          ) oi
            ON o3.ORDER_ID = oi.ORDER_ID
    WHERE E.JOB_ID IN ('SA_MAN', 'SA_REP')
    ORDER BY o3.ORDER_DATE DESC NULLS LAST, E.EMPLOYEE_ID;

-- task 12 ----------------------------------------------------
SELECT  max(SALES.SALE)
  FROM (
    SELECT  O.ORDER_ID,
            round(1 - sum(O.UNIT_PRICE * O.QUANTITY) / sum(P.LIST_PRICE * O.QUANTITY), 4) * 100 as SALE
      FROM ORDER_ITEMS O
        INNER JOIN PRODUCT_INFORMATION P
          ON O.PRODUCT_ID = P.PRODUCT_ID
      GROUP BY O.ORDER_ID
  ) SALES;

-- task 13 ----------------------------------------------------
SELECT  P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P.LIST_PRICE,
        i2.PRODUCT_ID,
        i3.WAREHOUSE_ID,
        W.WAREHOUSE_NAME,
        C.COUNTRY_NAME
  FROM  (
    SELECT  i1.PRODUCT_ID,
            count(1) AS HOW_MANY_WAREHOUSES_HAS_IT
      FROM INVENTORIES i1
      GROUP BY i1.PRODUCT_ID
    ) i2
        INNER JOIN
          INVENTORIES i3
          ON i2.PRODUCT_ID = i3.PRODUCT_ID
        INNER JOIN PRODUCTS P
          ON i2.PRODUCT_ID = P.PRODUCT_ID
        INNER JOIN WAREHOUSES W
          ON i3.WAREHOUSE_ID = W.WAREHOUSE_ID
        INNER JOIN LOCATIONS L
          ON W.LOCATION_ID = L.LOCATION_ID
        INNER JOIN COUNTRIES C
          ON L.COUNTRY_ID = C.COUNTRY_ID
  WHERE i2.HOW_MANY_WAREHOUSES_HAS_IT = 1;

-- task 14 ----------------------------------------------------
SELECT  CO.COUNTRY_ID,
        CO.COUNTRY_NAME,
        CASE
          WHEN CU1.CUSTOMERS_COUNT IS NOT NULL THEN CU1.CUSTOMERS_COUNT -- тут nvl юзануть
          WHEN CU1.CUSTOMERS_COUNT IS NULL THEN 0
        END AS CUSTOMERS_COUNT
  FROM  COUNTRIES CO
          LEFT JOIN (
            SELECT  CU.CUST_ADDRESS_COUNTRY_ID,
                    count(1) AS CUSTOMERS_COUNT
              FROM CUSTOMERS CU
              GROUP BY CU.CUST_ADDRESS_COUNTRY_ID
          ) CU1
            ON CO.COUNTRY_ID = CU1.CUST_ADDRESS_COUNTRY_ID
  ORDER BY CU1.CUSTOMERS_COUNT DESC NULLS LAST, CO.COUNTRY_NAME;

-- task 15 ----------------------------------------------------
SELECT  C.CUSTOMER_ID,
        C.CUST_LAST_NAME||' '||C.CUST_FIRST_NAME AS CUST_NAME,
        O1.ORDER_DATE AS ORDER_DATE1,
        O2.ORDER_DATE AS ORDER_DATE2,
        O3.MIN_ORDERS_INTERVAL
  FROM  CUSTOMERS C
         LEFT JOIN (
           SELECT  O1.CUSTOMER_ID,
                   MIN(TRUNC(O2.ORDER_DATE, 'DD') - TRUNC(O1.ORDER_DATE, 'DD')) AS MIN_ORDERS_INTERVAL
             FROM  ORDERS O1
                   LEFT JOIN ORDERS O2
                     ON  O2.CUSTOMER_ID = O1.CUSTOMER_ID
             WHERE O1.ORDER_DATE < O2.ORDER_DATE
             GROUP BY  O1.CUSTOMER_ID
         ) O3
           ON  O3.CUSTOMER_ID = C.CUSTOMER_ID
         LEFT JOIN ORDERS O1
           ON  O1.CUSTOMER_ID = C.CUSTOMER_ID
         LEFT JOIN ORDERS O2
           ON  O2.CUSTOMER_ID = C.CUSTOMER_ID
  WHERE TRUNC(O2.ORDER_DATE, 'DD') - TRUNC(O1.ORDER_DATE, 'DD') = O3.MIN_ORDERS_INTERVAL
  ORDER BY  C.CUSTOMER_ID;
