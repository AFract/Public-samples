Select object_name(object_id) as TableName,* 
from SYS.columns 
where name LIKE '%MyName%'



SELECT t.name AS table_name,
SCHEMA_NAME(schema_id) AS schema_name,
c.name AS column_name
FROM sys.tables AS t
INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
WHERE c.name LIKE '%productDiscountType%'
ORDER BY schema_name, table_name;



Select * from  INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME LIKE '%empty%'

