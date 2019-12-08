-- Создаем исходную БД
DROP DATABASE IF EXISTS DB04;
GO
CREATE DATABASE DB04;
GO

USE DB04;
GO

CREATE TABLE Table1
(
   ID INT IDENTITY PRIMARY KEY,
   [Name] nvarchar(50)
)
GO

CREATE TABLE Table2
(
	ID INT IDENTITY,
	[Name] nvarchar(10)
)
GO

-- Вставляем данные
INSERT INTO Table1(Name) VALUES('aaa')
INSERT INTO Table2(Name) VALUES('bbb')
GO

-- Смотрим данные
SELECT * FROM Table1;
SELECT * FROM Table2;
GO

-- Создем БД для репликации 
DROP DATABASE IF EXISTS DB04_repl;
GO
CREATE DATABASE DB04_repl;
GO

-- Создать публикацию в SSMS
-- (репликация транзакций)
-- ...

-- Создать подписку в SSMS
-- ...

-- Смотрим данные
USE DB04
SELECT * FROM Table1;

USE DB04_repl
SELECT * FROM Table1;

-- Запустить в отдельном окне "нагрузку" на DB04 
-- из Load.sql

-- Опять смотрим данные
USE DB04
SELECT * FROM Table1;

USE DB04_repl
SELECT * FROM Table1;

-- SSMS Replication Monitor



