CREATE TABLE Student (
    Student_ID NUMBER PRIMARY KEY,
    National_ID VARCHAR2(20) UNIQUE NOT NULL,
    First_Name VARCHAR2(50) NOT NULL,
    Last_Name VARCHAR2(50) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    Birth_Date DATE,
    Email VARCHAR2(100) UNIQUE NOT NULL CHECK (Email LIKE '%@%'),
    Phone VARCHAR2(15),
    Enrollment_Date DATE NOT NULL,
    Completed_Hours NUMBER(3) NOT NULL,
    CGPA NUMBER(3, 2) NOT NULL,
    Supervisor_ID NUMBER,
    Department_ID NUMBER 
);

CREATE TABLE Department (
    Department_ID NUMBER PRIMARY KEY,
    Department_Name VARCHAR2(100) UNIQUE NOT NULL,
    Manager_ID NUMBER 
);

CREATE TABLE Staff (
    Staff_ID NUMBER PRIMARY KEY,
    National_ID VARCHAR2(20) UNIQUE NOT NULL,
    First_Name VARCHAR2(50) NOT NULL,
    Last_Name VARCHAR2(50) NOT NULL,
    Hire_Date DATE NOT NULL,
    Role VARCHAR2(50) NOT NULL,
    Department_ID NUMBER
);

CREATE TABLE Course (
    Course_ID NUMBER PRIMARY KEY,
    Course_Name VARCHAR2(100) UNIQUE NOT NULL,
    Credit_Hours NUMBER(5) NOT NULL,
    No_of_Students NUMBER(10) NOT NULL,
    Status VARCHAR2(10) NOT NULL
);


CREATE TABLE Study (
    Student_ID NUMBER NOT NULL REFERENCES Student(Student_ID) ON DELETE CASCADE,
    Course_ID NUMBER NOT NULL REFERENCES Course(Course_ID),
    Score NUMBER(5),
    Semester VARCHAR2(10) NOT NULL,
    Year CHAR(4) NOT NULL,
    PRIMARY KEY (Student_ID, Course_ID, Semester, Year)
);

CREATE TABLE Teach (
    Staff_ID NUMBER NOT NULL REFERENCES Staff(Staff_ID) ON DELETE CASCADE,
    Course_ID NUMBER NOT NULL REFERENCES Course(Course_ID) ON DELETE CASCADE,
    PRIMARY KEY (Staff_ID, Course_ID)
);

-- Adding foriegn key constraints to  Student , Department, Staff Tables

ALTER TABLE Student 
ADD CONSTRAINT student_super_fk FOREIGN KEY (Supervisor_ID) REFERENCES Staff(Staff_id) ON DELETE SET NULL;


ALTER TABLE Student 
ADD CONSTRAINT student_dept_fk FOREIGN KEY (Department_ID) REFERENCES Department(Department_id);

alter table student
add constraint chk_completed_hours check (completed_hours >= 0 and completed_hours <= 150 ); 

alter table student
add constraint chk_cgpa check (cgpa >= 0 and cgpa <= 4 ); 

ALTER TABLE Department 
ADD CONSTRAINT dept_mgr_fk FOREIGN KEY (Manager_ID) REFERENCES Staff(Staff_ID) ON DELETE SET NULL;

ALTER TABLE Staff 
ADD CONSTRAINT staff_dept_fk FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID) ON DELETE SET NULL;

