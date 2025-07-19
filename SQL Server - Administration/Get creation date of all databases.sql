USE master
SELECT
    sys.databases.name,
    create_date,
    sys.syslogins.name
FROM sys.databases
INNER JOIN sys.syslogins ON sys.databases.owner_sid = sys.syslogins.sid
ORDER BY sys.databases.create_date desc