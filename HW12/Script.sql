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

SELECT * FROM #tmpStockItems
 
/*
select *
from #tmpStockItems
t inner join [Warehouse].[StockItems] s
on t.StockItemName=s.StockItemName
COLLATE SQL_Latin1_General_CP1_CI_AS
where s.StockItemName is null
*/

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
END
ELSE
    print  'Don''t have row for update'



IF NOT EXISTS(
select t.*
from #tmpStockItems
t left join [Warehouse].[StockItems] s
on t.StockItemName=s.StockItemName
COLLATE SQL_Latin1_General_CP1_CI_AS
where s.StockItemName is null
)
   print  'Table #tmpStockItems don''t have new Items to record'
ELSE
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