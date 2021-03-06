/****** Script for SelectTopNRows command from SSMS  ******/
SELECT PurchaseOrderID
      ,DeliveryMethods.DeliveryMethodName
	  ,Suppliers.SupplierName
	  ,People.FullName
	  ,ExpectedDeliveryDate
  
  FROM [Purchasing].[PurchaseOrders]
  INNER JOIN Application.DeliveryMethods
	ON [PurchaseOrders].DeliveryMethodID = DeliveryMethods.DeliveryMethodID
  INNER JOIN Purchasing.Suppliers
	ON PurchaseOrders.SupplierID = Suppliers.SupplierID
  INNER JOIN Application.People
	ON PurchaseOrders.ContactPersonID = People.PersonID
  
  WHERE PurchaseOrders.ExpectedDeliveryDate BETWEEN '2014-01-01' AND '2014-12-31'
		AND PurchaseOrders.IsOrderFinalized = 1
		AND (DeliveryMethods.DeliveryMethodName = 'Road Freight'
			OR DeliveryMethods.DeliveryMethodName = 'Post')