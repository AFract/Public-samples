WITH OnDelete AS
(   SELECT  f.parent_object_id,
            f.referenced_object_id,
            RecursionLevel = 1,
            ObjectTree = CONVERT(VARCHAR(MAX), CONCAT(OBJECT_NAME(f.parent_object_id), ' --> ', OBJECT_NAME(f.referenced_object_id)))
    FROM sys.foreign_keys AS f
    WHERE f.delete_referential_action_desc = 'CASCADE'
    UNION ALL
    SELECT  od.parent_object_id,
            f.referenced_object_id,
            od.RecursionLevel + 1,
            ObjectTree = CONVERT(VARCHAR(MAX), CONCAT(od.ObjectTree, ' --> ', OBJECT_NAME(f.referenced_object_id)))
    FROM    OnDelete AS od
            INNER JOIN sys.foreign_keys AS f
                ON f.parent_object_id = od.referenced_object_id
                AND f.delete_referential_action_desc = 'CASCADE'

)
SELECT  BaseTable = OBJECT_NAME(od.parent_object_id),
        OnDelete = od.ObjectTree
FROM    OnDelete AS od
WHERE   NOT EXISTS
        (   SELECT  1
            FROM    OnDelete AS ex
            WHERE   ex.parent_object_id = od.parent_object_id
            AND     ex.ObjectTree LIKE CONCAT(od.ObjectTree, '%')
            AND     LEN(ex.ObjectTree) > LEN(od.ObjectTree)
        )
ORDER BY od.parent_object_id;