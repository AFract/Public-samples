DECLARE @TableNames TABLE (TableName NVARCHAR(128));
INSERT INTO @TableNames (TableName) VALUES 
('Table1'), 
('Table2'), 
('Table3');

DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = @SQL + 
'ALTER TABLE ' + QUOTENAME(TableName) + ' ADD
	CreationDate DATETIME NOT NULL DEFAULT GETDATE(),
    LastModificationDate DATETIME NOT NULL DEFAULT GETDATE();
'
FROM @TableNames;

PRINT @SQL;
-- EXEC sp_executesql @SQL; -- Uncomment this line to execute the generated script