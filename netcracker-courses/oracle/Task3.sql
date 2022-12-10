/*
1. Выбрать с помощью иерархического запроса сотрудников 3-его уровня иерархии (т.е. таких, у которых непосредственный 
начальник напрямую подчиняется руководителю организации). Упорядочить по коду сотрудника.
*/

select  e.employee_id,
        e.last_name||' '||e.first_name as emp_name,
        e.manager_id,
        prior(e.last_name||' '||e.first_name) as manager_name,
        level,
        sys_connect_by_path(e.last_name||' '||e.first_name, ' / ') as path
  from  employees e
  where level = 3
  start with  e.manager_id is null
  connect by nocycle  e.manager_id=prior(e.employee_id)
  order by e.employee_id
;

/*
2. Для каждого сотрудника выбрать всех его начальников по иерархии. Вывести поля: код сотрудника, имя сотрудника 
(фамилия + имя через пробел), код начальника, имя начальника (фамилия + имя через пробел), кол-во промежуточных 
начальников между сотрудником и начальником из данной строки выборки. Если у какого-то сотрудника есть несколько 
начальников, то для данного сотрудника в выборке должно быть несколько строк с разными начальниками. 
Упорядочить по коду сотрудника, затем по уровню начальника 
(первый – непосредственный начальник, последний – руководитель организации).
*/

select  e.employee_id,
        lpad(' ', (level-2)*4, ' ')||e.last_name||' '||e.first_name as employee_name,        
        connect_by_root e.employee_id as manager_id,
        connect_by_root (e.last_name || ' ' || e.first_name) as manager_name,
        sys_connect_by_path(e.last_name || ' ' || e.first_name, '/') as path,
        level,
        level - 2 as count_of_managers
  from  employees e
  where level > 1
  connect by nocycle  e.manager_id=prior(e.employee_id)
  order by  e.employee_id,
            level desc
;

/*
3. Для каждого сотрудника посчитать количество его подчиненных, как непосредственных, так и по иерархии. 
Вывести поля: код сотрудника, имя сотрудника (фамилия + имя через пробел), общее кол-во подчиненных.
*/

select  connect_by_root (e.employee_id) as employee_id,
        connect_by_root (e.last_name || ' ' || e.first_name) as employee_name
  from  employees e
  where level > 1
  connect by e.manager_id = prior(e.employee_id)
;

select  e.employee_id,
        e.last_name||' '||e.first_name as employee_name,
        (
          select  count(e1.employee_id)        
            from  employees e1
            where e.employee_id = e1.manager_id
            connect by  e1.employee_id=prior(e1.manager_id)
            group by e.employee_id
        ) as count_emp
  from  employees e
;

/*
4. Для каждого заказчика выбрать в виде строки через запятую даты его заказов. Для конкатенации дат 
заказов использовать sys_connect_by_path (иерархический запрос). Для отбора «последних» строк 
использовать connect_by_isleaf.
*/

with w_orders as (
  select  c.customer_id as cust_id,
          c.cust_last_name||' '||c.cust_first_name as cust_name,
          o.order_date,
          row_number() over(partition by o.customer_id order by o.order_date) rn                          
    from  customers c
          inner join orders o on
            o.customer_id=c.customer_id 
)
select  cust_id,
        cust_name,
        ltrim(sys_connect_by_path(order_date,', '),', ') as order_dates
  from  w_orders
  where connect_by_isleaf = 1
  start with rn = 1
  connect by cust_id = prior cust_id
         and rn = prior rn + 1
;

/*
5. Выполнить задание № 4 c помощью обычного запроса с группировкой и функцией listagg.
*/

select  c.customer_id,
        c.cust_last_name||' '||c.cust_first_name as cust_name,(
          select  listagg(o.order_date, ', ') within group (order by o.order_date)
            from orders o
            where o.customer_id=c.customer_id
        ) as order_dates        
  from  customers c
  order by  c.customer_id
;

/*
6. Выполнить задание № 2 с помощью рекурсивного запроса.
Для каждого сотрудника выбрать всех его начальников по иерархии. Вывести поля: код сотрудника, имя сотрудника 
(фамилия + имя через пробел), код начальника, имя начальника (фамилия + имя через пробел), кол-во промежуточных 
начальников между сотрудником и начальником из данной строки выборки. Если у какого-то сотрудника есть несколько 
начальников, то для данного сотрудника в выборке должно быть несколько строк с разными начальниками. 
Упорядочить по коду сотрудника, затем по уровню начальника 
(первый – непосредственный начальник, последний – руководитель организации).
*/

with w_cust(
       emp_id,
       emp_name,
       mgr_id,
       lvl,
       count_of_managers
      ) as (
             select  e1.employee_id,
                     e1.last_name || ' ' || e1.first_name,
                     e1.manager_id,
                     1,
                     0
               from  employees e1
            union all
             select  w.emp_id,
                     w.emp_name,
                     e.manager_id,
                     w.lvl + 1,
                     w.lvl
               from  w_cust w, employees e
               where e.employee_id = w.mgr_id
                 and e.manager_id is not null
           )
select  w.emp_id,
        w.emp_name,
        w.mgr_id,
        (
          select  e.last_name || ' ' || e.first_name 
            from employees e 
            where e.employee_id = w.mgr_id
        ) mgr_name,
        w.count_of_managers
  from  w_cust w
  order by w.emp_id,
           w.count_of_managers
;

with w_cust(
       emp_id,
       emp_name,
       mgr_id,
       mgr_name,
       connect_mgr_id,
       lvl
      ) as (
             select  e1.employee_id,
                     e1.last_name || ' ' || e1.first_name,
                     null,
                     null,
                     e1.manager_id,
                     1
               from  employees e1
            union all
             select  w.emp_id,
                     w.emp_name,
                     e.employee_id,
                     e.last_name || ' ' || e.first_name,
                     e.manager_id,
                     w.lvl + 1
               from  w_cust w, employees e
               where e.employee_id = w.connect_mgr_id
           )
select  w.emp_id,
        w.emp_name,
        w.mgr_id,
        w.mgr_name,
        w.lvl - 2 as count_of_managers
  from  w_cust w
  where mgr_id is not null
  order by w.emp_id,
           count_of_managers
;


/*
7. Выполнить задание № 3 с помощью рекурсивного запроса.
Для каждого сотрудника посчитать количество его подчиненных, как непосредственных, так и по иерархии. 
Вывести поля: код сотрудника, имя сотрудника (фамилия + имя через пробел), общее кол-во подчиненных.
*/

with
  emp_count (emp_id, emp_name, mgr_id, cnt_employees) as
  (
    select  employee_id,
            last_name || ' ' || first_name,
            manager_id,
            0 cnt_employees
      from  employees
  union all
    select  e.employee_id,
            e.last_name || ' ' || e.first_name,
            e.manager_id,
            1 cnt_employees
      from  emp_count ec, employees e
      where e.employee_id = ec.mgr_id
  )
select  emp_id,
        emp_name,
        sum(cnt_employees)
  from  emp_count
  group by emp_id,
           emp_name
  order by emp_id
;

/*
8. Каждому менеджеру по продажам сопоставить последний его заказ. Менеджером по продажам считаем сотрудников, 
код должности которых: «SA_MAN» и «SA_REP». Для выборки последних заказов по менеджерам использовать подзапрос 
с применением аналитических функций (например в подзапросе выбирать дату следующего заказа менеджера, а во 
внешнем запросе «оставить» только те строки, у которых следующего заказа нет). Вывести поля: код менеджера,
имя менеджера (фамилия + имя через пробел), код клиента, имя клиента (фамилия + имя через пробел), 
дата заказа, сумма заказа, количество различных позиций в заказе. Упорядочить данные по дате заказа в обратном 
порядке, затем по сумме заказа в обратном порядке, затем по коду сотрудника. Тех менеджеров, у которых нет заказов, 
вывести в конце.
*/

select distinct *
  from  (
          select  e.employee_id,
                  e.last_name || ' ' || e.first_name as emp_name,
                  last_value(o.order_date) over (
                  order by e.employee_id) as last_date,
                  o.order_total as total_sum,                
                  (
                    select count(oi.product_id)
                      from order_items oi
                      where oi.order_id = o.order_id
                  ) as count_items
            from  employees e 
                  left join orders o on
                    e.employee_id = o.sales_rep_id
            where (job_id = 'SA_MAN' or job_id = 'SA_REP')
      )
  order by  last_date desc,
            total_sum desc,
            employee_id
;

/*
9. Для каждого месяца текущего года найти первые и последние рабочие и выходные дни с учетом праздников и 
переносов выходных дней (на 2016 год эту информацию можно посмотреть, например, на странице 
http://www.interfax.ru/russia/469373). Для формирования списка всех дней текущего года использовать 
иерархический запрос, оформленный в виде подзапроса в секции with. Праздничные дни и переносы выходных 
также задать в виде подзапроса в секции with (с помощью union all перечислить все даты, в которых рабочие/выходные
дни не совпадают с обычной логикой определения выходного дня как субботы и воскресения). 
Запрос должен корректно работать, если добавить изменить какие угодно выходные/рабочие дни в данном подзапросе. 
Вывести поля: месяц в виде первого числа месяца, первый выходной день месяца, последний выходной день, 
первый праздничный день, последний праздничный день.
Задачи на манипулирование данными. (После выполнения запросов транзакции завершать необязательно, 
чтобы исходные данные не поменялись).
*/

with all_days as (
  select  trunc(sysdate, 'YY') + level - 1 as dt
    from  dual
    connect by trunc(trunc(sysdate, 'YY') + level - 1, 'YY') = trunc(sysdate, 'YY')
),
w_weekends as(
              select  date'2018-01-1' as dt, 1 as weekend from  dual union all
              select  date'2018-01-2' as dt, 1 from  dual union all
              select  date'2018-01-3' as dt, 1 from  dual union all
              select  date'2018-01-4' as dt, 1 from  dual union all
              select  date'2018-01-5' as dt, 1 from  dual union all
              select  date'2018-01-6' as dt, 1 from  dual union all
              select  date'2018-01-31' as dt, 1 from  dual union all
              select  date'2018-02-23' as dt, 1 from  dual union all
              select  date'2018-02-24' as dt, 1 from  dual union all
              select  date'2018-03-8' as dt, 1 from  dual union all 
              select  date'2018-05-1' as dt, 1 from  dual union all 
              select  date'2018-05-8' as dt, 1 from  dual union all 
              select  date'2018-05-9' as dt, 1 from  dual union all
              select  date'2018-06-12' as dt, 1 from  dual union all
              select  date'2018-11-6' as dt, 1 from  dual
              ),
w_inner as (
            select  all_days.dt as dt,
                    (
                      case             
                        when all_days.dt = any ( select w.dt 
                                                  from w_weekends w
                                                )
                          then 1                
                        else 0
                      end
                    ) as flag
              from  all_days
                    --left join w_weekends w on all_days.dt = w.dt
            )
select  distinct to_char(w_i.dt, 'MM') as number_month,
        (
          least(
                  trunc(w_i.dt, 'MM') + case trim(to_char(trunc(w_i.dt,'MM'), 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH'))   
                  when 'MONDAY' then 5
                  when 'TUESDAY' then 4
                  when 'WEDNESDAY' then 3
                  when 'THURSDAY' then 2
                  when 'FRIDAY' then 1
                  else 0
                  end,
                  nvl((
                    select w_i2.dt
                      from w_inner w_i2
                      where w_i2.flag = 1 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM') and rownum = 1
                    ), date'2018-12-31')
                )
            ) as first_day_off,       
            (
              greatest(
                        last_day(w_i.dt) - case trim(to_char(last_day(w_i.dt), 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH'))
                        when 'MONDAY' then 1
                        when 'TUESDAY' then 2
                        when 'WEDNESDAY' then 3
                        when 'THURSDAY' then 4
                        when 'FRIDAY' then 5
                        else 0
                        end,
                        nvl((
                          select max(w_i2.dt)
                            from w_inner w_i2
                            where w_i2.flag = 1 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM')
                          ), date'2018-01-01')
                      )
            ) as last_day_off,
            (
              greatest(                 
                      trunc(w_i.dt, 'MM') + case trim(to_char(trunc(w_i.dt,'MM'), 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH'))              
                      when 'SUNDAY' then 1
                      when 'SATURDAY' then 2              
                      else 0
                      end,
                        nvl((
                          select w_i2.dt
                            from w_inner w_i2
                            where w_i2.flag = 0 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM') and rownum = 1
                          ), date'2018-01-01')
                      )
                ) as first_work_day,
            (
              least(                 
                      last_day(w_i.dt) - case trim(to_char(last_day(w_i.dt), 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH'))
                      when 'SUNDAY' then 2
                      when 'SATURDAY' then 1
                      else 0
                      end,
                        nvl((
                          select max(w_i2.dt)
                            from w_inner w_i2
                            where w_i2.flag = 0 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM')
                          ), date'2018-12-31')
                    )
            ) as last_work_day
  from w_inner w_i   
  order by  number_month
;





with all_days as (
  select  trunc(sysdate, 'YY') + level - 1 as dt
    from  dual
    connect by trunc(trunc(sysdate, 'YY') + level - 1, 'YY') = trunc(sysdate, 'YY')
),
w_weekends as (
    select  date'2018-01-1' as dt, 1 as weekend from  dual union all
    select  date'2018-01-2' as dt, 1 as weekend from  dual union all
    select  date'2018-01-3' as dt, 1 as weekend from  dual union all
    select  date'2018-01-4' as dt, 1 as weekend from  dual union all
    select  date'2018-01-5' as dt, 1 as weekend from  dual union all
    select  date'2018-01-6' as dt, 1 as weekend from  dual union all
    select  date'2018-01-31' as dt, 1 as weekend from  dual union all
    select  date'2018-02-23' as dt, 1 as weekend from  dual union all
    select  date'2018-02-24' as dt, 1 as weekend from  dual union all
    select  date'2018-03-8' as dt, 1 as weekend from  dual union all 
    select  date'2018-05-1' as dt, 1 as weekend from  dual union all 
    select  date'2018-05-8' as dt, 1 as weekend from  dual union all 
    select  date'2018-05-9' as dt, 1 as weekend from  dual union all
    select  date'2018-06-12' as dt, 1 as weekend from  dual union all
    select  date'2018-11-6' as dt, 1 as weekend from  dual union all
    select  date'2018-02-24' as dt, 0 as weekend from dual
),
w_inner as (
    select  all_days.dt as dt,
            nvl(
              w.weekend,
              decode(
                to_char(all_days.dt, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'),
                'SAT', 1,
                'SUN', 1,
                0
              )
            ) as weekend
    from  all_days
          left join w_weekends w on
            all_days.dt = w.dt
)
select  trunc(dt, 'mm') as month,
        min(decode(weekend, 1, dt)),
        max(decode(weekend, 1, dt)),
        min(decode(weekend, 0, dt)),
        max(decode(weekend, 0, dt))
  from w_inner
  group by trunc(dt, 'mm')
  order by month
;



select  distinct to_char(w_i.dt, 'MM') as number_month,
        (
          least(
                  nvl((
                    select  w_i1.dt
                      from  w_inner w_i1
                      where w_i1.flag_weekend = 1 and to_char(w_i.dt, 'MM') = to_char(w_i1.dt, 'MM') and rownum = 1
                    ), date'2018-12-31'),
                  nvl((
                    select  w_i2.dt
                      from  w_inner w_i2
                      where w_i2.flag = 1 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM') and rownum = 1
                    ), date'2018-12-31')
                )
            ) as first_day_off,       
            (
              greatest(
                        nvl((
                          select  max(w_i1.dt)
                            from  w_inner w_i1
                            where w_i1.flag_weekend = 1 and to_char(w_i.dt, 'MM') = to_char(w_i1.dt, 'MM')
                          ), date'2018-01-01'),
                        nvl((
                          select  max(w_i2.dt)
                            from  w_inner w_i2
                            where w_i2.flag = 1 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM')
                          ), date'2018-01-01')
                      )
            ) as last_day_off,
            (
              greatest(                 
                      nvl((
                          select  w_i1.dt
                            from  w_inner w_i1
                            where w_i1.flag_weekend = 0 and to_char(w_i.dt, 'MM') = to_char(w_i1.dt, 'MM') and rownum = 1
                          ), date'2018-01-01'),
                        nvl((
                          select  w_i2.dt
                            from  w_inner w_i2
                            where w_i2.flag = 0 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM') and rownum = 1
                          ), date'2018-01-01')
                      )
                ) as first_work_day,
            (
              least(                 
                      nvl((
                          select  max(w_i1.dt)
                            from  w_inner w_i1
                            where w_i1.flag_weekend = 0 and to_char(w_i.dt, 'MM') = to_char(w_i1.dt, 'MM')
                          ), date'2018-12-31'),
                      nvl((
                        select  max(w_i2.dt)
                          from  w_inner w_i2
                          where w_i2.flag = 0 and to_char(w_i.dt, 'MM') = to_char(w_i2.dt, 'MM')
                        ), date'2018-12-31')
                    )
            ) as last_work_day
  from w_inner w_i   
  order by  number_month
;


/*
10. 3-м самых эффективным по сумме заказов за 1999 год менеджерам по продажам увеличить зарплату еще на 20%.
*/

update  employees e
   set  salary = 1.2*salary
   where exists (
      select  emp_id
        from  (
                select  emp_id
                  from (
                        select  o.sales_rep_id as emp_id,
                                sum(oi.unit_price*oi.quantity) as max_sum
                          from  orders o join order_items oi
                                on o.order_id = oi.order_id 
                                and o.order_date >= date'1999-01-1' and o.order_date < date '2000-01-1'
                          where o.sales_rep_id is not null 
                          group by  o.sales_rep_id
                          order by max_sum desc
                          ) 
                  where rownum <=3
              ) d
        where d.emp_id = e.employee_id
);


select  e.employee_id,
        e.salary
  from  employees e
  where exists (
          select  emp_id
            from  (
                    select  emp_id
                      from (
                            select  o.sales_rep_id as emp_id,
                                    sum(oi.unit_price*oi.quantity) as max_sum
                              from  orders o join order_items oi
                                    on o.order_id = oi.order_id 
                                    and o.order_date >= date'1999-01-1' and o.order_date < date '2000-01-1'
                              where o.sales_rep_id is not null 
                              group by  o.sales_rep_id
                              order by max_sum desc
                              ) 
                      where rownum <=3
                  ) d
            where d.emp_id = e.employee_id
        )        
;

ROLLBACK;

/*
11. Завести нового клиента ‘Старый клиент’ с менеджером, который является руководителем организации. 
Остальные поля клиента – по умолчанию.
*/

insert into customers
  (cust_first_name, cust_last_name, account_mgr_id)
  values
  ('клиент', 'Старый', (select  e.employee_id
                        from  employees e
                        where e.manager_id is null)
);

select *
  from customers c
  where c.cust_first_name = 'клиент';
  
ROLLBACK;

/*
12. Для клиента, созданного в предыдущем запросе, (найти можно по максимальному id клиента), 
продублировать заказы всех клиентов за 1990 год. (Здесь будет 2 запроса,
для дублирования заказов и для дублирования позиций заказа).
*/

insert into orders 
  (order_date, order_mode, customer_id, order_status, order_total, sales_rep_id, promotion_id)
select  o.order_date,
        o.order_mode,
        (   
          select  max(c.customer_id)
            from  customers c
        ) as customer_id,
        o.order_status,
        o.order_total,
        o.sales_rep_id,
        o.promotion_id
  from  orders o
  where o.order_date >= date'1990-01-1' and o.order_date < date '1991-01-1'
;

select * from order_items;

insert into order_items
  (order_id, line_item_id, product_id, unit_price, quantity)
select  r.new_id,
        oi.line_item_id,
        oi.product_id,
        oi.unit_price,
        oi.quantity
  from  (
          select  a.order_id as new_id,
                  b.order_id as old_id
                  from  (
                      select  *
                        from  orders
                        where customer_id =  (   
                                select  max(customer_id)
                                  from  customers
                              ) 
                            ) a
                            join 
                            (
                      select  *
                        from  orders
                        where order_date >= date'1990-01-1' and order_date < date '1991-01-1' 
                        ) b
                        on a.order_date = b.order_date and a.order_id != b.order_id
        ) r join order_items oi
        on r.old_id = oi.order_id
;

rollback;








with t as (
    select  o.order_id
      from  orders o
      where o.customer_id =  (   
              select  max(c.customer_id)
                from  customers c
            )
    union all
    select  o.order_id
      from  orders o
      where o.order_date >= date'1990-01-1' and o.order_date < date '1991-01-1' 
      
    )
    select  *
      from  t
;

select  o.order_id,
        o.order_date,
        o.order_mode,
        o.customer_id,
        o.order_status,
        o.order_total,
        o.sales_rep_id,
        o.promotion_id
  from  orders o
  where o.customer_id = (   
                          select  max(c.customer_id)
                            from  customers c
                        )
;

/*
13. Для каждого клиента удалить самый первый заказ. Должно быть 2 запроса: первый – для удаления 
позиций в заказах, второй – на удаление собственно заказов).
*/

delete  from order_items oi 
  where  exists (
    select  *
      from  orders o
      where not exists 
      (
        select  *
          from  orders o1
          where o1.order_date < o.order_date
                and o1.customer_id = o.customer_id
      )
      and o.order_id = oi.order_id
)
;
 
select  *
  from  order_items oi
  where exists (
        select  *
          from  orders o
          where not exists 
                (
                  select  *
                    from  orders o1
                    where o1.order_date < o.order_date
                          and o1.customer_id = o.customer_id
                )
                and o.order_id = oi.order_id
        )
  order by oi.order_id
;


delete  from  orders o2
  where  exists (
    select  *
      from  orders o
      where not exists 
      (
        select  *
          from  orders o1
          where o1.order_date < o.order_date
          and o1.customer_id = o.customer_id
        )
    and o.order_id = o2.order_id
    )
;


select  *
  from  orders o
  where not exists 
        (
          select  *
            from  orders o1
            where o1.order_date < o.order_date
                  and o1.customer_id = o.customer_id
        )
  order by o.customer_Id
;

select  o.customer_id,
        o.order_date
  from  orders o
  where o.customer_id = 101
  order by o.order_date
;

ROLLBACK;

/*
14. Для товаров, по которым не было ни одного заказа, уменьшить цену в 2 раза (округлив до целых)
и изменить название, приписав префикс ‘Супер Цена! ’.
*/

update  product_information pt
   set  list_price = round(list_price/2),
        product_name = 'Супер Цена! '|| product_name
  where exists (
          select  p.product_id,
                  p.product_name,
                  p.list_price
            from  product_information p
            where not exists (          
                    select  pi.product_id
                      from  product_information pi
                      --from  product_information pi join order_items oi
                       --     on pi.product_id = oi.product_id
                      --where p.product_id = pi.product_id
                  ) and pt.product_id = p.product_id
)
;

select  p.product_id,
        p.product_name,
        p.list_price
            from  product_information p
            where not exists (          
                  select  pi.product_id
                    from  product_information pi join order_items oi
                          on pi.product_id = oi.product_id
                    where p.product_id = pi.product_id
                  )
;

rollback;

/*
15. Импортировать в базу данных из прайс-листа фирмы «Рет» (http://www.voronezh.ret.ru/? &pn=down) 
информацию о всех реализуемых планшетах. Подсказка: воспользоваться excel для конструирования 
insert-запросов (или select-запросов, что даже удобнее).
*/

create table EXAMPLE (
  ID number(10) not null,
  NAME varchar2(350) not null,
  price number(8,2)   
);

ALTER TABLE EXAMPLE ADD (
  CONSTRAINT CT_EXAMPLE_PK_ID PRIMARY KEY (ID));
CREATE SEQUENCE dept_seq START WITH 1;

create or replace trigger EXAMPLE_TR_SET_ID
  before insert on EXAMPLE
  for each row
begin
  if :new.ID is null then
    select dept_seq.nextval into :new.ID
      from dual;
  end if;
end;
  
select * from example;
delete from example;
/*="select '" & B16 &"' as name, " & D16 & " as price from dual union all"*/

insert into EXAMPLE(name, price)
select 'Планшет  7" Archos 70c Xenon, 1024*600, ARM 1.3ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 2/0.3Мпикс,  Android 5.1, 190*110*10мм 242г, серебристый' as name, 64.04 as price from dual union all			
select 'Планшет  7" ASUS ZenPad C 7.0 (Z170C-1B009A), 1024*600, intel 1.2ГГц, 8GB, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5, белый' as name, 110.84 as price from dual union all			
select 'Планшет  7" Galapad 7, 1024*600, NVIDIA 1.3ГГц, 8GB, GPS, BT, WiFi, SD-micro, microHDMI, камера 2Мпикс, Android 4.1, 122*196*10мм 320г, черный' as name, 42.68 as price from dual union all			
select 'Планшет  7" Huawei Ideos S7 Slim, 800*480, Qualcomm 1ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro, MiniHDMI, 2 камеры 3.2/0.3Мпикс, Android 2.2, 200*110*13мм 440г, 12ч, белый' as name, 37.6 as price from dual union all			
select 'Планшет  7" Iconbit NetTAB Rune, 800*600, ARM 1.2ГГц, 8GB, BT, WiFi, SD-micro/SDHC-micro, Android 2.3, 180*140*12мм 429г, 7ч, черный' as name, 37.6 as price from dual union all			
select 'Планшет  7" Iconbit NetTAB Sky II mk2, 800*480, ARM 1.2ГГц, 4GB, WiFi, SD-micro, камера 0.3Мпикс, Android 4.1, 191*114*11мм 310г, белый' as name, 37.6 as price from dual union all			
select 'Планшет  7" Iconbit NetTAB Sky 3G Duo, 1024*600, ARM 1.2ГГц, 4GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, MiniHDMI, 2 камеры 5/0.3Мпикс, Android 4.0, 195*124*11мм 315г, черный' as name, 49.1 as price from dual union all			
select 'Планшет  7" Iconbit NetTAB Thor mini, 1024*600, ARM 1.6ГГц, 8GB, WiFi, SD-micro/SDHC-micro, MiniHDMI, 2 камеры 2/2Мпикс, Android 4.1, 196*114*11мм 319г, белый' as name, 40.23 as price from dual union all			
select 'Планшет  7" Irbis TX16, 1280*800, ARM 1.5ГГц, 8GB, 4G/3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5.1 черный' as name, 65.52 as price from dual union all			
select 'Планшет  7" Irbis TZ71, 1024*600, ARM 1ГГц, 8GB, 4G/3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 0.3/2Мпикс, Android 5.1, 119.2*191.8*10.7мм 280г, черный' as name, 65.52 as price from dual union all			
select 'Планшет  7" Lenovo Tab 3 TB3-710I Essential (ZA0S0023RU), 1024*600, MTK 1.3ГГц, 8GB, BT, WiFi, 3G, GPS, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 113*190*10мм 300г, черный' as name, 106.57 as price from dual union all			
select 'Планшет  7" Lenovo Tab 3 TB3-730X (ZA130004RU), 1024*600,  MTK 1ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 6, 101*191*98мм 260г, белый' as name, 139.41 as price from dual union all			
select 'Планшет  7" Lenovo Tab 4 TB-7304i Essential (ZA310031RU), 1024*600, MTK 1.3ГГц, 16GB, BT, WiFi, 3G, GPS, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 102*194.8*8.8мм 254г, черный' as name, 109.2 as price from dual union all			
select 'Планшет  7" PocketBook A7, 1024*600, TI 1ГГц, 4GB, WiFi, SD-micro, камера 2Мпикс, Android 2.3, 131*207*14мм 410г, 6.5ч, черный-белый' as name, 40.89 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad  Wize 3787, 1280*800, intel 1.1ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 190*115*9.5мм 270г, серый' as name, 77.01 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad  Wize 3787, 1280*800, intel 1.1ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 190*115*9.5мм 270г, черный' as name, 77.01 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad Color Wize 3797, 1280*800, intel 1.2ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 190*115*9.5мм 270г, серый' as name, 73.73 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad Grace (PMT3157), 1280*720, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 186*115*9.5мм 280г черный' as name, 98.36 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad Grace (PMT3157), 1280*720, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 186*115*9.5мм 280г черный' as name, 73.73 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad PMT3677, 800*480, ARM 1ГГц, 4GB, WiFi, SD-micro, камера 0.3Мпикс, Android 4.2, 192*116*11мм 300г, черный' as name, 37.6 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad Wize (PMT3137), 1024*600, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 191.8*119.2*10.7мм 320г, черный' as name, 63.88 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad Wize 3407, 1024*600, intel 1.3ГГц, 8GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 188*108*10.5мм 310г, черный' as name, 96.72 as price from dual union all			
select 'Планшет  7" Prestigio MultiPad WIZE 3757, 1280*800, intel 1.2ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 186*115*9.5мм 280г черный' as name, 97.7 as price from dual union all			
select 'Планшет  7" Samsung Galaxy Tab A (SM-T285NZKASER), 1280*800, Samsung 1.3ГГц, 8GB, 4G/3G, GPS, BT, WiFi, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 109*187*8.7мм 285г, 10ч, черный' as name, 164.04 as price from dual union all			
select 'Планшет  7" Samsung Galaxy Tab A (SM-T285NZSASER), 1280*800, Samsung 1.3ГГц, 8GB, 4G/3G, GPS, BT, WiFi, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 109*187*8.7мм 285г, 10ч, серебристый' as name, 164.04 as price from dual union all			
select 'Планшет  7" Samsung Galaxy Tab 4 (SM-T231NYKASER), 1280*800, Samsung 1.2ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 3/1.3Мпикс, Android 4.2, 107*186*9мм 281г, 10ч, черный' as name, 159.11 as price from dual union all			
select 'Планшет  7" Samsung Galaxy Tab 4 (SM-T231NZWASER), 1280*800, Samsung 1.2ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 3/1.3Мпикс, Android 4.2, 107*186*9мм 281г, 10ч, белый' as name, 159.11 as price from dual union all			
select 'Планшет  7" Tesla Element 7.0, 1024*600, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, камера 0.3Мпикс, Android 4.4, 188*108*10.5мм 311г, черный' as name, 53.37 as price from dual union all			
select 'Планшет  7" Topstar TS-AD75 TE, 1024*600, ARM 1ГГц, 8GB, 3G, GSM, BT, WiFi, SD-micro, SDHC-micro, miniHDMI, камера 0.3 Мпикс, Android 4.0, 193*123*10мм 350г, черный' as name, 49.1 as price from dual union all			
select 'Планшет  7.85" Iconbit NetTAB Skat RX (NT-0801C), 1024*768, ARM 1.8ГГц, 16GB, BT, WiFi, SD-micro/SDHC-micro, microHDMI, 2 камеры 0.3/2Мпикс, Android 4.1, 136*202*9мм 335г, белый' as name, 47.45 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini Retina (ME860), 2048*1536, A7 1.3ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 135*200*8мм 331г, 10ч, серебристый' as name, 402.13 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 Demo (3A136RU), 2048*1536, A7 1.3ГГц, 16GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, золотистый' as name, 295.4 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGGQ2RU/A), 2048*1536, A7 1.3ГГц, 64GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 135*200*8мм 331г, 10ч, серый' as name, 492.45 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGGT2RU/A), 2048*1536, A7 1.3ГГц, 64GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 135*200*8мм 331г, 10ч, серебристый' as name, 459.61 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGJ22RU/A), 2048*1536, A7 1.3ГГц, 128GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, серый' as name, 573.07 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGJ32RU/A), 2048*1536, A7 1.3ГГц, 128GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, серебристый' as name, 573.07 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGNV2RU/A), 2048*1536, A7 1.3ГГц, 16GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, серебристый' as name, 408.87 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGP32RU/A), 2048*1536, A7 1.3ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, серый' as name, 541.71 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGYE2RU/A), 2048*1536, A7 1.3ГГц, 16GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, золотистый' as name, 376.03 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGYU2RU/A), 2048*1536, A7 1.3ГГц, 128GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 341г, 10ч, золотистый' as name, 623.81 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 3 (MGY92RU/A), 2048*1536, A7 1.3ГГц, 64GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 134.7*200*7.5мм 331г, 10ч, золотистый' as name, 492.45 as price from dual union all			
select 'Планшет  7.9" Apple iPad mini 4 (MK6Y2RU/A), 2048*1536, A8 1.4ГГц, 16GB, 4G/3G, GSM, GPS, BT, WiFi, 2 камеры 8/1.2Мпикс, 134.8*203.2*6.1мм 304г, 9ч, серый' as name, 523.81 as price from dual union all			
select 'Планшет  8" Acer Iconia Tab 8 (A1-840FHD-17RT), 1920*1080, Intel 1.8ГГц, 16GB, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/2Мпикс, Android 4.4, серебристый' as name, 180.46 as price from dual union all			
select 'Планшет  8" Archos 80 G9, 1024*768, ARM 1ГГц, 8GB, GPS, BT, WiFi, SD-micro, miniHDMI, камера, Android 3.2, 226*155*12мм 465г, 10ч, темно-серый' as name, 40.89 as price from dual union all			
select 'Планшет  8" ASUS VivoTab Note 8 (M80TA), 1280*800, Intel 1.86ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/1.26Мпикс, W8.1, 134*221*11мм 380г, черный' as name, 180.46 as price from dual union all			
select 'Планшет  8" Iconbit NetTAB Parus Quad, 1024*768, Samsung 1.4ГГц, 16GB, WiFi, SD-micro/SDHC-micro, MiniHDMI, 2 камеры 2/2Мпикс, Android 4.0, 207*160*10мм 475г, серебристый' as name, 80.3 as price from dual union all			
select 'Планшет  8" Irbis TX81, 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 4.2, черный' as name, 72.09 as price from dual union all			
select 'Планшет  8" Lenovo Tab 4 TB-8504X (ZA2D0036RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 211*124.2мм 310г, черный' as name, 196.88 as price from dual union all			
select 'Планшет  8" Lenovo Tab 4 TB-8504X (ZA2D0059RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 211*124.2мм 310г, белый' as name, 196.88 as price from dual union all			
select 'Планшет  8" Lenovo Yoga Tablet YT3-850M (ZA0B0044RU), 1280*800, MTK 1ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, камера 8Мпикс, Android 6, 213*144*9мм 329г, черный' as name, 246.14 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Grace (PMT3118), 1280*800, MTK 1.1ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 206*123*10мм, 343гр, черный' as name, 91.79 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Muze (PMT3708), 1280*800, MTK 1.3ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 206*122.8*10мм, 360гр, черный' as name, 98.36 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Muze (PMT3708), 1280*800, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 206*122.8*10мм, 360гр, черный' as name, 91.79 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Wize (PMT3108) + CNE-CSPB26W, 1280*800, intel 1.2ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 207*123*8.8мм, 356гр, черный' as name, 103.28 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Wize (PMT3208), 1280*800, intel 1.1ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 208.2*126.2*10мм, 613гр, черный' as name, 98.36 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Wize (PMT3418), 1280*800, MTK 1.1ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 6, 206*122.8*10мм, 360гр, черный' as name, 116.42 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Wize (PMT3508), 1280*800, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 206*122.8*10мм, 360гр, серый' as name, 108.21 as price from dual union all			
select 'Планшет  8" Prestigio MultiPad Wize (PMT3508), 1280*800, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 5/2Мпикс, Android 5.1, 206*122.8*10мм, 360гр, черный' as name, 109.85 as price from dual union all			
select 'Планшет  8" Sony Xperia Tablet Z3 Compact (SGP611RU), 1920*1200, Qualcomm 2.5ГГц , 16GB, GPS, ИК, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 8.1/2.2Мпикс, Android 4.4, 213.3*123.6*6.4мм, 270г, белый' as name, 229.72 as price from dual union all			
select 'Планшет  8" Sony Xperia Tablet Z3 Compact (SGP611RU), 1920*1200, Qualcomm 2.5ГГц , 16GB, GPS, ИК, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 8.1/2.2Мпикс, Android 4.4, 213.3*123.6*6.4мм, 270г, черный' as name, 229.72 as price from dual union all			
select 'Планшет  8" Tesla Element 8.0 3G, 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 4.4, 207*123.5*9.8мм 420г, черный' as name, 66.5 as price from dual union all			
select 'Планшет  8" Tesla Impulse 8.0 3G, 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 4.4, 208*123.5*11мм 420г, черный' as name, 70.44 as price from dual union all			
select 'Планшет  9.6" Samsung Galaxy Tab E (SM-T561NZKASER), 1280*800, ARM 1.3ГГц, 8GB, 3G, GSM, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/2Мпикс, Android 4.4, 242*149.5*8.5мм 495г, черный' as name, 213.3 as price from dual union all			
select 'Планшет  9.7" Apple iPad Air (MD791), 2048*1536, A7 1.4ГГц, 16GB, 3G/4G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 480г, 10ч, серый' as name, 581.28 as price from dual union all			
select 'Планшет  9.7" Apple iPad Air (ME898), 2048*1536, A7 1.4ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 469г, 10ч, серый' as name, 558.13 as price from dual union all			
select 'Планшет  9.7" Apple iPad Air (ME906), 2048*1536, A7 1.4ГГц, 128GB, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 469г, 10ч, серебристый' as name, 574.55 as price from dual union all			
select 'Планшет  9.7" Apple iPad Air (ME987), 2048*1536, A7 1.4ГГц, 128GB, 3G/4G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 478г, 10ч, серый' as name, 623.81 as price from dual union all			
select 'Планшет  9.7" Apple iPad Air (ME988), 2048*1536, A7 1.4ГГц, 128GB, 3G/4G, GSM, GPS, BT, WiFi, 2 камеры 5/1.2Мпикс, 170*240*8мм 480г, 10ч, серебристый' as name, 640.23 as price from dual union all			
select 'Планшет  9.7" Apple iPad Air 2 Demo (3A141RU), 2048*1536, A8X 1.5ГГц, 16GB, BT, WiFi, 2 камеры 8/1.2Мпикс, золотистый' as name, 400.49 as price from dual union all			
select 'Планшет  9.7" Apple iPad Pro (MM172RU/A), 2048*1536, A9X 2.26ГГц, 32GB, BT, WiFi, 2 камеры 12/5Мпикс, 169.5*240*6.1мм437г, 10ч, розовое золото' as name, 714.12 as price from dual union all			
select 'Планшет 10.1" Acer Iconia Tab A200, 1280*800, ARM 1ГГц, 32GB, GPS, BT, WiFi, SD-micro, камера 2Мпикс, Android 4.0, 260*175*70мм 720г, красный' as name, 102.63 as price from dual union all			
select 'Планшет 10.1" Acer Iconia Tab A510 (HT.H9LEE.004), 1280*800, NVIDIA 1.3ГГц, 32GB, GPS, BT, WiFi, SD-micro, microHDMI, 2 камеры 5/1Мпикс, Android 4.0, 260*175*11мм 680г, 14.5ч, черный' as name, 102.63 as price from dual union all			
select 'Планшет 10.1" Archos 101b Copper, 1024*600, ARM 1.3ГГц, 8GB, 3G, BT, WiFi, SD-micro, 2 камеры 2/0.3Мпикс,  Android 4.4, 262*166*10мм 577г, серый' as name, 112.48 as price from dual union all			
select 'Планшет 10.1" Archos 101c Copper, 1024*600, ARM 1.3ГГц, 16GB, 3G, GPS, BT, WiFi, SD-micro, 2 камеры 2/0.3Мпикс,  Android 5.1, 259*150*9.8мм 450г, синий' as name, 112.48 as price from dual union all			
select 'Планшет 10.1" ASUS Eee Pad Transformer Prime (TF201), 1280*800, ARM 1.4ГГц, 64GB, GPS, BT, WiFi, SD, microHDMI, 8/1.2 Мпикс, Android 4.0, док-станция, клавиатура, 263*181*8мм 586г, 12ч, золотистый' as name, 164.4 as price from dual union all			
select 'Планшет 10.1" ASUS Transformer Book (T100HA-FU002T), 1280*800, Intel 1.44ГГц, 32GB,  BT, WiFi, SDHC-micro, microHDMI, 2 камеры 5/2Мпикс, W10, док-станция, клавиатура, 263*171*11мм 550гр, серый' as name, 311.82 as price from dual union all			
select 'Планшет 10.1" ASUS Transformer Pad (TF103CG-1A056A), 1280*800, intel 1.6ГГц, 8GB, BT, 3G, WiFi, SD/SD-micro, 2/0.3Мпикс, Android 4.4, 257.3*178.4*9.9мм 550г черный' as name, 131.2 as price from dual union all			
select 'Планшет 10.1" ASUS Transformer Pad (TF103CG-1A059A), 1280*800, intel 1.33ГГц, 8GB, BT, 3G, WiFi, SD/SD-micro, 2/0.3Мпикс, клавиатура, Android 4.4, 257.3*178.4*9.9мм 550г черный' as name, 246.14 as price from dual union all			
select 'Планшет 10.1" ASUS ZenPad 10 (Z300CG-1A047A), 1280*800, intel 1.2ГГц, 8GB, 3G, GPS, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5, 251*172*7.9мм 510г, черный' as name, 190.31 as price from dual union all			
select 'Планшет 10.1" ASUS ZenPad 10 (Z300M-6A056A), 1280*800, MTK 1.3ГГц, 8GB, BT,  WiFi, SD/SD-micro, 2/5Мпикс, Android 6, 251.6*172*7.9мм 490г, черный' as name, 201.15 as price from dual union all			
select 'Планшет 10.1" Dell XPS 10 Tablet (6225-8264), 1366*768, Qualcomm 1.5ГГц, 64GB, BT, WiFi, SD-micro, miniHDMI, 2 камеры 5/2 Мпикс, W8RT, док-станция, клавиатура, 275*177*9мм 635г, 10.5ч, черный' as name, 147.62 as price from dual union all			
select 'Планшет 10.1" Irbis TW31, 1280*800, Intel 1.8ГГц, 32GB, 3G, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс,  W10, клавиатура, 170*278*10мм 600г, черный' as name, 180.46 as price from dual union all			
select 'Планшет 10.1" Lenovo Tab 4 TB-X304L (ZA2K0056RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 247*170*8.4мм 505г, черный' as name, 215.11 as price from dual union all			
select 'Планшет 10.1" Lenovo Tab 4 TB-X304L (ZA2K0082RU), 1280*800, Qualcomm 1.4ГГц, 16GB, BT, WiFi, 4G/3G, GPS, SD-micro, 2 камеры 5/2Мпикс, Android 7, 247*170*8.4мм 505г, белый' as name, 213.3 as price from dual union all			
select 'Планшет 10.1" Lenovo Yoga Book (YB1-X91F), 1920*1200, Intel 1.44ГГц, 64GB, BT, WiFi, GPS, SD-micro, 2 камеры 8/2Мпикс, клавиатура, W10, 256*170.8*9.6мм 690г, черный' as name, 788.01 as price from dual union all			
select 'Планшет 10.1" Pegatron Chagall (90NL-083S100), 1280*800, ARM 1.5ГГц, 16GB, BT, WiFi, SD-micro,  2 камеры 8/2 Мпикс, Android 4.0, 260*7*180мм 540г, 8ч, черный' as name, 70.44 as price from dual union all			
select 'Планшет 10.1" Prestigio MultiPad Grace (PMT3101), 1280*800, MTK 1.3ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 243*171*10мм, 545гр, черный' as name, 132.18 as price from dual union all			
select 'Планшет 10.1" Prestigio MultiPad Grace (PMT3201), 1280*800, MTK 1ГГц, 16GB, 4G/3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 7, 243*171*10мм, 545гр, черный' as name, 139.41 as price from dual union all			
select 'Планшет 10.1" Prestigio MultiPad Wize (PMT3131), 1280*800, MTK 1.13ГГц, 16GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 261*155*9.8мм, 554гр, черный' as name, 114.78 as price from dual union all			
select 'Планшет 10.1" Prestigio MultiPad Wize (PMT3131), 1280*800, MTK 1.13ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 261*155*9.8мм, 554гр, черный' as name, 106.57 as price from dual union all			
select 'Планшет 10.1" Prestigio MultiPad Wize (PMT3401), 1280*800, MTK 1.3ГГц, 8GB, 3G, WiFi, GPS, BT, SD-micro, 2 камеры 2/0.3Мпикс, Android 6, 261*162*11.6мм, 400гр, черный' as name, 98.36 as price from dual union all			
select 'Планшет 10.1" Prestigio Visconte A (WCPMP1014TEDG), 1280*800, Intel 1.83ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс, W10, клавиатура, 259.3*173.5*10.1мм 575г, серый' as name, 147.62 as price from dual union all			
select 'Планшет 10.1" Prestigio Visconte V (VMPMP1012TERD), 1280*800, Intel 1.83ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс, W10, клавиатура, 260*161*9.5мм 594г, коричневый/красный' as name, 164.04 as price from dual union all			
select 'Планшет 10.1" Prestigio Visconte 4U (XIPMP1011TDBK), 1280*800, Intel 1.8ГГц, 16GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/2Мпикс, W10, клавиатура, 256*173.6*10.5мм 580г, черный' as name, 131.2 as price from dual union all			
select 'Планшет 10.1" Tesla Impulse 10.1 3G, 1280*800, ARM 1.2ГГц, 8GB, 3G, GSM, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 2/0.3Мпикс, Android 5.1, 242.3*171.2*9.5мм 560г, черный' as name, 91.79 as price from dual union all			
select 'Планшет 11.6" Prestigio Visconte S (UEPMP1020CESR), 1920*1080, Intel 1.84ГГц, 32GB, BT, WiFi, SD-micro/SDHC-micro, 2 камеры 5/2Мпикс, W10, клавиатура, 260*186*9.75мм 684г, серый' as name, 229.72 as price from dual union all			
select 'Планшет 11.6" Samsung ATIV Smart PC Pro (XE700T1C-A03RU), 1920*1080, Intel 1.5ГГц, 64GB, BT, WiFi, SD-micro, microHDMI, 2 камеры 5/2Мпикс, W8, 340*189*12мм 888г, черный' as name, 295.4 as price from dual		
;

