use [Test];

DROP TABLE IF EXISTS dbo.TextTable
GO
CREATE TABLE dbo.TextTable
	(
	Id int NOT NULL IDENTITY (1, 1),
	JsonText varchar(MAX) NOT NULL,
	XmlText varchar(MAX) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.TextTable SET (LOCK_ESCALATION = TABLE)
GO
select Has_Perms_By_Name(N'dbo.TextTable', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.TextTable', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.TextTable', 'Object', 'CONTROL') as Contr_Per 

INSERT INTO [dbo].[TextTable]
           (JsonText
           ,XmlText)
     VALUES
           ('[
    {
        "personId": 2,
        "info": {
            "name": "John",
            "surname": "Smith"
        },
        "age": 25
    },
    {
        "personId": 3,
        "info": {
            "name": "Bob",
            "surname": "Smith"
        },
        "age": 17
    },
    {
        "personId": 5,
        "info": {
            "name": "Jane",
            "surname": "Smith",
            "skills": ["SQL", "C#", "Azure"]
        },
        "dob": "2005-11-04T12:00:00"
    }
]'
           ,'')
GO

SELECT TOP (1000) [Id]
      ,JsonText
      ,XmlText
  FROM [Test].[dbo].[TextTable]

-- query in json7 column of a table
SELECT 
	PersonId,
    FirstName,
    LastName,
    Age,
    DateOfBirth, 
    Skills
FROM OPENJSON((SELECT JsonText FROM [TextTable])) WITH (
    PersonId INT '$.personId',
    FirstName NVARCHAR(50) '$.info.name',
    LastName NVARCHAR(50) '$.info.surname',
    Age INT '$.age',
    DateOfBirth DATETIME2 '$.dob',
    Skills NVARCHAR(MAX) '$.info.skills' AS JSON
);

-- Query in table regular columns, and a json column
-- Aliases are added just for disambiguation at reading but not mandatory for SQL Server
SELECT 
    t.Id,
	PersonId,
    FirstName,
    LastName,
    Age,
    DateOfBirth,
    Skills
FROM [TextTable] t
CROSS APPLY OPENJSON(t.JsonText) WITH (
    PersonId INT '$.personId',
    FirstName NVARCHAR(50) '$.info.name',
    LastName NVARCHAR(50) '$.info.surname',
    Age INT '$.age',
    DateOfBirth DATETIME2 '$.dob',
    Skills NVARCHAR(MAX) '$.info.skills' AS JSON
) AS p

-- Query in table regular columns, and a json column containing a nested array (than can be empty or missing), and a WHERE clause
-- Aliases are added just for disambiguation at reading but not mandatory for SQL Server
SELECT 
    t.Id,
	PersonId,
    FirstName,
    LastName,
    Age,
    DateOfBirth,
    ps.Skill
FROM [TextTable] t
CROSS APPLY OPENJSON(t.JsonText) WITH (
    PersonId INT '$.personId',
    FirstName NVARCHAR(50) '$.info.name',
    LastName NVARCHAR(50) '$.info.surname',
    Age INT '$.age',
    DateOfBirth DATETIME2 '$.dob',
    Skills NVARCHAR(MAX) '$.info.skills' AS JSON
) AS p
-- OUTER APPLY to not filter persons without skills
OUTER APPLY OPENJSON(p.Skills) WITH ( 
    Skill NVARCHAR(50) '$'
) AS ps
WHERE p.Age > 10 and p.Age > 21