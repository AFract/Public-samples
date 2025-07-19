-- Ce script, exécuté depuis un serveur source, permet de générer la liste des instructions RESTORE à exécuter sur un serveur cible pour remonter une série de bases depuis des backups générés par le script "Generate BACKUP list.sql"
-- Ce script intègre les changements de chemin pour une migration SQL Server 2014 à 2022.
-- Attention, si le nom logique interne de la base diffère du nom physique il faudra corriger le premier paramètre de chaque instruction MOVE.


--SELECT *, name, database_id, create_date  
--FROM sys.databases
--WHERE name not in('master', 'tempdb', 'model', 'msdb')

SET NOCOUNT ON;

SELECT 'USE [master]';

SELECT 'PRINT ''Restoring ' + name + '...''' + CHAR(13) +
'RESTORE DATABASE [' + name + '] FROM  DISK = N''D:\BDD\MSSQL16.SQLEXPRESS\MSSQL\Backup\SqlBackup_' + name + '_20230704.bak'' ' + CHAR(13) +
'WITH  FILE = 1,  ' + CHAR(13) +
' MOVE N''' + name + ''' TO N''D:\BDD\MSSQL16.SQLEXPRESS\MSSQL\DATA\' + name + '.mdf'', ' + CHAR(13) +
' MOVE N''' + name + '_log'' TO N''D:\BDD\MSSQL16.SQLEXPRESS\MSSQL\DATA\' + name + '_log.ldf'',  NOUNLOAD,  STATS = 5' + CHAR(13)
FROM sys.databases
WHERE name not in('master', 'tempdb', 'model', 'msdb')