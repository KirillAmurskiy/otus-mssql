use WideWorldImporters;

SELECT dateadd(day, -day(i.InvoiceDate)+1, i.InvoiceDate) as InvoiceMonth,
		   substring(c.CustomerName, charindex('(', c.CustomerName) + 1, charindex(')', c.CustomerName) - charindex('(', c.CustomerName) - 1) as CustomerName,
		   i.InvoiceID
	FROM Sales.Customers AS c
	JOIN Sales.Invoices as i ON c.CustomerID = i.CustomerID
	where c.CustomerID >= 2 and c.CustomerID <= 6

select c.CustomerName
from Sales.Customers as c
where CustomerID >= 2 and CustomerID <= 6


SELECT * FROM 
(
	SELECT dateadd(day, -day(i.InvoiceDate)+1, i.InvoiceDate) as InvoiceMonth,
		   substring(c.CustomerName, charindex('(', c.CustomerName) + 1, charindex(')', c.CustomerName) - charindex('(', c.CustomerName) - 1) as CustomerName,
		   i.InvoiceID
	FROM Sales.Customers AS c
	JOIN Sales.Invoices as i ON c.CustomerID = i.CustomerID
	where c.CustomerID >= 2 and c.CustomerID <= 6
) AS s
PIVOT (count(s.InvoiceID)
	FOR CustomerName IN (
		[Sylvanite, MT],
		[Peeples Valley, AZ],
		[Medicine Lodge, KS],
		[Gasport, NY],
		[Jessie, ND])) as PVT
order by InvoiceMonth
