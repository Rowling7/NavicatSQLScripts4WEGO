--低倍率 ，住院天数小于等于3天，31天内没有再住院
select a.mdtrt_sn,left(a.brjsrq,10) 结算日期,replace(replace(a.hi_type,'310','职工'),'390','居民')医保类型,a.act_ipt_days 住院天数,
a.dscg_way 离院方式代码,
case when a.dscg_way='1'then '医嘱离院'
		when a.dscg_way='2'then '医嘱转院'
		when a.dscg_way='3'then '医嘱转社区卫生服务机构/乡镇卫生院'
		when a.dscg_way='4'then '非医嘱离院'
		when a.dscg_way='5'then '死亡'
		else '其他' end 离院方式,
a.days_rinp_flag_31 '出院 31 天内再住院计划标志代码',
case when a.days_rinp_flag_31 ='1'then '有' else '无' end '出院 31 天内再住院计划标志',a.*
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
left join t_drg_result_abnormal d on c.id = d.drgresult_id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
			and c.drgcode is not null
			and (a.isdrg=1
					or (len(a.fixmedins_code)>8
							and a.mdtrt_sn not in (
							'153506001-001'
							,'052200005-001'
							,'153146001-001'
							,'139768002-001'
							,'153678001-001')
							)
					)
			and d.type=3 --3 低倍率 2 高倍率
			and isnull(a.act_ipt_days,0) <=3 
			and a.days_rinp_flag_31<>'1'
order by '离院方式'




--入组失败原因之 主诊与手术不符
select a.mdtrt_sn 就诊流水号,case when c.errormsg is null then '主诊与手术不符' else c.errormsg end 错误信息,d.code 手术编码,d.name 手术名称,e.diag_code 诊断编码,e.diag_name 诊断名称,e.maindiag_flag,a.*
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
left join t_drg_result_operation d on d.drgresult_id=c.id
left join t_setlinfo_diseinfo e on a.mdtrt_sn=e.mdtrt_sn
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
and c.code <> 1
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001'
,'052200005-001'
,'153146001-001'
,'139768002-001'
,'153678001-001'
)))
--and e.maindiag_flag =1 /*主诊标志1是*/
and c.errormsg like'%无效%'
--and c.errormsg is null
--and c.errormsg  like '%住院天数大于60%'

and a.mdtrt_sn in (


--入组失败原因
select a.mdtrt_sn
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
and c.code <> 1
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001'
,'052200005-001'
,'153146001-001'
,'139768002-001'
,'153678001-001'
))) 
and c.errormsg like'%无效%'
)
order by a.mdtrt_sn