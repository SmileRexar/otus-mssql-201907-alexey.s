/*
XML, JSON и динамический SQL
1. Загрузить данные из файла StockItems.xml в таблицу StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (искать по StockItemName).
Файл StockItems.xml в личном кабинете.

2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml

3. В таблице StockItems в колонке CustomFields есть данные в json.
Написать select для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- Range (из CustomFields)

4. Найти в StockItems строки, где есть тэг "Vintage"
Запрос написать через функции работы с JSON.
Тэги искать в поле CustomFields, а не в Tags.

5. Пишем динамический PIVOT. 
По заданию из 8го занятия про CROSS APPLY и PIVOT 
Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Нужно написать запрос, который будет генерировать результаты для всех клиентов 
имя клиента указывать полностью из CustomerName
дата должна иметь формат dd.mm.yyyy например 25.12.2019
*/

/*
1. Загрузить данные из файла StockItems.xml в таблицу StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (искать по StockItemName).
Файл StockItems.xml в личном кабинете.
*/

DROP TABLE IF EXISTS #tmpStockItems
CREATE TABLE #tmpStockItems(
	SupplierID INT,
	StockItemName NVARCHAR(100),
	UnitPackageID INT,
	OuterPackageID INT,
	QuantityPerOuter INT,
	TypicalWeightPerUnit DECIMAL(18,3),
	LeadTimeDays INT,
	IsChillerStock BIT,
	TaxRate DECIMAL(18,3),
	UnitPrice DECIMAL(18,3)
)
GO

INSERT INTO #tmpStockItems (SupplierID, StockItemName, UnitPackageID,OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate,UnitPrice) 
SELECT X.product.query('SupplierID').value('.', 'INT'),
	   X.product.value('@Name', 'NVARCHAR(100)'),
       X.product.query('Package/UnitPackageID').value('.', 'INT'),
	   X.product.query('Package/OuterPackageID').value('.', 'INT'),
	   X.product.query('Package/QuantityPerOuter').value('.', 'INT'),
	   X.product.query('Package/TypicalWeightPerUnit').value('.', 'DECIMAL(18,3)'),
	   X.product.query('LeadTimeDays').value('.', 'INT'),
	   X.product.query('IsChillerStock').value('.', 'BIT'),
	   X.product.query('TaxRate').value('.', 'DECIMAL(18,3)'),
	   X.product.query('UnitPrice').value('.', 'DECIMAL(18,3)')
FROM ( 
SELECT CAST(x AS XML)
FROM OPENROWSET(
     BULK 'C:\Source\otus-mssql-201907-alexey.s\HW12\StockItems-188-f89807.xml',
     SINGLE_BLOB) AS T(x)
     ) AS T(x)
CROSS APPLY x.nodes('StockItems/Item') AS X(product);
GO

SELECT * FROM #tmpStockItems
 
/*
Устаревший код
select *
from #tmpStockItems
t inner join [Warehouse].[StockItems] s
on t.StockItemName=s.StockItemName
COLLATE SQL_Latin1_General_CP1_CI_AS
where s.StockItemName is null
*/
GO

/*
Режим отладки.
1 - включен, вывод текстовых сообщений
0 - выключен
*/
DECLARE @DebugMode int=1

BEGIN TRY
BEGIN TRANSACTION;

--обновление совпадающих записей
IF EXISTS(
SELECT t.*
FROM #tmpStockItems
t INNER JOIN [Warehouse].[StockItems] s
on t.StockItemName=s.StockItemName
COLLATE SQL_Latin1_General_CP1_CI_AS
)
BEGIN
   UPDATE s
	 SET	s.[SupplierID] = t.[SupplierID],
			s.[StockItemName] = t.[StockItemName],
			s.[UnitPackageID] = t.[UnitPackageID],
			s.[OuterPackageID] = t.[OuterPackageID],
			s.[QuantityPerOuter] = t.[QuantityPerOuter],
			s.[TypicalWeightPerUnit] = t.[TypicalWeightPerUnit],
			s.[LeadTimeDays] = t.[LeadTimeDays],
			s.[IsChillerStock] = t.[IsChillerStock],
			s.[TaxRate] = t.[TaxRate],
			s.[UnitPrice] = t.[UnitPrice]
FROM [Warehouse].[StockItems] s
INNER JOIN #tmpStockItems t
on s.StockItemName=t.StockItemName
COLLATE SQL_Latin1_General_CP1_CI_AS
	if(@DebugMode<>0)
	print  'Updated succeed'
END
ELSE
	if(@DebugMode<>0)
    print  'Don''t have row for update'

--вставка новых записей
IF NOT EXISTS(
select t.*
from #tmpStockItems
t left join [Warehouse].[StockItems] s
on t.StockItemName=s.StockItemName
COLLATE SQL_Latin1_General_CP1_CI_AS
where s.StockItemName is null
)
	if(@DebugMode<>0)
	print 'Table #tmpStockItems don''t have new Items to record'
ELSE
begin
   insert into [Warehouse].[StockItems](
	   [SupplierID],
       [StockItemName]
      ,[UnitPackageID]
      ,[OuterPackageID]
      ,[QuantityPerOuter]
	  ,[TypicalWeightPerUnit]
	  ,[LeadTimeDays]
      ,[IsChillerStock]
      ,[TaxRate]
      ,[UnitPrice],
	  [LastEditedBy]
   ) 
select t.*, 1
from #tmpStockItems
t left join [Warehouse].[StockItems] s
on t.StockItemName=s.StockItemName
COLLATE SQL_Latin1_General_CP1_CI_AS
where s.StockItemName is null
	if(@DebugMode<>0)
	print 'Inserted succeed'
end
  COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END CATCH;

/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/
SELECT 
		[StockItemName] AS [@Name]	
		,[SupplierID]
		,[UnitPackageID] AS [Package/UnitPackageID]
		,[OuterPackageID] AS [Package/OuterPackageID]
		,[QuantityPerOuter] AS [Package/QuantityPerOuter]
		,[TypicalWeightPerUnit] AS [Package/TypicalWeightPerUnit]
		,[LeadTimeDays]
		,[IsChillerStock]
		,[TaxRate]
		,[UnitPrice]
  FROM [WideWorldImporters].[Warehouse].[StockItems]
FOR XML PATH('Item'), ROOT('StockItems'), ELEMENTS

/*
3. В таблице StockItems в колонке CustomFields есть данные в json.
Написать select для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- Range (из CustomFields)
*/
SELECT StockItemID, 
       StockItemName, 
       JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture, 
       JSON_VALUE(CustomFields, '$.Range') AS Range1
FROM [WideWorldImporters].[Warehouse].[StockItems];

/*
4. Найти в StockItems строки, где есть тэг "Vintage"
Запрос написать через функции работы с JSON.
Тэги искать в поле CustomFields, а не в Tags.
*/
SELECT CustomFields, 
       StockItemID, 
       StockItemName, 
       JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture, 
       JSON_VALUE(CustomFields, '$.Range') AS Range1, 
       JSON_VALUE(CustomFields, '$.Tags[0]') AS aaa
FROM [WideWorldImporters].[Warehouse].[StockItems]
WHERE JSON_VALUE(CustomFields, '$.Tags[0]') = 'Vintage'
      OR JSON_VALUE(CustomFields, '$.Tags[1]') = 'Vintage';
	  
	  
	  
/*
5. Пишем динамический PIVOT. 
По заданию из 8го занятия про CROSS APPLY и PIVOT 
Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Нужно написать запрос, который будет генерировать результаты для всех клиентов 
имя клиента указывать полностью из CustomerName
дата должна иметь формат dd.mm.yyyy например 25.12.2019	  
*/
	  
--начальный pivot, статический	  
SELECT *
FROM
(
    SELECT format([InvoiceDate], 'MM-yyyy') AS Data1, 
           c.[CustomerName] AS [CustomerName], 
           COUNT(*) AS [Count]
    FROM [WideWorldImporters].[Sales].[Invoices] AS i
         INNER JOIN [Sales].[Customers] AS c ON i.CustomerID = c.CustomerID
    WHERE i.CustomerID BETWEEN 2 AND 6
    GROUP BY format([InvoiceDate], 'MM-yyyy'), 
             c.[CustomerName]
) AS Cl PIVOT(SUM([Count]) FOR [CustomerName] IN([Tailspin Toys (Sylvanite, MT)], 
                                                 [Tailspin Toys (Peeples Valley, AZ)], 
                                                 [Tailspin Toys (Medicine Lodge, KS)], 
                                                 [Tailspin Toys (Gasport, NY)], 
                                                 [Tailspin Toys (Jessie, ND)])) AS PVT
												 
												 
												 
--начальный pivot, динамический	 
												 
 --переменная названий столбцов
DECLARE @PivotColumns AS NVARCHAR(MAX)
DECLARE @SqlQuery as nvarchar(max)

SET @PivotColumns = N'';
--склейка столбцов для вывода
SELECT @PivotColumns += QUOTENAME([CustomerName]) + ', '
FROM [Sales].[Customers]
where CustomerID between 2 and 6

--Убрать последний разделитель ,
SET @PivotColumns = LEFT(@PivotColumns, LEN(@PivotColumns)-1)
PRINT @PivotColumns

set @SqlQuery = 
'
SELECT *
FROM
(
    SELECT format([InvoiceDate], ''MM-yyyy'') AS Data1, 
           c.[CustomerName] AS [CustomerName], 
           COUNT(*) AS [Count]
    FROM [WideWorldImporters].[Sales].[Invoices] AS i
         INNER JOIN [Sales].[Customers] AS c ON i.CustomerID = c.CustomerID
     WHERE i.CustomerID BETWEEN 2 AND 6
    GROUP BY format([InvoiceDate], ''MM-yyyy''), 
             c.[CustomerName]
) AS Cl PIVOT(SUM([Count]) FOR [CustomerName] IN(' +@PivotColumns +')) AS PVT'
print @SqlQuery
EXEC SP_EXECUTESQL @SqlQuery