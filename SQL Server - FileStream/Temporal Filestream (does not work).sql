-- Create a temporal table with FILESTREAM
CREATE TABLE Documents (
    DocID int PRIMARY KEY,
    FileName nvarchar(255),
    FileContent varbinary(max) FILESTREAM,
    ValidFrom datetime2 GENERATED ALWAYS AS ROW START,
    ValidTo datetime2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DocumentsHistory));

-- Insert a document
INSERT INTO Documents (DocID, FileName, FileContent)
VALUES (1, 'Document1.pdf', CAST('' AS varbinary(max)));

-- Update document (creates historical record)
UPDATE Documents
SET FileName = 'UpdatedDoc1.pdf'
WHERE DocID = 1;

-- Query document history
SELECT DocID, FileName, ValidFrom, ValidTo
FROM Documents
FOR SYSTEM_TIME ALL
WHERE DocID = 1;