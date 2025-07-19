declare @moi geography, @mass  geography;

set @moi = geography::STGeomFromText('POINT(3.162668 50.689739)', 4326); -- 4326 = WGS84  
set @mass  = geography::STGeomFromText('POINT(3.071310 50.635235)', 4326);

declare @dist float;

set @dist = @moi.STDistance(@mass)/1000;

select @dist;

--go 1000