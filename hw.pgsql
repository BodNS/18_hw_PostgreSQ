/* создайте необходимые таблицы и реализуйте связи

добавьте (вставьте данные)

получить список студентов

получить список курсов

студенты которые учатся на курсе “data base”

получить список : курс и количество студентов, которые его изучают

получить список курсов которые проходит конкретный студент

получить список курсов которые идут более 40 часов

средний балл по группе студентов по каждому курсу */

--создайте необходимые таблицы и реализуйте связи

CREATE TABLE Courses
(
id           serial PRIMARY KEY,
title        varchar(64) NOT NULL UNIQUE,
description  varchar(64),
hours integer
);

CREATE TABLE Students
(
id           serial PRIMARY KEY,
name        varchar(64) NOT NULL,
surname  varchar(64) NOT NULL
);

CREATE TABLE Exams
(
id_stud integer REFERENCES Students (id) ON DELETE SET NULL ON UPDATE CASCADE,
id_course integer REFERENCES Courses (id) ON DELETE SET NULL ON UPDATE CASCADE,
mark integer
);

--добавьте (вставьте данные)
INSERT INTO Courses (title, description, hours)
VALUES ('Course1', 'qwerty1', 11),
        ('Course2', 'qwerty2', 32),
        ('Course3', 'qwerty3', 23),
        ('Course4', 'qwerty4', 44),
        ('Course5', 'qwerty5', 75),
        ('Course6', 'qwerty6', 56);

INSERT INTO Students (name, surname)
VALUES ('name1', 'surname1'),
        ('name2', 'surname2'),
        ('name3', 'surname3'),
        ('name4', 'surname4'),
        ('name5', 'surname5'),
        ('name6', 'surname6');

INSERT INTO Exams (id_stud, id_course, mark)
VALUES (1, 3, 5),
        (5, 2, 3),
        (6, 3, 4),
        (2, 6, 2),
        (4, 4, 4),
        (5, 5, 5),
        (3, 3, 5),
        (6, 6, 1),
        (3, 2, 1),
        (2, 4, 3),
        (5, 3, 2),
        (4, 3, 5);

--получить список студентов
SELECT *
FROM Students
LIMIT 10;
--получить список курсов
SELECT *
FROM Courses
LIMIT 10;
--студенты которые учатся на курсе “Course3”
SELECT S.name, S.surname
FROM Students as S JOIN Exams ON S.id = Exams.id_stud
JOIN Courses as C ON C.id = Exams.id_course
WHERE C.title = 'Course3';
--получить список : курс и количество студентов, которые его изучают
SELECT C.title, count (E.id_course) AS "KolVo"
FROM Courses as C LEFT JOIN Exams AS E ON C.id = E.id_course
GROUP BY C.title
ORDER BY C.title;
--получить список курсов которые проходит конкретный студент
SELECT S.surname, S.name, C.title
FROM Students as S JOIN Exams ON S.id = Exams.id_stud
JOIN Courses as C ON C.id = Exams.id_course
GROUP BY S.surname, S.name, C.title
ORDER BY S.surname;

SELECT S.surname::text ||' '|| S.name::text AS "FullName", C.title
FROM Students as S JOIN Exams ON S.id = Exams.id_stud
JOIN Courses as C ON C.id = Exams.id_course
GROUP BY "FullName", C.title
ORDER BY "FullName";
--получить список курсов которые идут более 40 часов
SELECT title, hours
FROM Courses
WHERE hours > 40
ORDER BY title;

SELECT title, hours
FROM Courses
WHERE hours > 40
ORDER BY hours DESC;
--средний балл по группе студентов по каждому курсу
SELECT C.title,
(SELECT string_agg (S.surname::text ||' '|| S.name::text, ', ')),
(SELECT AVG (exams.mark) AS "Sredn_bal")
FROM Students as S JOIN Exams ON S.id = Exams.id_stud
RIGHT JOIN Courses as C ON C.id = Exams.id_course
GROUP BY  C.title
ORDER BY C.title;