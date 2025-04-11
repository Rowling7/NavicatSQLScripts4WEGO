----行政科室分析
declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';
select  
case when cyksbm is null  then '不详' else cyksbm end  出院科室
,count(*)  例数
,sum(total_fee )  总费用
,sum(settleCost) 预计结算
,sum(profitloss)  预计盈亏,
sum(totalcost)/count(0) 平均费用
,convert(decimal(18,2),sum(act_ipt_days )/convert(decimal(18,2), count(distinct jzlsh)) ) 平均住院日,
sum(d.[west_drug_fee]) 西药费,
sum(d.[west_drug_fee])/sum(totalcost)*100 西药费占比,
sum(d.[west_drug_fee])/count(0) 人均西药费,
sum(d.chinese_drug_fee) 中成药费,
sum(d.chinese_drug_fee)/sum(totalcost)*100 中成药费占比,
sum(d.chinese_drug_fee)/count(0) 人均中成药费,
sum(d.chinese_slice_drug_fee) 中药饮片费,
sum(d.chinese_slice_drug_fee)/sum(totalcost)*100 中药饮片费占比,
sum(d.chinese_slice_drug_fee)/count(0) 人均中药饮片费,
sum(d.consumable_fee) 耗材费,
sum(d.consumable_fee)/sum(totalcost)*100 耗材费占比,
sum(d.consumable_fee)/count(0) 人均耗材费,
sum(d.check_fee) 检查化验费,
sum(d.check_fee)/sum(totalcost)*100检查化验费占比,
sum(d.check_fee)/count(0) 人均检查化验费,
sum(d.medical_fee) 其他费,
sum(d.medical_fee)/sum(totalcost)*100 其他费占比,
sum(d.medical_fee)/count(0) 人均其他费
  from t_drg_result a
  ,t_drg_result_relation b 
  ,t_setlinfo d
   where a.id=b.drgresult_id and a.jzlsh=d.mdtrt_sn  and
settletime>=
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
end/*
and 
len(fixmedins_code)>
case @fixmedins_code
when '%2%'
then 6
else
0
end
and 
len(fixmedins_code)<
case @fixmedins_code
when '%1%'
then 10
else
100
end
and d.hi_type like @hi_type
*/
and isdrg=1
group by case when cyksbm is null  then '不详' else cyksbm end 
with rollup

order by case when cyksbm is null  then '不详' else cyksbm end desc

