DECLARE @BooksJson nvarchar(max) = N'
[
  {
	"category": "ITPro",
	"title": "Programming SQL Server",
	"author": "Lenni Lobel",
	"price": 49.99
  },
  {
	"category": "Developer",
	"title": "Developing ADO .NET",
	"author": "Andrew Brust",
	"price": 39.93
  },
  {
	"category": "ITPro",
	"title": "Windows Cluster Server",
	"author": "Stephen Forte",
	"price": 59.99
  }
]
'

-- OPEN JSON
SELECT * FROM OPENJSON(@BooksJson)

-- Можно сразу отфильтровать
SELECT *
 FROM   	 OPENJSON(@BooksJson, '$') AS b
 WHERE   	 JSON_VALUE(b.value, '$.category') = 'ITPro'
 ORDER BY    JSON_VALUE(b.value, '$.author') DESC
    
-- Свойства первого объекта в строки
SELECT *
FROM OPENJSON(@BooksJson, '$[0]')

--    0 = null
--    1 = string
--    2 = int
--    3 = bool
--    4 = array
--    5 = object

-- Преобразование json в таблицу (one-to-many)

DECLARE @PersonJson nvarchar(max) = N'
    {
   	 "Id": 236,
   	 "Name": {
   		 "FirstName": "John",
   		 "LastName": "Doe"
   	 },
   	 "Address": {
   		 "AddressLine": "137 Madison Ave",
   		 "City": "New York",
   		 "Province": "NY",
   		 "PostalCode": "10018"
   	 },
   	 "Contacts": [
   		 {
   			 "Type": "mobile",
   			 "Number": "917-777-1234"
   		 },
   		 {
   			 "Type": "home",
   			 "Number": "212-631-1234"
   		 },
   		 {
   			 "Type": "work",
   			 "Number": "212-635-2234"
   		 },
   		 {
   			 "Type": "fax",
   			 "Number": "212-635-2238"
   		 }
   	 ]
    }
'

-- Отдельные значения
SELECT
    PersonId   	 = JSON_VALUE(@PersonJson, '$.Id'),
    FirstName  	 = JSON_VALUE(@PersonJson, '$.Name.FirstName'),
    LastName   	 = JSON_VALUE(@PersonJson, '$.Name.LastName'),
    AddressLine	 = JSON_VALUE(@PersonJson, '$.Address.AddressLine'),
    City   		 = JSON_VALUE(@PersonJson, '$.Address.City'),
    Province   	 = JSON_VALUE(@PersonJson, '$.Address.Province'),
    PostalCode 	 = JSON_VALUE(@PersonJson, '$.Address.PostalCode')

-- "many"
SELECT
    PersonId   		= JSON_VALUE(@PersonJson, '$.Id'),    -- FK
    ContactType		= JSON_VALUE(c.value, '$.Type'),
    ContactNumber   = JSON_VALUE(c.value, '$.Number')
 FROM
    OPENJSON(@PersonJson, '$.Contacts') AS c

-- OPENJSON (с описанием схемы) 
DECLARE @json nvarchar(max) = N'
{
  "BatchId": 442,
  "Orders": [
	{
  	"OrderNumber": "SO43659",
  	"OrderDate": "2011-05-31T00:00:00",
  	"AccountNumber": "AW29825",
  	"Item": {
    	"Quantity": 1,
    	"Price": 2024.9940
  	}
	},
	{
  	"OrderNumber": "SO43661",
  	"OrderDate": "2011-06-01T00:00:00",
  	"AccountNumber": "AW73565",
  	"Item": {
    	"Quantity": 3,
    	"Price": 2024.9940
  	}
	}
  ]
}
'

-- Без схемы
SELECT *
 FROM OPENJSON (@json, '$.Orders')

-- Явное описание схемы
SELECT *
 FROM OPENJSON (@json, '$.Orders')
 WITH (
    OrderNumber    varchar(200),
    OrderDate    datetime,
    Customer    varchar(200)	'$.AccountNumber',
    Item   	 nvarchar(max)		'$.Item' AS JSON,
    Quantity   int   			'$.Item.Quantity',
    Price    money   			'$.Item.Price'
)
