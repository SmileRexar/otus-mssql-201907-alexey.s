-- ������� �������� ��
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

-- ��������� ������
INSERT INTO Table1(Name) VALUES('aaa')
INSERT INTO Table2(Name) VALUES('bbb')
GO

-- ������� ������
SELECT * FROM Table1;
SELECT * FROM Table2;
GO

-- ������ �� ��� ���������� 
DROP DATABASE IF EXISTS DB04_repl;
GO
CREATE DATABASE DB04_repl;
GO

-- ������� ���������� � SSMS
-- (���������� ����������)
-- ...

-- ������� �������� � SSMS
-- ...

-- ������� ������
USE DB04
SELECT * FROM Table1;

USE DB04_repl
SELECT * FROM Table1;

-- ��������� � ��������� ���� "��������" �� DB04 
-- �� Load.sql

-- ����� ������� ������
USE DB04
SELECT * FROM Table1;

USE DB04_repl
SELECT * FROM Table1;

-- SSMS Replication Monitor



