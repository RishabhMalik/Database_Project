CREATE OR REPLACE PROCEDURE "DROP_ALL_OBJECTS" AS
-- If the log shows the some object was not droped, call this procedure again
v_pom PLS_INTEGER;
BEGIN
LOOP
FOR irec IN (SELECT DISTINCT
                    object_type,object_name,
                    'drop '||object_type||' "'||object_name||'"'||
                    CASE object_type WHEN 'TABLE' THEN ' cascade constraints purge'
                                     ELSE ' '
                    END AS command_c
              FROM user_objects
              WHERE object_name <> 'DROP_ALL_OBJECTS'
            )
  LOOP
   BEGIN
   DBMS_OUTPUT.put_line('command_c '||irec.command_c);
      EXECUTE IMMEDIATE irec.command_c;
   EXCEPTION
      WHEN OTHERS THEN DBMS_OUTPUT.put('nenĂ­ ');
   END;
   DBMS_OUTPUT.put_line('zrusen(a) '||irec.object_type||' '||irec.object_name);
  END LOOP;
SELECT COUNT(*) INTO v_pom
FROM user_objects
WHERE object_name <> 'DROP_ALL_OBJECTS';
EXIT WHEN v_pom = 0;
END LOOP;
DBMS_OUTPUT.put_line('Finish!');
END DROP_ALL_OBJECTS;
/
execute DROP_ALL_OBJECTS