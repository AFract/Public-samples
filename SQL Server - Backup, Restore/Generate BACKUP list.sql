-- Ce script permet de générer une instruction BACKUP pour chaque base utilisateur du serveur actuellement connecté.
-- Après exécution, il faut déplacer les .bak dans le répertoire du serveur cible où doivent se trouver les backups et exécuter l'équivalent pour faire les Restore obtenu par le script "Generate RESTORE list.sql"

--SELECT name, database_id, create_date  
--FROM sys.databases
--WHERE name not in('master', 'tempdb', 'model', 'msdb')

SET NOCOUNT ON;

SELECT 'USE [master]';

select 'PRINT ''Backuping ' + name + '...''' + CHAR(13) +
'BACKUP DATABASE [' + name + '] TO  DISK = N''F:\WIP\Migration\SQL\SqlBackup_' + name + '_20230704.bak'' ' + CHAR(13) +
'WITH NOFORMAT, NOINIT,  NAME = N''' + name + '-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10;' + CHAR(13) + 
'GO' + CHAR(13)
FROM sys.databases
WHERE name not in('master', 'tempdb', 'model', 'msdb')