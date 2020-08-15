EXEC sp_configure 'xp_cmdshell',1
reconfigure with override

-- BCP:
-- -c = tipo de informação texto | -t = termino de campo "," | -T = Trusted connection | -S = Servidor | -C ACP = Windows 1252 charset
EXEC master.dbo.xp_cmdshell 'del E:\Bancos\DB_CNES_tabelas2.csv'
EXEC master.dbo.xp_cmdshell 'bcp "select * from DB_CNES.sys.tables" queryout E:\Bancos\DB_CNES_dados.csv -c -t";"  -T -SROBSON-DELL -C1252'
EXEC master.dbo.xp_cmdshell 'copy E:\Bancos\*.csv E:\Bancos\DB_CNES_tabelas.csv'

----

--use DB_CNES

--EXEC sp_configure 'xp_cmdshell',1
--reconfigure with override

DECLARE @competencia varchar(10), @arquivo varchar(50);
DECLARE @sql varchar (max);

set @competencia = CONVERT(varchar(10),GETDATE(),112);
set @arquivo = 'DB_CNES_dados.csv'

--select TOP 0* into #cabeca from DB_CNES.sys.tables

--select @arquivo

-- BCP:
-- -c = tipo de informação texto | -t = termino de campo "," | -T = Trusted connection | -S = Servidor | -C ACP = Windows 1252 charset
--EXEC master.dbo.xp_cmdshell 'del E:\Bancos\DB_CNES_tabelas.csv'

--set @sql = ' master.dbo.xp_cmdshell ''bcp "select * from #cabeca" queryout E:\Bancos\cabecalho.csv -c -t";"  -T -SROBSON-DELL -C1252'''
--EXEC (@sql)
set @sql = ' master.dbo.xp_cmdshell ''bcp "select * from DB_CNES.sys.tables" queryout E:\Bancos\'+ @arquivo + ' -c -t";"  -T -SROBSON-DELL -C1252'''
EXEC (@sql)
set @arquivo = 'DB_CNES_dados_' + @competencia + '.csv'
set @sql = ' master.dbo.xp_cmdshell ''copy E:\Bancos\*.csv E:\Bancos\' + @arquivo + ''''
EXEC (@sql)
set @sql = ' master.dbo.xp_cmdshell ''del E:\Bancos\DB_CNES_dados.csv'''
EXEC (@sql)
--EXEC master.dbo.xp_cmdshell '
--DROP TABLE #cabeca

 