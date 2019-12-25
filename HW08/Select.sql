/*
Pivot и Cross Apply
1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение 
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:
InvoiceMonth	Peeples Valley, AZ	Medicine Lodge, KS	Gasport, NY	Sylvanite, MT	Jessie, ND
01.01.2013	3	1	4	2	2
01.02.2013	7	3	4	2	1

2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке

Пример результатов
CustomerName	AddressLine
Tailspin Toys (Head Office)	Shop 38
Tailspin Toys (Head Office)	1877 Mittal Road
Tailspin Toys (Head Office)	PO Box 8975
Tailspin Toys (Head Office)	Ribeiroville
.....

3. В таблице стран есть поля с кодом страны цифровым и буквенным
сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
Пример выдачи

CountryId	CountryName	Code
1	Afghanistan	AFG
1	Afghanistan	4
3	Albania	ALB
3	Albania	8

4. Перепишите ДЗ из оконных функций через CROSS APPLY 
Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

5. Code review (опционально). Запрос приложен в материалы Hometask_code_review.sql. 
Что делает запрос? 
Чем можно заменить CROSS APPLY - можно ли использовать другую стратегию выборки\запроса?
*/

/*
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
*/

/*
Pivot и Cross Apply
1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение 
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:
InvoiceMonth	Peeples Valley, AZ	Medicine Lodge, KS	Gasport, NY	Sylvanite, MT	Jessie, ND
01.01.2013	3	1	4	2	2
01.02.2013	7	3	4	2	1
*/
SELECT *
FROM
(
    SELECT DATEADD(day, -DAY(i.InvoiceDate) + 1, i.InvoiceDate) AS InvoiceMonth, 
           SUBSTRING(c.CustomerName, CHARINDEX('(', c.CustomerName) + 1, CHARINDEX(')', c.CustomerName) - CHARINDEX('(', c.CustomerName) - 1) AS CustomerName, 
           i.InvoiceID
    FROM Sales.Customers AS c
         JOIN Sales.Invoices AS i ON c.CustomerID = i.CustomerID
    WHERE c.CustomerID >= 2
          AND c.CustomerID <= 6
) AS s PIVOT(COUNT(s.InvoiceID) FOR CustomerName IN([Sylvanite, MT], 
                                                    [Peeples Valley, AZ], 
                                                    [Medicine Lodge, KS], 
                                                    [Gasport, NY], 
                                                    [Jessie, ND])) AS PVT
ORDER BY InvoiceMonth;




/*
2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке

Пример результатов
CustomerName	AddressLine
Tailspin Toys (Head Office)	Shop 38
Tailspin Toys (Head Office)	1877 Mittal Road
Tailspin Toys (Head Office)	PO Box 8975
Tailspin Toys (Head Office)	Ribeiroville
*/


SELECT CustomerName, 
       DA
FROM
(
    SELECT DeliveryAddressLine1, 
           DeliveryAddressLine2, 
           CustomerName
    FROM Sales.Customers
    WHERE CustomerName LIKE 'Tailspin Toys%'
) D UNPIVOT(DA FOR AddressDataSet IN(DeliveryAddressLine1, 
                                     DeliveryAddressLine2)) AS UNP;

/*
3. В таблице стран есть поля с кодом страны цифровым и буквенным
сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
Пример выдачи

CountryId	CountryName	Code
1	Afghanistan	AFG
1	Afghanistan	4
3	Albania	ALB
3	Albania	8
*/

SELECT CountryID, 
       CountryName, 
       Code
FROM
(
    SELECT CountryID, 
           CountryName, 
           CAST(IsoAlpha3Code AS NVARCHAR) AS IsoAlpha3, 
           CAST(IsoNumericCode AS NVARCHAR) AS IsoNumeric
    FROM Application.Countries
) T UNPIVOT(Code FOR CodeList IN(IsoAlpha3, 
                           IsoNumeric)) AS UNP;