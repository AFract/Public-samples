-- Activation niveau serveur
EXEC sys.sp_configure N'filestream access level', N'2'
GO
RECONFIGURE WITH OVERRIDE
GO

--Tuto : https://www.red-gate.com/simple-talk/databases/sql-server/learn/an-introduction-to-sql-server-filestream/

USE [master]
GO
ALTER DATABASE [Test] ADD FILEGROUP [DefaultFilegroup] CONTAINS FILESTREAM 
GO
USE [Test]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'DefaultFilegroup') ALTER DATABASE [Test] MODIFY FILEGROUP [DefaultFilegroup] DEFAULT
GO
USE [Test]
GO
ALTER DATABASE [Test] REMOVE FILEGROUP [FileStream_FileGroup]
GO

ALTER DATABASE Test
ADD FILE 
(
    NAME = 'FileStreamFile',
    FILENAME = 'C:\temp\TestFileStream\FileStream1' -- TODO : locate close to the folder of MDF / LDF files (however the Filestream last directory should be a NON existing directory)
)
TO FILEGROUP [DefaultFilegroup];



ALTER DATABASE Test SET FILESTREAM (NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = 'TestFileStream')
ALTER DATABASE Test SET FILESTREAM (NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = 'SQLEXPRESS_FileStream')

ALTER DATABASE Test
    ADD FILEGROUP [FileStream_FileGroup] CONTAINS FILESTREAM

--------------------------------------------------------------------------------------------

-- Using a Filetable (ap<pears as a Windows file share)
CREATE TABLE ImagesTable AS FileTable
-- or
CREATE TABLE ImagesTable AS FileTable
WITH (
 FileTable_Directory = 'SQLEXPRESS_FileStream',
 FileTable_Collate_Filename = database_default
)
-- The table will be displayed in "Tables/FileTables" entry of SSMS, not with the other tables.

-- To get the Windows shared folder name of a FileTable : 
SELECT FileTableRootPath(N'[dbo].[ImagesTable]');

--------------------------------------------------------------------------------------------

-- Using a regular table with a FILESTREAM column (Does NOT appear as a direct Windows file share even if it's reachable with its guid, but is actually stored "outside" of the DB in the FileStream storage system)
CREATE TABLE [dbo].[Items](
   [ItemID] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
   [ItemNumber] VARCHAR(20),
   [ItemDescription] VARCHAR(50),
   [ItemImage] VARBINARY(MAX) FILESTREAM NULL
)

-- Insert a record in the table :

-- Declare a variable to store the image data
DECLARE @img AS VARBINARY(MAX)
 
-- Load the image data
SELECT @img = CAST(bulkcolumn AS VARBINARY(MAX))
      FROM OPENROWSET(
            BULK
            'C:\temp\MicrosoftMouse.jpg',
            SINGLE_BLOB ) AS x
            
-- Insert the data to the table           
INSERT INTO Items (ItemID, ItemNumber, ItemDescription, ItemImage)
SELECT NEWID(), 'MS1001','Microsoft Mouse', @img

-- To find the shared folder name (not intended for direct usage) : 
SELECT itemimage.PathName() AS PathName
FROM Items;
-- Returns something like "\\computer-name\SQLEXPRESS_FileStream\v02-A60EC2F8-2B24-11DF-9CC3-AF2E56D89593\Test\dbo\Items\ItemImage\3C3AEF41-D65C-4727-B51F-F918410DA881\VolumeHint-HarddiskVolume3"