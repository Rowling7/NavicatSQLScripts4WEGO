--1.初始化
update t_setlinfo   set  isdrg=0   where  convert(date,brjsrq,23)  between  '2025-02-01'  and  '2025-02-28';

--2.执行对数脚本
update  a  set  a.isdrg=1 ,a.hi_type=b.insuranceid 
from   t_setlinfo  a  
	,( select distinct zylsh,insuranceid from  t_job_settlebillinglist    
			where convert(date,datebill,23) between  '2025-02-01'  and '2025-02-28'  and 
			medicalhosid =1  
 	  )  b 
 where a.mdtrt_sn=b.zylsh;

--3.核对结果
select  distinct  mdtrt_sn from   t_setlinfo  a 
where  convert(date,brjsrq,23)  between  '2025-02-01' and '2025-02-28' and isdrg =1 ;
