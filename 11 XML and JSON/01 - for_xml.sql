SELECT CityID,  CityName
FROM Application.Cities

--------------------------
-- FOR XML RAW
--------------------------

-- Простой FOR XML RAW 
SELECT CityID,  CityName
FROM Application.Cities
FOR XML RAW

-- Переименование <row> 
SELECT CityID,  CityName
FROM Application.Cities
FOR XML RAW('City')

-- ROOT
SELECT CityID,  CityName
FROM Application.Cities
FOR XML RAW('City'), ROOT

SELECT CityID,  CityName
FROM Application.Cities
FOR XML RAW('City'), ROOT('Cities')

-- ELEMENTS
SELECT CityID,  CityName
FROM Application.Cities
FOR XML RAW('City'), ROOT('Cities'), ELEMENTS;

-- FOR XML RAW JOIN
SELECT 
	CityID as [ID], 
	c.CityName as [City], 
	s.StateProvinceName as [State]
FROM Application.Cities c
JOIN Application.StateProvinces s 
	ON s.StateProvinceID = c.StateProvinceID
FOR XML RAW('City'), ROOT('Cities')

--------------------------
-- FOR XML AUTO
--------------------------

-- Простой FOR XML AUTO
SELECT CityID,  CityName
FROM Application.Cities
FOR XML AUTO

-- Имена через алиасы
SELECT CityID as id,  CityName as name
FROM Application.Cities as c
FOR XML AUTO

-- ROOT
SELECT CityID as id,  CityName as name
FROM Application.Cities as c
FOR XML AUTO, ROOT('Cities')

-- ELEMENTS
SELECT CityID as id,  CityName as name
FROM Application.Cities as c
FOR XML AUTO, ROOT('Cities'), ELEMENTS

-- FOR XML AUTO JOIN
SELECT 
	State.StateProvinceName as [StateName],
	CityID as [ID], 
	City.CityName as [CityName]
FROM Application.Cities City
JOIN Application.StateProvinces State ON State.StateProvinceID = City.StateProvinceID
ORDER BY State.StateProvinceName
FOR XML AUTO, ROOT('Cities'), ELEMENTS

--  FOR XML AUTO JOIN, сортировка и порядок колонок
SELECT 		
	City.CityName as [CityName],
	CityID as [ID], 
	State.StateProvinceName as [StateName]
FROM Application.Cities City
JOIN Application.StateProvinces State ON State.StateProvinceID = City.StateProvinceID
ORDER BY State.StateProvinceName
FOR XML AUTO, ROOT('Cities'), ELEMENTS

SELECT 
	State.StateProvinceName as [StateName],
	CityID as [ID], 
	City.CityName as [CityName]
FROM Application.Cities City
JOIN Application.StateProvinces State ON State.StateProvinceID = City.StateProvinceID
ORDER BY City.CityID
FOR XML AUTO, ROOT('Cities'), ELEMENTS

--------------------------
-- FOR XML PATH
--------------------------
SELECT 
	CityID as [@ID], 
	'Population: ' + 
		cast(LatestRecordedPopulation as nvarchar(10)) 
		as "comment()", 
	CityName
FROM Application.Cities
FOR XML PATH('City'), ROOT('Cities')

-- string aggregation
-- https://habr.com/ru/post/200120/

SELECT 
	s.StateProvinceName as [StateName],
	
	(select c.CityName +', ' as 'data()'
	from Application.Cities c 
	where s.StateProvinceID = c.StateProvinceID
	for xml path('')) as Cities

FROM Application.StateProvinces s 


