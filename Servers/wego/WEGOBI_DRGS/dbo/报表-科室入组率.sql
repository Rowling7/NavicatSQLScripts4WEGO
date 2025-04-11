---科室入组率
declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';

SELECT
res.出院科室
,res.例数
,res.本地异地
,res.入组例数
,res.入组率
,res.DRG组数
,res.平均费用
,res.平均住院天数
,res.总权重
,res.总点数
,res.药费
,res.材料费
,res.检验检查费
,res.医务性收入
,res.总费用
from (
select  
case when cyksbm is null  then '不详' else cyksbm end  出院科室
,count(*)  例数
,case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end 本地异地
,count(distinct case when a.drgcode is  not null  and  a.isqy <>1   then a.jzlsh end) 入组例数
,  
cast(count(distinct case when a.drgcode is  not null  and  a.isqy <>1  then a.jzlsh end) /cast(count(*) as decimal(18,4))  as decimal(18,4))*100  入组率
,count(distinct a.drgcode) DRG组数
,cast(sum(totalcost)/cast(nullif(count(*),0)  as decimal(18,2))  as decimal(18,2))平均费用
,cast(sum(d.act_ipt_days)/cast(nullif(count(*),0)  as decimal(18,2))  as decimal(18,2))平均住院天数
,sum(a.rw) 总权重
,sum(settlepoint)  总点数
,sum(drug_fee)  药费
,sum(consumable_fee)  材料费
,sum(check_fee) 检验检查费
,sum(medical_fee) 医务性收入
,sum(total_fee) 总费用
,grouping(case when cyksbm is null  then '不详' else cyksbm end) isTotal
   from t_drg_result a
  ,t_drg_result_relation b 
  ,t_setlinfo d 
  where  a.id=b.drgresult_id and a.jzlsh=d.mdtrt_sn  
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
and d.hi_type<>'999'
--and case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end like @bdyd
group by case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end,case when cyksbm is null  then '不详' else cyksbm end   WITH ROLLUP
)res
order by res.isTotal,res.出院科室,res.例数,res.本地异地,res.入组率 desc