# Lecture 1
Соломатин Дмитрий Иванович

## суть
- **упор на сложные sql selects**
- древовидные запросы, иерархические, аналитические - фишки чисто Oracle
- будет немного изучение `PL/SQL`
- будет 5 лаб

## SQL / PLSQL
- SQL - язык запросов
- PL/SQL - код, который внутри RDBMS (как правило юзается в Oracle)
    - часто логика на нем пишется
    - внутри себя вызывает SQL
    - очень стремный (wrt java), но очень удобно манипулировать данными, плюс он на том же компе, все рядом и все очень fast. Поэтому он еще не рип.
- когда CRUD по фасту - то код в application + ORM - норм
- но когда обработка очень больших массивов - логика в PL/SQL тащит (ultra-fast). Стрем - то что жестко завязываешься на Oracle. При переходе на другую нужно будет переписыват пол приложухи.

## RDBMS:
- файловые
- встраиваемые(внутри приложения, ты даже про него не знаешь)
- серверные (на серваке, сервак обрабатывает запросы)

## Oracle
- Oracle - объектная RDBMS. Но типа создавать объекты стремно по performace
- есть консоль SQL Oracle `SQL*Plus` - типа `Oracle CLI`

## Oracle Strings
- `char(N)` - (всегда N. если меньше - то rest забивается нулями)
- `varchar(N)` N - max length
- `varchar2(N)` тоже самое что varchar в новых версиях. Но раньше рекомендовалось всегда varchar2 (~)

## Oracle numbers
- `number(N, M)` - все в 10чной системе. Всегда четко при сложении. Никогда не будет 5 + 5 = 10.000000000001 22 bytes
- `int` 22 bytes
- ...
- Bool - нет,  есть в PL/SQL. Юзают int(1)

## Oracle Date
- `date` - точеность до секунд
- `timestamp` - до микросекунд
- `timestamp with timezone`
- пишется вот так `date'2017-11-13'`
- есть варик `to_date('01.01.2012 12:00:02', 'DD.MM.YYY HH24:MI:SS')`
- `interval`

## blob
- `blob` - binary byte object (2 терабайта)
- `clob` - character large object

## Misc Facts
- Oracle типа stable. Scalable. License: в учебных целях free. В комерческих целях - дорого.
- many integrity constraints is good idea
- `NULL` != `0` == `''` (**Только в oracle!** пустая строка == `null`)
- `FOREIGN KEY` - значение в столбце с `FK` может принимать только значение `PK` из другой table
- лучше писать `table1 AS t` при rename table, а не просто `table1 t`
- use case-insensetive for most scenarios
- в Oracle 30 chars max for names ?? ~
