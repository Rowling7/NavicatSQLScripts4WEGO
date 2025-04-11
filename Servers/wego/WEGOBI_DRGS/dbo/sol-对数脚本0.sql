--执行定时任务  医保结算数据计划循环任务

update t_setlinfo set isdrg=0 where brjsrq>='2024-07-01' and brjsrq<'2024-08-01' /*病人结算日期*/;

update t_setlinfo set isdrg=1 where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>='20240701' and datebill<'20240801' and medicalhosid=1 /*是否结算*/group by zylsh)

update t_setlinfo set hi_type='310'/*医保类型为职工*/ where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>='20210701' and datebill<'20240801' /*结算时间*/and medicalhosid=1 and insuranceid='310' group by zylsh)

update t_setlinfo set hi_type='390' where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>='20210701' and datebill<'20240801' and medicalhosid=1 /*是否结算*/and insuranceid='390' /*医保类型*/group by zylsh)

delete t_drg_result_relation /*入组信息关联*/where uid in (select mdtrt_sn from t_setlinfo a left join t_drg_result_relation b on a.mdtrt_sn=b.uid left join t_drg_result c on b.drgresult_id=c.id where a.hi_type <> c.insurtype)

 
SELECT * FROM t_setlinfo /*结算清单患者基本信息表*/where brjsrq>='2021-07-01' and brjsrq<'2024-08-01' AND isdrg=1 and hi_type='390'/*医保类型为城乡*/;

SELECT zylsh
  FROM [WEGOBI_DRGS].[dbo].[t_job_settlebillinglist] where datebill>='20210701' and datebill<'20240801' AND medicalhosid=1 and insuranceid='390' GROUP BY zylsh /*就诊流水号*/


 --初始化
 update t_setlinfo   set  isdrg=0   where  convert(date,brjsrq,23)  between  '2024-12-01'  and  '2024-12-31';

 --执行对数脚本
update  a  set  a.isdrg=1 ,a.hi_type=b.insuranceid /*医保类型*/
from   t_setlinfo  a  
	,( select distinct zylsh,insuranceid from  t_job_settlebillinglist    
			where convert(date,datebill,23) between '2024-12-01'  and '2024-12-31'    and 
			medicalhosid =1  
 	  )  b 
 where a.mdtrt_sn=b.zylsh      ;