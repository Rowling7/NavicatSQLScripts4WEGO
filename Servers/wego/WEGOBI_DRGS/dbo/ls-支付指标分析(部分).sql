declare @startdate datetime,@enddate datetime;
set @startdate='2025-03-01 00:00:00';
set @enddate='2025-04-01 00:00:00';

select
cast(count(distinct case when dr.drgcode is not null and  dr.isqy <>1  then dr.jzlsh end) /cast(nullif(count(0),0) as decimal(18,4)) as decimal(18,4)) * 100 as groupingrate,
cast(count(0)/cast(nullif(count(distinct si.certno),0) as decimal(18,4)) as decimal(18,4)) * 100 as inpatientvisitspercapita,
count(distinct dr.drgcode) as drgcount,
cast(sum(dr.rw) /cast(nullif(count(0),0) as decimal(18,6)) as decimal(18,6)) as cmi,
cast(sum(dr.totalcost)/cast(nullif(count(0),0) as decimal(18,2)) as decimal(18,2)) as averageinpatientcostpervisit,
cast(sum(dr.totalcost) /cast(nullif(sum(dr.rw),0) as decimal(18,2)) as decimal(18,2)) as averageinpatientcostperweight,
count(0) as annualtotalinpatientvisits, sum(dr.totalcost) as annualtotalinpatientmedicalcosts,
cast(sum(si.act_ipt_days)/cast(nullif(count(0),0) as decimal(18,2)) as decimal(18,2)) as averagelengthofstay,
cast(sum(si.total_fee-si.psn_selfpay-si.psn_ownpay)/cast(nullif(sum(si.total_fee),0) as decimal(18,4)) as decimal(18,4))*100 as fundpaymentratio,
cast(sum(si.total_fee)/cast(nullif(count(0),0) as decimal(18,2)) as decimal(18,2)) as avgcostperadmission ,
cast(sum(si.psn_selfpay + si.psn_ownpay)/cast(nullif(sum(si.total_fee),0) as decimal(18,4)) as decimal(18,4)) * 100 as outofcatalogratio,
datepart(year, si.brjsrq) as year,  datepart(month, si.brjsrq) as month
from t_setlinfo si
inner join t_drg_result_relation drr  on si.mdtrt_sn = drr.uid
inner join t_drg_result dr  on drr.drgresult_id = dr.id
where si.isdrg = 1  and si.brjsrq >= @startdate  and si.brjsrq < @enddate  group by datepart(year, si.brjsrq),datepart(month, si.brjsrq)
order by datepart(year, si.brjsrq) asc,datepart(month, si.brjsrq) asc