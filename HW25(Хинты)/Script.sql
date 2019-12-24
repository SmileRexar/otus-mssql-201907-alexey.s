/*
Оптимизируем запрос
Цель: Используем все свои полученные знания для оптимизации сложного запроса. 
Вариант 1. Вы можете взять запрос со своей работы с планом и показать, что было до оптимизации, какие решения вы применили, и что стало после. 
В этом случае нужно приложить Текст запроса, актуальный план и статистики по времени и операциям ввода\вывода до оптимизации и после оптимизации. 
Опишите кратко ход рассуждений при оптимизации. 

Вариант 2. Оптимизируйте запрос по БД WorldWideImporters. 
Приложите текст запроса со статистиками по времени и операциям ввода вывода, опишите кратко ход рассуждений при оптимизации. 
*/

Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)	FROM Sales.Orders AS ord JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID 
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID JOIN Warehouse.StockItemTransactions AS ItemTrans 
ON ItemTrans.StockItemID = det.StockItemID WHERE Inv.BillToCustomerID != ord.CustomerID AND (Select SupplierId FROM Warehouse.StockItems AS It Where It.StockItemID = det.StockItemID) = 12 
AND (SELECT SUM(Total.UnitPrice*Total.Quantity) FROM Sales.OrderLines AS Total Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID WHERE ordTotal.CustomerID = Inv.CustomerID) 
> 250000 AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 GROUP BY ord.CustomerID, det.StockItemID ORDER BY ord.CustomerID, det.StockItemID

/*
Используем DMV, хинты и все прочее для сложных случаев
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------


--Шаг 1
/*
Переписал на читаемый вид
*/
set statistics io on
Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)	
FROM Sales.Orders AS ord JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID 
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID 
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
WHERE Inv.BillToCustomerID != ord.CustomerID 
AND 
(Select SupplierId FROM Warehouse.StockItems AS It Where It.StockItemID = det.StockItemID) = 12 
AND 
(
SELECT SUM(Total.UnitPrice*Total.Quantity) 
FROM Sales.OrderLines AS Total 
Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID 
WHERE ordTotal.CustomerID = Inv.CustomerID
) > 250000 
AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID
/*
set statistics io on
Table 'StockItemTransactions'. Scan count 1, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 29, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 331, lob physical reads 0, lob read-ahead reads 0.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 216184, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/


--Шаг 2
/*
Запрос состоит из 3 вложенных подзапросов, которые требуется разобрать
1) (SELECT SupplierID FROM Warehouse.StockItems AS It WHERE (StockItemID = det.StockItemID))
2) (SELECT SUM(Total.UnitPrice * Total.Quantity) AS Expr1 FROM Sales.OrderLines AS Total INNER JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID WHERE (ordTotal.CustomerID = Inv.CustomerID))
3)  DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate)
их и нужно оптимизировать
*/

--Шаг3
/*
В подзапросах используются всего 3 таблицы с разным количекством записей в них.
Самая большая OrderLines, она связующую и по возможноссти нужно проверить на избыточность к обращениям к данной таблицы
select count(*) from  Sales.Orders
-- Warehouse.StockItems 229
-- Sales.OrderLines 231412
-- Sales.Orders 73595
*/


--Шаг4
/*
Заменил подзапрос с вычислением списка лучших клиентов
--Пример 1
set statistics io on
;WITH CustomersCTE(CustomerID, summ) AS (
	SELECT o.CustomerID, 
	SUM(ol.UnitPrice * ol.Quantity) OVER(PARTITION BY CustomerID)  
	FROM Sales.OrderLines ol
	INNER JOIN Sales.Orders o ON ol.OrderID = o.OrderID
	
)
select distinct o.CustomerID from CustomersCTE c
join Sales.Orders o
on o.CustomerID = c.CustomerID
where summ>250000
--запрос выполняется долго и высокая сложность ~2.8

--Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 163, lob physical reads 0, lob read-ahead reads 0.
--Table 'OrderLines'. Segment reads 1, segment skipped 0.
--Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--Table 'Orders'. Scan count 2, logical reads 382, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.


--Пример 2
set statistics io on
;WITH CustomersCTE(CustomerID) AS (
	SELECT o.CustomerID FROM Sales.OrderLines ol
	INNER JOIN Sales.Orders o ON ol.OrderID = o.OrderID
	GROUP BY o.CustomerID
	HAVING SUM(ol.UnitPrice * ol.Quantity) > 250000
)
select CustomerID from CustomersCTE
--Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 163, lob physical reads 0, lob read-ahead reads 0.
--Table 'OrderLines'. Segment reads 1, segment skipped 0.
--Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--Table 'Orders'. Scan count 1, logical reads 191, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

--Сложность 0.48. 
Вывод: Лучше оптимизатора сделать не удалось
В примере №2 меньше работа с таблицей Orders

*/


set statistics io on
;WITH CustomersCTE(CustomerID) AS (
	SELECT o.CustomerID FROM Sales.OrderLines ol
	INNER JOIN Sales.Orders o ON ol.OrderID = o.OrderID
	GROUP BY o.CustomerID
	HAVING SUM(ol.UnitPrice * ol.Quantity) > 250000
)
Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)	
FROM Sales.Orders AS ord JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID 
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID 
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
JOIN CustomersCTE cT on ord.CustomerID=cT.CustomerID
WHERE Inv.BillToCustomerID != ord.CustomerID 
AND 
(Select SupplierId FROM Warehouse.StockItems AS It Where It.StockItemID = det.StockItemID) = 12 
AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID
/*
Table 'StockItemTransactions'. Scan count 1, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 29, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 331, lob physical reads 0, lob read-ahead reads 0.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 54863, logical reads 277896, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Меньше обращений к таблице Invoices стало с 
*/

--Шаг5
/*
В выводе статистике большие значения для таблицы Invoices в полях Scan count 54863 и  logical reads 277896.
Scan count- это количество сканирований таблицы/индекса. Соответственно решено проверить наличие индексов для условий where в таблице Invoices, так и для условий при слоединениях.
*/
--Запрос соедения Invoices
select s.CustomerID
from Sales.Invoices i inner join sales.Orders s 
on i.OrderID = s.OrderID
WHERE i.BillToCustomerID <> s.CustomerID 
/*юез условия where sql сервер выбирает merge Оператор для условия on i.OrderID = s.OrderID/
А вот i.BillToCustomerID <> s.CustomerID  показывает Hash с примерной стоимостью оператора ~10.1 sql попугай.
После добавления доп поля BillToCustomerID в индекс FK_Sales_Invoices_OrderID выборка стала показывать оператор merge и стоимость 1.17 
*/
--ниже запрос перестроения через удаления и добавление индекса
USE [WideWorldImporters]
GO
DROP INDEX [FK_Sales_Invoices_OrderID] ON [Sales].[Invoices]
GO
CREATE NONCLUSTERED INDEX [FK_Sales_Invoices_OrderID] ON [Sales].[Invoices]
(
	[OrderID] ASC,
	[BillToCustomerID] ASC
) 
GO
--Шаг6 
/*
Проверка запроса из Шага4 после добавления поля в индекс в шаге 5
*/
/*
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 331, lob physical reads 0, lob read-ahead reads 0.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Scan count 3619, logical reads 25105, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 11767, logical reads 48242, physical reads 0, read-ahead reads 2, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/
--После добавления BillToCustomerID в FK_Sales_Invoices_OrderID число Scan count для таблицы Invoices упало с 54863 до 11767, т.е. меньше обращений к индексу при поиске


/*
1) По плану выполнения сложность с 7.5 упала до 5.3 за счет преварительной склейки данных.
2) Добавления грязного чтения set transaction isolation level read uncommitted не улучшает statistics time on, но годится для уменьшая блокировок при чтении (Shared) если разрешено бизнес логикой
3) Добавления доп поля в индексе сокращает количества операций для поиска по индеквсу
*/