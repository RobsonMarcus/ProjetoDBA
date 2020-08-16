SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130);
DECLARE @objectname nvarchar(130);
DECLARE @indexname nvarchar(130);
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000);

-- Coleta as informações de fragmentação e traz também os nomes
SELECT
object_id AS objectid,
index_id AS indexid,
partition_number AS partitionnum,
avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0;

--Armazena em uma tabela temporária
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;
OPEN partitions;
WHILE (1=1)
BEGIN;
FETCH NEXT
FROM partitions
INTO @objectid, @indexid, @partitionnum, @frag;
IF @@FETCH_STATUS < 0 BREAK;
SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
FROM sys.objects AS o
JOIN sys.schemas as s ON s.schema_id = o.schema_id
WHERE o.object_id = @objectid;
SELECT @indexname = QUOTENAME(name)
FROM sys.indexes
WHERE object_id = @objectid AND index_id = @indexid;
SELECT @partitioncount = count (*)
FROM sys.partitions
WHERE object_id = @objectid AND index_id = @indexid;

-- Ajuste aqui o nível de fragmentação para REORGANIZE ou REBUILD
IF @frag < 30
SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
Print 'OK'
IF @frag >= 30
SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
IF @partitioncount > 1
SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
EXEC (@command);
--PRINT N'Executed: ' + @command;
END;
CLOSE partitions;
DEALLOCATE partitions;
select * from #work_to_do

-- Apaga a tabela temporária
DROP TABLE #work_to_do;
GO

select ST.name,index_type_desc,index_id,avg_fragmentation_in_percent,fragment_count,page_count,avg_page_space_used_in_percent,record_count from SYS.DM_DB_INDEX_PHYSICAL_STATS(18, NULL,NULL,NULL,'DETAILED') SD
JOIN sys.tables ST ON SD.object_id = ST.object_id
select ST.name,index_type_desc,index_id,avg_fragmentation_in_percent,fragment_count,page_count,avg_page_space_used_in_percent,record_count from SYS.DM_DB_INDEX_PHYSICAL_STATS(18, NULL,NULL,NULL,'LIMITED') SD
JOIN sys.tables ST ON SD.object_id = ST.object_id
