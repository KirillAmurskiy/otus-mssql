SELECT [Suppliers].[SupplierID]
      ,[SupplierName]
  FROM [WideWorldImporters].[Purchasing].[Suppliers]
  LEFT JOIN Purchasing.PurchaseOrders
	ON Suppliers.SupplierID = PurchaseOrders.SupplierID
WHERE PurchaseOrders.PurchaseOrderID is NULL
GROUP BY Suppliers.SupplierID, Suppliers.SupplierName