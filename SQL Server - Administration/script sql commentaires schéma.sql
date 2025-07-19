
-- EXTRACTION REQUETE PRÉPARÉE PR TOUS LES CHAMPS D'UNE TABLE
declare @table varchar(100); set @table = ''

select 10, '--Commentaires pour la table ' + @table
union
select 11, ''
union
select 20, 'exec sp_addextendedproperty N''MS_Description'', N''commentairetable'', ''SCHEMA'', ''dbo'', ''TABLE'', ''' + @table + ''''
union
select 30, ''
union
SELECT 40,
'exec sp_addextendedproperty N''MS_Description'', N''commentairecolonne'', ''SCHEMA'', ''dbo'', ''TABLE'', ''' + @table + ''', ''COLUMN'', ''' + 
  COLUMN_NAME
+ ''''
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
TABLE_NAME=@table AND
ordinal_position != 1 AND -- pour exclure la PK à défaut de mieux
-- pour exclure les champs spéciaux à nous
COLUMN_NAME not like '%creation%' and
COLUMN_NAME not like '%suppression%' and
COLUMN_NAME not like '%_maj%' 
order by 1 -- pour résoudre le pb d'union qui a tendance à organiser les trucs comme il en a envie
-- FIN EXTRACTION REQUETE PRÉPARÉE PR TOUS LES CHAMPS D'UNE TABLE