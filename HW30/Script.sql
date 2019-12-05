/*
Секционирование таблицы
Выбираем в своем проекте таблицу-кандидат для секционирования и добавляем партиционирование. 
Если в проекте нет такой таблицы, то делаем анализ базы данных из первого модуля, выбираем таблицу и делаем ее секционирование, с переносом данных по секциям (партициям) - исходя из того, что таблица большая, пишем скрипты миграции в секционированную таблицу
Критерии оценки: 3 задание сдано и есть замечания, которые студент не хочет исправлять
+1 балл замечаний нет либо они исправлены
+1 балл ДЗ сдано в течение 1 недели с момента занятия
*/

/*
В задании будет сделана всекционировнаная таблица, аналог таблицы Orders из бд WideWorldImporters.
Разбивка для проверки по полю [OrderID]
*/

--проверка секционированных таблиц
select distinct t.name
from sys.partitions p
inner join sys.tables t
on p.object_id = t.object_id
where p.partition_number <> 1

/*Подготовка файловых групп для таблицы*/
ALTER DATABASE [WideWorldImporters] ADD FILEGROUP [OrderIDData]
GO

ALTER DATABASE [WideWorldImporters] ADD FILE 
( NAME = N'[OrderIDData]', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\OrderIDData.ndf' , 
SIZE = 2097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [OrderIDData]
GO


--создание новой секционированной таблицы
DROP TABLE IF EXISTS [Sales].OrdersPartitioned;


--функция партиционированния
CREATE PARTITION FUNCTION [OrderIDPartition](int) AS RANGE RIGHT FOR VALUES
(10000,20000,30000,40000,500000, 60000, 70000);	

--создание схемы
CREATE PARTITION SCHEME [schmOrderIDPartition] AS PARTITION [OrderIDPartition] 
ALL TO ([OrderIDData])
GO


/*
Удаление на всякий
DROP TABLE IF EXISTS [Sales].[OrdersPartitioned];
DROP PARTITION SCHEME [schmOrderIDPartition];
DROP PARTITION FUNCTION [OrderIDPartition];

*/

--таблица партицированных ордеров
CREATE TABLE [Sales].OrdersPartitioned(
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PickedByPersonID] [int] NULL,
	[ContactPersonID] [int] NOT NULL,
	[BackorderOrderID] [int] NULL,
	[OrderDate] [date] NOT NULL,
	[ExpectedDeliveryDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsUndersupplyBackordered] [bit] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,)
	ON [schmOrderIDPartition]([OrderID])
GO

ALTER TABLE [Sales].OrdersPartitioned ADD CONSTRAINT PK_Sales_OrdersPartitioned 
PRIMARY KEY CLUSTERED  ([OrderID])
 ON [schmOrderIDPartition]([OrderID]);
 
 
--Запись в партиционировнаную таблицу значений из ордеров 
insert into [Sales].OrdersPartitioned
select * from [Sales].Orders



/*
Блочная переброска
1) Сделать промежуточную таблицу 
SELECT * INTO [Sales].CopyOrders
FROM Sales.[Orders];

2) Удалять данные из промежуточной перебрасывая в оригинальную
while 1=1
begin
DELETE top(3000) [Sales].CopyOrders
OUTPUT DELETED.* INTO [Sales].[OrdersPartitioned]
 IF(@@ROWCOUNT = 0)
    BREAK
WAITFOR DELAY '00:00:00.100';
print @@ROWCOUNT
end
*/


--Таблица с партициями
SELECT TOP (1000) [OrderID]
      ,[CustomerID]
      ,[SalespersonPersonID]
      ,[PickedByPersonID]
      ,[ContactPersonID]
      ,[BackorderOrderID]
      ,[OrderDate]
      ,[ExpectedDeliveryDate]
      ,[CustomerPurchaseOrderNumber]
      ,[IsUndersupplyBackordered]
  FROM [WideWorldImporters].[Sales].[OrdersPartitioned]
  where Orderid >30000 and Orderid<50000

--Таблица без партиций
  SELECT TOP (1000) [OrderID]
      ,[CustomerID]
      ,[SalespersonPersonID]
      ,[PickedByPersonID]
      ,[ContactPersonID]
      ,[BackorderOrderID]
      ,[OrderDate]
      ,[ExpectedDeliveryDate]
      ,[CustomerPurchaseOrderNumber]
      ,[IsUndersupplyBackordered]
  FROM [WideWorldImporters].[Sales].[Orders]
  where Orderid >30000 and Orderid<50000