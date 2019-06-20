-- ------------
-- OPEN XML
---------------
drop table #Orders

CREATE TABLE #Orders(
	[ID] int,
	[OrderNumber] int,
	[CustomerNumber] int,
	[OrderDate] nvarchar(20)
)
GO

DECLARE @docHandle int

DECLARE @xmlDocument  xml
SET @xmlDocument = N'
<ROOT>
<Orders ID="1">
  <OrderNumber>1</OrderNumber>
  <CustomerNumber>2</CustomerNumber>
  <OrderDate>6/26/2008</OrderDate>
</Orders>
<Orders ID="2">
  <OrderNumber>2</OrderNumber>
  <CustomerNumber>4</CustomerNumber>
  <OrderDate>6/27/2008</OrderDate>
</Orders>
<Orders ID="3">
  <OrderNumber>1054</OrderNumber>
  <CustomerNumber>9445</CustomerNumber>
  <OrderDate>6/29/2008</OrderDate>
</Orders>
</ROOT>'

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument

-- insert into #Orders
SELECT *
FROM OPENXML(@docHandle, N'/ROOT/Orders', 3)
WITH ( 
	[ID] int,
	[OrderNumber] int ,
	[CustomerNumber] int,
	[OrderDate] varchar(15) )

EXEC sp_xml_removedocument @docHandle

/*
1 - attributes
2 - elements
3 - both
*/


-- select * from #Orders