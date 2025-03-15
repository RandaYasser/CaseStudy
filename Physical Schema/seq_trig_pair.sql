set serveroutput on ;
DECLARE

 CURSOR valid_tab_cursor is

    SELECT ucc.TABLE_NAME, ucc.COLUMN_NAME  
    FROM user_cons_columns ucc
    JOIN user_constraints uc    -- to get primary key constraints
      ON ucc.CONSTRAINT_NAME = uc.CONSTRAINT_NAME
    JOIN user_tab_columns utc -- to get column types
      ON ucc.TABLE_NAME = utc.TABLE_NAME 
      AND ucc.COLUMN_NAME = utc.COLUMN_NAME
    WHERE uc.CONSTRAINT_TYPE = 'P'  -- to get columns with primary key constraints
      AND utc.DATA_TYPE = 'NUMBER' -- to get only numeric primary keys
      AND NOT EXISTS (
        -- correlated subquery to exclude tables with composite primary keys
        SELECT 1
        FROM user_cons_columns t1
        JOIN user_cons_columns t2
          ON t1.CONSTRAINT_NAME = t2.CONSTRAINT_NAME 
          AND t1.COLUMN_NAME <> t2.COLUMN_NAME
          AND t1.POSITION IS NOT NULL
        WHERE t1.TABLE_NAME = ucc.TABLE_NAME
      );

     seq_name varchar2(100); trig_name varchar2(100); check_seq number(2); check_trig number(2); max_id number(4);
BEGIN 

 FOR tab_record in valid_tab_cursor LOOP
        seq_name := tab_record.table_name||'_SEQ';
        trig_name := tab_record.table_name||'_TRIG';
        
       -- check if a sequence or a trigger exixts with the same name
        select count(*) into check_seq from user_objects where object_type='SEQUENCE' and object_name =seq_name;
       
        if check_seq > 0 then
            execute immediate 'drop sequence '||seq_name;
        end if;
        
        select count(*) into check_trig from user_objects where object_type='TRIGGER' and object_name =trig_name;
     
        if check_trig > 0 then
            execute immediate 'drop trigger '||trig_name;
        end if;
        
         execute immediate 'select NVL(max('||tab_record.column_name||'), 0)  from '||tab_record.table_name into max_id;
        max_id:=max_id+1;
        -- Sequence
        
         execute immediate 'CREATE SEQUENCE '||seq_name||' START WITH '|| max_id||
         ' MAXVALUE 99999 INCREMENT BY 1 NOCYCLE';
         
        dbms_output.put_line('created '||seq_name||' for '||tab_record.TABLE_NAME);
        
        execute immediate 'CREATE OR REPLACE TRIGGER '||trig_name||' BEFORE INSERT ON ' ||tab_record.table_name||
        ' FOR EACH ROW BEGIN IF :new.'||tab_record.column_name||' IS NULL THEN :new.'||tab_record.column_name||
        ' := '||seq_name||'.nextval; END IF; END; ';
        

        dbms_output.put_line('created '||trig_name||' for '||tab_record.TABLE_NAME);
END LOOP;
END;