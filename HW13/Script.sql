/*
SP и function
1) Написать функцию возвращающую Клиента с набольшей
суммой покупки.
2) Написать хранимую процедуру с входящим параметром
СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
3) Cозда5ть одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
Во всех процедурах, в описании укажите для преподавателям
5) какой уровень изоляции нужен и почему. 

Опционально
6) Переписываем одну и ту же процедуру kitchen sink с множеством входных параметров по поиску в заказах на динамический SQL.
Сравниваем планы запроса. 
7) напишите запрос в транзакции где есть выборка, вставка\добавление\удаление данных и параллельно запускаем выборку данных в разных уровнях изоляции, нужно предоставить мини отчет, 
что на каком уровне было видно со скриншотами и ваши выводы (1-2 предложение) 
8) сделайте паралелльно в 2х окнах добавление данных в одну таблицу с разным уровнем изоляции, изменение данных в одной таблице, изменение одной и той же строки. 
Что в итоге получилось, что нового узнали.
*/


/*
1) Написать функцию возвращающую Клиента с набольшей суммой покупки.
*/

-- в 1 работа без проверки схемы, 2 со схемой бд

IF OBJECT_ID ( 'tvf_GetClientMaxPrice' ) IS NOT NULL   
   DROP FUNCTION tvf_GetClientMaxPrice
GO  


CREATE FUNCTION dbo.tvf_GetClientMaxPrice ()  
RETURNS TABLE  
AS  
RETURN   
(  
SELECT TOP (1)(il.Quantity * il.UnitPrice) AS TotalPrice, 
              i.CustomerID
FROM Sales.InvoiceLines AS iL
     INNER JOIN Sales.Invoices AS i ON il.InvoiceID = i.InvoiceID
ORDER BY(il.Quantity * il.UnitPrice) DESC
);  

go

select * from tvf_GetClientMaxPrice()

/*
2) Написать хранимую процедуру с входящим параметром
СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

--единоразово. Схема не пересоздается
CREATE SCHEMA [ClientRpt] AUTHORIZATION [dbo]
GO

IF OBJECT_ID ( 'ClientRpt.uspClientPriceInvoices', 'P' ) IS NOT NULL   
    DROP PROCEDURE ClientRpt.uspClientPriceInvoices;  
GO  

CREATE PROCEDURE ClientRpt.uspClientPriceInvoices
    @СustomerID int   
AS   

IF @СustomerID IS NULL  
BEGIN  
   PRINT 'Error: @CustomerID is null'  
   RETURN  
END  
SET NOCOUNT ON;  
SELECT il.UnitPrice * il.Quantity
FROM Sales.Customers c
     INNER JOIN sales.Invoices i ON c.CustomerID = i.CustomerID
     INNER JOIN sales.InvoiceLines iL ON i.InvoiceID = il.InvoiceID
WHERE i.CustomerID = @СustomerID
ORDER BY il.UnitPrice * il.Quantity DESC;
GO 

EXEC ClientRpt.uspClientPriceInvoices @СustomerID=894