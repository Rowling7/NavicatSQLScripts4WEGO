declare @settleTimeStart date;
declare @settleTimeEnd date;
set @settleTimeStart='2025-04-01';
set @settleTimeEnd ='2025-04-30';

if object_id('tempdb..#temp_profitlossTOP10') is not null drop table #temp_profitlossTOP10

select  top 10
CASE WHEN GROUPING(a.drgcode) = 1 THEN '合计' ELSE a.drgcode END AS  DRG组编码
,a.drgname  DRG组名称
,sum(totalcost)/count(distinct jzlsh) 例均费用
,a.basepoint  基准点数
,count(distinct jzlsh) 病案数
,sum(a.settlepoint) 预计结算点数
,sum(profitloss) 预计盈亏
,sum(drug_fee)   药费
,sum(drug_fee)/sum(total_fee )*100 药费占比
,sum(consumable_fee)   材料费
,sum(consumable_fee)/sum(total_fee )*100 材料费占比
,sum(check_fee)   检验检查费
,sum(check_fee)/sum(total_fee )*100 检验检查费占比
,sum(medical_fee)   医务性收入
,sum(medical_fee)/sum(total_fee )*100 医务性收入占比
,sum(total_fee )  总费用
,sum(medical_fee) /cast(count(distinct jzlsh) as decimal(18,2))  人均医务性收入
,sum(settlecost) 预计结算费用
,sum(profitloss)/nullif(cast(sum(medical_fee) as decimal(18,2)),0)*100 亏损占医务性收入比例
,convert(decimal(18,2),sum(act_ipt_days )/convert(decimal(18,2), count(distinct jzlsh)) ) 平均住院日

INTO #temp_profitlossTOP10
from t_drg_result a ,t_drg_result_relation b  ,t_setlinfo c
where a.id=b.drgresult_id and a.jzlsh=c.mdtrt_sn    and a.drgcode is  not null   
 
and  settletime>=
case 
when isnull(@settleTimeStart,'') <> ''
then @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
settletime<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end
and insurtype<>'999'
and isdrg=1
and c.hi_type<>'999'
group by 
a.drgcode
,a.drgname 
,a.basepoint 
order by  sum(profitloss)

SELECT 
CASE WHEN GROUPING(DRG组编码) = 1 THEN '合计' ELSE DRG组编码 END DRG组编码,
DRG组名称,
sum(例均费用) 例均费用,
sum(基准点数) 基准点数,
sum(病案数) 病案数,
sum(预计结算点数) 预计结算点数,
sum(预计盈亏) 预计盈亏,
sum(药费) 药费,
sum(药费占比) 药费占比,
sum(材料费) 材料费,
sum(材料费占比) 材料费占比,
sum(检验检查费) 检验检查费,
sum(检验检查费占比) 检验检查费占比,
sum(医务性收入) 医务性收入,
sum(医务性收入占比) 医务性收入占比,
sum(总费用) 总费用,
sum(人均医务性收入) 人均医务性收入,
sum(预计结算费用) 预计结算费用,
sum(亏损占医务性收入比例) 亏损占医务性收入比例,
sum(平均住院日) 平均住院日
FROM #temp_profitlossTOP10
group by DRG组编码 ,DRG组名称 with rollup
having grouping(DRG组编码)=grouping(DRG组名称)
ORDER BY CASE WHEN GROUPING(DRG组编码) = 1 THEN 1 ELSE 0 END, sum(预计盈亏)