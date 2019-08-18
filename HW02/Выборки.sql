/*
Напишите выборки для того, чтобы получить:
1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
2. Поставщиков, у которых не было сделано ни одного заказа (потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)
3. Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа, включите также к какой трети года относится дата - каждая треть по 4 месяца, дата забора заказа должна быть задана, с ценой товара более 100$ либо количество единиц товара более 20. Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей. Соритровка должна быть по номеру квартала, трети года, дате продажи. 
4. Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, добавьте название поставщика, имя контактного лица принимавшего заказ
5. 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ.
6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
*/

--1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
SELECT [StockItemID], 
       [StockItemName]
FROM [WideWorldImporters].[Warehouse].[StockItems]
WHERE([StockItemName] LIKE '%urgent%')
     OR ([StockItemName] = N'Animal%');
	 
/*
2. Поставщиков, у которых не было сделано ни одного заказа 
(потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)*/
SELECT p.PersonID, 
       p.FullName
FROM Application.People AS p
     INNER JOIN Purchasing.Suppliers AS s ON p.PersonID = s.PrimaryContactPersonID
     LEFT OUTER JOIN Sales.Orders AS o ON p.PersonID = o.PickedByPersonID
WHERE(o.PickedByPersonID IS NULL);

/*
3. Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа, 
включите также к какой трети года относится дата - каждая треть по 4 месяца, 
дата забора заказа должна быть задана, с ценой товара более 100$ либо количество единиц товара более 20. 
Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей. 
Соритровка должна быть по номеру квартала, трети года, дате продажи. 
*/
SELECT DATENAME(mm, Sales.Orders.OrderDate) AS _Month, 
       DATEPART(QUARTER, Sales.Orders.OrderDate) AS _QUARTER,
       CASE
           WHEN MONTH(OrderDate) BETWEEN 1 AND 4
           THEN 1
           WHEN MONTH(OrderDate) BETWEEN 5 AND 8
           THEN 2
           WHEN MONTH(OrderDate) BETWEEN 9 AND 12
           THEN 3
       END AS [Треть Года]
FROM Sales.Orders
     INNER JOIN Sales.OrderLines ON Sales.Orders.OrderID = Sales.OrderLines.OrderID
WHERE(Sales.OrderLines.Quantity > 20)
     OR ((Sales.OrderLines.UnitPrice > 100))
ORDER BY _QUARTER, 
         [Треть Года], 
         Sales.Orders.OrderDate
OFFSET 1000 ROWS FETCH FIRST 100 ROWS ONLY;

/*
4. Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, 
добавьте название поставщика, имя контактного лица принимавшего заказ
*/
SELECT        o.OrderID, Sales.Customers.CustomerName, p.FullName, d.DeliveryMethodName
FROM            Sales.Orders AS o INNER JOIN
                         Sales.Customers ON o.CustomerID = Sales.Customers.CustomerID INNER JOIN
                         Application.People AS p ON o.SalespersonPersonID = p.PersonID INNER JOIN
                         Sales.Invoices AS i ON i.OrderID = o.OrderID INNER JOIN
                         Application.DeliveryMethods AS d ON i.DeliveryMethodID = d.DeliveryMethodID
WHERE        (YEAR(o.OrderDate) = '2014') AND (d.DeliveryMethodName = N'POST') OR
                         (d.DeliveryMethodName = N'Road Freight')


/*
5. 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ.
*/
SELECT        TOP (10) o.OrderID, c.CustomerName, p.FullName, o.OrderDate
FROM            Sales.Orders AS o INNER JOIN
                         Sales.Customers AS c ON o.CustomerID = c.CustomerID INNER JOIN
                         Application.People AS p ON o.SalespersonPersonID = p.PersonID
ORDER BY o.OrderDate DESC

SELECT        TOP (10) o.OrderID, c.CustomerName, p.FullName, o.OrderDate
FROM            Sales.Orders AS o INNER JOIN
                         Sales.Customers AS c ON o.CustomerID = c.CustomerID INNER JOIN
                         Application.People AS p ON o.SalespersonPersonID = p.PersonID
ORDER BY  convert(datetime, o.OrderDate, 103) DESC

/*
6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
*/
SELECT       distinct Sales.Customers.CustomerID, Sales.Customers.CustomerName, Sales.Customers.PhoneNumber, Sales.InvoiceLines.InvoiceID, Sales.InvoiceLines.Description
FROM            Sales.Customers INNER JOIN
                         Sales.Orders ON Sales.Customers.CustomerID = Sales.Orders.CustomerID INNER JOIN
                         Sales.Invoices ON Sales.Customers.CustomerID = Sales.Invoices.CustomerID   INNER JOIN
                         Sales.InvoiceLines ON Sales.Invoices.InvoiceID = Sales.InvoiceLines.InvoiceID
WHERE        (Sales.InvoiceLines.Description LIKE 'Chocolate frogs 250g')
order by Sales.Customers.CustomerID