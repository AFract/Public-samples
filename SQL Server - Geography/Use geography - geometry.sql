DECLARE @point GEOGRAPHY = GEOGRAPHY::Point(1, 1, 4326)
DECLARE @polygon GEOGRAPHY = GEOGRAPHY::STGeomFromText('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))', 4326)

SELECT @polygon.STIntersects(@point), @point.STIntersects(@polygon)

-- binary to WKT string readable representation
select location.STAsText() from [ObjectsTable] -- 0xE6100000010CE0388EE3388E3340A28B2EBAE86A6140 ----> POINT (139.34090909090907 19.555555555555543)
select polygon.STAsText() from [AreaTable] -- 0xE610000001040500000062105839B4E82E4000000000000028404B598638D6452F40A52C431CEBA2274062105839B4E82E404B598638D6452740083D9B559F8B2E40A52C431CEBA2274062105839B4E82E40000000000000284001000000020000000001000000FFFFFFFF0000000003 -----> POLYGON ((12 15.4545, 11.8182 15.6364, 11.6364 15.4545, 11.8182 15.2727, 12 15.4545))

-- Find objects in polygon
SELECT obj.id as boId, a.id as areaId, a.name as areaName, obj.name as boName
from [ObjectsTable] obj, 
[AreaTable] a
where a.id = 'my area' and a.polygon.STIntersects(obj.location) = 1

-- Find all objects in all polygons
select * from 
(
	SELECT obj.id as boId, a.id as aId, a.name as areaName, obj.name as boName, polygon.STIntersects(location) intersects
	from [ObjectsTable] obj, 
	[AreaTable] a
) as req where req.intersects != 0

-- Count all objects in all polygons
select areaId, areaName, COUNT(*) from 
(
	SELECT obj.id as boId, a.id as areaId, a.name as areaName, obj.name as boName, polygon.STIntersects(location) intersects
	from [ObjectsTable] obj, 
	[AreaTable] a
) as req 
where req.intersects != 0
group by areaId, areaName
order by COUNT(*) desc

-- Entity framework "Intersects" extension method to count objects in area
var count = (from a in context.Area     
from obj in context.Objects
where a.Id == item.Id && a.Polygon.Intersects(obj.Location)  
select obj).Count();