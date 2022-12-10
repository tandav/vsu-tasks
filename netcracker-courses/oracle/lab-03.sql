-------------------------------- TASK 1 --------------------------------
-- Выбрать с помощью иерархического запроса сотрудников 3-его уровня
-- иерархии (т.е. таких, у которых непосредственный начальник напрямую
-- подчиняется руководителю организации). Упорядочить по коду сотрудника.

SELECT  E.*
  FROM  EMPLOYEES E
  WHERE LEVEL = 2
  START WITH E.MANAGER_ID IS NULL
  CONNECT BY E.MANAGER_ID = PRIOR(E.EMPLOYEE_ID)
  ORDER BY  E.EMPLOYEE_ID
;

-------------------------------- TASK 2 --------------------------------
-- Для каждого сотрудника выбрать всех его начальников по иерархии.
-- Вывести поля: код сотрудника, имя сотрудника (фамилия + имя через пробел),
-- код начальника, имя начальника (фамилия + имя через пробел),
-- кол-во промежуточных начальников между сотрудником и начальником
-- из данной строки выборки. Если у какого-то сотрудника есть несколько
-- начальников, то для данного сотрудника в выборке должно быть несколько
-- строк с разными начальниками. Упорядочить по коду сотрудника, затем по
-- уровню начальника (первый – непосредственный начальник, последний –
-- руководитель организации).

SELECT  E.EMPLOYEE_ID,
        E.LAST_NAME||' '||E.FIRST_NAME AS EMPLOYEE_NAME,
        CONNECT_BY_ROOT E.EMPLOYEE_ID AS MANAGER_ID,
        CONNECT_BY_ROOT (E.LAST_NAME || ' ' || E.FIRST_NAME) AS MANAGER_NAME,
        SYS_CONNECT_BY_PATH(E.LAST_NAME || ' ' || E.FIRST_NAME, '/') AS PATH,
        LEVEL,
        LEVEL - 2 AS COUNT_OF_MANAGERS
  FROM  EMPLOYEES E
  WHERE LEVEL > 1
  CONNECT BY NOCYCLE  E.MANAGER_ID=PRIOR(E.EMPLOYEE_ID)
  ORDER BY  E.EMPLOYEE_ID,
            LEVEL DESC;

-------------------------------- TASK 3 --------------------------------
-- Для каждого сотрудника посчитать количество его подчиненных,
-- как непосредственных, так и по иерархии. Вывести поля: код сотрудника,
-- имя сотрудника (фамилия + имя через пробел), общее кол-во подчиненных.

SELECT  E.EMPLOYEE_ID,
        E.LAST_NAME || ' ' || E.FIRST_NAME AS EMPLOYEE_NAME,
        DEP.AMOUNT_OF_DEPANDANTS
  FROM  EMPLOYEES E
        LEFT JOIN (
          SELECT CUR_EMP, (COUNT(CUR_EMP)-1) AS AMOUNT_OF_DEPANDANTS
            FROM (
              SELECT  CONNECT_BY_ROOT(EMP.EMPLOYEE_ID) AS CUR_EMP                                
                FROM  EMPLOYEES EMP
                CONNECT BY  EMP.MANAGER_ID = PRIOR EMP.EMPLOYEE_ID
            )
            GROUP BY CUR_EMP
        ) DEP
          ON  E.EMPLOYEE_ID = DEP.CUR_EMP
    ORDER BY  DEP.AMOUNT_OF_DEPANDANTS DESC,
              E.EMPLOYEE_ID
;

-------------------------------- TASK 4 --------------------------------
-- Для каждого заказчика выбрать в виде строки через запятую даты его заказов.
-- Для конкатенации дат заказов использовать sys_connect_by_path (иерархический
-- запрос). Для отбора «последних» строк использовать connect_by_isleaf.

SELECT  (C.CUST_LAST_NAME || ' ' || C.CUST_FIRST_NAME) AS CUST_NAME,
        SYS_CONNECT_BY_PATH(LAST_ORDER.ORDER_DATE, ', ') AS DATES
  FROM  CUSTOMERS C
        JOIN (
          SELECT  O.*,
                  ROW_NUMBER() OVER (PARTITION BY O.CUSTOMER_ID ORDER BY O.ORDER_DATE) AS ORD_NUM
            FROM  ORDERS O
        ) LAST_ORDER
          ON  C.CUSTOMER_ID = LAST_ORDER.CUSTOMER_ID
  WHERE CONNECT_BY_ISLEAF = 1
  START WITH LAST_ORDER.ORD_NUM = 1    
  CONNECT BY  PRIOR(LAST_ORDER.CUSTOMER_ID) = LAST_ORDER.CUSTOMER_ID AND
              PRIOR(LAST_ORDER.ORD_NUM)+1 = LAST_ORDER.ORD_NUM;

-------------------------------- TASK 5 --------------------------------
-- Выполнить задание № 4 c помощью обычного запроса с группировкой и функцией
-- listagg.

SELECT  (C.CUST_LAST_NAME || ' ' || C.CUST_FIRST_NAME) AS CUST_NAME,
        LISTAGG(O.ORDER_DATE, ', ')
          WITHIN GROUP(ORDER BY O.ORDER_DATE) AS DATES
  FROM  CUSTOMERS C
        JOIN ORDERS O
          ON C.CUSTOMER_ID = O.CUSTOMER_ID
  GROUP BY C.CUSTOMER_ID, C.CUST_LAST_NAME || ' ' || C.CUST_FIRST_NAME
;

-------------------------------- TASK 6 --------------------------------
-- Выполнить задание № 2 с помощью рекурсивного запроса.
-- Для каждого сотрудника выбрать всех его начальников по иерархии.
-- Вывести поля: код сотрудника, имя сотрудника (фамилия + имя через пробел),
-- код начальника, имя начальника (фамилия + имя через пробел),
-- кол-во промежуточных начальников между сотрудником и начальником из данной
-- строки выборки. Если у какого-то сотрудника есть несколько начальников, то
-- для данного сотрудника в выборке должно быть несколько строк с разными
-- начальниками. Упорядочить по коду сотрудника, затем по уровню начальника
-- (первый – непосредственный начальник, последний – руководитель организации).

WITH EMPL  (EMPLOYEE_ID,
            EMPLOYEE_NAME,
            MANAGER_ID,
            MANAGER_NAME,
            AMOUNT_OF_MANAGERS,
            MANAGER_ID_
) AS (
    SELECT E.EMPLOYEE_ID,
                E.LAST_NAME || ' ' || E.FIRST_NAME,
                NULL,
                NULL,
                -1,
                E.MANAGER_ID
      FROM  EMPLOYEES E
    UNION ALL
    SELECT  EMPL.EMPLOYEE_ID,
            EMPL.EMPLOYEE_NAME,
            EMPL.MANAGER_ID_,
            E.LAST_NAME || ' ' || E.FIRST_NAME,
            AMOUNT_OF_MANAGERS+1,
            E.MANAGER_ID            
      FROM  EMPLOYEES E
            INNER JOIN  EMPL
              ON EMPL.MANAGER_ID_=E.EMPLOYEE_ID
 )        
  SELECT  EMPLOYEE_ID,
          EMPLOYEE_NAME,
          MANAGER_ID,
          MANAGER_NAME,
          AMOUNT_OF_MANAGERS as AMOUNT_OF_BETWEEN_MANAGERS
    FROM  EMPL
    WHERE MANAGER_ID IS NOT NULL
    ORDER BY  EMPLOYEE_ID,
              AMOUNT_OF_MANAGERS
;

-------------------------------- TASK 7 --------------------------------
-- Выполнить задание № 3 с помощью рекурсивного запроса.
-- Для каждого сотрудника посчитать количество его подчиненных,
-- как непосредственных, так и по иерархии. Вывести поля: код сотрудника,
-- имя сотрудника (фамилия + имя через пробел), общее кол-во подчиненных.

WITH EMPL  (EMPLOYEE_ID,  
            EMPLOYEE_NAME,
            MANAGER_ID 
            ) AS
( SELECT  E.EMPLOYEE_ID,
          E.LAST_NAME ||' ' || E.FIRST_NAME,
          E.MANAGER_ID
    FROM  EMPLOYEES E
  UNION ALL
  SELECT  E.EMPLOYEE_ID,
          E.LAST_NAME ||' ' || E.FIRST_NAME,
          E.MANAGER_ID
    FROM  EMPLOYEES E
          INNER JOIN EMPL
            ON  EMPL.MANAGER_ID=E.EMPLOYEE_ID
)
  SELECT  EMPL.EMPLOYEE_ID,  
          EMPL.EMPLOYEE_NAME, 
          COUNT(*)-1 AS AMOUNT_OF_DEPANDANTS
    FROM  EMPL
    GROUP BY EMPL.EMPLOYEE_ID,  
             EMPL.EMPLOYEE_NAME
    ORDER BY  AMOUNT_OF_DEPANDANTS DESC,
              EMPL.EMPLOYEE_ID
;

-------------------------------- TASK 8 --------------------------------
-- Каждому менеджеру по продажам сопоставить последний его заказ.
-- Менеджером по продажам считаем сотрудников, код должности которых: «SA_MAN» и
-- «SA_REP». Для выборки последних заказов по менеджерам использовать подзапрос с
-- применением аналитических функций (например в подзапросе выбирать дату
-- следующего заказа менеджера, а во внешнем запросе «оставить» только те строки,
-- у которых следующего заказа нет). Вывести поля: код менеджера, имя менеджера
-- (фамилия + имя через пробел), код клиента, имя клиента (фамилия + имя через
-- пробел), дата заказа, сумма заказа, количество различных позиций в заказе.
-- Упорядочить данные по дате заказа в обратном порядке, затем по сумме заказа в
-- обратном порядке, затем по коду сотрудника. Тех менеджеров, у которых нет
-- заказов, вывести в конце.

SELECT  LAST_ORDER.EMP_ID, 
        LAST_ORDER.EMP_NAME, 
        LAST_ORDER.CUST_ID, 
        LAST_ORDER.CUST_NAME, 
        LAST_ORDER.ORDER_TOTAL, 
        LAST_ORDER.ORDER_DATE, 
        LAST_ORDER.AMOUNT 
  FROM  
     ( SELECT E.EMPLOYEE_ID AS EMP_ID, 
              E.LAST_NAME || ' ' || E.FIRST_NAME AS EMP_NAME, 
              C.CUSTOMER_ID AS CUST_ID, 
              C.CUST_LAST_NAME || ' ' || C.CUST_FIRST_NAME AS CUST_NAME, 
              O.ORDER_TOTAL, 
              O.ORDER_DATE, 
              (SELECT COUNT(*) 
                FROM  ORDER_ITEMS OI 
                WHERE OI.ORDER_ID = O.ORDER_ID 
              ) AS AMOUNT, 
              ROW_NUMBER() OVER (PARTITION BY E.EMPLOYEE_ID ORDER BY O.ORDER_DATE DESC) AS ROW_NUM 
        FROM  EMPLOYEES E 
              LEFT JOIN ORDERS O 
                ON  E.EMPLOYEE_ID = O.SALES_REP_ID 
              LEFT JOIN CUSTOMERS C 
                ON  O.CUSTOMER_ID = C.CUSTOMER_ID 
        WHERE E.JOB_ID = 'SA_MAN' OR E.JOB_ID = 'SA_REP'
     ) LAST_ORDER 
  WHERE LAST_ORDER.ROW_NUM = 1 
  ORDER BY  LAST_ORDER.ORDER_DATE DESC NULLS LAST, 
            LAST_ORDER.ORDER_TOTAL DESC, 
            LAST_ORDER.EMP_ID 
;

-------------------------------- TASK 9 --------------------------------
-- Для каждого месяца текущего года найти первые и последние рабочие и
-- выходные дни с учетом праздников и переносов выходных дней (на 2016 год эту
-- информацию можно посмотреть, например, на странице
-- http://www.interfax.ru/russia/469373).
-- Для формирования списка всех дней текущего года использовать иерархический запрос,
-- оформленный в виде подзапроса в секции with. Праздничные дни и переносы выходных
-- также задать в виде подзапроса в секции with (с помощью union all перечислить
-- все даты, в которых рабочие/выходные дни не совпадают с обычной логикой
-- определения выходного дня как субботы и воскресения). Запрос должен корректно
-- работать, если добавить/изменить какие угодно выходные/рабочие дни в данном
-- подзапросе. Вывести поля: месяц в виде первого числа месяца, первый выходной
-- день месяца, последний выходной день, первый рабочий день, последний
-- рабочий день.

WITH
    DAYS AS (
      SELECT  TO_DATE('01.01.2018','DD.MM.YYYY') + LEVEL - 1 AS DATES
      FROM  DUAL
      CONNECT BY TO_DATE('01.01.2018','DD.MM.YYYY') + LEVEL - 1 < TO_DATE('01.01.2019','DD.MM.YYYY')
  ),
    HOLIDAYS(DAY) AS (
    SELECT  DATE'2018-01-01' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-01-02' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-01-03' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-01-04' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-01-05' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-01-08' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-02-23' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-03-08' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-03-09' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-04-30' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-05-01' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-05-02' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-05-09' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-06-11' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-06-12' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-11-05' AS DATES
    FROM  DUAL
    UNION ALL
    SELECT  DATE'2018-12-31' AS DATES
    FROM  DUAL
  )
SELECT  TRUNC(DATES,'MM') AS MONTH,
        MIN(
            CASE
            WHEN (DATES - TRUNC(DATES, 'IW') IN (5,6) OR
                  H.DAY IS NOT NULL)
              THEN DATES
            END
        ) AS FIRST_FREE_DAY,
        MAX(
            CASE
            WHEN DATES - TRUNC(DATES, 'IW') IN (5,6) OR
                 H.DAY IS NOT NULL
              THEN DATES
            END
        ) AS LAST_FREE_DAY,
        MIN(
            CASE
            WHEN DATES - TRUNC(DATES, 'IW') IN (0,1,2,3,4) and
                 H.DAY IS NULL
              THEN DATES
            END
        ) AS FIRST_JOB_DAY,
        MAX(
            CASE
            WHEN D.DATES - TRUNC(D.DATES, 'IW') IN (0, 1, 2, 3, 4) and
                 H.DAY IS NULL THEN
              D.DATES
            END
        ) AS LAST_JOB_DAY
FROM  DAYS D
  left join HOLIDAYS H on
                         D.DATES=H.DAY
GROUP BY TRUNC(DATES, 'MM')
ORDER BY MONTH;

-------------------------------- TASK 10 --------------------------------
-- 3-м самых эффективным по сумме заказов за 1999 год менеджерам по
-- продажам увеличить зарплату еще на 20%.

UPDATE  EMPLOYEES E
  SET E.SALARY = E.SALARY * 1.2
    WHERE E.EMPLOYEE_ID IN (
                            SELECT EMPLOYEE_ID
                              FROM (
                                SELECT    E.EMPLOYEE_ID,
                                          ORD.TOTAL AS TOTAL
                                    FROM  EMPLOYEES E
                                          LEFT JOIN (
                                            SELECT  O.SALES_REP_ID,
                                                    SUM(O.ORDER_TOTAL) AS TOTAL
                                              FROM  ORDERS O
                                              WHERE O.ORDER_DATE < DATE '2000-01-01' AND
                                                    O.ORDER_DATE >= DATE '1999-01-01'
                                              GROUP BY O.SALES_REP_ID
                                           ) ORD
                                             ON E.EMPLOYEE_ID = ORD.SALES_REP_ID
                                    ORDER BY TOTAL DESC NULLS LAST
                                )
                              WHERE ROWNUM < 4
                           )
;
SELECT E.employee_id, E.SALARY
  FROM EMPLOYEES E
  WHERE E.employee_id IN
                        (SELECT EMPLOYEE_ID
                                    FROM (
                                      SELECT  E.EMPLOYEE_ID,
                                                ORD.TOTAL AS TOTAL
                                          FROM  EMPLOYEES E
                                                LEFT JOIN (
                                                  SELECT  O.SALES_REP_ID,
                                                          SUM(O.ORDER_TOTAL) AS TOTAL
                                                    FROM  ORDERS O
                                                    WHERE O.ORDER_DATE < DATE '2000-01-01' AND
                                                          O.ORDER_DATE >= DATE '1999-01-01'
                                                    GROUP BY O.SALES_REP_ID
                                                 ) ORD
                                                   ON E.EMPLOYEE_ID = ORD.SALES_REP_ID
                                          ORDER BY TOTAL DESC NULLS LAST
                                      )
                                    WHERE ROWNUM < 4
                          )
;
-------------------------------- TASK 11 --------------------------------
-- Завести нового клиента ‘Старый клиент’ с менеджером, который является
-- руководителем организации. Остальные поля клиента – по умолчанию.

INSERT INTO CUSTOMERS (CUST_FIRST_NAME, CUST_LAST_NAME, ACCOUNT_MGR_ID)
  VALUES('Старый', 'клиент', (
    SELECT E.EMPLOYEE_ID
      FROM  EMPLOYEES E
      WHERE E.MANAGER_ID IS NULL
  ));

-------------------------------- TASK 12 --------------------------------
-- Для клиента, созданного в предыдущем запросе, (найти можно по максимальному
-- id клиента), продублировать заказы всех клиентов за 1990 год. (Здесь будет 2
-- запроса, для дублирования заказов и для дублирования позиций заказа).

-- 1.

INSERT INTO ORDERS (
          ORDER_DATE,
          ORDER_MODE,
          CUSTOMER_ID,
          ORDER_STATUS,
          ORDER_TOTAL,
          SALES_REP_ID,
          PROMOTION_ID
       )
  SELECT  O.ORDER_DATE, 
          O.ORDER_MODE, (
            SELECT MAX(CUSTOMER_ID)
            FROM CUSTOMERS
          ),
          O.ORDER_STATUS, 
          O.ORDER_TOTAL, 
          O.SALES_REP_ID, 
          O.PROMOTION_ID     
    FROM  ORDERS O
    WHERE O.ORDER_DATE >= DATE '1990-01-01'  AND
          O.ORDER_DATE < DATE '1991-01-01';
  
-- 2
INSERT INTO ORDER_ITEMS
       ( ORDER_ID, 
         LINE_ITEM_ID, 
         PRODUCT_ID, 
         UNIT_PRICE, 
         QUANTITY
       )
  SELECT  NEW_ORDER.ORDER_ID,
          OT.LINE_ITEM_ID,
          OT.PRODUCT_ID,
          OT.UNIT_PRICE,
          OT.QUANTITY
    FROM  ORDER_ITEMS OT, (
            SELECT *
              FROM ORDERS O
              WHERE O.CUSTOMER_ID = (
                      SELECT MAX(CUSTOMER_ID)
                        FROM CUSTOMERS
                    )
          ) NEW_ORDER, (
            SELECT *
              FROM  ORDERS O
              WHERE O.ORDER_DATE >= DATE '1990-01-01' AND
                    O.ORDER_DATE < DATE '1991-01-01' AND
                    O.CUSTOMER_ID <> ( SELECT MAX(CUSTOMER_ID)
                                        FROM CUSTOMERS
                                     )
          ) OLD_ORDER   
    WHERE OLD_ORDER.ORDER_DATE = NEW_ORDER.ORDER_DATE AND
          OLD_ORDER.ORDER_TOTAL = NEW_ORDER.ORDER_TOTAL AND
          OT.ORDER_ID = OLD_ORDER.ORDER_ID
          
;
          
          
          
          

SELECT *
FROM ORDERS O
WHERE DATE '1990-01-01' <= O.ORDER_DATE 
AND O.ORDER_DATE < DATE '1991-01-01';   

SELECT *
FROM ORDER_ITEMS OI
WHERE OI.ORDER_ID IN (
                          SELECT O.ORDER_ID 
                          FROM ORDERS O
                          WHERE O.ORDER_DATE >= DATE '1990-01-01' 
                            AND O.ORDER_DATE < DATE '1991-01-01'
                      );

-------------------------------- TASK 13 --------------------------------
-- Для каждого клиента удалить самый первый заказ. Должно быть 2 запроса:
-- первый – для удаления позиций в заказах, второй – на удаление собственно заказов).*/

-- 1
DELETE FROM ORDER_ITEMS OI 
  WHERE OI.ORDER_ID IN (
          SELECT  O1.ORDER_ID
            FROM  ORDERS O1
            WHERE O1.ORDER_DATE = (
                    SELECT MIN(O2.ORDER_DATE)
                      FROM  ORDERS O2
                      WHERE O1.CUSTOMER_ID = O2.CUSTOMER_ID
                  )
        );

-- 2
DELETE FROM ORDERS ORD 
  WHERE ORD.ORDER_ID IN  (
        SELECT O1.ORDER_ID
            FROM CUSTOMERS CUST,
                 ORDERS O1
            WHERE CUST.CUSTOMER_ID = O1.CUSTOMER_ID 
                  AND O1.ORDER_DATE = (
                     SELECT MIN(O2.ORDER_DATE)
                        FROM  ORDERS O2                                                                            
                        WHERE O1.CUSTOMER_ID = O2.CUSTOMER_ID                                                                            
                  )
        )
;                                                   

 
/*SELECT O1.ORDER_ID,
       O1.CUSTOMER_ID,
       O1.ORDER_DATE
FROM ORDERS O1
WHERE O1.ORDER_DATE < ALL (
       SELECT O2.ORDER_DATE
       FROM ORDERS O2
       WHERE O2.CUSTOMER_ID = O1.CUSTOMER_ID
            AND O2.ORDER_DATE <> O1.ORDER_DATE
);
*/

-------------------------------- TASK 14 --------------------------------
-- Для товаров, по которым не было ни одного заказа, уменьшить цену в 2 раза
-- (округлив до целых) и изменить название, приписав префикс ‘Супер Цена! ’.*/

UPDATE  PRODUCT_INFORMATION PI 
  SET PI.LIST_PRICE = ROUND(PI.LIST_PRICE/2),
      PI.PRODUCT_NAME = 'Супер Цена! '|| PI.PRODUCT_NAME
    WHERE PI.PRODUCT_ID NOT IN (
            SELECT OI.PRODUCT_ID                            
              FROM ORDER_ITEMS OI
          )
;
-------------------------------- TASK 15 --------------------------------
-- Импортировать в базу данных из прайс-листа фирмы «Рет»
-- (http://www.voronezh.ret.ru/? &pn=down) информацию о всех реализуемых
-- планшетах. Подсказка: воспользоваться excel для конструирования
-- insert-запросов (или select-запросов, что даже удобнее).
CREATE TABLE  INFORMATION_OF_PRODUCT(
        id NUMBER NOT NULL,
        name VARCHAR2(3000),
        usPrice NUMBER,
        ruPrice NUMBER,
        garant NUMBER,
        PRIMARY KEY(id)
      );

INSERT INTO INFORMATION_OF_PRODUCT(id, name, usPrice, ruPrice, garant)  
    select 803170 as id,'Планшет  7" Iconbit NetTAB Rune, 800*600, ARM 1.2ГГц, 8GB, BT, WiFi, SD-micro/SDHC-micro, Android 2.3, 180*140*12мм 429г, 7ч, черный' as name,37.6 as usPrice,2290 as ruPrice,12 as garant from dual union all
    select 804357 as id,'Планшет  7" Huawei Ideos S7 Slim, 800*480, Qualcomm 1ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro, MiniHDMI, 2 камеры 3.2/0.3Мпикс, Android 2.2, 200*110*13мм 440г, 12ч, белый' as name,37.6 as usPrice,2290 as ruPrice,12 as garant from dual union all
    select 807441 as id,'Планшет  8" Archos 80 G9, 1024*768, ARM 1ГГц, 8GB, GPS, BT, WiFi, SD-micro, miniHDMI, камера, Android 3.2, 226*155*12мм 465г, 10ч, темно-серый' as name,40.89 as usPrice,2490 as ruPrice,12 as garant from dual union all
    select 819954 as id,'Планшет  7" PocketBook A7, 1024*600, TI 1ГГц, 4GB, WiFi, SD-micro, камера 2Мпикс, Android 2.3, 131*207*14мм 410г, 6.5ч, черный-белый' as name,40.89 as usPrice,2490 as ruPrice,12 as garant from dual union all
    select 837015 as id,'Планшет 10.1" ASUS Eee Pad Transformer Prime (TF201), 1280*800, ARM 1.4ГГц, 64GB, GPS, BT, WiFi, SD, microHDMI, 8/1.2 Мпикс, Android 4.0, док-станция, клавиатура, 263*181*8мм 586г, 12ч, золотистый' as name,164.04 as usPrice,9990 as ruPrice,12 as garant from dual union all
    select 841417 as id,'Планшет 10.1" Acer Iconia Tab A200, 1280*800, ARM 1ГГц, 32GB, GPS, BT, WiFi, SD-micro, камера 2Мпикс, Android 4.0, 260*175*70мм 720г, красный' as name,102.63 as usPrice,6250 as ruPrice,12 as garant from dual union all
    select 849357 as id,'Планшет 10.1" Acer Iconia Tab A510 (HT.H9LEE.004), 1280*800, NVIDIA 1.3ГГц, 32GB, GPS, BT, WiFi, SD-micro, microHDMI, 2 камеры 5/1Мпикс, Android 4.0, 260*175*11мм 680г, 14.5ч, черный' as name,102.63 as usPrice,6250 as ruPrice,12 as garant from dual union all
    select 871942 as id,'Планшет  7" Iconbit NetTAB Thor mini, 1024*600, ARM 1.6ГГц, 8GB, WiFi, SD-micro/SDHC-micro, MiniHDMI, 2 камеры 2/2Мпикс, Android 4.1, 196*114*11мм 319г, белый' as name,40.23 as usPrice,2450 as ruPrice,12 as garant from dual union all
    select 872163 as id,'Планшет 11.6" Samsung ATIV Smart PC Pro (XE700T1C-A03RU), 1920*1080, Intel 1.5ГГц, 64GB, BT, WiFi, SD-micro, microHDMI, 2 камеры 5/2Мпикс, W8, 340*189*12мм 888г, черный' as name,295.4 as usPrice,17990 as ruPrice,12 as garant from dual union all
    select 872181 as id,'Планшет 10.1" Pegatron Chagall (90NL-083S100), 1280*800, ARM 1.5ГГц, 16GB, BT, WiFi, SD-micro,  2 камеры 8/2 Мпикс, Android 4.0, 260*7*180мм 540г, 8ч, черный' as name,70.44 as usPrice,4290 as ruPrice,12 as garant from dual union all
    select 880324 as id,'Планшет  7" Iconbit NetTAB Sky 3G Duo, 1024*600, ARM 1.2ГГц, 4GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, MiniHDMI, 2 камеры 5/0.3Мпикс, Android 4.0, 195*124*11мм 315г, черный' as name,49.1 as usPrice,2990 as ruPrice,12 as garant from dual union all
    select 889098 as id,'Планшет  8" Iconbit NetTAB Parus Quad, 1024*768, Samsung 1.4ГГц, 16GB, WiFi, SD-micro/SDHC-micro, MiniHDMI, 2 камеры 2/2Мпикс, Android 4.0, 207*160*10мм 475г, серебристый' as name,80.3 as usPrice,4890 as ruPrice,12 as garant from dual union all
    select 895200 as id,'Планшет  7" Topstar TS-AD75 TE, 1024*600, ARM 1ГГц, 8GB, 3G, GSM, BT, WiFi, SD-micro, SDHC-micro, miniHDMI, камера 0.3 Мпикс, Android 4.0, 193*123*10мм 350г, черный' as name,49.1 as usPrice,2990 as ruPrice,12 as garant from dual union all
    select 895204 as id,'Планшет  7" Galapad 7, 1024*600, NVIDIA 1.3ГГц, 8GB, GPS, BT, WiFi, SD-micro, microHDMI, камера 2Мпикс, Android 4.1, 122*196*10мм 320г, черный' as name,42.68 as usPrice,2599 as ruPrice,12 as garant from dual union all
    select 903785 as id,'Планшет  7" Iconbit NetTAB Sky II mk2, 800*480, ARM 1.2ГГц, 4GB, WiFi, SD-micro, камера 0.3Мпикс, Android 4.1, 191*114*11мм 310г, белый' as name,37.6 as usPrice,2290 as ruPrice,12 as garant from dual union all
    select 908698 as id,'Планшет  7.85" Iconbit NetTAB Skat RX (NT-0801C), 1024*768, ARM 1.8ГГц, 16GB, BT, WiFi, SD-micro/SDHC-micro, microHDMI, 2 камеры 0.3/2Мпикс, Android 4.1, 136*202*9мм 335г, белый' as name,47.45 as usPrice,2890 as ruPrice,12 as garant from dual union all
    select 915845 as id,'Планшет 10.1" Dell XPS 10 Tablet (6225-8264), 1366*768, Qualcomm 1.5ГГц, 64GB, BT, WiFi, SD-micro, miniHDMI, 2 камеры 5/2 Мпикс, W8RT, док-станция, клавиатура, 275*177*9мм 635г, 10.5ч, черный' as name,147.62 as usPrice,8990 as ruPrice,12 as garant from dual union all
    select 921566 as id,'Планшет  9.7" Apple iPad Air (ME987), 2048*1536, A7 1.4ГГц, 128GB, 3G/4G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 478г, 10ч, серый' as name,623.81 as usPrice,37990 as ruPrice,12 as garant from dual union all
    select 922816 as id,'Планшет  9.7" Apple iPad Air (MD791), 2048*1536, A7 1.4ГГц, 16GB, 3G/4G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 480г, 10ч, серый' as name,581.28 as usPrice,35400 as ruPrice,12 as garant from dual union all
    select 922819 as id,'Планшет  9.7" Apple iPad Air (ME988), 2048*1536, A7 1.4ГГц, 128GB, 3G/4G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 480г, 10ч, серебристый' as name,640.23 as usPrice,38990 as ruPrice,12 as garant from dual union all
    select 928785 as id,'Планшет  9.7" Apple iPad Air (ME898), 2048*1536, A7 1.4ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 469г, 10ч, серый' as name,558.13 as usPrice,33990 as ruPrice,12 as garant from dual union all
    select 929480 as id,'Планшет  7.9" Apple iPad mini Retina (ME860), 2048*1536, A7 1.3ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 135*200*8мм 331г, 10ч, серебристый' as name,402.13 as usPrice,24490 as ruPrice,12 as garant from dual union all
    select 929996 as id,'Планшет  9.7" Apple iPad Air (ME906), 2048*1536, A7 1.4ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 469г, 10ч, серебристый' as name,574.55 as usPrice,34990 as ruPrice,12 as garant from dual union all
    select 934910 as id,'Планшет  8" ASUS VivoTab Note 8 (M80TA), 1280*800, Intel 1.86ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/1.26Мпикс, W8.1, 134*221*11мм 380г, черный' as name,180.46 as usPrice,10990 as ruPrice,12 as garant from dual union all
    select 952526 as id,'Планшет  7" Prestigio MultiPad PMT3677, 800*480, ARM 1ГГц, 4GB, WiFi, SD-micro, камера 0.3Мпикс, Android 4.2, 192*116*11мм 300г, черный' as name,37.6 as usPrice,2290 as ruPrice,12 as garant from dual union all
    select 956008 as id,'Планшет  7.9" Apple iPad mini 3 (MGYE2RU/A), 2048*1536, A7 1.3ГГц, 16GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, золотистый' as name,376.03 as usPrice,22900 as ruPrice,12 as garant from dual union all
    select 956009 as id,'Планшет  7.9" Apple iPad mini 3 (MGY92RU/A), 2048*1536, A7 1.3ГГц, 64GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, золотистый' as name,492.45 as usPrice,29990 as ruPrice,12 as garant from dual union all
    select 956010 as id,'Планшет  7.9" Apple iPad mini 3 (MGGQ2RU/A), 2048*1536, A7 1.3ГГц, 64GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 135*200*8мм 331г, 10ч, серый' as name,492.45 as usPrice,29990 as ruPrice,12 as garant from dual union all
    select 956970 as id,'Планшет  7.9" Apple iPad mini 3 (MGP32RU/A), 2048*1536, A7 1.3ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, серый' as name,541.71 as usPrice,32990 as ruPrice,12 as garant from dual union all
    select 956971 as id,'Планшет  7.9" Apple iPad mini 3 (MGYU2RU/A), 2048*1536, A7 1.3ГГц, 128GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, золотистый' as name,623.81 as usPrice,37990 as ruPrice,12 as garant from dual union all
    select 956972 as id,'Планшет  7.9" Apple iPad mini 3 (MGJ22RU/A), 2048*1536, A7 1.3ГГц, 128GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, серый' as name,573.07 as usPrice,34900 as ruPrice,12 as garant from dual union all
    select 957649 as id,'Планшет  7.9" Apple iPad mini 3 (MGGT2RU/A), 2048*1536, A7 1.3ГГц, 64GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 135*200*8мм 331г, 10ч, серебристый' as name,459.61 as usPrice,27990 as ruPrice,12 as garant from dual union all
    select 957650 as id,'Планшет  7.9" Apple iPad mini 3 (MGJ32RU/A), 2048*1536, A7 1.3ГГц, 128GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, серебристый' as name,573.07 as usPrice,34900 as ruPrice,12 as garant from dual union all
    select 957654 as id,'Планшет  7.9" Apple iPad mini 3 (MGNV2RU/A), 2048*1536, A7 1.3ГГц, 16GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, серебристый' as name,408.87 as usPrice,24900 as ruPrice,12 as garant from dual union all
    select 958228 as id,'Планшет  8" Sony Xperia Tablet Z3 Compact (SGP611RU), 1920*1200, Qualcomm 2.5ГГц , 16GB, GPS, ИК, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 8.1/2.2Мпикс, Android 4.4, 213.3*123.6*6.4мм, 270г, черный' as name,229.72 as usPrice,13990 as ruPrice,12 as garant from dual union all
    select 958229 as id,'Планшет  8" Sony Xperia Tablet Z3 Compact (SGP611RU), 1920*1200, Qualcomm 2.5ГГц , 16GB, GPS, ИК, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 8.1/2.2Мпикс, Android 4.4, 213.3*123.6*6.4мм, 270г, белый' as name,229.72 as usPrice,13990 as ruPrice,12 as garant from dual union all
    select 958283 as id,'Планшет  9.7" Apple iPad Air 2 Demo (3A141RU), 2048*1536, A8X 1.5ГГц, 16GB, BT, WiFi, 2 камеры 8/1.2Мпикс, золотистый' as name,400.49 as usPrice,24390 as ruPrice,1 as garant from dual union all
    select 958284 as id,'Планшет  7.9" Apple iPad mini 3 Demo (3A136RU), 2048*1536, A7 1.3ГГц, 16GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, золотистый' as name,295.4 as usPrice,17990 as ruPrice,1 as garant from dual union all
    select 969052 as id,'Планшет  7" Samsung Galaxy Tab 4 (SM-T231NYKASER), 1280*800, Samsung 1.2ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 3/1.3Мпикс, Android 4.2, 107*186*9мм 281г, 10ч, черный' as name,159.11 as usPrice,9690 as ruPrice,12 as garant from dual union all
    select 973339 as id,'Планшет 10.1" ASUS Transformer Pad (TF103CG-1A056A), 1280*800, intel 1.6ГГц, 8GB, BT, 3G, WiFi, SD/SD-micro, 2/0.3Мпикс, Android 4.4, 257.3*178.4*9.9мм 550г черный' as name,131.2 as usPrice,7990 as ruPrice,12 as garant from dual union all
    select 973353 as id,'Планшет  8" Acer Iconia Tab 8 (A1-840FHD-17RT), 1920*1080, Intel 1.8ГГц, 16GB, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/2Мпикс, Android 4.4, серебристый' as name,180.46 as usPrice,10990 as ruPrice,12 as garant from dual union all
    select 974551 as id,'Планшет 10.1" ASUS Transformer Pad (TF103CG-1A059A), 1280*800, intel 1.33ГГц, 8GB, BT, 3G, WiFi, SD/SD-micro, 2/0.3Мпикс, клавиатура, Android 4.4, 257.3*178.4*9.9мм 550г черный' as name,246.14 as usPrice,14990 as ruPrice,12 as garant from dual union all
    select 976903 as id,'Планшет  7" Irbis TX16, 1280*800, ARM 1.5ГГц, 8GB, 4G/3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5.1 черный' as name,65.52 as usPrice,3990 as ruPrice,12 as garant from dual union all
    select 977326 as id,'Планшет  7" ASUS ZenPad C 7.0 (Z170C-1B009A), 1024*600, intel 1.2ГГц, 8GB, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5, белый' as name,110.84 as usPrice,6750 as ruPrice,12 as garant from dual union all
    select 978535 as id,'Планшет  8" Irbis TX81, 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 4.2, черный' as name,72.09 as usPrice,4390 as ruPrice,12 as garant from dual union all
    select 985138 as id,'Планшет  7.9" Apple iPad mini 4 (MK6Y2RU/A), 2048*1536, A8 1.4ГГц, 16GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 8/1.2Мпикс, 134.8*203.2*6.1мм 304г, 9ч, серый' as name,523.81 as usPrice,31900 as ruPrice,12 as garant from dual union all
    select 986899 as id,'Планшет 10.1" Archos 101b Copper, 1024*600, ARM 1.3ГГц, 8GB, 3G, BT, WiFi, SD-micro, 2 камеры 2/0.3Мпикс,  Android 4.4, 262*166*10мм 577г, серый' as name,112.48 as usPrice,6850 as ruPrice,12 as garant from dual union all
    select 987821 as id,'Планшет  7" Prestigio MultiPad WIZE 3757, 1280*800, intel 1.2ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 186*115*9.5мм 280г черный' as name,97.7 as usPrice,5950 as ruPrice,12 as garant from dual union all
    select 989104 as id,'Планшет 10.1" Irbis TW31, 1280*800, Intel 1.8ГГц, 32GB, 3G, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс,  W10, клавиатура, 170*278*10мм 600г, черный' as name,180.46 as usPrice,10990 as ruPrice,12 as garant from dual union all
    select 992535 as id,'Планшет  9.6" Samsung Galaxy Tab E (SM-T561NZKASER), 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/2Мпикс, Android 4.4, 242*149.5*8.5мм 495г, черный' as name,213.3 as usPrice,12990 as ruPrice,12 as garant from dual union all
    select 993311 as id,'Планшет 10.1" ASUS Transformer Book (T100HA-FU002T), 1280*800, Intel 1.44ГГц, 32GB,  BT, WiFi, SDHC-micro, microHDMI, 2 камеры 5/2Мпикс, W10, док-станция, клавиатура, 263*171*11мм 550гр, серый' as name,311.82 as usPrice,18990 as ruPrice,12 as garant from dual union all
    select 996857 as id,'Планшет 10.1" Prestigio Visconte 4U (XIPMP1011TDBK), 1280*800, Intel 1.8ГГц, 16GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс, W10, клавиатура, 256*173.6*10.5мм 580г, черный' as name,131.2 as usPrice,7990 as ruPrice,12 as garant from dual union all
    select 998059 as id,'Планшет  7" Samsung Galaxy Tab 4 (SM-T231NZWASER), 1280*800, Samsung 1.2ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 3/1.3Мпикс, Android 4.2, 107*186*9мм 281г, 10ч, белый' as name,159.11 as usPrice,9690 as ruPrice,12 as garant from dual union all
    select 1001656 as id,'Планшет  9.7" Apple iPad Pro (MM172RU/A), 2048*1536, A9X 2.26ГГц, 32GB, BT, WiFi, 2 камеры 12/5Мпикс, 169.5*240*6.1мм437г, 10ч, розовое золото' as name,714.12 as usPrice,43490 as ruPrice,12 as garant from dual union all
    select 1004601 as id,'Планшет  7" Samsung Galaxy Tab A (SM-T285NZKASER), 1280*800, Samsung 1.3ГГц, 8GB, 4G/3G, GPS, BT, WiFi, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 109*187*8.7мм 285г, 10ч, черный' as name,164.04 as usPrice,9990 as ruPrice,12 as garant from dual union all
    select 1004602 as id,'Планшет  7" Samsung Galaxy Tab A (SM-T285NZSASER), 1280*800, Samsung 1.3ГГц, 8GB, 4G/3G, GPS, BT, WiFi, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 109*187*8.7мм 285г, 10ч, серебристый' as name,164.04 as usPrice,9990 as ruPrice,12 as garant from dual union all
    select 1004675 as id,'Планшет  8" Prestigio MultiPad Wize (PMT3108) + CNE-CSPB26W, 1280*800, intel 1.2ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 207*123*8.8мм, 356гр, черный' as name,103.28 as usPrice,6290 as ruPrice,12 as garant from dual union all
    select 1006226 as id,'Планшет  7" Prestigio MultiPad Color Wize 3797, 1280*800, intel 1.2ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 190*115*9.5мм 270г, серый' as name,73.73 as usPrice,4490 as ruPrice,12 as garant from dual union all
    select 1007808 as id,'Планшет 10.1" ASUS ZenPad 10 (Z300CG-1A047A), 1280*800, intel 1.2ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5, 251*172*7.9мм 510г, черный' as name,190.31 as usPrice,11590 as ruPrice,12 as garant from dual union all
    select 1010495 as id,'Планшет 10.1" ASUS ZenPad 10 (Z300M-6A056A), 1280*800, MTK 1.3ГГц, 8GB, BT,  WiFi, SD/SD-micro, 2/5Мпикс, Android 6, 251.6*172*7.9мм 490г, черный' as name,201.15 as usPrice,12250 as ruPrice,12 as garant from dual union all
    select 1010863 as id,'Планшет 10.1" Prestigio Visconte V (VMPMP1012TERD), 1280*800, Intel 1.83ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс, W10, клавиатура, 260*161*9.5мм 594г, коричневый/красный' as name,164.04 as usPrice,9990 as ruPrice,12 as garant from dual union all
    select 1011232 as id,'Планшет  7" Irbis TZ71, 1024*600, ARM 1ГГц, 8GB, 4G/3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 0.3/2Мпикс, Android 5.1, 119.2*191.8*10.7мм 280г, черный' as name,65.52 as usPrice,3990 as ruPrice,12 as garant from dual union all
    select 1013518 as id,'Планшет  7" Prestigio MultiPad Wize (PMT3137), 1024*600, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 191.8*119.2*10.7мм 320г, черный' as name,63.88 as usPrice,3890 as ruPrice,12 as garant from dual union all
    select 1016352 as id,'Планшет  8" Prestigio MultiPad Wize (PMT3508), 1280*800, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 206*122.8*10мм, 360гр, серый' as name,108.21 as usPrice,6590 as ruPrice,12 as garant from dual union all
    select 1018681 as id,'Планшет  7" Prestigio MultiPad Wize 3407, 1024*600, intel 1.3ГГц, 8GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 188*108*10.5мм 310г, черный' as name,96.72 as usPrice,5890 as ruPrice,12 as garant from dual union all
    select 1022835 as id,'Планшет  7" Lenovo Tab 3 TB3-730X (ZA130004RU), 1024*600,  MTK 1ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 6, 101*191*98мм 260г, белый' as name,139.41 as usPrice,8490 as ruPrice,12 as garant from dual union all
    select 1023625 as id,'Планшет  8" Prestigio MultiPad Wize (PMT3208), 1280*800, intel 1.1ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 208.2*126.2*10мм, 613гр, черный' as name,98.36 as usPrice,5990 as ruPrice,12 as garant from dual union all
    select 1026075 as id,'Планшет 10.1" Archos 101c Copper, 1024*600, ARM 1.3ГГц, 16GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 2/0.3Мпикс,  Android 5.1, 259*150*9.8мм 450г, синий' as name,112.48 as usPrice,6850 as ruPrice,12 as garant from dual union all
    select 1026086 as id,'Планшет  7" Archos 70c Xenon, 1024*600, ARM 1.3ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 2/0.3Мпикс,  Android 5.1, 190*110*10мм 242г, серебристый' as name,64.04 as usPrice,3900 as ruPrice,12 as garant from dual union all
    select 1026959 as id,'Планшет  7" Prestigio MultiPad  Wize 3787, 1280*800, intel 1.1ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 190*115*9.5мм 270г, черный' as name,77.01 as usPrice,4690 as ruPrice,12 as garant from dual union all
    select 1027852 as id,'Планшет  8" Prestigio MultiPad Grace (PMT3118), 1280*800, MTK 1.1ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 206*123*10мм, 343гр, черный' as name,91.79 as usPrice,5590 as ruPrice,12 as garant from dual union all
    select 1029586 as id,'Планшет 10.1" Lenovo Yoga Book (YB1-X91F), 1920*1200, Intel 1.44ГГц, 64GB, BT, WiFi, GPS, SD-micro, 2 камеры 8/2Мпикс, клавиатура, W10, 256*170.8*9.6мм 690г, черный' as name,788.01 as usPrice,47990 as ruPrice,12 as garant from dual union all
    select 1029979 as id,'Планшет 10.1" Prestigio MultiPad Wize (PMT3131), 1280*800, MTK 1.13ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 261*155*9.8мм, 554гр, черный' as name,114.78 as usPrice,6990 as ruPrice,12 as garant from dual union all
    select 1032330 as id,'Планшет  8" Prestigio MultiPad Wize (PMT3508), 1280*800, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 206*122.8*10мм, 360гр, черный' as name,109.85 as usPrice,6690 as ruPrice,12 as garant from dual union all
    select 1032331 as id,'Планшет 10.1" Prestigio MultiPad Wize (PMT3401), 1280*800, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 261*162*11.6мм, 400гр, черный' as name,98.36 as usPrice,5990 as ruPrice,12 as garant from dual union all
    select 1043255 as id,'Планшет  7" Prestigio MultiPad  Wize 3787, 1280*800, intel 1.1ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 190*115*9.5мм 270г, серый' as name,77.01 as usPrice,4690 as ruPrice,12 as garant from dual union all
    select 1045808 as id,'Планшет  8" Prestigio MultiPad Wize (PMT3418), 1280*800, MTK 1.1ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 6, 206*122.8*10мм, 360гр, черный' as name,116.42 as usPrice,7090 as ruPrice,12 as garant from dual union all
    select 1045845 as id,'Планшет 11.6" Prestigio Visconte S (UEPMP1020CESR), 1920*1080, Intel 1.84ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/2Мпикс, W10, клавиатура, 260*186*9.75мм 684г, серый' as name,229.72 as usPrice,13990 as ruPrice,12 as garant from dual union all
    select 1047674 as id,'Планшет 10.1" Prestigio Visconte A (WCPMP1014TEDG), 1280*800, Intel 1.83ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс, W10, клавиатура, 259.3*173.5*10.1мм 575г, серый' as name,147.62 as usPrice,8990 as ruPrice,12 as garant from dual union all
    select 1049102 as id,'Планшет  7" Tesla Element 7.0, 1024*600, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, камера 0.3Мпикс, Android 4.4, 188*108*10.5мм 311г, черный' as name,53.37 as usPrice,3250 as ruPrice,12 as garant from dual union all
    select 1049207 as id,'Планшет  8" Lenovo Tab 4 TB-8504X (ZA2D0036RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 211*124.2мм 310г, черный' as name,196.88 as usPrice,11990 as ruPrice,12 as garant from dual union all
    select 1049208 as id,'Планшет 10.1" Lenovo Tab 4 TB-X304L (ZA2K0056RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 247*170*8.4мм 505г, черный' as name,215.11 as usPrice,13100 as ruPrice,12 as garant from dual union all
    select 1049218 as id,'Планшет  7" Prestigio MultiPad Grace (PMT3157), 1280*720, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 186*115*9.5мм 280г черный' as name,73.73 as usPrice,4490 as ruPrice,12 as garant from dual union all
    select 1050082 as id,'Планшет 10.1" Prestigio MultiPad Grace (PMT3101), 1280*800, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 243*171*10мм, 545гр, черный' as name,132.18 as usPrice,8050 as ruPrice,12 as garant from dual union all
    select 1050862 as id,'Планшет  7" Lenovo Tab 3 TB3-710I Essential (ZA0S0023RU), 1024*600, MTK 1.3ГГц, 8GB, BT, WiFi, 3G, GPS, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 113*190*10мм 300г, черный' as name,106.57 as usPrice,6490 as ruPrice,12 as garant from dual union all
    select 1051243 as id,'Планшет  8" Tesla Element 8.0 3G, 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 4.4, 207*123.5*9.8мм 420г, черный' as name,66.5 as usPrice,4050 as ruPrice,12 as garant from dual union all
    select 1051245 as id,'Планшет 10.1" Tesla Impulse 10.1 3G, 1280*800, ARM 1.2ГГц, 8GB, 3G, GSM, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 242.3*171.2*9.5мм 560г, черный' as name,91.79 as usPrice,5590 as ruPrice,12 as garant from dual union all
    select 1056279 as id,'Планшет  7" Prestigio MultiPad Grace (PMT3157), 1280*720, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 186*115*9.5мм 280г черный' as name,98.36 as usPrice,5990 as ruPrice,12 as garant from dual union all
    select 1056280 as id,'Планшет  8" Prestigio MultiPad Muze (PMT3708), 1280*800, MTK 1.3ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 206*122.8*10мм, 360гр, черный' as name,98.36 as usPrice,5990 as ruPrice,12 as garant from dual union all
    select 1056780 as id,'Планшет  8" Tesla Impulse 8.0 3G, 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 4.4, 208*123.5*11мм 420г, черный' as name,70.44 as usPrice,4290 as ruPrice,12 as garant from dual union all
    select 1057110 as id,'Планшет  7" Lenovo Tab 4 TB-7304i Essential (ZA310031RU), 1024*600, MTK 1.3ГГц, 16GB, BT, WiFi, 3G, GPS, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 102*194.8*8.8мм 254г, черный' as name,109.2 as usPrice,6650 as ruPrice,12 as garant from dual union all
    select 1058388 as id,'Планшет 10.1" Prestigio MultiPad Wize (PMT3131), 1280*800, MTK 1.13ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 261*155*9.8мм, 554гр, черный' as name,106.57 as usPrice,6490 as ruPrice,12 as garant from dual union all
    select 1058896 as id,'Планшет 10.1" Prestigio MultiPad Grace (PMT3201), 1280*800, MTK 1ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 243*171*10мм, 545гр, черный' as name,139.41 as usPrice,8490 as ruPrice,12 as garant from dual union all
    select 1058905 as id,'Планшет 10.1" Lenovo Tab 4 TB-X304L (ZA2K0082RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 247*170*8.4мм 505г, белый' as name,213.3 as usPrice,12990 as ruPrice,12 as garant from dual union all
    select 1058906 as id,'Планшет  8" Lenovo Tab 4 TB-8504X (ZA2D0059RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 211*124.2мм 310г, белый' as name,196.88 as usPrice,11990 as ruPrice,12 as garant from dual union all
    select 1061881 as id,'Планшет  8" Prestigio MultiPad Muze (PMT3708), 1280*800, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 206*122.8*10мм, 360гр, черный' as name,91.79 as usPrice,5590 as ruPrice,12 as garant from dual union all
    select 1062393 as id,'Планшет  8" Lenovo Yoga Tablet YT3-850M (ZA0B0044RU), 1280*800, MTK 1ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, камера 8Мпикс, Android 6, 213*144*9мм 329г, черный' as name,246.14 as usPrice,14990 as ruPrice,12 as garant from dual
;
