USE Test
GO


-- Enable change tracking at database level
ALTER DATABASE [Test] SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 30 DAYS)
GO

-- NOTE : enable change tracking let users know if a record was modified, but NOT the changes done on the columns themselves
-- to track changes of data themselves we need Change Data Capture feature but it's not supported on Express edition
-- EXEC sys.sp_cdc_enable_db

-- drop & create tables
drop table if exists dbo.Test_1;

GO

CREATE TABLE dbo.Test_1
	(
	Id int NOT NULL,
	value varchar(50) NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.Test_1 ADD CONSTRAINT
	PK_Table_1 PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Test_1 SET (LOCK_ESCALATION = TABLE)
GO

-- Add CHANGE_TRACKING at table level
ALTER TABLE dbo.[test_1]
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = ON)

GO

-- Insert then update data
INSERT INTO [dbo].[Test_1]           (Id, [value])     VALUES           (1, 'Valeur initiale (1)')

UPDATE [dbo].[Test_1]           
set [value]     = 'Valeur mise à jour ' + CONVERT(varchar(50), GETDATE(), 103)
where Id = 1

UPDATE [dbo].[Test_1]           
set [value]     = 'Valeur mise à jour (encore) ' + CONVERT(varchar(50), GETDATE(), 103)
where Id = 1

INSERT INTO [dbo].[Test_1]           (Id, [value])     VALUES           (2, 'Valeur initiale (2)')
INSERT INTO [dbo].[Test_1]           (Id, [value])     VALUES           (3, 'Valeur initiale (3)')
delete [dbo].[Test_1]           where Id = 2

GO

-- Get current synchronization version
DECLARE @last_synchronization_version bigint;
SET @last_synchronization_version = CHANGE_TRACKING_CURRENT_VERSION();

select @last_synchronization_version;

declare @synchronization_version bigint 
set @synchronization_version = 1; --@last_synchronization_version - 1;

-- Retrieve changes
SELECT 
    CT.Id,--, Ct.[Value], 
	P.value as [value in source table],
    CT.SYS_CHANGE_OPERATION,
	CT.SYS_CHANGE_VERSION, 
    CT.SYS_CHANGE_COLUMNS, 
    CT.SYS_CHANGE_CONTEXT	
FROM
    dbo.Test_1 AS P
RIGHT OUTER JOIN
    CHANGETABLE(CHANGES dbo.Test_1, @synchronization_version) AS CT ON P.Id = CT.Id
