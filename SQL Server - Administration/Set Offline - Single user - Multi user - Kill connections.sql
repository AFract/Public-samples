sp_who 

ALTER DATABASE [targetDb]
SET OFFLINE WITH ROLLBACK IMMEDIATE

go
ALTER DATABASE [targetDb]
SET multi_user WITH ROLLBACK IMMEDIATE
GO

go
ALTER DATABASE [targetDb]
SET single_user WITH ROLLBACK IMMEDIATE
GO

DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
WHERE database_id  = db_id('targetDb') 

EXEC(@kill);
print @kill
