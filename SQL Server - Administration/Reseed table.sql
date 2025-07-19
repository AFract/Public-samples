-- Reseed identity table.
-- Apparently, the table must contain at least one row to use the parameterless version of this method
DBCC CHECKIDENT('[dbo].[TableName]', RESEED, 0); 