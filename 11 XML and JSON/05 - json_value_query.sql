CREATE DATABASE json_test
GO

USE json_test
GO

-- ISJSON

DECLARE @jsonData AS nvarchar(max) = N'
[
    {
   	 "OrderId": 5,
   	 "CustomerId: 6,
   	 "OrderDate": "2015-10-10T14:22:27.25-05:00",
   	 "OrderAmount": 25.9
    },
    {
   	 "OrderId": 29,
   	 "CustomerId": 76,
   	 "OrderDate": "2015-12-10T11:02:36.12-08:00",
   	 "OrderAmount": 350.25
    }
]'

SELECT ISJSON(@jsonData)    -- Будет 0, тк в "CustomerId нет кавычки

CREATE TABLE OrdersJson(
	OrdersId int PRIMARY KEY,
    OrdersDoc nvarchar(max) NOT NULL DEFAULT '[]',
	CONSTRAINT [CK_OrdersJson_OrdersDoc] 
	CHECK (ISJSON(OrdersDoc) = 1)
)

DECLARE @jsonData AS nvarchar(max) = N'
[
    {
   	 "OrderId": 5,
   	 "CustomerId": 6,
   	 "OrderDate": "2015-10-10T14:22:27.25-05:00",
   	 "OrderAmount": 25.9
    },
    {
   	 "OrderId": 29,
   	 "CustomerId": 76,
   	 "OrderDate": "2015-12-10T11:02:36.12-08:00",
   	 "OrderAmount": 350.25
    }
]'

INSERT INTO OrdersJson(OrdersId, OrdersDoc) VALUES (1, @jsonData)

INSERT INTO OrdersJson(OrdersId) VALUES (2)    -- По умолчанию будет пустой json-массив 

SELECT * FROM OrdersJson

DROP TABLE OrdersJson

-- ---------------------------------

CREATE TABLE BooksJson(
	 BookId int PRIMARY KEY,
    BookDoc nvarchar(max) NOT NULL,
	CONSTRAINT [CK_BooksJson_BookDoc] CHECK (ISJSON(BookDoc) = 1)
)

INSERT INTO BooksJson VALUES (1, '
    {
   	 "category": "ITPro",
   	 "title": "Programming SQL Server",
   	 "author": "Lenni Lobel",
   	 "price": {
   		 "amount": 49.99,
   		 "currency": "USD"
   	 },
   	 "purchaseSites": [
   		 "amazon.com",
   		 "booksonline.com"
   	 ]
    }
')

INSERT INTO BooksJson VALUES (2, '
    {
   	 "category": "Developer",
   	 "title": "Developing ADO .NET",
   	 "author": "Andrew Brust",
   	 "price": {
   		 "amount": 39.93,
   		 "currency": "USD"
   	 },
   	 "purchaseSites": [
   		 "booksonline.com"
   	 ]
    }
')

INSERT INTO BooksJson VALUES (3, '
    {
   	 "category": "ITPro",
   	 "title": "Windows Cluster Server",
   	 "author": "Stephen Forte",
   	 "price": {
   		 "amount": 59.99,
   		 "currency": "CAD"
   	 },
   	 "purchaseSites": [
   		 "amazon.com"
   	 ]
    }
')

SELECT * FROM BooksJson

-- простой JSON_VALUE
SELECT 
	BookId, 
	JSON_VALUE(BookDoc, '$.category') as BookCategory,
	BookDoc
FROM BooksJson

-- не существующий путь
SELECT 
	BookId, 
	JSON_VALUE(BookDoc, '$.not_exist_property') as BookCategory,
	BookDoc
FROM BooksJson

-- не существующий путь, strict
SELECT 
	BookId, 
	JSON_VALUE(BookDoc, 'strict$.not_exist_property') as BookCategory,
	BookDoc
FROM BooksJson

-- Все книги ITPro
SELECT *
 FROM BooksJson
 WHERE JSON_VALUE(BookDoc, '$.category') = 'ITPro'

-- Индекс на Category
ALTER TABLE BooksJson
 ADD BookCategory AS JSON_VALUE(BookDoc, '$.category')

CREATE INDEX IX_BooksJson_BookCategory
 ON BooksJson(BookCategory)

-- по идее должен использоваться индекс, если таблица большая
SELECT *
FROM BooksJson
WHERE JSON_VALUE(BookDoc, '$.category') = 'ITPro'

-- Другие свойства
SELECT
    BookId,
    JSON_VALUE(BookDoc, '$.category') AS Category,
    JSON_VALUE(BookDoc, '$.title') AS Title,
    JSON_VALUE(BookDoc, '$.price.amount') AS PriceAmount,
    JSON_VALUE(BookDoc, '$.price.currency') AS PriceCurrency
 FROM
    BooksJson

-- JSON_QUERY 
SELECT
    BookId,
    JSON_VALUE(BookDoc, '$.category') AS Category,
    JSON_VALUE(BookDoc, '$.title') AS Title,
    JSON_VALUE(BookDoc, '$.price.amount') AS PriceAmount,
    JSON_VALUE(BookDoc, '$.price.currency') AS PriceCurrency,
    JSON_QUERY(BookDoc, '$.purchaseSites') AS PurchaseSites
 FROM
    BooksJson

DROP TABLE BooksJson


