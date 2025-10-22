/*医保平台校验不通过
错误信息：疾病编码或疾病诊断不在疾病表中，或编码与名称不匹配
--处理方式
通过查询表确定疾病名称和编码对应t_diagnosis_code诊断映射表中医保码疾病名称和编码的是否一致，不一致的情况下，修改t_setlinfo_diseinfo表确定疾病名称和编码重新上传。
*/
select mdtrt_sn,diag_type,diag_code,diag_name,adm_cond_type
from t_setlinfo_diseinfo
where diag_code+diag_name not in
	(select distinct trim(insur_code)+trim(insur_name)  from  t_diagnosis_code)


SELECT
	diagnosis_code 诊断编码国临版,
	diagnosis_name 诊断名称国临版,
	insur_code 诊断编码医保版,
	insur_name 诊断名称医保版 
FROM
	t_diagnosis_code
where 
	insur_code like '%k58.800%' 

