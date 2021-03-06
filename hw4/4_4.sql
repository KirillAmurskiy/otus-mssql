with Top3ExpensiveStockItems (StockItemID)
as
(
	select TOP(3)
		si.StockItemID
	from Warehouse.StockItems as si
	order by si.UnitPrice desc
)

SELECT city.CityID
      ,city.CityName
	  ,p.FullName
FROM [WideWorldImporters].[Application].[Cities] as city
join Sales.Customers as customer
	on city.CityID = customer.DeliveryCityID
join Sales.Orders as o
	on o.CustomerID = customer.CustomerID
join Sales.OrderLines as ol
	on ol.OrderID = o.OrderID
join Application.People as p
	on p.PersonID = o.PickedByPersonID
where exists(
	select si.StockItemID
	from Top3ExpensiveStockItems as si
	where si.StockItemID = ol.StockItemID);