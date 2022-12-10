-- нужно написать функцию которая посчитает количество
-- подчиненных данного сотрудника


CREATE OR REPLACE
function fn_sb_count(
  p_employee_id in employees.employee_id%type
) RETURN INT
  is r_result int := 0;
  BEGIN
    FOR i
  END;


--------------------------------------------------------
-- emplyee customer role type
-- в переменную записываем клиента, если не найден - исключение
-- меняем поля клиента, добавляем суффикс копия
--                               |
--                               v
-- insert into customers values(   )