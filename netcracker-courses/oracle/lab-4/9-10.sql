/*
  9 Написать функцию, которая возвратит таблицу (table of record), содержащую информацию о частоте встречаемости отдельных символов во всех названиях (и описаниях) товара
  на заданном языке (передается код языка, а также параметр, указывающий, учитывать ли описания товаров). 
  Возвращаемая таблица состоит из 2-х полей: символ, частота встречаемости в виде частного от кол-ва данного символа к количеству всех символов в названиях (и описаниях) товара. 
*/
CREATE OR REPLACE TYPE symbol_row AS OBJECT ( 
symbol nvarchar2(10), 
frequency number 
); 

CREATE OR REPLACE TYPE record_table AS TABLE OF symbol_row; 

CREATE OR REPLACE FUNCTION symbol_frequency( 
  p_select_language IN product_descriptions.language_id%TYPE, 
  p_is_descriptions IN BOOLEAN 
) RETURN record_table 
IS 
  v_temp_string CLOB; 
  v_str_length NUMBER; 
  v_symbols VARCHAR(100) := NULL; 
  v_rec symbol_row; 
  v_table record_table; 
  v_string CLOB; 
CURSOR c1 IS 
  select * 
    from product_descriptions pd 
    where pd.language_id = p_select_language; 
BEGIN 
  v_table := record_table(); 
  v_rec := symbol_row(null,0); 
FOR pd IN c1 LOOP 
  IF p_is_descriptions THEN 
    v_temp_string := concat(pd.translated_name, pd.translated_description); 
    v_string := concat(v_string, v_temp_string); 
    ELSE 
    v_temp_string := pd.translated_name; 
    v_string := concat(v_string, v_temp_string); 
  END IF; 

v_temp_string := lower(v_temp_string); 
v_str_length := length(v_temp_string); 
FOR i IN 1..v_str_length 
  LOOP 
    IF instr(v_symbols, substr(v_temp_string, i, 1)) > 0 THEN 
      FOR i_INDEX IN 1..v_table.count LOOP 
        IF(v_table(i_INDEX).symbol = substr(v_temp_string, i, 1)) THEN 
           v_table(i_INDEX).frequency := v_table(i_INDEX).frequency + 1; 
        END IF; 
      END LOOP; 
    ELSE 
      v_rec.symbol := substr(v_temp_string, i, 1); 
      v_rec.frequency := 1; 
      v_table.extend(1); 
      v_table(v_table.count) := v_rec; 
      v_symbols := v_symbols || substr(v_temp_string, i, 1); 
    END IF; 
  END LOOP; 
v_temp_string := ''; 
v_str_length := 0; 
END LOOP; 
FOR i IN 1..length(v_symbols) 
LOOP 
v_table(i).frequency := round(v_table(i).frequency / length(v_string),6); 
END LOOP; 
RETURN v_table; 
END; 

set serveroutput on 
declare 
v_table record_table; 
begin 
  v_table := symbol_frequency('RU', true); 
for i in 1..v_table.count loop 
  DBMS_OUTPUT.put_line('"'|| v_table(i).symbol || '"' || '-' || v_table(i).frequency); 
end loop; 
end;
/*10 Написать функцию, которой передается sys_refcursor и которая по данному курсору формирует HTML-таблицу,
  содержащую информацию из курсора. Тип возвращаемого значения – clob.
 */
CREATE OR REPLACE FUNCTION fncRefCursor2HTML(rf SYS_REFCURSOR)  RETURN CLOB
  IS
    lRetVal      CLOB;
    lHTMLOutput  XMLType; 
    lXSL         CLOB;
    lXMLData     XMLType;
    lContext     DBMS_XMLGEN.CTXHANDLE;
BEGIN
    -- используется для преобразования результатов SQL запроса в XML формат и вохвращает результат как CLOB --
    lContext := DBMS_XMLGEN.NEWCONTEXT(rf);
    -- Для вывода null начений--
    DBMS_XMLGEN.setNullHandling(lContext,1);
    -- Для создания XML из ref cursor --
    lXMLData := DBMS_XMLGEN.GETXMLTYPE(lContext,DBMS_XMLGEN.NONE);

    -- Это генерация XSL для Oracle стандартные вещи для XML поля и теги --
    --экранируем кавычки при помощи q'--
    lXSL := lXSL || q'[<?xml version="1.0" encoding="ISO-8859-1"?>]';
    lXSL := lXSL || q'[<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">]';
    lXSL := lXSL || q'[ <xsl:output method="html"/>]';
    lXSL := lXSL || q'[ <xsl:template match="/">]';
    lXSL := lXSL || q'[ <html>]';
    lXSL := lXSL || q'[  <body>]';
    lXSL := lXSL || q'[   <table border="1">]';
    lXSL := lXSL || q'[     <tr bgcolor="cyan">]';
    lXSL := lXSL || q'[      <xsl:for-each select="/ROWSET/ROW[1]/*">]';
    lXSL := lXSL || q'[       <th><xsl:value-of select="name()"/></th>]';
    lXSL := lXSL || q'[      </xsl:for-each>]';
    lXSL := lXSL || q'[     </tr>]';
    lXSL := lXSL || q'[     <xsl:for-each select="/ROWSET/*">]';
    lXSL := lXSL || q'[      <tr>]';    
    lXSL := lXSL || q'[       <xsl:for-each select="./*">]';
    lXSL := lXSL || q'[        <td><xsl:value-of select="text()"/> </td>]';
    lXSL := lXSL || q'[       </xsl:for-each>]';
    lXSL := lXSL || q'[      </tr>]';
    lXSL := lXSL || q'[     </xsl:for-each>]';
    lXSL := lXSL || q'[   </table>]';
    lXSL := lXSL || q'[  </body>]';
    lXSL := lXSL || q'[ </html>]';
    lXSL := lXSL || q'[ </xsl:template>]';
    lXSL := lXSL || q'[</xsl:stylesheet>]';

    -- XSL первод в XML для создания HTML --
    lHTMLOutput := lXMLData.transform(XMLType(lXSL));
    -- Перевод XML в Clob --
    lRetVal := lHTMLOutput.getClobVal();

    RETURN lRetVal;
END;

DECLARE 
  l_cursor sys_refcursor;
  x clob;
BEGIN
  --объявляете переменную курсора, а затем связываем эту переменную с динамическим опратором SELECT , который возвращает строки из таблицы empoyees--
  OPEN l_cursor 
  for 
    select * 
      from employees;
  x:= fncRefCursor2HTML(l_cursor);
  CLOSE l_cursor;  
END;
