CREATE USER my_user IDENTIFIED BY my_pass;
GRANT CONNECT, RESOURCE, DBA TO my_user;
GRANT CREATE SESSION TO my_user;
GRANT UNLIMITED TABLESPACE TO my_user;
-- ALTER USER my_user quota unlimited on 'USERS';
select user from dual;

