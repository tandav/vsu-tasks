-- task 1 --------------------------------------------------------------------------------
-- В анонимном PL/SQL блоке распечатать все пифагоровы числа, меньшие 25
-- (для печати использовать пакет dbms_output, процедуру put_line).
DECLARE
  N INTEGER := 24;
BEGIN 
  FOR A IN 1..N LOOP
    FOR B IN A..N LOOP
      FOR C IN B..N LOOP
        IF C*C = A*A + B*B THEN
          DBMS_OUTPUT.PUT_LINE(A||', '||B||', '||C);
        END IF;
      END LOOP;
    END LOOP;
  END LOOP;
END;

-- task 2 --------------------------------------------------------------------------------
-- Переделать предыдущий пример, чтобы для определения, что 3 числа пифагоровы
-- использовалась функция.
DECLARE
  N INTEGER := 24;
FUNCTION CHECK_PIFAGOR(
  p_A INTEGER,
  p_B INTEGER,
  p_C INTEGER
) 
RETURN BOOLEAN
IS
BEGIN
    RETURN p_C * p_C = p_A * p_A + p_B * p_B;
END;

  
BEGIN
  DBMS_OUTPUT.ENABLE;  
  FOR A IN 1..N LOOP
    FOR B IN A..N LOOP
      FOR C IN B..N LOOP
        IF CHECK_PIFAGOR(A, B, C) THEN
          DBMS_OUTPUT.PUT_LINE(A||', '||B||', '||C);
        END IF;
      END LOOP;
    END LOOP;
  END LOOP;
END;

-- task 3 --------------------------------------------------------------------------------
-- Написать хранимую процедуру, которой передается ID сотрудника и которая
-- увеличивает ему зарплату на 10%, если в 2000 году у сотрудника были продажи.
-- Использовать выборку количества заказов за 2000 год в переменную. А затем,
-- если переменная больше 0, выполнить update данных.
CREATE OR REPLACE PROCEDURE SALARY_PLUS(
  p_EMP_ID NUMERIC
)
IS
  ORDER_COUNT NUMBER;
BEGIN
  SELECT COUNT(*) INTO ORDER_COUNT
    FROM ORDERS O
    WHERE p_EMP_ID = O.SALES_REP_ID AND
          O.ORDER_DATE >= DATE'2000-01-01' AND 
          O.ORDER_DATE <  DATE'2001-01-01';
  IF ORDER_COUNT > 0 THEN
    UPDATE EMPLOYEES E
      SET E.SALARY = E.SALARY * 1.1
      WHERE E.EMPLOYEE_ID = p_EMP_ID;
  END IF;
END;


-- task 4 --------------------------------------------------------------------------------
-- Проверить корректность данных о заказах, а именно, что поле ORDER_TOTAL
-- равно сумме UNIT_PRICE * QUANTITY по позициям каждого заказа. Для этого создать
-- хранимую процедуру, в которой будет в цикле for проход по всем заказам, далее по
-- конкретному заказу отдельным select-запросом будет выбираться сумма по позициям
-- данного заказа и сравниваться с ORDER_TOTAL. Для «некорректных» заказов
-- распечатать код заказа, дату заказа, заказчика и менеджера.
CREATE OR REPLACE PROCEDURE CHECK_ORDERS_TOTAL
IS 
  v_SUMM     NUMBER;
  v_DATA_    TIMESTAMP;
  v_CUSTOMER VARCHAR2(100);
  v_MANAGER  VARCHAR2(100);

BEGIN
  FOR i_ORD IN (
    SELECT *
      FROM ORDERS
  ) LOOP
    SELECT SUM(OI.UNIT_PRICE*OI.QUANTITY) INTO v_SUMM
      FROM ORDER_ITEMS OI
      WHERE OI.ORDER_ID=i_ORD.ORDER_ID;
      
    IF i_ORD.ORDER_TOTAL <> nvl(v_SUMM, 0) THEN
      
      SELECT  C.CUST_FIRST_NAME || ' ' || C.CUST_LAST_NAME INTO v_CUSTOMER
        FROM  CUSTOMERS C 
        where C.CUSTOMER_ID = i_ORD.CUSTOMER_ID;
        
      SELECT  O.ORDER_DATE INTO v_DATA_
        FROM  ORDERS O
        WHERE O.ORDER_ID = i_ORD.ORDER_ID;
        
      SELECT E.FIRST_NAME || ' ' || E.LAST_NAME INTO v_MANAGER
        FROM ORDERS O INNER JOIN EMPLOYEES E ON O.SALES_REP_ID=E.EMPLOYEE_ID
        WHERE O.ORDER_ID = i_ORD.ORDER_ID;
    
      DBMS_OUTPUT.PUT_LINE('КОД ЗАКАЗА: '||i_ORD.ORDER_ID||' ДАТА: '||v_DATA_||' ЗАКАЗЧИК :'||v_CUSTOMER||' МЕНЕДЖЕР: '||v_MANAGER);
    END IF;
  END LOOP;
END;

-- task 5 --------------------------------------------------------------------------------
-- Переписать предыдущее задание с использованием явного курсора
CREATE OR REPLACE PROCEDURE CHECK_ORDERS_TOTAL_CURSOR
AS
  CURSOR CURSOR_ORD IS
    SELECT  O.ORDER_ID,
            O.ORDER_DATE, 
            O.ORDER_TOTAL,
            E.FIRST_NAME || ' ' || E.LAST_NAME AS MANAGER,
            C.CUST_FIRST_NAME || ' ' || C.CUST_LAST_NAME AS CUSTOMER         
      FROM  ORDERS O 
            INNER JOIN CUSTOMERS C 
              ON O.CUSTOMER_ID=C.CUSTOMER_ID
            INNER JOIN EMPLOYEES E 
              ON O.SALES_REP_ID=E.EMPLOYEE_ID;
    v_ORD_SUM NUMBER;
  
BEGIN    
  FOR i_ORD IN CURSOR_ORD LOOP
    SELECT  SUM(OI.UNIT_PRICE * OI.QUANTITY) INTO v_ORD_SUM
      FROM  ORDER_ITEMS OI
      WHERE OI.ORDER_ID=i_ORD.ORDER_ID;     
    IF v_ORD_SUM <> i_ORD.ORDER_TOTAL THEN
      DBMS_OUTPUT.PUT_LINE('КОД ЗАКАЗА: '||i_ORD.ORDER_ID||' ДАТА: '||i_ORD.ORDER_DATE||' ЗАКАЗЧИК :'||i_ORD.CUSTOMER||' МЕНЕДЖЕР: '||i_ORD.MANAGER);
    END IF;
  END LOOP;
END;

-- task 6 --------------------------------------------------------------------------------
-- Написать функцию, в которой будет создан тестовый клиент, которому будет
-- сделан заказ на текущую дату из одной позиции каждого товара на складе.
-- Имя тестового клиента и ID склада передаются в качестве параметров.
Функция возвращает ID созданного клиента.*/
DECLARE
FUNCTION CREATE_CLIENT(p_CUSTOMER_NAME IN VARCHAR2, p_CUSTOMER_SURNAME IN VARCHAR2, p_WAREHOUSE_ID IN NUMBER)
RETURN NUMBER
IS 
  v_NEW_CUSTOMER_ID NUMBER;
  v_NEW_ORDER_ID NUMBER;
  v_SUM NUMBER:=0;
BEGIN

  INSERT INTO CUSTOMERS C(C.CUST_FIRST_NAME, C.CUST_LAST_NAME) 
    VALUES(p_CUSTOMER_NAME, p_CUSTOMER_SURNAME)
    RETURNING CUSTOMER_ID INTO v_NEW_CUSTOMER_ID;

  INSERT INTO ORDERS O(O.CUSTOMER_ID, O.ORDER_DATE) 
    VALUES(v_NEW_CUSTOMER_ID, SYSDATE)
    RETURNING ORDER_ID INTO v_NEW_ORDER_ID;
    
  UPDATE ORDERS 
    SET ORDER_TOTAL=v_SUM
    WHERE ORDER_ID=v_NEW_ORDER_ID;

  FOR i_PROD IN (
    SELECT  I.PRODUCT_ID, PI.LIST_PRICE
      FROM  WAREHOUSES W 
            INNER JOIN INVENTORIES I 
              ON W.WAREHOUSE_ID=I.WAREHOUSE_ID
            INNER JOIN PRODUCT_INFORMATION PI
              ON  PI.PRODUCT_ID=I.PRODUCT_ID
      WHERE W.WAREHOUSE_ID=P_WAREHOUSE_ID
  ) LOOP         
    INSERT INTO ORDER_ITEMS OI(OI.ORDER_ID,OI.PRODUCT_ID) 
      VALUES(v_NEW_ORDER_ID,i_PROD.PRODUCT_ID);
    
  END LOOP;

  RETURN v_NEW_CUSTOMER_ID;
END;


BEGIN
DBMS_OUTPUT.ENABLE;
DBMS_OUTPUT.PUT_LINE(CREATE_CLIENT('NET','CRACKER',2));
END;

-- task 7 --------------------------------------------------------------------------------
-- Добавить в предыдущую функцию проверку на существование склада с
-- переданным ID. Для этого выбрать склад в переменную типа «запись о складе» и
-- перехватить исключение no_data_found, если оно возникнет. В обработчике
-- исключения выйти из функции, вернув null.*/
DECLARE
  v_IDCUSTOMER NUMBER;
  v_IDORDER NUMBER;
  v_LINEITEMID NUMBER;
  v_COUNTER NUMBER := 1;
  FUNCTION ADDTOVAR_EXCEPT(NAMECUSTOMER IN VARCHAR2, P_IDWAR IN NUMBER)
    RETURN NUMBER
  IS
    v_IDCUSTOMER NUMBER;
    CURSOR ID_TOVAR IS
      SELECT I.PRODUCT_ID,(
                            SELECT PI.LIST_PRICE
                            FROM  PRODUCT_INFORMATION PI
                            WHERE  PI.PRODUCT_ID = I.PRODUCT_ID
                          ) AS LIST_PRICE
      FROM WAREHOUSES W INNER JOIN INVENTORIES I ON W.WAREHOUSE_ID=I.WAREHOUSE_ID
      WHERE W.WAREHOUSE_ID=P_IDWAR;

    ROWWAREHOUSES  WAREHOUSES%ROWTYPE;
    BEGIN
      BEGIN
        SELECT * INTO ROWWAREHOUSES
        FROM WAREHOUSES
        WHERE WAREHOUSE_ID = P_IDWAR;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN NULL;
      END;

      INSERT INTO CUSTOMERS C(C.CUST_FIRST_NAME, C.CUST_LAST_NAME)
      VALUES(NAMECUSTOMER, 'TEST')
      RETURNING CUSTOMER_ID INTO v_IDCUSTOMER;

      INSERT INTO ORDERS(CUSTOMER_ID, ORDER_DATE)
      VALUES(v_IDCUSTOMER,SYSDATE)
      RETURNING ORDER_ID INTO v_IDORDER;

      FOR REC IN ID_TOVAR LOOP
        INSERT INTO ORDER_ITEMS(ORDER_ID,LINE_ITEM_ID, PRODUCT_ID,UNIT_PRICE,QUANTITY)
        VALUES(v_IDORDER,v_COUNTER, REC.PRODUCT_ID,REC.LIST_PRICE,1);
        v_COUNTER :=v_COUNTER + 1;
      END LOOP;

      RETURN v_IDCUSTOMER;
    END;


BEGIN
  DBMS_OUTPUT.ENABLE;
  DBMS_OUTPUT.PUT_LINE(ADDTOVAR_EXCEPT('asdf',3));
END;












-- task 8 --------------------------------------------------------------------------------
-- Написанные процедуры и функции объединить в пакет FIRST_PACKAGE.*/
CREATE OR REPLACE PACKAGE FIRST_PACKAGE AS
FUNCTION CHECK_PIFAGOR(A INTEGER,B INTEGER,C INTEGER)
  RETURN BOOLEAN;
  PROCEDURE SALARY_PLUS(EMP_ID NUMERIC);
  PROCEDURE CHECK_ORDERS_TOTAL;
  PROCEDURE CHECK_ORDERS_TOTAL_CURSOR;
  
  FUNCTION CREATE_CLIENT(
      CUSTOMER_NAME IN VARCHAR2,
      CUSTOMER_SURNAME IN VARCHAR2,
      V_WAREHOUSE_ID IN NUMBER
  ) RETURN NUMBER;
  
  FUNCTION CREATE_CLIENT_2(CUSTOMER_NAME IN VARCHAR2, CUSTOMER_SURNAME IN VARCHAR2, V_WAREHOUSE_ID IN NUMBER)
    RETURN NUMBER;
END;

CREATE OR REPLACE PACKAGE BODY FIRST_PACKAGE AS
  FUNCTION CHECK_PIFAGOR(
    A INTEGER,
    B INTEGER,
    C INTEGER
  ) 
  RETURN BOOLEAN
  IS
   RES BOOLEAN;
  BEGIN
    RES:=FALSE;
    IF C*C = A*A + B*B THEN 
      RES:=TRUE;
    END IF;    
    RETURN RES;
  END;

  PROCEDURE SALARY_PLUS(
    EMP_ID NUMERIC
  )
  IS
    ORDER_COUNT NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ORDER_COUNT
      FROM ORDERS O
      WHERE EMP_ID=O.SALES_REP_ID AND 
            O.ORDER_DATE >= DATE'2000-01-01' AND 
            O.ORDER_DATE < DATE'2001-01-01';
    IF ORDER_COUNT > 0 THEN
      UPDATE EMPLOYEES E
        SET E.SALARY = E.SALARY*1.1
        WHERE E.EMPLOYEE_ID = EMP_ID;
    END IF;
  END;
  
  PROCEDURE CHECK_ORDERS_TOTAL
  IS 
    SUMM NUMBER;
    CODE INTEGER;
    DATA_ TIMESTAMP;
    CUSTOMER VARCHAR2(100);
    MANAGER VARCHAR2(100);

  BEGIN
    FOR ORD IN (
      SELECT *
        FROM ORDERS
    ) LOOP
      SELECT SUM(OI.UNIT_PRICE*OI.QUANTITY) INTO SUMM
        FROM ORDER_ITEMS OI
        WHERE OI.ORDER_ID=ORD.ORDER_ID;
      
      IF ORD.ORDER_TOTAL<>SUMM THEN 
        SELECT  C.CUST_FIRST_NAME || ' ' || C.CUST_LAST_NAME INTO CUSTOMER             
          FROM  CUSTOMERS C 
          WHERE C.CUSTOMER_ID = ORD.CUSTOMER_ID;
        
        SELECT  O.ORDER_DATE INTO DATA_
          FROM  ORDERS O
          WHERE O.ORDER_ID = ORD.ORDER_ID;
        
        SELECT E.FIRST_NAME || ' ' || E.LAST_NAME INTO MANAGER
          FROM ORDERS O INNER JOIN EMPLOYEES E ON O.SALES_REP_ID=E.EMPLOYEE_ID
          WHERE O.ORDER_ID = ORD.ORDER_ID;
    
        DBMS_OUTPUT.PUT_LINE('КОД ЗАКАЗА: '||ORD.ORDER_ID||' ДАТА: '||DATA_||' ЗАКАЗЧИК :'||CUSTOMER||' МЕНЕДЖЕР: '||MANAGER);
      END IF;
    END LOOP;
  END;
  
  PROCEDURE CHECK_ORDERS_TOTAL_CURSOR
  AS
    CURSOR CURSOR_ORD IS
      SELECT  O.ORDER_ID,
              O.ORDER_DATE, 
              O.ORDER_TOTAL,
              E.FIRST_NAME || ' ' || E.LAST_NAME AS MANAGER,
              C.CUST_FIRST_NAME || ' ' || C.CUST_LAST_NAME AS CUSTOMER         
        FROM  ORDERS O 
            INNER JOIN CUSTOMERS C 
              ON O.CUSTOMER_ID=C.CUSTOMER_ID
            INNER JOIN EMPLOYEES E 
              ON O.SALES_REP_ID=E.EMPLOYEE_ID;
      ORD_SUM NUMBER;
  
  BEGIN    
    FOR ORD IN CURSOR_ORD 
    LOOP
      SELECT  SUM( OI.UNIT_PRICE*OI.QUANTITY ) INTO ORD_SUM
        FROM  ORDER_ITEMS OI
        WHERE OI.ORDER_ID=ORD.ORDER_ID;     
      IF (ORD_SUM<>ORD.ORDER_TOTAL)
        THEN DBMS_OUTPUT.PUT_LINE('КОД ЗАКАЗА: '||ORD.ORDER_ID||' ДАТА: '||ORD.ORDER_DATE||' ЗАКАЗЧИК :'||ORD.CUSTOMER||' МЕНЕДЖЕР: '||ORD.MANAGER);
      END IF;
    END LOOP;
  END;

  FUNCTION CREATE_CLIENT(CUSTOMER_NAME IN VARCHAR2, CUSTOMER_SURNAME IN VARCHAR2, V_WAREHOUSE_ID IN NUMBER)
    RETURN NUMBER
  IS 
    NEW_CUSTOMER_ID NUMBER;
    NEW_ORDER_ID NUMBER;
    
  BEGIN

    INSERT INTO CUSTOMERS C(C.CUST_FIRST_NAME, C.CUST_LAST_NAME) 
      VALUES(CUSTOMER_NAME, CUSTOMER_SURNAME)
      RETURNING CUSTOMER_ID INTO NEW_CUSTOMER_ID;

    INSERT INTO ORDERS O(O.CUSTOMER_ID,O.ORDER_DATE) 
      VALUES(NEW_CUSTOMER_ID,TO_CHAR(SYSDATE,'DD.MM.YYYY HH24:MI:SS'))
      RETURNING ORDER_ID INTO NEW_ORDER_ID;

    FOR PROD IN (SELECT  I.PRODUCT_ID
      FROM  WAREHOUSES W 
          INNER JOIN INVENTORIES I 
            ON W.WAREHOUSE_ID=I.WAREHOUSE_ID
      WHERE W.WAREHOUSE_ID=V_WAREHOUSE_ID) LOOP         
      INSERT INTO ORDER_ITEMS OI(OI.ORDER_ID,OI.PRODUCT_ID) 
        VALUES(NEW_ORDER_ID,PROD.PRODUCT_ID);
    END LOOP;
    RETURN NEW_CUSTOMER_ID;
  END;

  FUNCTION CREATE_CLIENT_2(CUSTOMER_NAME IN VARCHAR2, CUSTOMER_SURNAME IN VARCHAR2, V_WAREHOUSE_ID IN NUMBER)
    RETURN NUMBER
  IS 
    NEW_CUSTOMER_ID NUMBER;
    NEW_ORDER_ID NUMBER;    
    ROW_WAREHOUSES  WAREHOUSES%ROWTYPE;
  BEGIN
    BEGIN
      SELECT * INTO ROW_WAREHOUSES
        FROM  WAREHOUSES 
        WHERE WAREHOUSE_ID = V_WAREHOUSE_ID;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
        RETURN NULL;
    END;
  
    INSERT INTO CUSTOMERS C(C.CUST_FIRST_NAME, C.CUST_LAST_NAME) 
      VALUES(CUSTOMER_NAME,CUSTOMER_SURNAME)
      RETURNING C.CUSTOMER_ID INTO NEW_CUSTOMER_ID;
    
    INSERT INTO ORDERS O(O.CUSTOMER_ID,O.ORDER_DATE) 
      VALUES(NEW_CUSTOMER_ID,TO_CHAR(SYSDATE,'DD.MM.YYYY HH24:MI:SS'))
      RETURNING ORDER_ID INTO NEW_ORDER_ID;
    
    FOR REC IN (SELECT  I.PRODUCT_ID
        FROM  WAREHOUSES W 
          INNER JOIN INVENTORIES I 
            ON  W.WAREHOUSE_ID=I.WAREHOUSE_ID
        WHERE W.WAREHOUSE_ID=V_WAREHOUSE_ID) LOOP         
      INSERT INTO ORDER_ITEMS OI(OI.ORDER_ID,OI.PRODUCT_ID) 
        VALUES(NEW_ORDER_ID,REC.PRODUCT_ID);
    END LOOP;  
    RETURN NEW_CUSTOMER_ID;
  END;
END;
