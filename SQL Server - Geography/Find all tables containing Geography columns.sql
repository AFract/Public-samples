-- All tables containing columns of type "Geography" or "Geometry"
SELECT
  sys.columns.name AS ColumnName,
  sys.columns.user_type_id AS ColumnType,
  tables.name AS TableName
FROM
  sys.columns
JOIN sys.tables ON
  sys.columns.object_id = tables.object_id
WHERE
  sys.columns.user_type_id in (129, 130)
order by TableName

-- See all types
select * from sys.types