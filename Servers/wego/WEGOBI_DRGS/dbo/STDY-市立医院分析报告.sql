--整体数据分析
select c.drgcode DRG组编码,sum(c.profitloss) 预计盈亏,convert(decimal(18,2),sum(a.total_fee)
/count(c.jzlsh)) 平均费用 
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)))
group by c.drgcode
having sum(c.profitloss)>0   --盈
--having sum(c.profitloss)<0  --亏



--数据概况
select c.insurtype,
count(c.jzlsh) 例数,sum(c.profitloss) 预计盈亏,convert(decimal(18,2),sum(a.total_fee)
/count(c.jzlsh)) 平均费用 
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
--and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)
))
group by c.insurtype



--盈亏top10
select c.drgcode DRG组编码,c.drgname DRG组名称,
concat('[',c.drgcode,']',c.drgname) DRG组
,c.basepoint 基准点数,count(c.jzlsh) 例数,sum(c.profitloss) 预计盈亏,convert(decimal(18,2),sum(a.total_fee)
/count(c.jzlsh)) 平均费用 
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)))
group by c.drgcode,c.drgname,c.basepoint
having count(c.jzlsh)>20
order by sum(c.profitloss) desc  --盈
--order by sum(c.profitloss) asc  --亏
--order by count(c.jzlsh) desc  --病案数



--盈亏top10 职工居民系数
select * from t_drg_coefficient where drgcode in(
'FM39','BZ19','KS19','FM19','FM29','ES33','GF15','BE29','TR19','GF23'
) and year = '2024'



--科室盈亏分析

select 
a.cyksbm 科室,count(c.jzlsh) 例数,sum(c.profitloss) 预计盈亏,convert(decimal(18,2),sum(a.total_fee)
/count(c.jzlsh)) 平均费用 
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
--and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)))
group by a.cyksbm
order by sum(c.profitloss) desc



--科室入组率
select 
a.cyksbm 科室,count(c.jzlsh) 例数
,(convert(decimal(18,2),isnull(convert(decimal(18,4),nullif(count(case when c.code =1 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)*100)) 入组率
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
--and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)))
group by a.cyksbm
order by (convert(decimal(18,2),isnull(convert(decimal(18,4),nullif(count(case when c.code =1 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)*100)) desc



--科室rw 分布
select 
case when a.cyksbm is null then '未匹配科室' else a.cyksbm end as 出院科室

,count(c.jzlsh) 出院人次


,isnull(isnull(count(case when c.rw>=0 and c.rw<0.5 then c.jzlsh end),0),0) 'RW0-0.5例数' 

,(convert(decimal(18,4),isnull(convert(decimal(18,4),nullif(count(case when c.rw>=0 and c.rw<0.5 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)))  'RW0-0.5占比' 

,isnull(isnull(count(case when c.rw>=0.5 and c.rw<1 then c.jzlsh end),0),0) 'RW0.5-1例数' 
,(convert(decimal(18,4),isnull(convert(decimal(18,4),nullif(count(case when c.rw>=0.5 and c.rw<1 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)))   'RW0.5-1占比'  
,isnull(isnull(count(case when c.rw>=1 and c.rw<2 then c.jzlsh end),0),0) 'RW1-2例数' 
,(convert(decimal(18,4),isnull(convert(decimal(18,4),nullif(count(case when c.rw>=1 and c.rw<2 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)))  'RW1-2占比'  
,isnull(isnull(count(case when c.rw>=2 and c.rw<3 then c.jzlsh end),0),0) 'RW2-3例数' 
,(convert(decimal(18,4),isnull(convert(decimal(18,4),nullif(count(case when c.rw>=2 and c.rw<3 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)))  'RW2-3占比' 
,isnull(isnull(count(case when c.rw>=3 and c.rw<4 then c.jzlsh end),0),0) 'RW3-4例数' 
,(convert(decimal(18,4),isnull(convert(decimal(18,4),nullif(count(case when c.rw>=3 and c.rw<4 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)))   'RW3-4占比' 
,isnull(isnull(count(case when c.rw>=4 then c.jzlsh end),0),0) 'RW>4例数' 
,(convert(decimal(18,4),isnull(convert(decimal(18,4),nullif(count(case when c.rw>=4 then c.jzlsh end),0) / convert(decimal(18,4),isnull(count(c.jzlsh),0))),0)))  'RW>4占比' 

from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
--and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)))
group by case when a.cyksbm is null then '未匹配科室' else a.cyksbm end
order by count(c.jzlsh) desc







--六大指标分析

select
t.year1 --年度
,t.dscg_caty 科室
,sum(t.drgcode) DRG组数
,sum(jzlsh) 病例数
,(convert(decimal(18,6),sum(rw)/sum(jzlsh))) CMI
,sum(rw) 总权重
,(convert(decimal(18,2),sum(E)/sum(N))) 费用消耗指数
,(convert(decimal(18,2),sum(D)/sum(N))) 时间消耗指数
,sum(t.profitloss) 盈亏
,sum(t.swrs) 死亡患者
from (
	select 	year(c.settletime) year1 /*年度*/	,a.cyksbm dscg_caty	,c.drgcode aa	,COUNT(DISTINCT c.drgcode) drgcode
	,(avg(totalcost)/(select top 1 zfy_avg from wegobi_drgs.dbo.t_drg_average_2024ac where drgcode=c.drgcode and year=year(c.settletime)))*count(0) E
	,(avg(day)/(select top 1 day_avg from wegobi_drgs.dbo.t_drg_average_2024ac where drgcode=c.drgcode and year=year(c.settletime)))*count(0) D
	,count(0) N	,SUM(c.rw) rw	,COUNT(c.jzlsh) jzlsh	,sum(profitloss) profitloss
	,count(case when a.dscg_way = 5 then c.jzlsh end) swrs
	
	from t_setlinfo a
	left join t_drg_result_relation b on a.mdtrt_sn=b.uid
	left join t_drg_result c on b.drgresult_id=c.id
	where convert(date, a.brjsrq, 23) between '2024-01-01' and '2024-12-31'
	and (a.isdrg=1
	or (len(a.fixmedins_code)>8	and a.mdtrt_sn  not in (	'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'	)
		)
	) and a.hi_type<>'999' and a.ipt_med_type=1 --and a.is_rjbf=0
	and c.drgcode is not null
	group by year(c.settletime),a.cyksbm,c.drgcode

) t
group by t.year1,t.dscg_caty
order by sum(jzlsh) desc ;






--21年医疗机构＋省内异地
select * from t_setlinfo where convert(date,brjsrq,23) between '2021-01-01' and '2021-12-31' 
and isdrg=1 and mdtrt_sn <> '101785013-002'

--22年医疗机构＋省内异地
select * from t_setlinfo where convert(date,brjsrq,23) between '2022-01-01' and '2022-12-31' 
and (isdrg=1
or (len(fixmedins_code)>8
and mdtrt_sn  not in (
'076394002-001','083690006-001','088312005-001','127734002-002','128207001-001','128580001-001','128799001-001','128911001-001','129090001-001','129445001-001','130105001-001','130201001-001','130287001-001','130315001-001','130345001-001','098599003-001','099633003-001','104504003-001','109303006-001','121613003-001','128102001-001','128507001-002','128839001-001','129143001-001','129505001-001','129536001-001','129545001-001','129767001-001','131879001-001','069574002-001','085706007-002','124808002-001','128587001-001','128620001-001','128873001-001','128912001-001','128961001-001','128997001-001','129298001-001','129940001-001','130108001-001','108965002-002','118447003-002','128787001-001','128816001-001','129169001-001','129301001-001','129570001-001','130218001-001','130302001-001','130309001-001','087584002-001','098747003-001','106744002-001','121261002-002','127718001-001','128190001-001','128602001-001','128863001-001','128891001-001','128958001-001','128975001-001','129262002-002','129586001-001','129592001-001','129690001-001','129911001-002','130027001-001','089909003-002','120102005-002','128759001-001','129252001-001','129274001-001','129478001-001','129740001-001','130174001-001','130305001-001','077960002-001','105751004-001','118447002-001','119364002-002','124521002-002','126099002-002','128223001-001','128439001-001','128466001-001','128703001-001','128786001-001','128861001-001','128866001-001','129185001-001','129382001-001','129683001-001','129877001-001','129978001-001','129996001-001','116796002-002','120995005-001','124917002-001','127328002-001','128237001-001','128660001-001','128677001-001','128753001-001','128820001-001','128870001-001','129198001-001','129262001-001','129361001-001','129750001-001','130122001-001'
)))



----23年医疗机构＋省内异地
select * from t_setlinfo where convert(date,brjsrq,23) between '2023-01-01' and '2023-12-31' 
and (isdrg=1
or (len(fixmedins_code)>8
and mdtrt_sn  not in (
'097071004-003','146160001-001','146454001-001','146463001-001','138196001-001','144216001-001','145366001-001','146261001-001','145670001-001','145476001-001'
)))


select count(c.jzlsh) 总例数 ,count(case when d.type = 3 then c.jzlsh end ) 低倍率例数,
count(case when d.type= 2 then c.jzlsh end ) 高倍率例数 
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
left join t_drg_result_abnormal d on c.id = d.drgresult_id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)))

--21年医疗机构＋省内异地
select * from t_setlinfo where convert(date,brjsrq,23) between '2021-01-01' and '2021-12-31' 
and isdrg=1 and mdtrt_sn <> '101785013-002'

--22年医疗机构＋省内异地
select * from t_setlinfo where convert(date,brjsrq,23) between '2022-01-01' and '2022-12-31' 
and (isdrg=1
or (len(fixmedins_code)>8
and mdtrt_sn  not in (
'076394002-001','083690006-001','088312005-001','127734002-002','128207001-001','128580001-001','128799001-001','128911001-001','129090001-001','129445001-001','130105001-001','130201001-001','130287001-001','130315001-001','130345001-001','098599003-001','099633003-001','104504003-001','109303006-001','121613003-001','128102001-001','128507001-002','128839001-001','129143001-001','129505001-001','129536001-001','129545001-001','129767001-001','131879001-001','069574002-001','085706007-002','124808002-001','128587001-001','128620001-001','128873001-001','128912001-001','128961001-001','128997001-001','129298001-001','129940001-001','130108001-001','108965002-002','118447003-002','128787001-001','128816001-001','129169001-001','129301001-001','129570001-001','130218001-001','130302001-001','130309001-001','087584002-001','098747003-001','106744002-001','121261002-002','127718001-001','128190001-001','128602001-001','128863001-001','128891001-001','128958001-001','128975001-001','129262002-002','129586001-001','129592001-001','129690001-001','129911001-002','130027001-001','089909003-002','120102005-002','128759001-001','129252001-001','129274001-001','129478001-001','129740001-001','130174001-001','130305001-001','077960002-001','105751004-001','118447002-001','119364002-002','124521002-002','126099002-002','128223001-001','128439001-001','128466001-001','128703001-001','128786001-001','128861001-001','128866001-001','129185001-001','129382001-001','129683001-001','129877001-001','129978001-001','129996001-001','116796002-002','120995005-001','124917002-001','127328002-001','128237001-001','128660001-001','128677001-001','128753001-001','128820001-001','128870001-001','129198001-001','129262001-001','129361001-001','129750001-001','130122001-001')))



----23年医疗机构＋省内异地
select * from t_setlinfo where convert(date,brjsrq,23) between '2023-01-01' and '2023-12-31' 
and (isdrg=1
or (len(fixmedins_code)>8
and mdtrt_sn  not in (
'097071004-003','146160001-001','146454001-001','146463001-001','138196001-001','144216001-001','145366001-001','146261001-001','145670001-001','145476001-001'
)))


select count(c.jzlsh) 总例数 ,count(case when d.type = 3 then c.jzlsh end ) 低倍率例数,
count(case when d.type= 2 then c.jzlsh end ) 高倍率例数 
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
left join t_drg_result_abnormal d on c.id = d.drgresult_id
where convert(date,a.brjsrq,23) between '2024-01-01' and '2024-12-31'
and c.drgcode is not null
and (a.isdrg=1
or (len(a.fixmedins_code)>8
and a.mdtrt_sn  not in (
'153506001-001','052200005-001','153146001-001','139768002-001','153678001-001'
)))