CREATE DATABASE Academy;

USE Academy;

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

FOREIGN KEY (facultyId)  REFERENCES faculties (id)
);

GO

DROP TABLE groups;
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


CREATE TABLE groupsLectures(
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
groupId INT NOT NULL,
lectureId INT NOT NULL,

FOREIGN KEY (groupId)  REFERENCES groups (id),
FOREIGN KEY (lectureId)  REFERENCES lectures (id)
);

-- DROP DATABASE Academy;

-- 1. 
SELECT t.name, t.surname, g.name AS group_name
FROM teachers t, groups g;

-- 2. 
SELECT [name] 
FROM faculties 
WHERE financing < (SELECT MAX(financing) FROM departments);

-- 3. 
SELECT c.surname AS CuratorSurname, g.[name] AS GroupName 
FROM curators c, groups g 
WHERE c.id IN (SELECT curatorId FROM groupsCurators WHERE groupId = g.id);

--  4. 
SELECT [name], surname 
FROM teachers 
WHERE id IN (
    SELECT teacherId 
    FROM lectures 
    WHERE id IN (
        SELECT lectureId 
        FROM groupsLectures 
        WHERE groupId IN (
            SELECT id 
            FROM groups 
            WHERE [name] = 'P107'
        )
    )
);

-- 7. 
SELECT [name] 
FROM subjects 
WHERE id IN (
    SELECT subjectId 
    FROM lectures 
    WHERE teacherId IN (
        SELECT id 
        FROM teachers 
        WHERE [name] = 'Samantha' AND surname = 'Adams'
    )
);

-- 8. 
SELECT g.name 
FROM groups g 
WHERE g.departmentId IN (
    SELECT d.id 
    FROM departments d 
    WHERE d.facultyId IN (
        SELECT f.id 
        FROM faculties f 
        WHERE f.name = 'Computer Science'
    )
);