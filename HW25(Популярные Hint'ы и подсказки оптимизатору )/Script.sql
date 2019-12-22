/*
Оптимизируем запрос
Цель: Используем все свои полученные знания для оптимизации сложного запроса. 
Вариант 1. Вы можете взять запрос со своей работы с планом и показать, что было до оптимизации, какие решения вы применили, и что стало после. 
В этом случае нужно приложить Текст запроса, актуальный план и статистики по времени и операциям ввода\вывода до оптимизации и после оптимизации. 
Опишите кратко ход рассуждений при оптимизации. 

Вариант 2. Оптимизируйте запрос по БД WorldWideImporters. 
Приложите текст запроса со статистиками по времени и операциям ввода вывода, опишите кратко ход рассуждений при оптимизации. 
*/
Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)	FROM Sales.Orders AS ord JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID WHERE Inv.BillToCustomerID != ord.CustomerID AND (Select SupplierId FROM Warehouse.StockItems AS It Where It.StockItemID = det.StockItemID) = 12 AND (SELECT SUM(Total.UnitPrice*Total.Quantity) FROM Sales.OrderLines AS Total Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000 AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 GROUP BY ord.CustomerID, det.StockItemID ORDER BY ord.CustomerID, det.StockItemID

/*
Используем DMV, хинты и все прочее для сложных случаев
*/