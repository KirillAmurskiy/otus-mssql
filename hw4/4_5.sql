/*
1. Этап

1.1. Вытащил InvoicesWithTotalSumMore27 в CTE
1.2. Получил SalesPersonName через join
1.3. Получил TotalSummForPickedItems через join, сначала по Order потом по OrderLines,
так читабельнее (в оригинале было наоборот). Читабельнее сначала использовать родительскую сущность.
1.4. Добавил нехватающие отступы

К данному этапу резко увеличил читабельность,
т.о. уже понятно, что делает запрос:
Выбирает все счета общей суммой более 27 тысяч, которые уже были собраны(?),
ну и добавляет к итоговым данным имя продажника.

Сравнение плана запросов дало понять, что переделанный вариант работает чуть дольше даже, чем
изначальный (51% против 49%). С планами запросов я еще не разбирался (и мы не проходили их),
т.о. это все что я смог понять из сравнения.


Этап 2

Внимательно посмотрел на результаты, обнаружил, что TotalSummByInvoice и 
TotalSummForPickedItems одинаковые. Ну так в общем-то и должно быть в нашем
случае (или я не прав?). В общем, решил не считать дополнительно SUM на
OrderLines. Т.о. удалось избавиться от join на OrderLines и части group by. Плюс перенес условие
из where PickingCompletedWhen is not null прямо в join на Orders. Запрос стал
совсем уж простой и очевидный.

Вопреки моим ожидания производительность практически не изменилась(
На данный момент ниже представлено 3 запроса, можно выполнить их одновременно и посмотреть.
*/

/*1. Переделанный вариант*/

with InvoicesWithTotalSumMore27 (InvoiceId, TotalSumm)
as
(
	SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000
)

SELECT 
i.InvoiceID, 
i.InvoiceDate,
p.FullName AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice, 
SUM(ol.PickedQuantity * ol.UnitPrice) AS TotalSummForPickedItems

FROM Sales.Invoices as i

join Sales.Orders as o
	on o.OrderID = i.OrderID
join Sales.OrderLines as ol
	on o.OrderID = ol.OrderID

join Application.People as p
	on p.PersonID = i.SalespersonPersonID 

JOIN InvoicesWithTotalSumMore27 AS SalesTotals
	ON i.InvoiceID = SalesTotals.InvoiceID

where o.PickingCompletedWhen is not null

group by 
i.InvoiceID, 
i.InvoiceDate,
p.FullName,
SalesTotals.TotalSumm

ORDER BY TotalSumm DESC;

/*2. Переделанный вариант, без суммирования PickedItems*/

with InvoicesWithTotalSumMore27 (InvoiceId, TotalSumm)
as
(
	SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000
)

SELECT 
i.InvoiceID, 
i.InvoiceDate,
p.FullName AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice, 
SalesTotals.TotalSumm AS TotalSummForPickedItems

FROM Sales.Invoices as i

join Sales.Orders as o
	on o.OrderID = i.OrderID
	   and o.PickingCompletedWhen is not null

join Application.People as p
	on p.PersonID = i.SalespersonPersonID 

JOIN InvoicesWithTotalSumMore27 AS SalesTotals
	ON i.InvoiceID = SalesTotals.InvoiceID

ORDER BY TotalSumm DESC;

/*3. Оригинальный вариант*/

SELECT 
Invoices.InvoiceID, 
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice, 
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL	
AND Orders.OrderId = Invoices.OrderId)	
) AS TotalSummForPickedItems
FROM Sales.Invoices 
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC;