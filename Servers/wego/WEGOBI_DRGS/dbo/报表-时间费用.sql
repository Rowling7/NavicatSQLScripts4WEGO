----时间费用

declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';

select cyksbm 出院科室,sum(N) 出院人次,
sum(D)/sum(N) 时间消耗指数,
sum(E)/sum(N) 费用消耗指数
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
when isnull(@settleTimeStart,'') <> ''
then @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 settleTime<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end 
and isdrg=1
and a.hi_type<>'999'
group by a.cyksbm,c.drgcode) a 
--where cyksbm like @cyksbm
group by cyksbm with rollup
order by cyksbm desc
