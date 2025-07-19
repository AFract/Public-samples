CREATE PROCEDURE 
SpSEmployeeHistory 
(
@startDate DATETIME, @EndDate DATETIME)
AS
(
SELECT [EmployeeID]
      ,[Name]
      ,[Position]
      ,[Department]
      ,[Address]
      ,[AnnualSalary]
      ,[ValidFrom]
      ,[ValidTo]
  FROM [dbo].[EmployeeHistory]
  WHERE ValidFrom >= @StartDate and ValidTo <= @EndDate
);




