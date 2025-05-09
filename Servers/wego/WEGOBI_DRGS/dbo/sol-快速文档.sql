--老系统错误：住院流水号：11172401-001；医院编码：000001调用省平台查询本地就医信息失败，请检查报文入参是否准确！
--省内异地改定点医疗机构代码和参保地
select insuplc from t_setlinfo where hi_no like '%372423%'

--查看任务执行状态
select id,zylsh,createdtime from t_job_settlebillinglist order by createdtime desc
-- select * from  [WEGOBI_DRGS].[dbo].[t_job] where id= '362976B6-3F2D-182B-360B-3A0962538462'
-- update [WEGOBI_DRGS].[dbo].[t_job]   set  jobstatus = '1' where id= '362976B6-3F2D-182B-360B-3A0962538462'


---查询错误信息
select a.mdtrt_sn as 流水号,a.brjsrq 结算时间,c.err_msg 错误信息
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid=c.id 
where infocode=-1 
and a.brjsrq>='2025-04-01' and a.brjsrq<'2025-05-31'-- cast(getdate() as date)
and err_msg not like '%省平台%'

--重复手术的手术日期oprn_oprt_date中‘年月日时分秒’完全一致时，会上传失败校验不通过，
--上报失败错误信息为：违反唯一约束条件(JSQD_OPERATION_INFO)
/*
---<5
update t_setlinfo_oprninfo
set  oprn_oprt_date=dateadd(MINUTE,1,oprn_oprt_date)
where  id in (
	--<4
	select  id
	from  (
		---<3
		select   id,ROW_NUMBER() over(partition by mdtrt_sn,oprn_oprt_code,oprn_oprt_date   order by id) rn
		from(
			---<2
			select a.*
			from t_setlinfo_oprninfo a,
				(select mdtrt_sn,oprn_oprt_code,oprn_oprt_date,count(*) cont
					from  t_setlinfo_oprninfo
					group by mdtrt_sn,oprn_oprt_code,oprn_oprt_date
					having count(*)>1
				 ) b
			where a.mdtrt_sn=b.mdtrt_sn
					and a.oprn_oprt_code=b.oprn_oprt_code
					and a.oprn_oprt_date=b.oprn_oprt_date
					and a.mdtrt_sn in (
						---<1
						select mdtrt_sn
						from t_setlinfo a
						left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
						left join t_mihs_result c on b.resultid=c.id
						where c.infocode=-1
								and c.err_msg not like '%省平台%'
								And c.err_msg   like  '%JSQD_OPERATION_INFO%'
						---1>
						)
				---2>
				) a
			---3>
		) id
	where rn=1
	---4>
)
---5>
*/
/*
--1.初始化
UPDATE t_setlinfo
SET isdrg = 0
WHERE CONVERT(DATE, brjsrq, 23)
BETWEEN '2025-02-01' AND '2025-02-28';

--2.执行对数脚本
UPDATE a
SET a.isdrg = 1,
    a.hi_type = b.insuranceid
FROM t_setlinfo a,
(
    SELECT DISTINCT
           zylsh,
           insuranceid
    FROM t_job_settlebillinglist
    WHERE CONVERT(DATE, datebill, 23)
          BETWEEN '2025-02-01' AND '2025-02-28'
          AND medicalhosid = 1
) b
WHERE a.mdtrt_sn = b.zylsh;

--3.核对结果
SELECT DISTINCT
       mdtrt_sn
FROM t_setlinfo a
WHERE CONVERT(DATE, brjsrq, 23)
      BETWEEN '2025-02-01' AND '2025-02-28'
      AND isdrg = 1;
*/