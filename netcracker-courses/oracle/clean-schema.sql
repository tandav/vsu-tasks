select 'drop '||object_type||' '|| object_name|| DECODE(OBJECT_TYPE,'TABLE',' CASCADE CONSTRAINTS','') || ';'  from user_objects;
purge recyclebin;
select * from user_objects;