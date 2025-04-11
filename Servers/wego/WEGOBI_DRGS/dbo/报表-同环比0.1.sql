declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2025-03-01';
set @settleTimeEnd ='2025-03-31';
drop table if exists #temp1;
drop table if exists #temp2;
drop table if exists #temp3;




select * into  #temp1 from (select '时值' 期,
count(0) 出院人次,
count(
case 
when c.profitloss>=0
then 1
end
) 预计盈利人次,
count(
case 
when c.profitloss<0
then 1
end
) 预计亏损人次,
convert(decimal(18,2),sum(rw)/count(*)) CMI指数,
count(distinct drgcode) DRG数量,
convert(decimal(18,2),sum(profitloss))  预计盈亏,
convert(decimal(18,2),sum(profitloss)/nullif(count(0),0)) 平均盈亏,
convert(decimal(18,2),sum(act_ipt_days )/nullif(convert(decimal(18,2), count(distinct jzlsh)),0) ) 平均住院天数,
convert(decimal(18,2),sum(totalcost)) 总费用,
convert(decimal(18,2),sum(totalcost)/nullif(count(0),0)) 平均费用,
convert(decimal(18,2),sum(a.west_drug_fee)) 西药费,
convert(decimal(18,2),sum(a.west_drug_fee)/nullif(count(0),0)) 平均西药费,
convert(decimal(18,2),sum(a.west_drug_fee)/nullif(sum(totalcost)*100,0)) 西药费占比,
convert(decimal(18,2),sum(a.chinese_drug_fee)) 中成药费,
convert(decimal(18,2),sum(a.chinese_drug_fee)/nullif(count(0),0)) 平均中成药费,
convert(decimal(18,2),sum(a.chinese_drug_fee)/nullif(sum(totalcost)*100,0)) 中成药费占比,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)) 中药饮片费,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)/nullif(count(0),0)) 平均中药饮片费,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)/nullif(sum(totalcost)*100,0)) 中药饮片费占比,
convert(decimal(18,2),sum(a.drug_fee)) 药费,
convert(decimal(18,2),sum(a.drug_fee)/nullif(count(0),0)) 平均药费,
convert(decimal(18,2),sum(a.drug_fee)/nullif(sum(totalcost)*100,0)) 药费占比,
convert(decimal(18,2),sum(a.consumable_fee)) 材料费,
convert(decimal(18,2),sum(a.consumable_fee)/nullif(count(0),0)) 平均材料费,
convert(decimal(18,2),sum(a.consumable_fee)/nullif(sum(totalcost)*100,0)) 材料费占比,
convert(decimal(18,2),sum(a.check_fee)) 检查化验费,
convert(decimal(18,2),sum(a.check_fee)/nullif(count(0),0)) 平均检查化验费,
convert(decimal(18,2),sum(a.check_fee)/nullif(sum(totalcost)*100,0)) 检查化验费占比,
convert(decimal(18,2),sum(a.medical_fee)) 医务性收入,
convert(decimal(18,2),sum(a.medical_fee)/nullif(count(0),0)) 平均医务性收入,
convert(decimal(18,2),sum(a.medical_fee)/nullif(sum(totalcost)*100,0)) 医务性收入占比
from t_setlinfo a
left join t_drg_result_relation b on a.mdtrt_sn=b.uid
left join t_drg_result c on b.drgresult_id=c.id
where 
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

and a.isdrg=1 and a.hi_type<>'999'
and a.cyksbm like '%%') as aa


select * into #temp2 from (select '上一期' 期,
count(0) 出院人次,
count(
case 
when c.profitloss>=0
then 1
end
) 预计盈利人次,
count(
case 
when c.profitloss<0
then 1
end
) 预计亏损人次,
convert(decimal(18,2),sum(rw)/count(*)) CMI指数,
count(distinct drgcode) DRG数量,
convert(decimal(18,2),sum(profitloss))  预计盈亏,
convert(decimal(18,2),sum(profitloss)/nullif(count(0),0)) 平均盈亏,
convert(decimal(18,2),sum(act_ipt_days )/nullif(convert(decimal(18,2), count(distinct jzlsh)),0) ) 平均住院天数,
convert(decimal(18,2),sum(totalcost)) 总费用,
convert(decimal(18,2),sum(totalcost)/nullif(count(0),0)) 平均费用,
convert(decimal(18,2),sum(a.west_drug_fee)) 西药费,
convert(decimal(18,2),sum(a.west_drug_fee)/nullif(count(0),0)) 平均西药费,
convert(decimal(18,2),sum(a.west_drug_fee)/nullif(sum(totalcost)*100,0)) 西药费占比,
convert(decimal(18,2),sum(a.chinese_drug_fee)) 中成药费,
convert(decimal(18,2),sum(a.chinese_drug_fee)/nullif(count(0),0)) 平均中成药费,
convert(decimal(18,2),sum(a.chinese_drug_fee)/nullif(sum(totalcost)*100,0)) 中成药费占比,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)) 中药饮片费,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)/nullif(count(0),0)) 平均中药饮片费,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)/nullif(sum(totalcost)*100,0)) 中药饮片费占比,
convert(decimal(18,2),sum(a.drug_fee)) 药费,
convert(decimal(18,2),sum(a.drug_fee)/nullif(count(0),0)) 平均药费,
convert(decimal(18,2),sum(a.drug_fee)/nullif(sum(totalcost)*100,0)) 药费占比,
convert(decimal(18,2),sum(a.consumable_fee)) 材料费,
convert(decimal(18,2),sum(a.consumable_fee)/nullif(count(0),0)) 平均材料费,
convert(decimal(18,2),sum(a.consumable_fee)/nullif(sum(totalcost)*100,0)) 材料费占比,
convert(decimal(18,2),sum(a.check_fee)) 检查化验费,
convert(decimal(18,2),sum(a.check_fee)/nullif(count(0),0)) 平均检查化验费,
convert(decimal(18,2),sum(a.check_fee)/nullif(sum(totalcost)*100,0)) 检查化验费占比,
convert(decimal(18,2),sum(a.medical_fee)) 医务性收入,
convert(decimal(18,2),sum(a.medical_fee)/nullif(count(0),0)) 平均医务性收入,
convert(decimal(18,2),sum(a.medical_fee)/nullif(sum(totalcost)*100,0)) 医务性收入占比
from t_setlinfo a
left join t_drg_result_relation b on a.mdtrt_sn=b.uid
left join t_drg_result c on b.drgresult_id=c.id
where 
brjsrq>=DATEADD(mm,-DATEDIFF(m, case 
when isnull(@settleTimeStart,'') <> ''
then @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end, case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end) ,case 
when isnull(@settleTimeStart,'') <> ''
then @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end) and brjsrq<DATEADD(mm,-DATEDIFF(m, case 
when isnull(@settleTimeStart,'') <> ''
then @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end, case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end) ,case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end)
and a.isdrg=1 and a.hi_type<>'999'
and a.cyksbm like '%%') as ab

select * into #temp3 from (select '去年同期' 期,
count(0) 出院人次,
count(
case 
when c.profitloss>=0
then 1
end
) 预计盈利人次,
count(
case 
when c.profitloss<0
then 1
end
) 预计亏损人次,
convert(decimal(18,2),sum(rw)/count(*)) CMI指数,
count(distinct drgcode) DRG数量,
convert(decimal(18,2),sum(profitloss))  预计盈亏,
convert(decimal(18,2),sum(profitloss)/nullif(count(0),0)) 平均盈亏,
convert(decimal(18,2),sum(act_ipt_days )/nullif(convert(decimal(18,2), count(distinct jzlsh)),0) ) 平均住院天数,
convert(decimal(18,2),sum(totalcost)) 总费用,
convert(decimal(18,2),sum(totalcost)/nullif(count(0),0)) 平均费用,
convert(decimal(18,2),sum(a.west_drug_fee)) 西药费,
convert(decimal(18,2),sum(a.west_drug_fee)/nullif(count(0),0)) 平均西药费,
convert(decimal(18,2),sum(a.west_drug_fee)/nullif(sum(totalcost)*100,0)) 西药费占比,
convert(decimal(18,2),sum(a.chinese_drug_fee)) 中成药费,
convert(decimal(18,2),sum(a.chinese_drug_fee)/nullif(count(0),0)) 平均中成药费,
convert(decimal(18,2),sum(a.chinese_drug_fee)/nullif(sum(totalcost)*100,0)) 中成药费占比,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)) 中药饮片费,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)/nullif(count(0),0)) 平均中药饮片费,
convert(decimal(18,2),sum(a.chinese_slice_drug_fee)/nullif(sum(totalcost)*100,0)) 中药饮片费占比,
convert(decimal(18,2),sum(a.drug_fee)) 药费,
convert(decimal(18,2),sum(a.drug_fee)/nullif(count(0),0)) 平均药费,
convert(decimal(18,2),sum(a.drug_fee)/nullif(sum(totalcost)*100,0)) 药费占比,
convert(decimal(18,2),sum(a.consumable_fee)) 材料费,
convert(decimal(18,2),sum(a.consumable_fee)/nullif(count(0),0)) 平均材料费,
convert(decimal(18,2),sum(a.consumable_fee)/nullif(sum(totalcost)*100,0)) 材料费占比,
convert(decimal(18,2),sum(a.check_fee)) 检查化验费,
convert(decimal(18,2),sum(a.check_fee)/nullif(count(0),0)) 平均检查化验费,
convert(decimal(18,2),sum(a.check_fee)/nullif(sum(totalcost)*100,0)) 检查化验费占比,
convert(decimal(18,2),sum(a.medical_fee)) 医务性收入,
convert(decimal(18,2),sum(a.medical_fee)/nullif(count(0),0)) 平均医务性收入,
convert(decimal(18,2),sum(a.medical_fee)/nullif(sum(totalcost)*100,0)) 医务性收入占比
from t_setlinfo a
left join t_drg_result_relation b on a.mdtrt_sn=b.uid
left join t_drg_result c on b.drgresult_id=c.id
where 
brjsrq>=DATEADD(yy,-1,case 
when isnull(@settleTimeStart,'') <> ''
then @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end) and brjsrq<DATEADD(yy,-1,case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end)
and a.isdrg=1 and a.hi_type<>'999'
and a.cyksbm like '%%') as ac

select * from #temp1
union all
select * from #temp2
union all
select * from #temp3
union all

select 
'环比' 期,
isnull(convert(decimal(18,2),(aa.出院人次-ab.出院人次)/nullif(convert(decimal(18,2),ab.出院人次),0)*100),0) 出院人次,
isnull(convert(decimal(18,2),(aa.预计盈利人次-ab.预计盈利人次)/nullif(convert(decimal(18,2),ab.预计盈利人次),0)*100),0) 预计盈利人次,
isnull(convert(decimal(18,2),(aa.预计亏损人次-ab.预计亏损人次)/nullif(convert(decimal(18,2),ab.预计亏损人次),0)*100),0) 预计亏损人次,
isnull(convert(decimal(18,2),(aa.CMI指数-ab.CMI指数)/nullif(convert(decimal(18,2),ab.CMI指数),0)*100),0) CMI指数,
isnull(convert(decimal(18,2),(aa.DRG数量-ab.DRG数量)/nullif(convert(decimal(18,2),ab.DRG数量),0)*100),0) DRG数量,
isnull(convert(decimal(18,2),(aa.预计盈亏-ab.预计盈亏)/nullif(convert(decimal(18,2),ab.预计盈亏),0)*100),0) 预计盈亏,
isnull(convert(decimal(18,2),(aa.平均盈亏-ab.平均盈亏)/nullif(convert(decimal(18,2),ab.平均盈亏),0)*100),0) 平均盈亏,
isnull(convert(decimal(18,2),(aa.平均住院天数-ab.平均住院天数)/nullif(convert(decimal(18,2),ab.平均住院天数),0)*100),0) 平均住院天数,
isnull(convert(decimal(18,2),(aa.总费用-ab.总费用)/nullif(convert(decimal(18,2),ab.总费用),0)*100),0) 总费用,
isnull(convert(decimal(18,2),(aa.平均费用-ab.平均费用)/nullif(convert(decimal(18,2),ab.平均费用),0)*100),0) 平均费用,
isnull(convert(decimal(18,2),(aa.西药费-ab.西药费)/nullif(convert(decimal(18,2),ab.西药费),0)*100),0) 西药费,
isnull(convert(decimal(18,2),(aa.平均西药费-ab.平均西药费)/nullif(convert(decimal(18,2),ab.平均西药费),0)*100),0) 平均西药费,
isnull(convert(decimal(18,2),(aa.西药费占比-ab.西药费占比)/nullif(convert(decimal(18,2),ab.西药费占比),0)*100) ,0)西药费占比,
isnull(convert(decimal(18,2),(aa.中成药费-ab.中成药费)/nullif(convert(decimal(18,2),ab.中成药费),0)*100),0) 中成药费,
isnull(convert(decimal(18,2),(aa.平均中成药费-ab.平均中成药费)/nullif(convert(decimal(18,2),ab.平均中成药费),0)*100),0) 平均中成药费,
isnull(convert(decimal(18,2),(aa.中成药费占比-ab.中成药费占比)/nullif(convert(decimal(18,2),ab.中成药费占比),0)*100),0) 中成药费占比,
isnull(convert(decimal(18,2),(aa.中药饮片费-ab.中药饮片费)/nullif(convert(decimal(18,2),ab.中药饮片费),0)*100) ,0)中药饮片费,
isnull(convert(decimal(18,2),(aa.平均中药饮片费-ab.平均中药饮片费)/nullif(convert(decimal(18,2),ab.平均中药饮片费),0)*100),0) 平均中药饮片费,
isnull(convert(decimal(18,2),(aa.中药饮片费占比-ab.中药饮片费占比)/nullif(convert(decimal(18,2),ab.中药饮片费占比),0)*100),0) 中药饮片费占比,
isnull(convert(decimal(18,2),(aa.药费-ab.药费)/nullif(convert(decimal(18,2),ab.药费),0)*100),0) 药费,
isnull(convert(decimal(18,2),(aa.平均药费-ab.平均药费)/nullif(convert(decimal(18,2),ab.平均药费),0)*100),0) 平均药费,
isnull(convert(decimal(18,2),(aa.药费占比-ab.药费占比)/nullif(convert(decimal(18,2),ab.药费占比),0)*100),0) 药费占比,
isnull(convert(decimal(18,2),(aa.材料费-ab.材料费)/nullif(convert(decimal(18,2),ab.材料费),0)*100),0) 材料费,
isnull(convert(decimal(18,2),(aa.平均材料费-ab.平均材料费)/nullif(convert(decimal(18,2),ab.平均材料费),0)*100),0) 平均材料费,
isnull(convert(decimal(18,2),(aa.材料费占比-ab.材料费占比)/nullif(convert(decimal(18,2),ab.材料费占比),0)*100),0) 材料费占比,
isnull(convert(decimal(18,2),(aa.检查化验费-ab.检查化验费)/nullif(convert(decimal(18,2),ab.检查化验费),0)*100),0) 检查化验费,
isnull(convert(decimal(18,2),(aa.平均检查化验费-ab.平均检查化验费)/nullif(convert(decimal(18,2),ab.平均检查化验费),0)*100),0) 平均检查化验费,
isnull(convert(decimal(18,2),(aa.检查化验费占比-ab.检查化验费占比)/nullif(convert(decimal(18,2),ab.检查化验费占比),0)*100),0) 检查化验费占比,
isnull(convert(decimal(18,2),(aa.医务性收入-ab.医务性收入)/nullif(convert(decimal(18,2),ab.医务性收入),0)*100) ,0)医务性收入,
isnull(convert(decimal(18,2),(aa.平均医务性收入-ab.平均医务性收入)/nullif(convert(decimal(18,2),ab.平均医务性收入),0)*100),0) 平均医务性收入,
isnull(convert(decimal(18,2),(aa.医务性收入占比-ab.医务性收入占比)/nullif(convert(decimal(18,2),ab.医务性收入占比),0)*100),0) 医务性收入占比
from #temp1 as aa ,#temp2 as ab
union all
select 
'同比' 期,
isnull(convert(decimal(18,2),(aa.出院人次-ab.出院人次)/nullif(convert(decimal(18,2),ab.出院人次),0)*100),0) 出院人次,
isnull(convert(decimal(18,2),(aa.预计盈利人次-ab.预计盈利人次)/nullif(convert(decimal(18,2),ab.预计盈利人次),0)*100),0) 预计盈利人次,
isnull(convert(decimal(18,2),(aa.预计亏损人次-ab.预计亏损人次)/nullif(convert(decimal(18,2),ab.预计亏损人次),0)*100),0) 预计亏损人次,
isnull(convert(decimal(18,2),(aa.CMI指数-ab.CMI指数)/nullif(convert(decimal(18,2),ab.CMI指数),0)*100),0) CMI指数,
isnull(convert(decimal(18,2),(aa.DRG数量-ab.DRG数量)/nullif(convert(decimal(18,2),ab.DRG数量),0)*100),0) DRG数量,
isnull(convert(decimal(18,2),(aa.预计盈亏-ab.预计盈亏)/nullif(convert(decimal(18,2),ab.预计盈亏),0)*100),0) 预计盈亏,
isnull(convert(decimal(18,2),(aa.平均盈亏-ab.平均盈亏)/nullif(convert(decimal(18,2),ab.平均盈亏),0)*100),0) 平均盈亏,
isnull(convert(decimal(18,2),(aa.平均住院天数-ab.平均住院天数)/nullif(convert(decimal(18,2),ab.平均住院天数),0)*100),0) 平均住院天数,
isnull(convert(decimal(18,2),(aa.总费用-ab.总费用)/nullif(convert(decimal(18,2),ab.总费用),0)*100),0) 总费用,
isnull(convert(decimal(18,2),(aa.平均费用-ab.平均费用)/nullif(convert(decimal(18,2),ab.平均费用),0)*100),0) 平均费用,
isnull(convert(decimal(18,2),(aa.西药费-ab.西药费)/nullif(convert(decimal(18,2),ab.西药费),0)*100),0) 西药费,
isnull(convert(decimal(18,2),(aa.平均西药费-ab.平均西药费)/nullif(convert(decimal(18,2),ab.平均西药费),0)*100) ,0)平均西药费,
isnull(convert(decimal(18,2),(aa.西药费占比-ab.西药费占比)/nullif(convert(decimal(18,2),ab.西药费占比),0)*100) ,0)西药费占比,
isnull(convert(decimal(18,2),(aa.中成药费-ab.中成药费)/nullif(convert(decimal(18,2),ab.中成药费),0)*100),0) 中成药费,
isnull(convert(decimal(18,2),(aa.平均中成药费-ab.平均中成药费)/nullif(convert(decimal(18,2),ab.平均中成药费),0)*100),0) 平均中成药费,
isnull(convert(decimal(18,2),(aa.中成药费占比-ab.中成药费占比)/nullif(convert(decimal(18,2),ab.中成药费占比),0)*100),0) 中成药费占比,
isnull(convert(decimal(18,2),(aa.中药饮片费-ab.中药饮片费)/nullif(convert(decimal(18,2),ab.中药饮片费),0)*100) ,0)中药饮片费,
isnull(convert(decimal(18,2),(aa.平均中药饮片费-ab.平均中药饮片费)/nullif(convert(decimal(18,2),ab.平均中药饮片费),0)*100),0) 平均中药饮片费,
isnull(convert(decimal(18,2),(aa.中药饮片费占比-ab.中药饮片费占比)/nullif(convert(decimal(18,2),ab.中药饮片费占比),0)*100),0) 中药饮片费占比,
isnull(convert(decimal(18,2),(aa.药费-ab.药费)/nullif(convert(decimal(18,2),ab.药费),0)*100),0) 药费,
isnull(convert(decimal(18,2),(aa.平均药费-ab.平均药费)/nullif(convert(decimal(18,2),ab.平均药费),0)*100),0) 平均药费,
isnull(convert(decimal(18,2),(aa.药费占比-ab.药费占比)/nullif(convert(decimal(18,2),ab.药费占比),0)*100),0) 药费占比,
isnull(convert(decimal(18,2),(aa.材料费-ab.材料费)/nullif(convert(decimal(18,2),ab.材料费),0)*100),0) 材料费,
isnull(convert(decimal(18,2),(aa.平均材料费-ab.平均材料费)/nullif(convert(decimal(18,2),ab.平均材料费),0)*100),0) 平均材料费,
isnull(convert(decimal(18,2),(aa.材料费占比-ab.材料费占比)/nullif(convert(decimal(18,2),ab.材料费占比),0)*100),0) 材料费占比,
isnull(convert(decimal(18,2),(aa.检查化验费-ab.检查化验费)/nullif(convert(decimal(18,2),ab.检查化验费),0)*100),0) 检查化验费,
isnull(convert(decimal(18,2),(aa.平均检查化验费-ab.平均检查化验费)/nullif(convert(decimal(18,2),ab.平均检查化验费),0)*100),0) 平均检查化验费,
isnull(convert(decimal(18,2),(aa.检查化验费占比-ab.检查化验费占比)/nullif(convert(decimal(18,2),ab.检查化验费占比),0)*100),0) 检查化验费占比,
isnull(convert(decimal(18,2),(aa.医务性收入-ab.医务性收入)/nullif(convert(decimal(18,2),ab.医务性收入),0)*100) ,0)医务性收入,
isnull(convert(decimal(18,2),(aa.平均医务性收入-ab.平均医务性收入)/nullif(convert(decimal(18,2),ab.平均医务性收入),0)*100),0) 平均医务性收入,
isnull(convert(decimal(18,2),(aa.医务性收入占比-ab.医务性收入占比)/nullif(convert(decimal(18,2),ab.医务性收入占比),0)*100),0) 医务性收入占比
from #temp1 as aa ,#temp3 as ab
