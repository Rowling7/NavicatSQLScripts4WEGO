declare @settleTimeStart date;
declare @settleTimeEnd date;
DECLARE  @cyksbm varchar(32);
DECLARE @drgcode varchar(32);
set @settleTimeStart='2025-04-01';
set @settleTimeEnd ='2025-04-30';
set @cyksbm = '%%';
set @drgcode= '%%';
select  
case when cyksbm is null  then '不详' else cyksbm end  出院科室
,case when a.drgcode   is null  then   '未入组'  else  a.drgcode end   组编码
,case when  a.drgname   is null  then   '未入组'  else   a.drgname end  组名
,count(*)  例数
,a.rw 权重
,cast(sum(settlepoint) as decimal(18,2))  总点数
,sum(total_fee )  总费用
,sum(settleCost) 预计结算
,sum(profitloss)  预计盈亏,
sum(d.[west_drug_fee]) 西药费,
case 
when sum(d.[west_drug_fee])>0
then 
sum(d.[west_drug_fee])/sum(totalcost)*100
else 
0
end  西药费占比,
case
 when sum(d.[west_drug_fee])>0
then sum(d.[west_drug_fee])/count(0)
else
0
end  人均西药费,
sum(d.chinese_drug_fee) 中成药费,
case 
when sum(d.chinese_drug_fee)>0
then 
sum(d.chinese_drug_fee)/sum(totalcost)*100
else 
0
end  中成药占比,
case
 when sum(d.chinese_drug_fee)>0
then sum(d.chinese_drug_fee)/count(0)
else
0
end  人均中成药,
sum(d.chinese_slice_drug_fee) 中药饮片费,
case 
when sum(d.chinese_slice_drug_fee) >0
then 
sum(d.chinese_slice_drug_fee) /sum(totalcost)*100
else 
0
end  中药饮片费占比,
case
 when sum(d.chinese_slice_drug_fee) >0
then sum(d.chinese_slice_drug_fee) /count(0)
else
0
end  人均中药饮片费,
sum(d.consumable_fee) 耗材费,
case 
when sum(d.consumable_fee) >0
then 
sum(d.consumable_fee) /sum(totalcost)*100
else 
0
end  耗材费占比,
case
 when sum(d.consumable_fee) >0
then sum(d.consumable_fee) /count(0)
else
0
end  人均耗材费,
sum(d.check_fee) 检查化验费,
case 
when sum(d.check_fee) >0
then 
sum(d.check_fee) /sum(totalcost)*100
else 
0
end  检查化验费占比,
case
 when sum(d.check_fee) >0
then sum(d.check_fee) /count(0)
else
0
end  人均检查化验费,
sum(d.medical_fee) 其他费,
case 
when sum(d.medical_fee) >0
then 
sum(d.medical_fee) /sum(totalcost)*100
else 
0
end   其他费占比,
case
 when sum(d.medical_fee) >0
then sum(d.medical_fee) /count(0)
else
0
end  人均其他费,
convert(decimal(18,2),sum(act_ipt_days )/convert(decimal(18,2), count(distinct jzlsh)) ) 平均住院日
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
end
and cyksbm like @cyksbm
and drgcode like @drgcode
and isdrg=1
and d.hi_type<>'999'
 group by case when cyksbm is null  then '不详' else cyksbm end 
,case when a.drgcode   is null  then   '未入组'  else  a.drgcode end    
,case when  a.drgname   is null  then   '未入组'  else   a.drgname end     ,a.rw
with rollup
having grouping(case when  a.drgname   is null  then   '未入组'  else   a.drgname end)=grouping(case when a.drgcode   is null  then   '未入组'  else  a.drgcode end) 
	and grouping(case when  a.drgname   is null  then   '未入组'  else   a.drgname end)=grouping(a.rw)
order by case when cyksbm is null  then '不详' else cyksbm end desc,case when a.drgcode   is null  then   '未入组'  else  a.drgcode end
