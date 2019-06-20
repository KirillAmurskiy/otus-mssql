USE tempdb
GO

-- ---------------------
/*

CREATE TABLE table1 (
id INTEGER, 
xml_col XML)


CREATE PROCEDURE proc1 (
@xform XML,
@indoc XML,
@outdoc XML OUTPUT)
AS
... 


CREATE FUNCTION func1 (
@x NVARCHAR(max))
RETURNS XML
AS
DECLARE @a XML
SET @a = @x
...
RETURN @a 

*/


-- --------------------

DECLARE @xmlvar XML
SELECT @xmlvar


CREATE TABLE table1 (xmlcol XML)
GO

INSERT table1 VALUES('<person/>')
INSERT table1 VALUES('<person></person>')

-- представление будет одинаковое
SELECT * FROM table1 
GO

INSERT table1 VALUES('<person name="bob" />')
INSERT table1 VALUES('<person name=''mary'' />')
GO

SELECT * FROM table1
GO

-- CDATA
INSERT table1 VALUES('<person><![CDATA[ Three <asd> <asdasd> is > two ]]></person>')
GO 
SELECT * FROM table1
GO

-- Конвертирование varchar в xml
-- Кодировки должны совпадать, если они указаны
INSERT table1 VALUES('<?xml version="1.0" encoding="UTF-16" ?><person/>')
INSERT table1 VALUES(N'<?xml version="1.0" encoding="UTF-8" ?><person/>')
INSERT table1 VALUES('<?xml version="1.0" encoding="UTF-8" ?><person/>')
INSERT table1 VALUES(N'<?xml version="1.0" encoding="UTF-16" ?><person/>')

-- документ
INSERT table1 VALUES('<doc/>')
-- фрагмент
INSERT table1 VALUES('<doc/><doc/>')
-- Только текст 
INSERT table1 VALUES('Text only')
-- Пустая строка
INSERT table1 VALUES('') 
-- NULL
INSERT table1 VALUES(NULL) 

-- Пространства имен (namespaces)
-- no namespace
INSERT table1 VALUES('<doc/>') 
-- namespace for doctors
INSERT table1 VALUES('<doc xmlns="http://www.abc.com" />')
-- namespace for documents
INSERT table1 VALUES('<doc xmlns="http://www.def.com" />')
-- namespace prefix
INSERT table1 VALUES('<dd:doc xmlns:dd="http://www.abc.com" />')
-- namespace prefix
INSERT table1 VALUES('<rr:doc xmlns:rr="http://www.def.com" />')

-- какой namespace?
INSERT table1 VALUES('
 <yy:doc xmlns:rr="http://www.abc.com" 
         xmlns:yy="http://www.def.com" />')

SELECT * FROM table1

-- XML SCHEMA
SELECT CityID,  CityName
FROM Application.Cities
FOR XML RAW('City'), ROOT('Cities'), XMLSCHEMA  

-- создать схему
CREATE XML SCHEMA COLLECTION TestXmlSchema AS   
N'
 <xsd:schema targetNamespace="urn:schemas-microsoft-com:sql:SqlRowSet1" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sqltypes="http://schemas.microsoft.com/sqlserver/2004/sqltypes" elementFormDefault="qualified">
    <xsd:import namespace="http://schemas.microsoft.com/sqlserver/2004/sqltypes" schemaLocation="http://schemas.microsoft.com/sqlserver/2004/sqltypes/sqltypes.xsd" />
    <xsd:element name="City">
      <xsd:complexType>
        <xsd:attribute name="CityID" type="sqltypes:int" use="required" />
        <xsd:attribute name="CityName" use="required">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1033" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth" sqltypes:sqlCollationVersion="2">
              <xsd:maxLength value="50" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:attribute>
      </xsd:complexType>
    </xsd:element>
  </xsd:schema>'

-- использование схемы
DECLARE @xmlvar XML(TestXmlSchema)

-- query
use WideWorldImporters

declare @x xml
select @x = (select c.CustomerId, c.CustomerName from Sales.Customers c for xml auto, elements)
select @x.query('count(//CustomerId)')

SELECT 
(select c.CustomerId, c.CustomerName from Sales.Customers c for xml auto, elements, type)
.query('count(//CustomerId)')

SELECT 
(select c.CustomerId, c.CustomerName from Sales.Customers c for xml auto, elements, type, root('Customers'))
.query('/Customers/c[10]')

SELECT 
(select c.CustomerId, c.CustomerName from Sales.Customers c for xml auto, elements, type, root('Customers'))
.exist('//CustomerId = 10')

-- -------------------------
-- Чтение XML из файла
-- -------------------------

-- xquery
/*
for $p in doc("people.xml")/people/person
where $p/age > 30
return $p/name/givenName/text()
*/

-- doc не поддерживается, использовать query()
-- !! изменить путь к файлу people.xml
DECLARE @x XML
SET @x = ( 
 SELECT * FROM OPENROWSET
  (BULK 'D:\otus\mssql\14 - XML, JSON\people.xml',
   SINGLE_BLOB)
   as d)

SELECT @x.query('
for $p in /people/person
where $p/age > 30
return $p/name/givenName/text()
')
GO 

-- Добавляем прострнство имен
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/xml/add-namespaces-to-queries-with-with-xmlnamespaces

SELECT 'en'    as "English/@xml:lang",  
       'food'  as "English",  
       'ger'   as "German/@xml:lang",  
       'Essen' as "German"  
FOR XML PATH ('Example')  
GO  


-- Индексы
CREATE TABLE test_index
(
	ID INT PRIMARY KEY,
	xml_data XML
)
GO

INSERT INTO test_index VALUES
(1, '<Orders ID="1"><OrderNumber>1</OrderNumber><CustomerNumber>2</CustomerNumber><OrderDate>6/26/2008</OrderDate></Orders>'),
(2, '<Orders ID="2"><OrderNumber>2</OrderNumber><CustomerNumber>4</CustomerNumber><OrderDate>6/27/2008</OrderDate></Orders>'),
(3, '<Orders ID="3"><OrderNumber>1054</OrderNumber><CustomerNumber>9445</CustomerNumber><OrderDate>6/29/2008</OrderDate></Orders>')

SELECT * FROM test_index

CREATE PRIMARY XML INDEX idx_xmldata on test_index(xml_data)

CREATE XML INDEX idx_xmldata_PROPERTY on test_index(xml_data)
USING XML INDEX idx_xmldata FOR PROPERTY

SELECT xml_data.value('(/Orders/OrderNumber)[1]', 'int') 
FROM test_index t


DROP TABLE test_index

