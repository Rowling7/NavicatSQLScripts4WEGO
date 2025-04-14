DECLARE @COLUMNS NVARCHAR(50);
SET @COLUMNS ='%'+'CONER_ADDR'+'%';

SELECT 
    TABLE_SCHEMA AS [SCHEMA],
    TABLE_NAME AS [TABLE],
    COLUMN_NAME AS [COLUMN],
    DATA_TYPE AS [DATA TYPE]
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE  @COLUMNS
ORDER BY 
    TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;
	