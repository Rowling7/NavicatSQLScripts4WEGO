DECLARE @columns nvarchar(50);
set @columns ='%'+'CONER_ADDR'+'%';

SELECT 
    TABLE_SCHEMA AS [Schema],
    TABLE_NAME AS [Table],
    COLUMN_NAME AS [Column],
    DATA_TYPE AS [Data Type]
FROM 
    INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like  @columns
ORDER BY 
    TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;
	