--查询麻醉方式为空和麻醉医师标准代码也为空的情况
SELECT id,mdtrt_sn,anst_way,anst_dr_code_std
from t_setlinfo_oprninfo
where anst_way is null and anst_dr_code_std is null

--更新麻醉医师标准代码为*
/*
update t_setlinfo_oprninfo
set anst_dr_code_std='*'
where anst_way is null and anst_dr_code_std is null
*/