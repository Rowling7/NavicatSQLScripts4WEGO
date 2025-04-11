----科室RW
declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';


SELECT 
res.科室
,res.总例数
,res.[RW0-0.5例数]
,res.[RW0-0.5占比]
,res.[RW0.5-1例数]
,res.[RW0.5-1占比]
,res.[RW1-2例数]
,res.[RW1-2占比]
,res.[RW2-3例数]
,res.[RW2-3占比]
,res.[RW3-4例数]
,res.[RW3-4占比]
,res.[大于4例数]
,res.[大于4占比]
from 
(
	select
	case when c.CYKSbm is null then '未匹配科室' else  c.CYKSbm end    科室
	,count(a.jzlsh)   总例数
	,isnull(isnull(count(case when a.rw>0 and a.rw<0.5 then a.jzlsh end),0),0)  'RW0-0.5例数'
	,isnull(convert(decimal(18,4),nullif(count(case when a.rw>0 and a.rw<0.5 then a.jzlsh end),0) / convert(decimal(18,4),isnull(count(a.jzlsh),0))),0)  'RW0-0.5占比'
	,isnull(isnull(count(case when a.rw>=0.5 and a.rw<1 then a.jzlsh end),0),0)  'RW0.5-1例数'
	,isnull(convert(decimal(18,4),nullif(count(case when a.rw>=0.5 and a.rw<1 then a.jzlsh end),0) / convert(decimal(18,4),isnull(count(a.jzlsh),0))),0)  'RW0.5-1占比'

	,isnull(isnull(count(case when a.rw>=1 and a.rw<2 then a.jzlsh end),0),0) 'RW1-2例数'
	,isnull(convert(decimal(18,4),nullif(count(case when  a.rw>=1 and a.rw<2 then a.jzlsh end),0) / convert(decimal(18,4),isnull(count(a.jzlsh),0))),0) 'RW1-2占比'

	,isnull(isnull(count(case when a.rw>=2 and a.rw<3 then a.jzlsh end),0),0)   'RW2-3例数'
	 ,isnull(convert(decimal(18,4),nullif(count(case when  a.rw>=2 and a.rw<3  then a.jzlsh end),0) / convert(decimal(18,4),isnull(count(a.jzlsh),0))),0)  'RW2-3占比'

	,isnull(isnull(count(case when a.rw>=3 and a.rw<4 then a.jzlsh end),0),0) 'RW3-4例数'
	 ,isnull(convert(decimal(18,4),nullif(count(case when  a.rw>=3 and a.rw<4  then a.jzlsh end),0) / convert(decimal(18,4),isnull(count(a.jzlsh),0))),0) 'RW3-4占比'

	,isnull(isnull(count(case when a.rw>=4   then a.jzlsh end),0),0)  大于4例数
		,isnull(convert(decimal(18,4),nullif(count(case when  a.rw>=4 then a.jzlsh end),0) / convert(decimal(18,4),isnull(count(a.jzlsh),0))),0)   大于4占比
		,grouping(case when c.CYKSbm is null then '未匹配科室' else  c.CYKSbm end) isTotal
	from t_drg_result a ,t_drg_result_relation b ,t_setlinfo c
	where a.id=b.drgresult_id and  a.jzlsh=c.mdtrt_sn
	and  
	brjsrq>=
	case 
	when isnull(@settleTimeStart,'') <> ''
	then @settleTimeStart
	else
	dateadd(month,datediff(month,0,getdate()-1)-1,0)
	end

	and 
	 brjsrq<
	case 
	when isnull(@settleTimeEnd,'') <> ''
	then DATEADD(day,1,@settleTimeEnd)
	else
	DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
	end
	--and cyksbm like @cyksbm
	and isdrg=1
	and c.hi_type<>'999'
	group by case when c.CYKSbm is null then '未匹配科室' else  c.CYKSbm end  with rollup
)res
	order by  res.isTotal,res.总例数 desc 
