--CREATE TABLE [dbo].[TestSpatial](
--	[Geography1] [geography] NOT NULL,
--	[Geography2] [geography] NOT NULL
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--DELETE FROM TESTDATABASE_DEV.dbo.TestSpatial

INSERT INTO [dbo].[TestSpatial]
           ([Geography1]
           ,[Geography2])
     VALUES
           (geography::Point(50.635850, 3.073520, 4326), -- lille flandres
           geography::Point(50.686200, 3.169320, 4326)) -- rue des arts roubaix 

select top 1 geography1.STDistance(geography2) from [TestSpatial]; 

-- NOTE : avec l'EFCore, la fonction Distance renvoie une toute autre valeur (0.1 au lieu de 8000m). C'est parce que quand le calcul est effectué côté client, il ne tient pas compte du système de référence utilisé et renvoie une valeur en degrés.