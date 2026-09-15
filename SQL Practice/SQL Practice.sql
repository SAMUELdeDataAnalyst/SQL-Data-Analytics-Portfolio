 Select JobTitle, Avg(Salary) from EmployeeDemographics
 join EmployeeSalary on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID	
 Where JobTitle = 'Salesman'
 Group by JobTitle  

  Select * from EmployeeDemographics
 full outer join WarehouseEmployeeDemographics 
 on EmployeeDemographics.EmployeeID = 
 WarehouseEmployeeDemographics.EmployeeID

 Select FirstName, LastName, Age, 
 case
 When Age = 38 then 'Stanley'
 When Age > 30 then 'Old'
 When Age between 27 and 30 then 'Young'
 else 'Baby' 
 end
 from EmployeeDemographics
 where Age is not null
 Order by Age 

 Select FirstName, LastName, JobTitle, Age,
 Case
 When JobTitle='Salesman'then Salary+(Salary*.10)
 When JobTitle= 'HR' then Salary+(Salary*0.0001)
 When JobTitle='Accountant' then Salary+(Salary*.05) 
 else Salary+(Salary *.03) 
 End as 'Salary After Raise'
 from EmployeeDemographics 
 join EmployeeSalary 
 on EmployeeDemographics.EmployeeID =
 EmployeeSalary.EmployeeID

 Select JobTitle, Count(JobTitle) from EmployeeSalary
 Join EmployeeDemographics
 on EmployeeSalary.EmployeeID= EmployeeDemographics.EmployeeID
 Group by JobTitle
 Having Count(JobTitle) > 1

 Select * from EmployeeDemographics
 
 Update EmployeeDemographics
 Set Age = 31 , Gender= 'Female'
 Where EmployeeID = 1012


 Delete from EmployeeDemographics
 Where EmployeeID = 1005--

 Select Demo.FirstName, Demo.LastName, 
 Sal.JobTitle, Sal.Salary, Ware.Age
 from EmployeeDemographics Demo
  left Join EmployeeSalary Sal 
 on Demo.EmployeeID = Sal.EmployeeID
  Left join WarehouseEmployeeDemographics ware 
 on Sal.EmployeeID =ware.EmployeeID

 

 With CTE_Employee as
 (Select FirstName,LastName,Gender, Salary,
 count(Gender) over ( Partition by Gender) as TOTALSALARY,
 AVG(Salary) over (Partition by Gender) as AVGSALARY
 from [SQL Tutorial ]..EmployeeDemographics dem
  join [SQL Tutorial ]..EmployeeSalary sal
 on dem.EmployeeID = sal.EmployeeID
 Where Salary > 45000
  )

 Select *from
 CTE_Employee
 Drop Table if exists #Temp_Employee2
 
 select * from #Temp_Employee2
 Create Table #Temp_Employee1
 (EmployeeID int,
 JobTitle varchar(50),
 Salary int
 )
 Select * from #Temp_Employee1
 Insert into #Temp_Employee1
 Select * from [SQL Tutorial ]..EmployeeSalary
 
 CREATE TABLE EmployeeErrors (
EmployeeID varchar(50),
FirstName varchar(50),
LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

--Using Trims in SQL--

Select EmployeeID, Trim(EmployeeID) as IDTRIM
from EmployeeErrors

Select EmployeeID, Ltrim(EmployeeID) as IDLTRIM
from EmployeeErrors

Select EmployeeID, Rtrim(EmployeeID) as IDRTRIM
from EmployeeErrors

Select *
from EmployeeErrors

--Using Replace--
Select LastName, Replace( LastName, '- Fired', '') as LastNameFixed
from EmployeeErrors

--Using Substrings--
Select err.FirstName,  Substring (err.FirstName,1,3),
 dem.FirstName, SubString(dem.FirstName,1,3)
from EmployeeErrors err
join [SQL Tutorial ]..EmployeeDemographics dem 
on Substring (err.FirstName,1,3) = 
SubString(dem.FirstName,1,3)

--Using UPPER and LOWER
Select FirstName, UPPER(FirstName)
from EmployeeErrors
Select FirstName, LOwer(FirstName)
from EmployeeErrors

Stored Procedures

Create Procedure TEST
as
Select * from EmployeeDemographics

Exec test


CREATE PROCEDURE Temp_Employee
AS

Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
From EmployeeDemographics emp join EmployeeSalary sal
on emp.EmployeeID=sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;

 Exec Temp_Employee @JobTitle='Salesman'


Subqueries

Select * from EmployeeSalary

--Subquery in Select 
Select EmployeeID, Salary, (Select AVG(Salary) from EmployeeSalary) as 'Salary Averages'
from EmployeeSalary

--How to do it with a partition by 
Select EmployeeID, Salary, AVG(Salary) over () as 'Salary Averages'
from EmployeeSalary

--- Why it doesn't work for a group
Select EmployeeID, Salary, Avg(Salary) as Allage
from EmployeeSalary
Group by EmployeeID, Salary
Order by 1,2

-- SUbquery in from
Select a.EmployeeID, [Salary Averages]
from (Select EmployeeID, Salary, AVG(Salary) 
over () as 'Salary Averages' from EmployeeSalary) a


--SUbquery in WHere
Select EmployeeID, JobTitle, Salary
from EmployeeSalary
where EmployeeID in
(
Select EmployeeID
from EmployeeDemographics
where Age>30)
