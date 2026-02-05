--插入payinfo
INSERT INTO
  [dbo].[t_setlinfo_payinfo] (
		[id]
  , [mdtrt_sn]
  , [fund_pay_type]
  , [fund_payamt]
)
SELECT
  [id]
  , CASE WHEN CHARINDEX('^',mdtrt_sn)> 0 THEN LEFT (mdtrt_sn, CHARINDEX('^',mdtrt_sn) -1)  ELSE mdtrt_sn  END
  , [fund_pay_type]
  , [fund_payamt]
FROM
  [dbo].[t_setlinfo_payinfo_mid]
WHERE
mdtrt_sn NOT IN (SELECT mdtrt_sn FROM t_setlinfo)