DECLARE @settleTimeStart datetime;
DECLARE @settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd='2024-11-30' ;


select  count(*)  例数,
count(distinct a.drgcode) DRG组数,
count(distinct case when a.drgcode is  not null  and  a.isqy <>1  then a.jzlsh end)入组成功,
cast(count(distinct case when a.drgcode is  not null  and  a.isqy <>1  then a.jzlsh end) /cast(count(*) as decimal(18,4))  as decimal(18,4))*100 入组成功占比,
count(distinct case when a.drgcode is  null then a.jzlsh end)未入组成功,
cast(count(distinct case when a.drgcode is  null then a.jzlsh end) /cast(count(*) as decimal(18,4))  as decimal(18,4))*100 未入组成功占比

				
from t_drg_result a ,t_drg_result_relation b ,t_setlinfo d 
where a.id=b.drgresult_id 
			and a.jzlsh=d.mdtrt_sn  
			and brjsrq>=case when isnull(@settleTimeStart,'') <> ''then @settleTimeStart else dateadd(month,datediff(month,0,getdate()-1)-1,0)end
			and brjsrq<case when isnull(@settleTimeEnd,'') <> ''then DATEADD(day,1,@settleTimeEnd)else DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))end
			and isdrg=1

/*
SELECT distinct a.insurtype,v.dmmc,count(*)
from t_drg_result a ,t_drg_result_relation b ,t_setlinfo d ,drgs_explain..v_drgs_fieldcont v
where a.id=b.drgresult_id 
			and a.jzlsh=d.mdtrt_sn  
			and brjsrq>=case when isnull(@settleTimeStart,'') <> ''then @settleTimeStart else dateadd(month,datediff(month,0,getdate()-1)-1,0)end
			and brjsrq<case when isnull(@settleTimeEnd,'') <> ''then DATEADD(day,1,@settleTimeEnd)else DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))end
			and isdrg=1
			and a.insurtype=v.dmz and v.tablename='t_drg_result'
GROUP BY a.insurtype,v.dmmc

*/


SELECT a.errormsg,count(distinct case when a.drgcode is  null then a.jzlsh end) erecount,cast(count(distinct case when a.drgcode is  null then a.jzlsh end)as decimal(18,4))/22*100
from t_drg_result a ,t_drg_result_relation b ,t_setlinfo d 
where a.id=b.drgresult_id 
			and a.jzlsh=d.mdtrt_sn  
			and brjsrq>=case when isnull(@settleTimeStart,'') <> ''then @settleTimeStart else dateadd(month,datediff(month,0,getdate()-1)-1,0)end
			and brjsrq<case when isnull(@settleTimeEnd,'') <> ''then DATEADD(day,1,@settleTimeEnd)else DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))end
			and isdrg=1  
			and a.drgcode is null
GROUP BY a.errormsg
