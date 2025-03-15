Create or replace procedure update_student (
											V_STUDENT_ID NUMBER, 
											V_NATIONAL_ID VARCHAR2, 
											V_FIRST_NAME VARCHAR2, 
											V_LAST_NAME VARCHAR2, 
											V_GENDER CHAR , 
											V_BIRTH_DATE DATE, 
											V_EMAIL VARCHAR2 , 
											V_PHONE VARCHAR2, 
											V_ENROLLMENT_DATE DATE, 
											V_COMPLETED_HOURS NUMBER , 
											V_CGPA NUMBER, 
											V_SUPERVISOR_ID NUMBER, 
											V_DEPARTMENT_ID NUMBER
											) is

Begin
        Update Student
        set NATIONAL_ID = V_NATIONAL_ID,  
             FIRST_NAME = V_FIRST_NAME,  
             LAST_NAME = V_LAST_NAME, 
             GENDER = V_GENDER, 
             BIRTH_DATE = V_BIRTH_DATE, 
             EMAIL = V_EMAIL, 
             PHONE = V_PHONE, 
             ENROLLMENT_DATE = V_ENROLLMENT_DATE, 
             COMPLETED_HOURS = V_COMPLETED_HOURS,
             CGPA = V_CGPA,
             SUPERVISOR_ID = V_SUPERVISOR_ID,
             DEPARTMENT_ID = V_DEPARTMENT_ID
             
        where STUDENT_ID=V_STUDENT_ID;

End;

Create or replace procedure update_cgpa(v_student_id number)
is
begin 
    update student 
    set CGPA = calc_cgpa(v_student_id)
    where student_id = v_student_id;
    
end;

Create or replace procedure update_completed_hours(v_student_id number)
is
begin 
    update student 
    set completed_hours = calc_completed_hours(v_student_id)
    where student_id = v_student_id;
    
end;