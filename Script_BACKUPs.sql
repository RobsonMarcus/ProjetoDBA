USE master;
GO

--select * from sys.database_files
ALTER DATABASE BASE_DE_DADOS_CNES_202005
    SET RECOVERY FULL;
GO
-- Create AdvWorksData and AdvWorksLog logical backup devices.
USE master
GO
EXEC sp_addumpdevice 'disk', 'BASE_DE_DADOS_CNES_202005',
'E:\Bancos\Backups\FULL\BASE_DE_DADOS_CNES_202005.bak';
GO
EXEC sp_addumpdevice 'disk', 'BASE_DE_DADOS_CNES_202005_log',
'E:\Bancos\Backups\LOG\BASE_DE_DADOS_CNES_202005_log.bak';
GO

-- Back up the full AdventureWorks2012 database.
BACKUP DATABASE AdventureWorks2012 TO AdvWorksData;
GO
-- Back up the AdventureWorks2012 log.
BACKUP LOG BASE_DE_DADOS_CNES_202005
    TO BASE_DE_DADOS_CNES_202005_log;
GO