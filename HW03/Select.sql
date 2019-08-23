/*
1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.
2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса. 
3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей из [Sales].[CustomerTransactions] представьте 3 способа (в том числе с CTE)
4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, а также Имя сотрудника, который осуществлял упаковку заказов
5. Объясните, что делает и оптимизируйте запрос:
SELECT 
Invoices.InvoiceID, 
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice, 
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL	
AND Orders.OrderId = Invoices.OrderId)	
) AS TotalSummForPickedItems
FROM Sales.Invoices 
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

*/

/*
1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.
*/
--не связанный подзапрос
SELECT *
FROM Application.People
WHERE PersonId NOT IN
(
    SELECT SalespersonPersonID
    FROM Sales.Invoices
);

--связанный подзапрос
SELECT *
FROM Application.People p
WHERE NOT EXISTS
(
    SELECT 1
    FROM Sales.Invoices
    WHERE SalespersonPersonID = p.PersonID
)
ORDER BY PersonID;


/*
2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса. 
*/

--cost 47%
SELECT StockItemID, 
       StockItemName, 
       UnitPrice
FROM Warehouse.StockItems
WHERE UnitPrice <= ALL
(
    SELECT UnitPrice
    FROM Warehouse.StockItems
);

-- cost 24%
/*
SELECT TOP (1) StockItemID, 
               StockItemName, 
               UnitPrice
FROM Warehouse.StockItems
GROUP BY UnitPrice, 
         StockItemID, 
         StockItemName
ORDER BY MIN(UnitPrice);
*/

-- cost 21%
SELECT StockItemID, 
       StockItemName, 
       UnitPrice
FROM Warehouse.StockItems s
WHERE UnitPrice <=
(
    SELECT MIN(UnitPrice)
    FROM Warehouse.StockItems
);

-- cost 32%
;WITH StockItemsCTE (StockItemID,minUnitPrice,StockItemName) AS 
(
SELECT top(1)  StockItemID, MIN(UnitPrice), StockItemName
FROM Warehouse.StockItems
group by UnitPrice,StockItemName,StockItemID
order by MIN(UnitPrice)
)

SELECT s.StockItemID, s.StockItemName, s.UnitPrice
FROM Warehouse.StockItems  AS s
	JOIN StockItemsCTE AS ss
		ON s.UnitPrice = ss.minUnitPrice


/*
3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей из [Sales].[CustomerTransactions] 
представьте 3 способа (в том числе с CTE)
*/

SELECT TOP (5) tr.CustomerID, 
               tr.TransactionAmount
FROM WideWorldImporters.Sales.CustomerTransactions AS tr
     INNER JOIN WideWorldImporters.Sales.Customers AS c ON tr.CustomerID = c.CustomerID
GROUP BY tr.CustomerID, 
         tr.TransactionAmount
ORDER BY tr.TransactionAmount DESC, 
         CustomerID;

;WITH CustomerCTE(CustomerID, 
                 TransactionAmount)
     AS (SELECT TOP (5) tr.CustomerID, 
                        tr.TransactionAmount
         FROM WideWorldImporters.Sales.CustomerTransactions AS tr
              INNER JOIN WideWorldImporters.Sales.Customers AS c ON tr.CustomerID = c.CustomerID
         GROUP BY tr.CustomerID, 
                  tr.TransactionAmount
         ORDER BY tr.TransactionAmount DESC, 
                  CustomerID)
     SELECT CustomerID, 
            TransactionAmount
     FROM CustomerCTE;
	 
SELECT CustomerID, 
       TransactionAmount
FROM WideWorldImporters.Sales.CustomerTransactions AS tr
     JOIN
(
    SELECT TOP (5) CustomerTransactionID
    FROM WideWorldImporters.Sales.CustomerTransactions
    ORDER BY TransactionAmount DESC,
                  CustomerID
) AS o ON tr.CustomerTransactionID = o.CustomerTransactionID;	 
	 
	 
SELECT CustomerID, 
       TransactionAmount
FROM WideWorldImporters.Sales.CustomerTransactions AS tr
WHERE tr.CustomerTransactionID IN
(
    SELECT TOP (5) CustomerTransactionID
    FROM WideWorldImporters.Sales.CustomerTransactions
    ORDER BY TransactionAmount DESC
);	 

/*
4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров,
 а также Имя сотрудника, который осуществлял упаковку заказов
 */
SELECT DISTINCT 
       Application.Cities.CityName, 
       Application.Cities.CityID, 
       Sales.Invoices.PackedByPersonID
FROM Sales.InvoiceLines
     INNER JOIN Warehouse.StockItems AS StockItems ON Sales.InvoiceLines.StockItemID = StockItems.StockItemID
     INNER JOIN Sales.Invoices ON Sales.InvoiceLines.InvoiceID = Sales.Invoices.InvoiceID
     INNER JOIN Sales.CustomerTransactions AS CustomerTransactions
     INNER JOIN Sales.Customers ON CustomerTransactions.CustomerID = Sales.Customers.CustomerID
     INNER JOIN Application.Cities ON Sales.Customers.DeliveryCityID = Application.Cities.CityID ON Sales.Invoices.CustomerID = Sales.Customers.CustomerID
WHERE(StockItems.StockItemID IN
(
    SELECT TOP (3) StockItemID
    FROM Warehouse.StockItems AS StockItems
    ORDER BY UnitPrice DESC
))
GROUP BY Application.Cities.CityName, 
         Application.Cities.CityID, 
         Sales.Invoices.PackedByPersonID
order by Application.Cities.CityName
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------5. Объясните, что делает и оптимизируйте запрос:------------------------------------
-----------------------------------------------------------------------------------------------------------------------
/*
SELECT 
Invoices.InvoiceID, 
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice, 
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL	
AND Orders.OrderId = Invoices.OrderId)	
) AS TotalSummForPickedItems
FROM Sales.Invoices 
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC
*/

/*
 Анализ плана выполнения:
1) В плане выполнения 4 раза читается таблица InvoiceLines и 4 раза читается таблица Invoices(На выходе InvoiceLines+Invoices), соединие hash join - оптимальное
2) Содержимое шага 1 соединяется с чтением 4х раз таблицы people (На выходе InvoiceLines+Invoices+people), соединие hash join - оптимальное
3) 4 раза читается OrderLines и 4 раза читается таблица Orders(OrderLines+Orders), соединие hash join - оптимальное
4) Содение выборки из шага 2(InvoiceLines+Invoices) и 3(OrderLines+Orders) 
*/
/*
Выводы:
1) Необходимо сократить кол-во итераций при чтении таблиц
2) Требуется проверить индексы и добавить покрывающие чтобы в листиях индекса были данные которые выбитрают select в выборках.
3) (Опциональный) Если допускается для данного отчета делать грязное чтение данных чтобы не блокировать таблицы при select операциях
*/

--№1 Попытка переписать
--вычисление сделок с клиентами на сумму более чем 27000
;WITH InvoiceLinesCTE(InvoiceId, TotalSumm)
	 AS (SELECT InvoiceId, SUM(Quantity * UnitPrice) AS TotalSumm
		 FROM Sales.InvoiceLines
		 GROUP BY InvoiceId
		 HAVING SUM(Quantity * UnitPrice) > 27000)

	 SELECT il.InvoiceId, i.InvoiceDate,
	 (
		 SELECT [FullName]
		 FROM [Application].[People] AS p
		 WHERE i.SalespersonPersonID = p.PersonID
	 ) AS SalespersonPersonName, il.TotalSumm,
	 (
		 SELECT SUM(OrderLines.PickedQuantity * OrderLines.UnitPrice)
		 FROM Sales.OrderLines
		 WHERE OrderLines.OrderId =
		 (
			 SELECT Orders.OrderId
			 FROM Sales.Orders
			 WHERE Orders.OrderId = i.OrderID AND 
			 Orders.PickingCompletedWhen IS NOT NULL  
				   
		 )
	 ) AS TotalSummForPickedItems
	 FROM InvoiceLinesCTE AS iL
		  INNER JOIN
		  [Sales].[Invoices] AS I
		  ON iL.InvoiceId = i.InvoiceID
		  ORDER BY il.TotalSumm DESC;
		  
		  
--№2 Попытка переписать (стало хуже)
--вычисление сделок с клиентами на сумму более чем 27000
;WITH InvoiceLinesCTE(InvoiceId, TotalSumm)
	 AS (SELECT InvoiceId, SUM(Quantity * UnitPrice) AS TotalSumm
		 FROM Sales.InvoiceLines
		 GROUP BY InvoiceId
		 HAVING SUM(Quantity * UnitPrice) > 27000)

	 SELECT il.InvoiceId, i.InvoiceDate,
	 (
		 SELECT [FullName]
		 FROM [Application].[People] AS p
		 WHERE i.SalespersonPersonID = p.PersonID
	 ) AS SalespersonPersonName, il.TotalSumm,
	 (
		 SELECT SUM(ol.PickedQuantity * ol.UnitPrice)
		 FROM Sales.OrderLines as OL
		 inner join Sales.Orders as o
		 on ol.OrderId = o.OrderID AND 
			 ol.PickingCompletedWhen IS NOT NULL
	 ) AS TotalSummForPickedItems
	 FROM InvoiceLinesCTE AS iL
		  INNER JOIN
		  [Sales].[Invoices] AS I
		  ON iL.InvoiceId = i.InvoiceID
		  ORDER BY il.TotalSumm DESC;