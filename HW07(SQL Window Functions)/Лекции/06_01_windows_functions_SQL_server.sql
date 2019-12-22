--заказы и оплаты по заказам
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	(SELECT MAX(inr.TransactionAmount)
	FROM Sales.CustomerTransactions as inr
		join Sales.Invoices as InvoicesInner ON 
			InvoicesInner.InvoiceID = inr.InvoiceID
	WHERE inr.CustomerID = trans.CustomerId
		AND InvoicesInner.InvoiceDate < '2014-01-01'
		) AS MaxPerCustomer
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId) AS MaxPerCustomer
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
--с сортировкой по сумме
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId) AS MaxPerCustomer,
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId 
						ORDER BY trans.TransactionAmount DESC) AS RowNumberByPaymentAmount
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

SELECT Invoices.InvoiceId, Invoices.InvoiceDate, 
	Invoices.CustomerID, trans.TransactionAmount,
	MAX(trans.TransactionAmount) MaxPayment
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
GROUP BY Invoices.InvoiceId, Invoices.InvoiceDate, 
	Invoices.CustomerID, trans.TransactionAmount
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
--с сортировкой по сумме
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.CustomerId, trans.TransactionAmount,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
ORDER BY Invoices.CustomerID, trans.TransactionAmount DESC

SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	LAG(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as prev,
	LEAD(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as Follow ,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID,Invoices.BillToCustomerID, trans.TransactionAmount,
	LAG(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as prev,
	LEAD(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as Follow ,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID in (958, 884)
ORDER BY trans.TransactionAmount DESC

SELECT *
FROM 
	(
		SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
			ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC) AS CustomerTransRank
		FROM Sales.Invoices as Invoices
			join Sales.CustomerTransactions as trans
				ON Invoices.InvoiceID = trans.InvoiceID
	) AS tbl
WHERE CustomerTransRank <= 3
order by CustomerID, TransactionAmount desc

select top(1) with ties *from Sales.Invoicesorder by row_number() OVER (partition by Invoices.CustomerID order by Invoices.InvoiceDate desc)

DECLARE @page INT = 2,
	@pageSize INT = 20;

WITH InvoiceLinePage AS
(
	SELECT I.InvoiceID, 
		I.InvoiceDate, 
		I.SalespersonPersonID, 
		L.Quantity, 
		L.UnitPrice,
		ROW_NUMBER() OVER (Order by InvoiceLineID) AS Row
	FROM Sales.Invoices AS I
		JOIN Sales.InvoiceLines AS L 
			ON I.InvoiceID = L.InvoiceID
)
SELECT *
FROM InvoiceLinePage
WHERE Row Between (@page-1)*@pageSize + 1 
	AND @page*@pageSize;

SELECT SupplierID, StockItemID, StockItemName,UnitPrice,
	LAG(UnitPrice) OVER (ORDER BY UnitPrice) AS lagv,
	LEAD(UnitPrice) OVER (ORDER BY UnitPrice) AS leadv,
	FIRST_VALUE(UnitPrice) OVER (ORDER BY UnitPrice) AS f,
	LAST_VALUE(UnitPrice) OVER (ORDER BY UnitPrice ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS l,
	LAST_VALUE(UnitPrice) OVER (ORDER BY UnitPrice) AS l_f,
	LAST_VALUE(UnitPrice) OVER (ORDER BY 1/0) AS l2
FROM Warehouse.StockItems
WHERE SupplierID = 7
ORDER By UnitPrice;

SELECT UnitPrice, SupplierID, StockItemID, StockItemName,
	ROW_NUMBER() OVER (ORDER BY UnitPrice),
	RANK() OVER (ORDER BY UnitPrice),
	DENSE_RANK() OVER (ORDER BY UnitPrice)
FROM Warehouse.StockItems
WHERE SupplierID = 7
ORDER By UnitPrice

SELECT UnitPrice, SupplierID, StockItemID, StockItemName, ColorId,
	ROW_NUMBER() OVER (ORDER BY UnitPrice) AS Rn,
	RANK() OVER (ORDER BY UnitPrice) AS Rnk,
	DENSE_RANK() OVER (PARTITION BY SupplierId ORDER BY UnitPrice) AS DenseRnk,
	NTILE(4) OVER (PARTITION BY SupplierId ORDER BY UnitPrice) AS GroupNumber
FROM Warehouse.StockItems
WHERE SupplierID in (5, 7)
ORDER By SupplierID, UnitPrice

SELECT SupplierID, ColorId, StockItemID, StockItemName,
	UnitPrice,
	SUM(UnitPrice) OVER() AS Total,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice) AS RunningTotal,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID) AS RunningTotalSort,
	AVG(UnitPrice) OVER() AS Total,
	AVG(UnitPrice) OVER(ORDER BY UnitPrice) AS RunningTotal,
	AVG(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID) AS RunningTotalSort,
	COUNT(UnitPrice) OVER() AS Total,
	COUNT(UnitPrice) OVER(ORDER BY UnitPrice) AS RunningTotal,
	COUNT(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID) AS RunningTotalSort
FROM Warehouse.StockItems
WHERE SupplierID in (5, 7)
ORDER By UnitPrice, StockItemID;

SELECT SupplierID, ColorId, StockItemID, StockItemName,
	UnitPrice,
	SUM(UnitPrice) OVER() AS Total,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice) AS RunningTotal,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID) AS RunningTotalSort,
	SUM(UnitPrice) OVER(Partition BY ColorId ORDER BY UnitPrice) AS RunningTotalByColor,
	--SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID ROWS UNBOUNDED PRECEDING) AS TotalBoundP,
	--SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID ROWS BETWEEN CURRENT row AND UNBOUNDED Following) AS TotalBoundF,
	--SUM(UnitPrice) OVER(ORDER BY UnitPrice DESC, StockItemID DESC) AS TotalBoundF2,
	--SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID ROWS 2 PRECEDING) AS TotalBound2,
	--SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID ROWS BETWEEN 2 PRECEDING AND 3 Following) AS TotalBound4,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice RANGE UNBOUNDED PRECEDING) AS TotalBoundRange,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS TotalBoundRange
FROM Warehouse.StockItems
WHERE SupplierID in (5, 7)
ORDER By UnitPrice, StockItemID;

SELECT UnitPrice, SupplierID, StockItemID, StockItemName, ColorId,
	ROW_NUMBER() OVER (ORDER BY UnitPrice) AS Rn,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ColorId) OVER (PARTITION BY SupplierId) AS PC,
	CUME_DIST() OVER (ORDER BY UnitPrice)
FROM Warehouse.StockItems
WHERE SupplierID in (5, 7)
ORDER By SupplierID, UnitPrice;

SELECT SupplierID, PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY SupplierID) OVER() AS median
FROM Warehouse.StockItems
GROUP BY SupplierID;

SELECT 	
	OrderId, OrderDate, 
	NEXT VALUE FOR Sequences.OrderID OVER(ORDER BY OrderDate, OrderId DESC) AS SeqValue
FROM (select top 10 * 
	FROM Sales.Orders) AS ord;