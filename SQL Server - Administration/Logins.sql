
use master
SELECT A.name as userName, B.name as login, B.Type_desc, default_database_name, B.* 
FROM sys.sysusers A 
    FULL OUTER JOIN sys.sql_logins B 
       ON A.sid = B.sid 
WHERE islogin = 1 and A.sid is not null

use [targetDb]
SELECT DB_NAME(DB_ID()) as DatabaseName, * FROM sys.sysusers

-- Repair orphaned logins
-- https://www.sqlshack.com/how-to-discover-and-handle-orphaned-database-users-in-sql-server/
EXEC dbo.sp_change_users_login 
                            @Action          = 'update_one', 
                            @UserNamePattern = 'testlogin', 
                            @LoginName       = 'testlogin' 
;

EXEC dbo.sp_change_users_login 'auto_fix', 'testlogin';
