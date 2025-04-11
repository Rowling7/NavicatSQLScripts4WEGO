declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-08-01';
set @settleTimeEnd ='2024-8-31';

if object_id('tempdb..#temp_zbfx_1') is not null drop table #temp_zbfx_1
select 
cyksbm  出院科别,
count(distinct mdccode)  mdc数量,
count(distinct adrgcode) adrg数量aa,
count(distinct drgcode) drg数量
into #temp_zbfx_1
from t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id
where
a.brjsrq>=CASE WHEN isnull(@settleTimeStart,'')<> '' THEN @settleTimeStart 
			ELSE dateadd(MONTH,datediff(MONTH,0,getdate()-1)-1,0) 
			END 
AND a.brjsrq< CASE WHEN isnull(@settleTimeEnd,'')<> '' THEN DATEADD(DAY,1,@settleTimeEnd) 
			ELSE DATEADD(DAY,1,dateadd(MONTH,datediff(MONTH,01,getdate()),-1)) 
			END
and isdrg=1
and a.hi_type<>'999'
group by cyksbm 

select 
case when aa.[出院科别]='Total'then null else aa.[出院科别] end 出院科别
,aa.[出院人次]
,case when aa.[出院科别]='Total'then(SELECT sum(mdc数量) from #temp_zbfx_1) else aa.[mdc数量] end [mdc数量]
,case when aa.[出院科别]='Total'then(SELECT sum(adrg数量aa) from #temp_zbfx_1) else aa.[adrg数量aa] end [adrg数量aa]
,case when aa.[出院科别]='Total'then(SELECT sum(drg数量) from #temp_zbfx_1) else aa.[drg数量] end [drg数量]
,aa.[总权重]
,aa.[低住院天数占比]
,aa.[低风险死亡率]
,aa.[中低风险死亡率]
,aa.[平均住院日]
,aa.[次均住院费用]
,convert(decimal(18,2),ac.再入院人次/convert(decimal(18,2),aa.出院人次)*100) as  九天再住院率
,convert(decimal(18,2),ad.再入院人次/convert(decimal(18,2),aa.出院人次)*100) as  十五天再住院率
,convert(decimal(18,2),ae.再入院人次/convert(decimal(18,2),aa.出院人次)*100) as  三十天再住院率
,ab.时间消耗指数
,ab.费用消耗指数


from (select 
CASE WHEN GROUPING(cyksbm) = 1 THEN 'Total' ELSE cyksbm END AS  出院科别,
count(0) 出院人次,
count(distinct mdccode) mdc数量,
count(distinct adrgcode) adrg数量aa,
count(distinct drgcode) drg数量,
sum(c.rw) 总权重,
convert(decimal(18,2),count(
case 
when act_ipt_days<2
then 1
end
)/convert(decimal(18,2),count(0))*100) 低住院天数占比,
0 低风险死亡率,
0 中低风险死亡率,
convert(decimal(18,2),avg(convert(decimal(18,2),a.act_ipt_days))) 平均住院日,
convert(decimal(18,2),avg(total_fee)) 次均住院费用
from t_setlinfo a left join t_drg_result_relation b on a.mdtrt_sn=b.uid left join t_drg_result c on b.drgresult_id=c.id
where
a.brjsrq>=
case 
when isnull( @settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 a.brjsrq<
case 
when isnull( @settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end 
and isdrg=1
and a.hi_type<>'999'
group by cyksbm with rollup

) as aa

left join 
(select CASE WHEN GROUPING(cyksbm) = 1 THEN 'Total' ELSE cyksbm END AS  出院科室,sum(N) 出院人次,
sum(D)/sum(N)*1.2582 时间消耗指数,
sum(E)/sum(N)*0.88578 费用消耗指数
from 
(select 
a.cyksbm cyksbm,
drgcode,
(avg(totalcost)/(select top 1 zfy_avg from t_drg_average where drgcode=c.drgcode))*count(0) E,
(avg(day)/(select top 1 day_avg from t_drg_average where drgcode=c.drgcode))*count(0) D,
Count(0) N
from 
t_setlinfo a 
left join t_drg_result_relation b on a.mdtrt_sn=b.uid 
left join t_drg_result c on b.drgresult_id=c.id  
where  
settleTime>=
case 
when isnull( @settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 settleTime<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1, @settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end 
and isdrg=1
and a.hi_type<>'999'
group by a.cyksbm,c.drgcode) a 
group by cyksbm with rollup) as ab
on aa.出院科别=ab.出院科室 
left join 
(select v.cyksbm,count(0) 再入院人次 from 
(select a.cyksbm,a.medcasno
from t_setlinfo a right join 
(select * from 
(select medcasno,count(0) number,min(dscg_time) time from 
t_setlinfo where 

brjsrq>=
case 
when isnull(@settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 brjsrq<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1, @settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end 

and isdrg=1 group by medcasno)
as d where d.number>1) 
b on
a.medcasno=b.medcasno where a.brjsrq>=
case 
when isnull( @settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 a.brjsrq<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1, @settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end  and isdrg=1 and a.adm_time>b.time and a.adm_time<=DATEADD(d,9,b.time) group by cyksbm,a.medcasno ) 
as v  group by v.cyksbm) ac on aa.出院科别=ac.cyksbm

left join 
(select v.cyksbm,count(0) 再入院人次 from 
(select a.cyksbm,a.medcasno
from t_setlinfo a right join 
(select * from 
(select medcasno,count(0) number,min(dscg_time) time from 
t_setlinfo where 

brjsrq>=
case 
when isnull( @settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 brjsrq<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1, @settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end 

and isdrg=1 group by medcasno)
as d where d.number>1) 
b on
a.medcasno=b.medcasno where a.brjsrq>=
case 
when isnull( @settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 a.brjsrq<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end  and isdrg=1 and a.adm_time>b.time and a.adm_time<=DATEADD(d,15,b.time) group by cyksbm,a.medcasno ) 
as v  group by v.cyksbm) ad on aa.出院科别=ad.cyksbm

left join 
(select v.cyksbm,count(0) 再入院人次 from 
(select a.cyksbm,a.medcasno
from t_setlinfo a right join 
(select * from 
(select medcasno,count(0) number,min(dscg_time) time from 
t_setlinfo where 

brjsrq>=
case 
when isnull( @settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 brjsrq<
case 
when isnull( @settleTimeEnd,'') <> ''
then DATEADD(day,1, @settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end 

and isdrg=1 group by medcasno)
as d where d.number>1) 
b on
a.medcasno=b.medcasno where a.brjsrq>=
case 
when isnull(@settleTimeStart,'') <> ''
then  @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 a.brjsrq<
case 
when isnull( @settleTimeEnd,'') <> ''
then DATEADD(day,1, @settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end  and isdrg=1 and a.adm_time>b.time and a.adm_time<=DATEADD(d,30,b.time) group by cyksbm,a.medcasno ) 
as v  group by v.cyksbm) ae on aa.出院科别=ae.cyksbm

