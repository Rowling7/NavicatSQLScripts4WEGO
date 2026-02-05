-- 更新 oprn 的mdtrt_sn
update som 
set som.mdtrt_sn	=CASE WHEN CHARINDEX('^',sim.mdtrt_id)> 0 THEN LEFT (sim.mdtrt_id, CHARINDEX('^',sim.mdtrt_id) -1)  ELSE sim.mdtrt_id  END 
from t_setlinfo_oprninfo_mid som
left join t_setlinfo_mid  sim on som.pmainindex=sim.pmainindex 
--插入oprninfo表
INSERT INTO
  [dbo].[t_setlinfo_oprninfo] (
    [id]
    , [mdtrt_sn]
    , [oprn_oprt_type]
    , [oprn_oprt_name]
    , [oprn_oprt_code]
    , [oprn_oprt_date]
    , [anst_way]
    , [oper_dr_name]
    , [oper_dr_code]
    , [oper_dr_code_std]
    , [anst_dr_name]
    , [anst_dr_code]
    , [anst_dr_code_std]
    , [sort]
    , [oprn_oprt_lev]
    , [oprn_oprt_begntime]
    , [oprn_oprt_endtime]
    , [anst_begntime]
    , [anst_endtime]
  )
SELECT
  [id]
  , [mdtrt_sn]
  , case when oprn_oprt_type='M' then '1' when oprn_oprt_type='O' then '2'else oprn_oprt_type end
  , [oprn_oprt_name]
  , [oprn_oprt_code]
  , [oprn_oprt_date]
  , [anst_way]
  , [oper_dr_name]
  , [oper_dr_code]
  , [oper_dr_code_std]
  , [anst_dr_name]
  , [anst_dr_code]
  , [anst_dr_code_std]
  , [sort]
  , [oprn_oprt_lev]
  , [oprn_oprt_begntime]
  , [oprn_oprt_endtime]
  , [anst_begntime]
  , [anst_endtime]
FROM
  t_setlinfo_oprninfo_mid
where mdtrt_sn not in (SELECT mdtrt_sn from t_setlinfo)