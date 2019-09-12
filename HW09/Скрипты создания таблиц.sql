/*
Используем DDL
Начало проектной работы. 
Создание таблиц и представлений для своего проекта.
Нужно используя операторы DDL создать:
1. 3-4 основные таблицы для своего проекта. 
2. Первичные и внешние ключи для всех созданных таблиц
3. 1-2 индекса на таблицы


В качестве проекта вы можете взять любую идею, которая вам близка и сделать схему базы данных, а затем создать ее. 
Это может быть какая-то часть вашего рабочего проекта, которую вы хотите переосмыслить. 
Если есть идея, но не понятно как ее уложить в рамки учебного проекта, напишите преподавателю и мы поможем.

*/


/*

USE MASTER
GO
IF DB_ID (N'AgriDB') IS NOT NULL 
DROP DATABASE AgriDB; 

*/

CREATE DATABASE AgriDB  
GO

USE AgriDB
GO

CREATE TABLE [dbo].[TypeEvents](
	[TypeEventID] [int] IDENTITY(1,1) NOT NULL,
	[TypeEventName] [nvarchar](50) NULL,
	PRIMARY KEY ([TypeEventID])
)

CREATE TABLE [dbo].[Events](
	[EventsID] [int] IDENTITY(1,1) NOT NULL,
	[EventsName] [nvarchar](50) NOT NULL,
	[TypeEventID] [int] FOREIGN KEY REFERENCES TypeEvents(TypeEventID),
	[DateOFEvents] [datetime2](7) NULL,
	[DateOFInsert] [datetime2](7) DEFAULT CURRENT_TIMESTAMP
	PRIMARY KEY ([EventsID]) 
 )
 
CREATE NONCLUSTERED INDEX IX_Events_DateOFInsert ON Events(DateOFInsert);
CREATE NONCLUSTERED INDEX IX_Events_Name ON Events(EventsName);
 
CREATE TABLE [dbo].[SourceType](
	[SourceTypeID] [int] IDENTITY(1,1) NOT NULL,
	[SourceTypeName] [nvarchar](50) NULL,
	PRIMARY KEY ([SourceTypeID])
)


CREATE TABLE [dbo].[Source](
	[SourceID] [int] IDENTITY(1,1) NOT NULL,
	[SourceName] [nvarchar](50) NULL,
	[SourceType] [int] ,
	PRIMARY KEY ([SourceID])
 )
CREATE NONCLUSTERED INDEX IX_Source_SourceName ON Source(SourceName);


--добавление внешнего ключа после созданипя таблицы
ALTER TABLE [dbo].[Source]  WITH CHECK ADD FOREIGN KEY([SourceType])
REFERENCES [dbo].[SourceType] ([SourceTypeID])
GO






