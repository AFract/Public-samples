-- sp_help 'schemaName.tableName'
-- sp_fkeys @pktable_name = 'tableName', @pktable_owner = 'schemaName'

declare @schema varchar(500) = 'schemaName';
declare @table varchar(500) = 'tableName';

SELECT  obj.name AS FK_NAME,
    sch1.name + '.' + tab1.name + '.'+ col1.name AS [column1],
    sch2.name + '.'+ tab2.name + '.' + col2.name AS [column2],
	typ.name
FROM sys.foreign_key_columns fkc
INNER JOIN sys.objects obj
    ON obj.object_id = fkc.constraint_object_id
INNER JOIN sys.tables tab1
    ON tab1.object_id = fkc.parent_object_id
INNER JOIN sys.schemas sch1
    ON tab1.schema_id = sch1.schema_id
INNER JOIN sys.columns col1
    ON col1.column_id = parent_column_id AND col1.object_id = tab1.object_id
INNER JOIN sys.tables tab2
    ON tab2.object_id = fkc.referenced_object_id
INNER JOIN sys.schemas sch2
    ON tab2.schema_id = sch2.schema_id
INNER JOIN sys.columns col2
    ON col2.column_id = referenced_column_id AND col2.object_id = tab2.object_id
INNER JOIN sys.types typ ON col1.user_type_id = typ.user_type_id
WHERE 
(tab1.name = @table and sch1.name = @schema)
OR (tab2.name = @table and sch2.name = @schema)
ORDER by col2.name 
