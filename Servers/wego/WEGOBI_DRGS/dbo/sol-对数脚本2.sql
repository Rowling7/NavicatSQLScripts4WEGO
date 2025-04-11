declare @brjsrqstart varchar(10),@brjsrqend varchar(10),@brjsrqstart2 varchar(8),@brjsrqend2 varchar(8);
set @brjsrqstart='2024-07-01';
set @brjsrqend ='2024-08-01';
set @brjsrqstart2 = REPLACE(@brjsrqstart, '-', '');
set @brjsrqend2 = REPLACE(@brjsrqend, '-', '');

update t_setlinfo set isdrg=0 where brjsrq>= @brjsrqstart and brjsrq<@brjsrqend;

update t_setlinfo set isdrg=1 where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>=@brjsrqstart2 and datebill<@brjsrqend2 and medicalhosid=1 group by zylsh)

update t_setlinfo set hi_type='310' where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>=@brjsrqstart2 and datebill<@brjsrqend2 and medicalhosid=1 and insuranceid='310' group by zylsh)

update t_setlinfo set hi_type='390' where mdtrt_sn in (select zylsh from t_job_settlebillinglist where datebill>=@brjsrqstart2 and datebill<@brjsrqend2 and medicalhosid=1 and insuranceid='390' group by zylsh)

delete t_drg_result_relation where uid in (select mdtrt_sn from t_setlinfo a left join t_drg_result_relation b on a.mdtrt_sn=b.uid left join t_drg_result c on b.drgresult_id=c.id where a.hi_type <> c.insurtype)

SELECT * FROM t_setlinfo where brjsrq>= @brjsrqstart and brjsrq<@brjsrqend AND isdrg=1 and hi_type='390';

SELECT zylsh
  FROM [WEGOBI_DRGS].[dbo].[t_job_settlebillinglist] where datebill>=@brjsrqstart2 and datebill<@brjsrqend2 AND medicalhosid=1 and insuranceid='390' GROUP BY zylsh
