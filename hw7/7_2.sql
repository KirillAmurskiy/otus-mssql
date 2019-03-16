CREATE TABLE dbo.MyEmployees 
( 
EmployeeID smallint NOT NULL, 
FirstName nvarchar(30) NOT NULL, 
LastName nvarchar(40) NOT NULL, 
Title nvarchar(50) NOT NULL, 
DeptID smallint NOT NULL, 
ManagerID int NULL, 
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
); 

INSERT INTO dbo.MyEmployees VALUES 
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL) 
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1) 
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273) 
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274) 
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274) 
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273) 
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285) 
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273) 
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 

select *
from dbo.MyEmployees;

with DirectReports(ManagerID, EmployeeID, FullName, Indent, Title, EmployeeLevel) as
(
	select ManagerID, EmployeeID, convert(varchar(255), concat(FirstName, ' ', LastName)) as FullName, convert(varchar(255), '') as Indent, Title, 0 as EmployeeLevel
	from dbo.MyEmployees
	where ManagerID is NULL
	union all
	select e.ManagerID, e.EmployeeID, convert(varchar(255), concat('|', d.Indent, FirstName, ' ', LastName)) as FullName, convert(varchar(255), concat('|', d.Indent)) as Indent, e.Title, d.EmployeeLevel + 1
	from dbo.MyEmployees as e
		inner join DirectReports as d
		on e.ManagerID = d.EmployeeID
)
select EmployeeID, FullName, Title, EmployeeLevel
from DirectReports;