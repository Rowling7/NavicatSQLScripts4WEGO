SELECT a. mdtrt_sn 流水号,a.psn_name 姓名,a.createtime 同步时间,min(c.inf_time)'第一次上报时间'
from t_setlinfo a
left join t_mihs_result c on a. mdtrt_sn=c.uid  and c.infocode<>-1 
where a.mdtrt_sn in
('230043289-31-001',
'2023416312-1-001',
'441346-2-001',
'501003-3-001',
'250042744-1-002',
'250063682-1-001',
'250054169-1-001',
'2023346577-2-001')
group by a. mdtrt_sn ,a.psn_name ,a.createtime