Create or replace function calc_grade(v_score number)
return Char
is

begin 
    if v_score >= 95 then
        return 'A';
    elsif v_score >= 90 then
        return 'A-';
    elsif v_score >= 87 then
        return 'B+';
    elsif v_score >= 83 then
        return 'B';
     elsif v_score >= 80 then
        return 'B-';
     elsif v_score >= 77 then
        return 'C+';
     elsif v_score >= 73 then
        return 'C';
     elsif v_score >= 70 then
        return 'C-';
     elsif v_score >= 65 then
        return 'D+';
     elsif v_score >= 60 then
        return 'D';
     else
        return 'F';
     end if;  
end;


Create or replace function calc_grade_point(v_grade char)
return number
is

begin 
    if v_grade = 'A' then
        return 4.0 ;
    elsif v_grade = 'A-' then
        return 3.7 ;
    elsif v_grade = 'B+' then
        return 3.3 ;
    elsif v_grade = 'B' then
        return 3.0 ;
    elsif v_grade = 'B-' then
        return 2.7 ;
    elsif v_grade = 'C+' then
        return 2.3 ;
    elsif v_grade = 'C' then
        return 2.0 ;
    elsif v_grade = 'C-' then
        return 1.7 ;
    elsif v_grade = 'D+' then
        return 1.3 ;
    elsif v_grade = 'D' then
        return 1.0 ;
    else
        return 0.0 ;
    end if;  
end;


Create or replace function calc_CGPA(v_student_id number)
return number
is
    CGPA number;
begin 
   select sum(calc_grade_point(calc_grade(s.score)) * c.credit_hours) / sum(c.credit_hours) into CGPA
   from study s join course c
   on s.course_id = c.course_id
   where s.student_id = v_student_id;
   
   return CGPA;
end;

Create or replace function calc_semester_GPA(v_student_id number, v_semester varchar2, v_year char )
return number
is
    GPA number;
begin 
   select sum(calc_grade_point(calc_grade(s.score)) * c.credit_hours) / sum(c.credit_hours) into GPA
   from study s join course c
   on s.course_id = c.course_id
   where s.student_id = v_student_id 
             and S.SEMESTER = v_semester
             and S.YEAR = v_year;
   
   return GPA;
end;


Create or replace function calc_completed_hours (v_student_id number)
return number
is
    completed_hours number;
begin 
   select sum(c.credit_hours) into completed_hours
   from study s join course c
   on s.course_id = c.course_id
   where s.student_id = v_student_id 
             and calc_grade(s.score) != 'F';
   
   return completed_hours;
end;


Create or replace function calc_level(v_completed_hours number)
return number
is
begin
    if v_completed_hours >= 114  then 
        return 4;
    elsif v_completed_hours >= 75 then 
        return 3;
    elsif v_completed_hours >= 37 then 
        return 2;
    else 
        return 1;
    end if;        
end;



-- calculate reagistered hours in the semester 
CREATE OR REPLACE FUNCTION calc_registered_hours(
    v_student_id NUMBER,
    v_semester VARCHAR2,
    v_year CHAR
)
RETURN NUMBER
IS
    registered_hours NUMBER;
BEGIN
    SELECT NVL(SUM(c.credit_hours), 0)
    INTO registered_hours
    FROM study s 
    JOIN course c
    ON s.course_id = c.course_id
    WHERE s.student_id = v_student_id 
          AND s.score IS NULL
          AND s.semester = v_semester  
          AND s.year = v_year;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
    WHEN OTHERS THEN
        RETURN -1;       
    RETURN registered_hours;
END;
