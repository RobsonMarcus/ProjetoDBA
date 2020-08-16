DECLARE @db_id int = 18;
DECLARE db_cursor CURSOR FOR
SELECT dbid
FROM MASTER.dbo.sysdatabases
WHERE name NOT IN ('master','model','msdb','tempdb')

OPEN db_cursor

FETCH NEXT FROM db_cursor INTO @db_id

WHILE @@FETCH_STATUS = 0
BEGIN
select DB_NAME(@db_id) as [Database]
,object_name(IPS.[object_id]) as [TableName]
,SI.index_id as [SI.index_id]
,SI.name AS [IndexName]
,IPS.index_type_desc
,IPS.index_id
,ROUND(IPS.avg_fragmentation_in_percent,2) AS avg_fragmentation_in_percent
,ROUND(IPS.avg_fragmentation_in_percent,2) AS avg_fragmentation_in_percent
,IPS.record_count
,IPS.fragment_count
from sys.dm_db_index_physical_stats(@db_id, null, null, null, 'detailed') as IPS
inner join sys.indexes as SI with (nolock) on IPS.[object_id] = SI.[object_id] and IPS.index_id = SI.index_id
inner join sys.tables as ST with (nolock) on IPS.[object_id] = ST.[object_id]
where ST.is_ms_shipped = 0
and IPS.avg_fragmentation_in_percent>=10 
and IPS.page_count>25 
and IPS.index_type_desc<>'heap' 
and IPS.index_level=0 
order by IPS.avg_fragmentation_in_percent desc

FETCH NEXT FROM db_cursor INTO @db_id
END
CLOSE db_cursor
DEALLOCATE db_cursor