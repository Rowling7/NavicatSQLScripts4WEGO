USE DRGS_EXPLAIN;
SELECT A.ID
     , B.TABLENAME AS 字段所在表名称
     , B.ZDCODE AS 字段名称
     , B.HZDCODE AS 字段名称汉字
     , A.ZDCODE AS 字段代码
     , A.HZDCODE AS 字段代码汉字
     , B.TYPE AS 字段类型
     , A.ERRORCODE AS 对应出错列名
FROM fieldcont2 AS A
     LEFT JOIN fieldcont AS B ON B.ZDCODE = A.ZDNAME
WHERE B.HZDCODE LIKE '%%'
      OR A.ERRORCODE LIKE '%%'
ORDER BY B.TABLENAME;


/*
SELECT A.ID
     , D.TABLENAME AS 字段所在表名称
     , B.ZDNAME       AS 字段名称
     , B.HZDNAME     AS 字段名称汉字
     , A.ZDCODE                            AS 字段代码
     , A.HZDCODE                           AS 字段代码汉字
     , B.ERRORCODE                         AS 对应出错列名
FROM fieldcont2     AS A
LEFT JOIN fieldcont2 AS B ON B.ID = A.PARENTID
LEFT JOIN fieldcont AS C  ON C.ZDCODE = B.ZDNAME
LEFT JOIN fieldcont AS D  ON D.ID = C.PARENTID

WHERE B.HZDNAME 		 LIKE '%%'
      OR B.ERRORCODE LIKE '%%'
*/

/*
SELECT B.TABLENAME
    ,A.ZDNAME
    ,A.HZDNAME
    ,C.ZDCODE
    ,C.HZDCODE
FROM fieldcont2 A
full JOIN (
SELECT X.TABLENAME TABLENAME,X.HTABLENAME HTABLENAME,Y.ZDCODE ZDCODE,Y.HZDCODE HZDCODE
FROM fieldcont X
LEFT JOIN fieldcont Y ON Y.PARENTID=X.ID
WHERE X.TABLENAME IS NOT NULL
) B ON A.ZDNAME=B.ZDCODE
left join fieldcont2 c on A.id =c.PARENTID
WHERE A.PARENTID IS  NULL and A.ZDNAME is not null
*/