INSERT INTO
  [dbo].[t_setlinfo_iteminfo] (
    [id]
    , [mdtrt_sn]
    , [med_chrgitm]
    , [amt]
    , [claa_sumfee]
    , [clab_amt]
    , [fulamt_ownpay_amt]
    , [oth_amt]
  )
SELECT
  [id]
	, CASE WHEN CHARINDEX('^',mdtrt_sn)> 0 THEN LEFT (mdtrt_sn, CHARINDEX('^',mdtrt_sn) -1)  ELSE mdtrt_sn  END
  , [med_chrgitm]
  , [amt]
  , [claa_sumfee]
  , [clab_amt]
  , [fulamt_ownpay_amt]
  , [oth_amt]
FROM
  [dbo].[t_setlinfo_iteminfo_mid]
WHERE mdtrt_sn NOT IN (SELECT mdtrt_sn FROM t_setlinfo);