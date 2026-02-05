-- 1
-- 更新dise的mdtrt_sn
update sdm 
set sdm.mdtrt_sn	=CASE WHEN CHARINDEX('^',sim.mdtrt_id)> 0 THEN LEFT (sim.mdtrt_id, CHARINDEX('^',sim.mdtrt_id) -1)  ELSE sim.mdtrt_id  END 
from t_setlinfo_diseinfo_mid sdm
left join t_setlinfo_mid  sim on sdm.pmainindex=sim.pmainindex ;
-- 插入diseinfo表
INSERT INTO
  t_setlinfo_diseinfo (
    id
    , mdtrt_sn
    , diag_type
    , diag_code
    , diag_name
    , adm_cond_type
    , maindiag_flag
    , tcm_dise_flag
    , sort
  )
SELECT
   id
  , mdtrt_sn
  , sdm.diag_type
  , REPLACE(sdm.diag_code  , NCHAR(8224)  , '+')
  , sdm.diag_name
  , sdm.adm_cond_type
  , CASE
    WHEN sdm.maindiag_flag = 'M' THEN '1'
    WHEN sdm.maindiag_flag = 'O' THEN '2'
    ELSE sdm.maindiag_flag
  END
  , sdm.tcm_dise_flag
  , sdm.sort
FROM
  t_setlinfo_diseinfo_mid sdm
where sdm.mdtrt_sn not in (SELECT mdtrt_sn from t_setlinfo)