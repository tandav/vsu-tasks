# Lecture 3 
- `COUNT(*)` - number of rows in table
- `COUNT(some_column)` - numbers of rows where `some_column != null`
- 


---

В `GROUP BY` могут быть только те столбцы которые есть в `GROUP BY` либо aggregate functions (по любым столбцам, не только по тем которые есть в `GROUP BY`)

```sql
SELECT a, b, avg(c), sum(d)
    FROM t
    GROUP BY a, b
```

- В ORDER BY можем использовать те выражения которые встречаются в SELECT, а также агрегатные функции.
- скорее всего если есть какие-то выражения в GROUP BY, то это выражение будет и в SELECT (либо явно либо еще какое-то выражение от этого выражения)

---

Нельзя юзать `where avg(sale) > 100` для аггрегатных функций юзается HAVING. (пишется и выполняется после GROUP BY) Отбор строк полученных в результате применения aggregate functions

В having могут быть aggregate functions не обяз те которые в SELECT

---

aggregate functions ignores null

---

`ROLLUP` - 


---

Когда очень много данных - юзается OLAP cubes. Срезы. А потом уже анализируется. Потому что если обычные запросы то будет очень долго считается

---
