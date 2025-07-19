-- la CTE Partitionne le contenu de ApplicationLog sur le champ Module en ordonnant sur EventCreationTime
-- le SELECT extrait de la CTE la première ligne et les ordonne sur ProcessStartTime
WITH CTE AS
(
    SELECT *, RN = ROW_NUMBER() OVER
    (
		PARTITION BY [Module]
		ORDER BY EventCreationTime asc
	)
    FROM dbo.ApplicationLog
)
SELECT * FROM CTE
WHERE RN = 1
order by ProcessStartTime asc, RN