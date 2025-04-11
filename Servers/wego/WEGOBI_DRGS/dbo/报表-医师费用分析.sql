declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';
---医师费用分析
select  
cyksbm 出院科室,chfpdr_name 主诊医师
,CASE hi_type WHEN '310' THEN '职工' WHEN '390' THEN '居民' ELSE '其他' END 医保类型
,case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end 本地异地
,count(*)  例数
,sum(total_fee )  总费用
,sum(settleCost) 预计结算
,sum(profitloss)  预计盈亏,
sum(totalcost)/count(0) 平均费用,
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
,convert(decimal(18,2),sum(act_ipt_days )/convert(decimal(18,2), count(distinct jzlsh)) ) 平均住院日
--,grouping(cyksbm,chfpdr_name,hi_type) isTotal
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
/*and 
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
and cyksbm like @cyksbm
and chfpdr_name like @chfpdr_name
and hi_type like @hi_type*/
and isdrg=1
and d.hi_type<>'999'
--and case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end like @bdyd
group by CASE hi_type WHEN '310' THEN '职工' WHEN '390' THEN '居民' ELSE '其他' END,case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end,cyksbm,chfpdr_name with rollup
having grouping(cyksbm)=GROUPING(chfpdr_name) and grouping(CASE hi_type WHEN '310' THEN '职工' WHEN '390' THEN '居民' ELSE '其他' END)=GROUPING(case when datalength(cast(insuplc as varchar(255)))=6 then '本地' else '省内异地' end)
order by cyksbm desc

