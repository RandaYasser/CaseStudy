
-- trigger to not let student register more than 21 hour in fall and spring semesters
-- in summer not more than 10 hours

create or replace trigger max_semester_hours 
before insert on study
for each row
declare 
    course_hours number; total_hours number;
begin 
    select credit_hours into course_hours
    from course
    where course_id = :new.course_id;
    
   total_hours :=  calc_registered_hours(:new.student_id, :new.semester, :new.academic_year) + course_hours;
 if total_hours > 21 and (:new.semester = 'Fall' or  :new.semester = 'Spring') then
    raise_application_error( -20005, 'You cannot register more than 21 hours in Fall or Spring semester');
 elsif  total_hours  > 10 and (:new.semester = 'Summer' ) then
    raise_application_error( -20006, 'You cannot register more than 10 hours in Summer semester');
    else
        dbms_output.put_line('Student with ID : '||:new.student_id||' has registered '|| total_hours ||' hours this semester so far' );
end if;
end;