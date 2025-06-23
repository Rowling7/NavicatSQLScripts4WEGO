USE DRGS_EXPLAIN;
DECLARE @QZD  VARCHAR(255)
      , @QZDe VARCHAR(255);
SET @QZD = '';
SET @QZDe = '';
SELECT ID
     --, PARENTID AS 父ID
     --, TABLENAME AS 字段所在表名称
     , ZDNAME AS 字段名称
     , HZDNAME AS 字段名称汉字
     , ZDCODE AS 字段代码
     , HZDCODE AS 字段代码汉字
     --, TYPE AS 字段类型
     --, EZDCODE AS 字段解释
     , ERRORCODE AS 对应出错列名
FROM fieldcont2
WHERE HZDNAME LIKE CONCAT('%', @QZD, '%')
      OR ERRORCODE LIKE CONCAT('%', @QZDe, '%');