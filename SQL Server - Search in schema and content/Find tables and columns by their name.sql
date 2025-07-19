-- Search columns
SELECT      c.name  AS 'ColumnName'
            ,(SCHEMA_NAME(t.schema_id) + '.' + t.name) AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%trans%'
ORDER BY    TableName
            ,ColumnName;

-- Search tables
SELECT      (SCHEMA_NAME(t.schema_id) + '.' + t.name) AS 'TableName'
FROM        sys.tables  t  
WHERE       t.name LIKE '%model%'
ORDER BY    TableName