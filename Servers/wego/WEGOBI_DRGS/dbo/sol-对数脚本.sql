--执行定时任务  医保结算数据计划循环任务

update t_setlinfo set isdrg=0 where brjsrq>='2024-07-01' and brjsrq<'2024-08-01';

update t_setlinfo set isdrg=1 where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>='20240701' and datebill<'20240801' and medicalhosid=1 group by zylsh)

update t_setlinfo set hi_type='310' where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>='20240701' and datebill<'20240801' and medicalhosid=1 and insuranceid='310' group by zylsh)

update t_setlinfo set hi_type='390' where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>='20240701' and datebill<'20240801' and medicalhosid=1 and insuranceid='390' group by zylsh)

delete t_drg_result_relation where uid in (select mdtrt_sn from t_setlinfo a left join t_drg_result_relation b on a.mdtrt_sn=b.uid left join t_drg_result c on b.drgresult_id=c.id where a.hi_type <> c.insurtype)

 
SELECT * FROM t_setlinfo where brjsrq>='2024-07-01' and brjsrq<'2024-08-01' AND isdrg=1 and hi_type='390';

SELECT zylsh
  FROM [WEGOBI_DRGS].[dbo].[t_job_settlebillinglist] where datebill>='20240701' and datebill<'20240801' AND medicalhosid=1 and insuranceid='390' GROUP BY zylsh
