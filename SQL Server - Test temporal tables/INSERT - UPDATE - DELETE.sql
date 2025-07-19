USE [Test]
GO

INSERT INTO [dbo].[Employee]
           ([EmployeeID]
           ,[Name]
           ,[Position]
           ,[Department]
           ,[Address]
           ,[AnnualSalary])
     VALUES
           (1
           ,'Test'
           ,'Position'
           ,'Department'
           ,'Address'
           ,120000)
GO

update dbo.[Employee]
set Name = 'Test-Updated'
where EmployeeID = 1


INSERT INTO [dbo].[Employee]
           ([EmployeeID]
           ,[Name]
           ,[Position]
           ,[Department]
           ,[Address]
           ,[AnnualSalary])
     VALUES
           (2
           ,'Test2'
           ,'Position'
           ,'Department'
           ,'Address'
           ,10)

update dbo.[Employee]
set Name = 'Test2-Updated'
where EmployeeID = 2

-- Delete in temporal table : creates a new History record (therefore data are still available in history) + delete the temporal record.
DELETE FROM [Employee] where EmployeeID = 2;


-- It is also possible to reinsert a record with the same Id even if a matching one was previously deleted
INSERT INTO [dbo].[Employee]
           ([EmployeeID]
           ,[Name]
           ,[Position]
           ,[Department]
           ,[Address]
           ,[AnnualSalary])
     VALUES
           (2
           ,'Test2-New'
           ,'Position'
           ,'Department'
           ,'Address'
           ,10)

GO

-- Delete in history table : not directly possible (prevented by SQL Server), but available by disabling SYSTEM_VERSIONING first
-- NOTE : it is also possible to perform some cleanup for a certain date range (configured in the temporal table with HISTORY_RETENTION_PERIOD) with EXEC sys.sp_cleanup_temporal_history
BEGIN TRANSACTION

-- Disable system versioning
ALTER TABLE [dbo].[Employee] SET (SYSTEM_VERSIONING = OFF)
GO
-- Delete rows from history table
DELETE FROM [dbo].[EmployeeHistory]
where EmployeeID = 1;
GO
-- Re-enable system versioning
ALTER TABLE [dbo].[Employee] 
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[EmployeeHistory]))

COMMIT TRANSACTION

--EXEC sys.sp_cleanup_temporal_history 'dbo', 'Employee'