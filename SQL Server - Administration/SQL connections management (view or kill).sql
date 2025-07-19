-- View all opened connections
SELECT 
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame
    



-- Kill all opened connections

ALTER DATABASE [ECOM_MONITORING] SET SINGLE_USER WITH ROLLBACK IMMEDIATE 
--do you stuff here 
ALTER DATABASE [ECOM_MONITORING] SET MULTI_USER    