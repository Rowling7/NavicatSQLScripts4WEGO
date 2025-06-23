select   case  when a.cyksbm is  null  then '不明确' else a.CYKSbm end  出院科室,
c.zylsh 住院流水号,
a.medcasno 病案号,
a.psn_name 患者姓名,
a.total_fee 总费用,
c.datebill 结算时间,
  b.inf_time   首次上报时间
 from  (select  distinct  zylsh, convert(date,datebill,23)  datebill from  t_job_settlebillinglist  where   convert(date,datebill,23) between '2025-01-01' and '2025-03-31'   and medicalhosid=1
)  c
 left outer join t_setlinfo a  on  a.mdtrt_sn=c.zylsh
 left join ( select   uid  ,min(inf_time) inf_time  from t_mihs_result  where inf_time>='2024-01-01' and   infocode=0  group by   uid ) b  on  c.zylsh=b.uid
where    convert(date,a.brjsrq,23) between '2025-01-01' and '2025-03-31'     and  isdrg=1 
and isnull(b.inf_time,convert(date,getdate(),23))<dateadd(day,10,c.datebill)
order by case  when a.cyksbm is  null  then '不明确' else a.CYKSbm end, c.datebill