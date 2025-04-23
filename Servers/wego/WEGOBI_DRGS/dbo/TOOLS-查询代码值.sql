USE DRGS_EXPLAIN;
DECLARE @QZD  VARCHAR(255)  -- 字段代码
      , @QZDe VARCHAR(255); -- 上报错误代码
SET @QZD = '';  -- 字段代码
SET @QZDe = ''; -- 上报错误代码
SELECT FD2.ID
     --, FD2.PARENTID                          AS 父ID
     --, FD2.TABLENAME                         AS 字段所在表名称
     , COALESCE(FD.TABLENAME, FD2.TABLENAME) AS 字段所在表名称
     , COALESCE(FD.ZDCODE, FD2.ZDNAME)       AS 字段名称
     , COALESCE(FD.HZDCODE, FD2.HZDNAME)     AS 字段名称汉字
     , FD2.ZDCODE                            AS 字段代码
     , FD2.HZDCODE                           AS 字段代码汉字
     --, FD2.TYPE                              AS 字段类型
     --, FD2.EZDCODE                           AS 字段解释
     , FD2.ERRORCODE                         AS 对应出错列名
FROM fieldcont2     AS FD2
LEFT JOIN fieldcont AS FD  ON FD.ID = FD2.PARENTID
WHERE FD2.HZDNAME 		 LIKE CONCAT('%', @QZD , '%')
      OR FD2.ERRORCODE LIKE CONCAT('%', @QZDe, '%');