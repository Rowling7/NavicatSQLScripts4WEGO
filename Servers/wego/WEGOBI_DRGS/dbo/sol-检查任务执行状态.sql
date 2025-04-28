-- 查看任务执行状态 ，先执行update ,后改掉“医保结算数据汇总计划循环任务”为通用后执行，执行完毕后改回cron并启动
select id,zylsh,createdtime from t_job_settlebillinglist order by createdtime desc
-- update [WEGOBI_DRGS].[dbo].[t_job]   set  jobstatus = '1' where id= '362976B6-3F2D-182B-360B-3A0962538462'
