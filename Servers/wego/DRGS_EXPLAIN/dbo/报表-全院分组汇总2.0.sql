 declare @settleTimeStart DATE;
declare @settleTimeEnd date;
set @settleTimeStart='2024';
set @settleTimeEnd ='2025';
select  
case 
when a.drgcode is null
then '未入组'
else
a.drgcode  
end 组编码,
case 
when a.drgname is null
then '未入组'
else
a.drgname  
end 组名,
case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end 本地异地
,count(*)  例数
,a.rw 权重
,sum(settlepoint)  总点数,
sum(c.[west_drug_fee]) 西药费,
sum(c.[west_drug_fee])/sum(totalcost)*100 西药费占比,
sum(c.[west_drug_fee])/count(0) 人均西药费,
sum(c.chinese_drug_fee) 中成药费,
sum(c.chinese_drug_fee)/sum(totalcost)*100 中成药费占比,
sum(c.chinese_drug_fee)/count(0) 人均中成药费,
sum(c.chinese_slice_drug_fee) 中药饮片费,
sum(c.chinese_slice_drug_fee)/sum(totalcost)*100 中药饮片费占比,
sum(c.chinese_slice_drug_fee)/count(0) 人均中药饮片费,
sum(c.consumable_fee) 耗材费,
sum(c.consumable_fee)/sum(totalcost)*100 耗材费占比,
sum(c.consumable_fee)/count(0) 人均耗材费,
sum(c.check_fee) 检查化验费,
sum(c.check_fee)/sum(totalcost)*100检查化验费占比,
sum(c.check_fee)/count(0) 人均检查化验费,
sum(c.medical_fee) 其他费,
sum(c.medical_fee)/sum(totalcost)*100 其他费占比,
sum(c.medical_fee)/count(0) 人均其他费
,sum(total_fee )  总费用
,convert(decimal(18,2),sum(act_ipt_days )/convert(decimal(18,2), count(distinct jzlsh)) ) 平均住院日
,sum(settlecost)  预计结算金额
,sum(profitloss)  预计盈亏
  from t_drg_result a
  ,t_drg_result_relation b 
  ,t_setlinfo c
 
  where 
  a.id=b.drgresult_id   and a.jzlsh=c.mdtrt_sn
  and 
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
and (drgcode like @keyword or drgname like @keyword)
and hi_type like @hi_type and
(case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end)  like @bdyd
and isdrg=1
and c.hi_type<>'999'
 group by case 
when a.drgcode is null
then '未入组'
else
a.drgcode  
end  ,
case 
when a.drgname is null
then '未入组'
else
a.drgname  
end   ,a.rw,(case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end)


UNION
select
'总计'as '组编码'
,''as '组名'
,case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end 本地异地
,count(*)  例数
,sum(a.rw) 权重
,sum(settlepoint)  总点数,
sum(c.[west_drug_fee]) 西药费,
sum(c.[west_drug_fee])/sum(totalcost)*100 西药费占比,
sum(c.[west_drug_fee])/count(0) 人均西药费,
sum(c.chinese_drug_fee) 中成药费,
sum(c.chinese_drug_fee)/sum(totalcost)*100 中成药费占比,
sum(c.chinese_drug_fee)/count(0) 人均中成药费,
sum(c.chinese_slice_drug_fee) 中药饮片费,
sum(c.chinese_slice_drug_fee)/sum(totalcost)*100 中药饮片费占比,
sum(c.chinese_slice_drug_fee)/count(0) 人均中药饮片费,
sum(c.consumable_fee) 耗材费,
sum(c.consumable_fee)/sum(totalcost)*100 耗材费占比,
sum(c.consumable_fee)/count(0) 人均耗材费,
sum(c.check_fee) 检查化验费,
sum(c.check_fee)/sum(totalcost)*100检查化验费占比,
sum(c.check_fee)/count(0) 人均检查化验费,
sum(c.medical_fee) 其他费,
sum(c.medical_fee)/sum(totalcost)*100 其他费占比,
sum(c.medical_fee)/count(0) 人均其他费
,sum(total_fee )  总费用
,convert(decimal(18,2),sum(act_ipt_days )/convert(decimal(18,2), count(distinct jzlsh)) ) 平均住院日
,sum(settlecost)  预计结算金额
,sum(profitloss)  预计盈亏
  from t_drg_result a
  ,t_drg_result_relation b 
  ,t_setlinfo c
 
  where 
  a.id=b.drgresult_id   and a.jzlsh=c.mdtrt_sn
  and 
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
and (drgcode like @keyword or drgname like @keyword)
and hi_type like @hi_type and
(case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end)  like @bdyd
and isdrg=1
and c.hi_type<>'999'
group by (case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end) WITH ROLLUP
 
 order by case 
when a.drgcode is null
then '未入组'
else
a.drgcode  
end  ,
case 
when a.drgname is null
then '未入组'
else
a.drgname  
end   ,a.rw,(case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end) 
