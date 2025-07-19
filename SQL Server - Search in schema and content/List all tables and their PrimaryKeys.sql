SELECT schema_name(tab.schema_id) AS [schema_name],
     tab.[name] AS TABLE_NAME,
       --pk.[name] AS pk_name,	   
       substring(column_names, 1, len(column_names) - 1) AS [pk_columns]
FROM sys.tables tab
INNER JOIN sys.indexes pk ON tab.object_id = pk.object_id
AND pk.is_primary_key = 1 CROSS apply
  (SELECT col.[name] + ' (' + UPPER(typ.name) + '), '
   FROM sys.index_columns ic
   INNER JOIN sys.columns col ON ic.object_id = col.object_id
   AND ic.column_id = col.column_id
   INNER JOIN sys.types typ ON col.user_type_id = typ.user_type_id
   WHERE ic.object_id = tab.object_id
     AND ic.index_id = pk.index_id
   ORDER BY col.column_id
   FOR XML PATH ('')) D (column_names)
ORDER BY schema_name(tab.schema_id), tab.[name]