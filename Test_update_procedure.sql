BEGIN
    update_student(
        V_STUDENT_ID => 203,
        V_NATIONAL_ID => '65432109876543',
        V_FIRST_NAME => 'Ali',
        V_LAST_NAME => 'Hussein',
        V_GENDER => 'M',
        V_BIRTH_DATE => TO_DATE('1999-03-22', 'YYYY-MM-DD'),
        V_EMAIL => 'ali.hussein@edu.com',
        V_PHONE => '01234567890',
        V_ENROLLMENT_DATE => TO_DATE('2023-09-01', 'YYYY-MM-DD'),
        V_COMPLETED_HOURS => 0,
        V_CGPA => 0.0,
        V_SUPERVISOR_ID => 104,
        V_DEPARTMENT_ID => 1
    );
END;