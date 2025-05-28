CREATE DATABASE Academy01;

USE Academy01;

-- DROP TABLE curators;

CREATE TABLE curators(
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[name] NVARCHAR (MAX) NOT NULL,
surname NVARCHAR (MAX) NOT NULL,

CONSTRAINT CHK_curators_name CHECK ([name] NOT LIKE '/\n\n/g'),
CONSTRAINT CHK_curators_surname CHECK ([name] NOT LIKE '/\n\n/g'),
);

GO

CREATE TABLE faculties (
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
financing MONEY NOT NULL DEFAULT 0,
[name] NVARCHAR(100) NOT NULL UNIQUE,

CONSTRAINT CHK_faculties_financing CHECK (financing >= 0),
CONSTRAINT CHK_faculties_name CHECK ([name] NOT LIKE '/\n\n/g')
);

GO

CREATE TABLE departments (
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
financing MONEY NOT NULL DEFAULT (0),
[name] NVARCHAR (100) NOT NULL UNIQUE,
facultyId INT NOT NULL,

CONSTRAINT CHK_departments_financing CHECK (financing >= 0),
CONSTRAINT CHK_departments_name CHECK ([name] NOT LIKE '/\n\n/g'),
FOREIGN KEY (facultyId) REFERENCES faculties (id)
);

GO

CREATE TABLE groups (
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[name] NVARCHAR (10) NOT NULL UNIQUE,
[year] INT NOT NULL,
departmentId INT NOT NULL,

CONSTRAINT CHK_groups_name CHECK ([name] NOT LIKE '/\n\n/g'),
CONSTRAINT CHK_groups_year CHECK ([year] >= 1 AND [year] <= 5),
FOREIGN KEY (departmentId)  REFERENCES departments (id)
);

GO 

CREATE TABLE  groupsCurators(
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
curatorId INT NOT NULL,
groupId INT NOT NULL,

FOREIGN KEY (curatorId)  REFERENCES curators (id),
FOREIGN KEY (groupId)  REFERENCES groups (id)
);

GO

CREATE TABLE subjects (
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[name] NVARCHAR (100) NOT NULL UNIQUE,

CONSTRAINT CHK_subjects_name CHECK ([name] NOT LIKE '/\n\n/g')
);

GO

CREATE TABLE teachers (
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[name] NVARCHAR (MAX) NOT NULL,
salary MONEY NOT NULL,
surname NVARCHAR (MAX) NOT NULL,

CONSTRAINT CHK_teachers_name CHECK ([name] NOT LIKE '/\n\n/g'),
CONSTRAINT CHK_teachers_salary CHECK (salary > 0),
CONSTRAINT CHK_teachers_surname CHECK (surname NOT LIKE '/\n\n/g')
);
GO

CREATE TABLE lectures (
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
lectureRoom NVARCHAR (MAX) NOT NULL,
subjectId INT NOT NULL,
teacherId INT NOT NULL,

CONSTRAINT CHK_lectures_lectureRoom CHECK (lectureRoom NOT LIKE '/\n\n/g'),

FOREIGN KEY (subjectId)  REFERENCES subjects (id),
FOREIGN KEY (teacherId)  REFERENCES teachers (id)
);
GO

CREATE TABLE groupsLectures(
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
groupId INT NOT NULL,
lectureId INT NOT NULL,

FOREIGN KEY (groupId)  REFERENCES groups (id),
FOREIGN KEY (lectureId)  REFERENCES lectures (id)
);

--DROP DATABASE Academy;

-- Filling in the faculty table
INSERT INTO faculties (financing, name) VALUES
(100000, 'Computer Science'),
(80000, 'Engineering'),
(120000, 'Mathematics'),
(90000, 'Physics'),
(75000, 'Biology');

-- Filling out the table of departments
INSERT INTO departments (financing, [name], facultyId) VALUES
(50000, 'Software Development', 1),
(60000, 'Data Science', 1),
(45000, 'Mechanical Engineering', 2),
(55000, 'Electrical Engineering', 2),
(70000, 'Pure Mathematics', 3),
(40000, 'Applied Mathematics', 3),
(50000, 'Quantum Physics', 4),
(35000, 'Nuclear Physics', 4),
(30000, 'Genetics', 5),
(25000, 'Ecology', 5);

-- Filling out the group table
INSERT INTO groups (name, year, departmentId) VALUES
('P107', 1, 1),
('P108', 2, 1),
('P207', 3, 2),
('P208', 4, 2),
('E101', 1, 3),
('E102', 2, 3),
('E201', 3, 4),
('E202', 5, 4),
('M301', 1, 5),
('M302', 5, 6);

-- Filling in the table of curators
INSERT INTO curators (name, surname) VALUES
('John', 'Smith'),
('Emily', 'Johnson'),
('Michael', 'Williams'),
('Sarah', 'Brown'),
('David', 'Jones');

-- Filling in the table of connections between groups and curators
INSERT INTO groupsCurators (curatorId, groupId) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);

-- Filling out the table of disciplines
INSERT INTO subjects (name) VALUES
('Database Theory'),
('Programming Fundamentals'),
('Algorithms and Data Structures'),
('Computer Networks'),
('Operating Systems'),
('Calculus'),
('Linear Algebra'),
('Quantum Mechanics'),
('Genetics'),
('Ecology');

-- Filling out the teacher table
INSERT INTO teachers (name, salary, surname) VALUES
('Samantha', 5000, 'Adams'),
('Robert', 4500, 'Wilson'),
('Jennifer', 4800, 'Taylor'),
('William', 5200, 'Anderson'),
('Elizabeth', 4700, 'Thomas');

-- Filling in the lecture table
INSERT INTO lectures (lectureRoom, subjectId, teacherId) VALUES
('B103', 1, 1),
('A205', 2, 2),
('B103', 3, 3),
('C301', 4, 4),
('D102', 5, 5),
('B103', 6, 1),
('A205', 7, 2),
('B103', 8, 3),
('C301', 9, 4),
('D102', 10, 5);

-- Filling in the table of connections between groups and lectures
INSERT INTO groupsLectures (groupId, lectureId) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);

-- 1. Output all possible pairs of teacher and group strings
SELECT t.Name, t.Surname, g.Name AS GroupName
FROM Teachers t, Groups g;

-- 2. Display the names of faculties whose department funding fund exceeds the faculty funding fund
SELECT f.Name
FROM faculties f
WHERE f.financing < (
SELECT SUM(d.financing)
FROM departments d
WHERE d.facultyId = f.id);

-- 3. Display the names of group curators and the names of the groups they supervise
SELECT c.Surname, g.Name AS GroupName
FROM Curators c
JOIN GroupsCurators gc ON c.Id = gc.CuratorId
JOIN Groups g ON g.Id = gc.GroupId;

-- 4. Display the names and surnames of the teachers who give lectures to group "P107"
SELECT DISTINCT t.Name, t.Surname
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON g.Id = gl.GroupId
WHERE g.Name = 'P107';

-- 5. Display the names of teachers and the names of the departments where they lecture
SELECT DISTINCT t.Surname, f.Name AS FacultyName
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON g.Id = gl.GroupId
JOIN Departments d ON d.Id = g.DepartmentId
JOIN Faculties f ON f.Id = d.FacultyId;

-- 6. Display the names of departments and the names of the groups that belong to them
SELECT d.Name AS DepartmentName, g.Name AS GroupName
FROM Departments d
JOIN Groups g ON d.Id = g.DepartmentId;

-- 7. Display the names of the courses taught by the teacher "Samantha Adams"
SELECT s.Name AS SubjectName
FROM Subjects s
JOIN Lectures l ON s.Id = l.SubjectId
JOIN Teachers t ON t.Id = l.TeacherId
WHERE t.Name = 'Samantha' AND t.Surname = 'Adams';

-- 8. Display the names of departments where the course "Database Theory" is taught
SELECT DISTINCT d.Name AS DepartmentName
FROM Departments d
JOIN Groups g ON d.Id = g.DepartmentId
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON l.Id = gl.LectureId
JOIN Subjects s ON s.Id = l.SubjectId
WHERE s.Name = 'Database Theory';

-- 9. Display the names of groups that belong to the faculty "Computer Science"
SELECT g.Name AS GroupName
FROM Groups g
JOIN Departments d ON d.Id = g.DepartmentId
JOIN Faculties f ON f.Id = d.FacultyId
WHERE f.Name = 'Computer Science';

-- 10. Display the names of the 5th year groups, as well as the names of the faculties to which they belong
SELECT g.Name AS GroupName, f.Name AS FacultyName
FROM Groups g
JOIN Departments d ON d.Id = g.DepartmentId
JOIN Faculties f ON f.Id = d.FacultyId
WHERE g.Year = 5;

-- 11. Display full names of teachers and lectures they give (names of disciplines and groups), 
-- and select only those lectures that are given in room "B103"
SELECT t.Name + ' ' + t.Surname AS TeacherFullName, 
       s.Name AS SubjectName, 
       g.Name AS GroupName
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
JOIN Subjects s ON s.Id = l.SubjectId
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON g.Id = gl.GroupId
WHERE l.LectureRoom = 'B103';