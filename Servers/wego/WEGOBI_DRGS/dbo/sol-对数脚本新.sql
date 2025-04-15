DECLARE @startTime datetime,@endTime datetime ;
set @startTime ='2025-03-01';
set @endTime ='2025-03-31';
select  @startTime,@endTime

--1.初始化
update t_setlinfo   set  isdrg=0   where  convert(date,brjsrq,23)  between  @startTime  and  @endTime;

--2.执行对数脚本
update  a  set  a.isdrg=1 ,a.hi_type=b.insuranceid 
from   t_setlinfo  a  
	,( select distinct zylsh,insuranceid from  t_job_settlebillinglist    
			where convert(date,datebill,23) between  @startTime  and @endTime    and 
			medicalhosid =1  
 	  )  b 
 where a.mdtrt_sn=b.zylsh;

--3.核对结果
select  distinct  mdtrt_sn from   t_setlinfo  a 
where  convert(date,brjsrq,23)  between  @startTime  and  @endTime and isdrg =1 ;
