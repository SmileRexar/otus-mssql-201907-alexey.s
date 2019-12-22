/*
Оконные функции
1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. Сравните планы. 
В качестве запроса с временной таблицей и табличной переменной можно взять свой запрос или следующий запрос:
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример 
Дата продажи Нарастающий итог по месяцу
2015-01-29	4801725.31
2015-01-30	4801725.31
2015-01-31	4801725.31
2015-02-01	9626342.98
2015-02-02	9626342.98
2015-02-03	9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/
--  Сам запрос
SELECT i.InvoiceID, c.CustomerName, i.CustomerID, i.InvoiceDate,
	SUM(il.Quantity * il.UnitPrice) OVER (PARTITION BY i.InvoiceID),
	SUM(il.Quantity * il.UnitPrice) OVER (ORDER BY DATEPART(YEAR, i.InvoiceDate), DATEPART(MONTH, i.InvoiceDate))
FROM Sales.Invoices i
INNER JOIN Sales.Customers c ON c.CustomerID = i.CustomerID
INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
WHERE i.InvoiceDate >= '20150101' 
ORDER BY i.InvoiceDate, i.CustomerID;

-- Проверка работы
set statistics time on 
-- запись в временную таблицу
DROP TABLE IF EXISTS tempdb.dbo.#TempT
SELECT i.InvoiceID, c.CustomerName, i.InvoiceDate,
	SUM(il.Quantity * il.UnitPrice) OVER (PARTITION BY i.InvoiceID) as Sum1,
	SUM(il.Quantity * il.UnitPrice) OVER (ORDER BY DATEPART(YEAR, i.InvoiceDate), DATEPART(MONTH, i.InvoiceDate)) as Sum2
into #TempT
FROM Sales.Invoices i
INNER JOIN Sales.Customers c ON c.CustomerID = i.CustomerID
INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
WHERE i.InvoiceDate >= '20150101' 
ORDER BY i.InvoiceDate, i.CustomerID;
select * from #TempT

DECLARE @Temp2 TABLE(
    InvoiceID nvarchar(150) NOT NULL,
    CustomerName nvarchar(150) NOT NULL, 
	InvoiceDate datetime NOT NULL,
	Sum1 int NOT NULL,
	Sum2 int NOT NULL
);

-- запись в табличную переменную
INSERT INTO @Temp2 (InvoiceID, CustomerName, InvoiceDate, Sum1, Sum2)
SELECT i.InvoiceID, c.CustomerName, i.InvoiceDate,
	SUM(il.Quantity * il.UnitPrice) OVER (PARTITION BY i.InvoiceID) as Sum1,
	SUM(il.Quantity * il.UnitPrice) OVER (ORDER BY DATEPART(YEAR, i.InvoiceDate), DATEPART(MONTH, i.InvoiceDate)) as Sum2
FROM Sales.Invoices i
INNER JOIN Sales.Customers c ON c.CustomerID = i.CustomerID
INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
WHERE i.InvoiceDate >= '20150101' 
ORDER BY i.InvoiceDate, i.CustomerID;
select * from @Temp2

/*
Для количества записей в dataset = 101356 
Вставка в временную таблицу 38% против вставки в табличную переменную 61% согласно актуальному плану выполнения
*/


/*
2. Если вы брали предложенный выше запрос, то сделайте расчет суммы нарастающим итогом с помощью оконной функции.
Сравните 2 варианта запроса - через windows function и без них. Написать какой быстрее выполняется, сравнить по set statistics time on;
2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)
3. Функции одним запросом
Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
посчитайте общее количество товаров и выведете полем в этом же запросе
посчитайте общее количество товаров в зависимости от первой буквы названия товара
отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
предыдущий ид товара с тем же порядком отображения (по имени)
названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций
4. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки
5. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

Опционально можно сделать вариант запросов для заданий 2,4,5 без использования windows function и сравнить скорость как в задании 1. 

*/

