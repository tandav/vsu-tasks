login: rodionov_a_a 
pass:  


oracle - скачать, 

новый пользователь, права. Выполнить скрипт `netcracker.sql`

Через пользователя system создать нового юзере:
```
create user netcracker identified by netckracker
grant connect, resourse, create view, create synonym to netcracker,
netcracker;
```

И создасться база с которой мы будем работать.

Либо там есть виртуальная машина, можно ее скопировать и 



Нужно поставить Oracle SE и развернуть базу

codestyle

```sql
SELECT column1 aS
               aS
  FROM
```

сдавать сразу по целой лабе


сначала писать `SELECT *` а в самом конце уже колонки выводить

## Set up oracle on macOS using docker
- [sath89/oracle-12c - Docker Hub](https://hub.docker.com/r/sath89/oracle-12c/)
- `docker pull sath89/oracle-12c`
- `docker run --name netcracker_db -p 8080:8080 -p 1521:1521 sath89/oracle-12c`
- потом короче save, rename container, alias
- дропнуть базу, populate with netcracker_db
    - [sql - Delete all contents in a schema in Oracle - Stack Overflow](https://stackoverflow.com/questions/29926262/delete-all-contents-in-a-schema-in-oracle)
- мб залить на dockerhub image
    - после того как спрошу у соломатина как все дропнуть и заного записать в SQL developer
