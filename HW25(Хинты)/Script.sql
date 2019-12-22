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


--Пример 2
;WITH CustomersCTE(CustomerID) AS (
	SELECT o.CustomerID FROM Sales.OrderLines ol
	INNER JOIN Sales.Orders o ON ol.OrderID = o.OrderID
	GROUP BY o.CustomerID
	HAVING SUM(ol.UnitPrice * ol.Quantity) > 250000
)
select CustomerID from CustomersCTE
--Сложность 0.48. 
Вывод: Лучше оптимизатора сделать не удалось

*/

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
1) По плану выполнения сложность с 7.5 упала до 5.3 за счет преварительной склейки данных.
2) Добавления грязного чтения set transaction isolation level read uncommitted не улучшает statistics time on, но годится для уменьшая блокировок при чтении (Shared) если разрешено бизнес логикой
*/