# Lecture 5
`L/Лекции/oracle`
`еще диск Z глянуть`
Запросы могут быть:
- возвращающие 1 значение
- столбец значений
- таблицу
- лучше соединять с подзапросом а не в селекте еще один селект

---

- если subselect do not return anything then it returns `null`
- в подзапросах удобно подготавливать данные / сортировать / 
- `not in [1, 2, 3, null, 4, 5] = empty/nothing`

```
5 in (3, 5, null) // true
5 = 3 or 5 = 5 or 5 = null => 
false or true or null => true
```

```
7 in (3, 5, null) // true
7 = 3 or 7 = 5 or 7 = null => 
false or false or null => null
```

```
5 not in (3, 5, null) // true
5 <> 3 or 5 <> 5 or 5 <> null => 
false or true or null => true
```

- `not in` лучше короче особо не юзать
- `all`, `any` - тоже стрем (сложно, нужно вспоминать как будут вести себя) 
---

# WITH
`with` - можно подзапрос назвать именем и типа как к таблицк потом обращаться

```sql
WITH
sum_sales AS 
  ( select /*+ materialize */ 
    sum(quantity) all_sales from stores ),
number_stores AS 
  ( select /*+ materialize */ 
    count(*) nbr_stores from stores ),
sales_by_store AS
  ( select /*+ materialize */ 
  store_name, sum(quantity) store_sales from 
  store natural join sales )
SELECT
   store_name
FROM
   store,
   sum_sales,
   number_stores,
   sales_by_store
where
   store_sales > (all_sales / nbr_stores);
```

