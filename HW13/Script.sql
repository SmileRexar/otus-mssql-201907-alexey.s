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

/*
3) Cозда5ть одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему
*/

--К ранее созданой процедуре из шага 2 добавить функцию ожинаковую по сигнатуре
IF OBJECT_ID ( 'ClientRpt.uspClientPriceInvoices' ) IS NOT NULL   
    DROP FUNCTION ClientRpt.tvf_ClientPriceInvoices;  
GO  

CREATE FUNCTION ClientRpt.tvf_ClientPriceInvoices(@СustomerID int) 

RETURNS TABLE  
AS  
RETURN   
(  
	SELECT il.UnitPrice * il.Quantity as Total
	FROM Sales.Customers c
     INNER JOIN sales.Invoices i ON c.CustomerID = i.CustomerID
     INNER JOIN sales.InvoiceLines iL ON i.InvoiceID = il.InvoiceID
	WHERE i.CustomerID = @СustomerID
);  
GO    

--вызов функции
select * from ClientRpt.tvf_ClientPriceInvoices (894)
order by Total desc

--вызов процедуры
EXEC ClientRpt.uspClientPriceInvoices @СustomerID=894

/*
Выводы:
1) В функции не удается вставить order by - 
The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, 
and common table expressions, unless TOP, OFFSET or FOR XML is also specified.
Соответствено фильтровать уже по столбцу на стороне вызывателя.
2) Маппер в sql для функции определяет функцию как таблицу и формат вызова для функции удобнее + внешнее поле видно для внешних словий.
В данном случае так как в функции "RETURNS TABLE" полуается удобный формат вызова и работы как с таблицей + поле Total доступно снаруже для опероаций агрегаций
3) План запроса отличается.
Для процедуры 
Table 'InvoiceLines'. Scan count 103, logical reads 1250, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Для функции 
Table 'InvoiceLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 161, lob physical reads 0, lob read-ahead reads 0.
Оценка sql в плане на левом операторе select не верная (в плане выролнения показывается, что процедура производительнее функции и план состоит соответственно 41% на процедуру и 59% на функцию).
В данном случае план ошибается из-за кол-ва выходных строк, ожидает 962 строки получить в случае функции и 10 строк для процедуры

*/


/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
Во всех процедурах, в описании укажите для преподавателям
*/

--абстрактная функция которая эмулирует некоторую логику в зависимости от переданного диапазона и формирует строку
--дописывает диапазоны в начало и конец, а само значение через разделитель подчеркивания указывается в центре

CREATE FUNCTION  dbo.ReplaceIdToName(
 @ID int
)
RETURNS nvarchar(100)
AS
BEGIN
if(@ID<100)
Return  '_0_' + CAST(@ID as nvarchar(10)) + '_100_'

if(@ID between 100 and 500)
Return  '_100_' + CAST(@ID as nvarchar(10)) + '_500_'

Return  '--------------------'
END


--Пример когда поле получаемое из функции передается на функцию обработчик которая каждую запись из выборки преобразует в засимости от правил.
--ниже вывод ClientRpt.tvf_ClientPriceInvoices передается на вход dbo.ReplaceIdToName которая "подменяет" каждую запись, просто абстрактынй пример
select dbo.ReplaceIdToName(Total) from ClientRpt.tvf_ClientPriceInvoices (894)
order by Total desc

/*
5) какой уровень изоляции нужен и почему. 
*/
/*
1) Смотря какие требования к данным для котороых применяется уровень
Желательно делать грязное/неблокирующее чтение данных если речь про отчеты.
Если данные не просто отчеты, а состояния - то уровень текущий или требуется повышать.
2) Уровни изоляций ещё не рассматривалисьв курсе =)
В целом я бы послушал перед ответом лекцию по применимости не с точки зрения блокитрования, а именно read committed/repeatable read примеры.
serializable - опасный все же, его бы не использовал.
read committed snapshot - крутая штука включения версионника для уровня read committed включенного по умолчанию в бд. Мягко иногда избавляет от делоков 
без переписывания ПО.
*/