 USE WideWorldImporters

-- ----------------------
-- FOR JSON AUTO
-- ----------------------

-- Исходный запрос
SELECT
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
 FROM
    Sales.Customers AS c
    JOIN Sales.Orders AS o ON o.CustomerID = c.CustomerID
 WHERE
    c.CustomerID IN (1060, 1059, 1061)
 ORDER BY
    c.CustomerID

-- FOR JSON AUTO
SELECT
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
 FROM
    Sales.Customers AS c
    JOIN Sales.Orders AS o ON o.CustomerID = c.CustomerID
 WHERE
    c.CustomerID IN (1060, 1059, 1061)
 ORDER BY
    c.CustomerID
 FOR JSON AUTO

-- FOR JSON AUTO
-- порядок колонок и сортировка
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CustomerName
 FROM
    Sales.Customers AS c
    JOIN Sales.Orders AS o ON o.CustomerID = c.CustomerID
 WHERE
    c.CustomerID IN (1060, 1059, 1061)
 ORDER BY
    o.OrderID
 FOR JSON AUTO


-- FOR JSON AUTO, ROOT
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CustomerName
 FROM
    Sales.Customers AS c
    JOIN Sales.Orders AS o ON o.CustomerID = c.CustomerID
 WHERE
    c.CustomerID IN (1060, 1059, 1061)
 ORDER BY
    o.OrderID
 FOR JSON AUTO, ROOT

-- FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CustomerName
 FROM
    Sales.Customers AS c
    JOIN Sales.Orders AS o ON o.CustomerID = c.CustomerID
 WHERE
    c.CustomerID IN (1060, 1059, 1061)
 ORDER BY
    o.OrderID
 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER

-- Сохранение в переменной
DECLARE @jsonData AS nvarchar(max)
SET @jsonData =
(
	SELECT
		o.OrderID,
		o.OrderDate,
		c.CustomerID,
		c.CustomerName
	 FROM
		Sales.Customers AS c
		JOIN Sales.Orders AS o ON o.CustomerID = c.CustomerID
	 WHERE
		c.CustomerID IN (1060, 1059, 1061)
	 ORDER BY
		o.OrderID
     FOR JSON AUTO --, WITHOUT_ARRAY_WRAPPER
)
SELECT @jsonData
GO

-- Подзапросы с JSON
SELECT
    c.CustomerID,
    c.CustomerName,
	 (
		SELECT SalesOrder.OrderID, SalesOrder.OrderDate, SalesOrder.Comments
		FROM Sales.Orders AS SalesOrder
		WHERE CustomerID = c.CustomerID
		FOR JSON AUTO, ROOT('SalesOrders')
	 )as Orders
 FROM Sales.Customers as c 
 WHERE c.CustomerID IN (1060, 1059, 1061)
 ORDER BY c.CustomerID

-- ----------------------
-- FOR JSON PATH
-- ----------------------

-- FOR JSON PATH
SELECT
    SupplierID AS [Id],
    SupplierName AS [SupplierInfo.Name],
    SupplierCategoryName AS [SupplierInfo.Category],
    PrimaryContact AS [Contact.Primary],
    AlternateContact AS [Contact.Alternate],
    WebsiteURL [WebsiteURL],
    CityName AS [CityName]
 FROM
    Website.Suppliers
 WHERE
    SupplierID < 5
 FOR JSON PATH, ROOT('Suppliers'), INCLUDE_NULL_VALUES



