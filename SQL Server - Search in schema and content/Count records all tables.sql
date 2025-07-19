SELECT
	SCHEMA_NAME(sOBJ.schema_id) As [SchemaName], sOBJ.name AS [TableName],
	QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [FullName],
    SUM(sPTN.Rows) AS [RowCount]
FROM 
      sys.objects AS sOBJ
      INNER JOIN sys.partitions AS sPTN
            ON sOBJ.object_id = sPTN.object_id
WHERE
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
      AND index_id < 2 -- 0:Heap, 1:Clustered

	  --AND SCHEMA_NAME(sOBJ.schema_id) = 'Objects'

GROUP BY 
      sOBJ.schema_id      , 
	  sOBJ.name
--ORDER BY FullName
ORDER BY [RowCount] desc

