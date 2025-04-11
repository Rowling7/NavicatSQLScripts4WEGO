declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';

select aa.*,
convert(decimal(18,2),ac.再入院人次/convert(decimal(18,2),aa.出院人次)*100) as  九天再住院率,
convert(decimal(18,2),ad.再入院人次/convert(decimal(18,2),aa.出院人次)*100) as  十五天再住院率,
convert(decimal(18,2),ae.再入院人次/convert(decimal(18,2),aa.出院人次)*100) as  三十天再住院率,
ab.时间消耗指数,ab.费用消耗指数


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
group by cyksbm with rollup) as aa

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
