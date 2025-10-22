--查看任务执行状态
select id,zylsh,createdtime from t_job_settlebillinglist order by createdtime desc

-- 重复手术的手术日期oprn_oprt_date中‘年月日时分秒’完全一致时，会上传失败校验不通过
-- 如果有修订日志，那么这个办法不可行。需要手动修订或修改修订记录
-- exec updateOprtDate;

--对数
-- EXEC CheckDRGCHSCount '2025-07-01', '2025-07-31';

---查询错误信息
select a.mdtrt_sn as 流水号,a.brjsrq 结算时间,c.err_msg 错误信息
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid=c.id 
where c.infocode=-1 
and a.brjsrq>='2025-08-01' and a.brjsrq<'2025-08-31'-- cast(getdate() as date)
and err_msg not like '%省平台%'


/* --对数
--1.初始化
declare @startTime varchar(255), @endTime varchar(255);
set @startTime ='2025-08-01';
set @endTime='2025-08-31';

UPDATE t_setlinfo
SET isdrg = 0
WHERE CONVERT(DATE, brjsrq, 23)
BETWEEN @startTime AND @endTime;

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
          BETWEEN @startTime AND @endTime
          AND medicalhosid = 1
) b
WHERE a.mdtrt_sn = b.zylsh;

--3.核对结果
SELECT DISTINCT
       mdtrt_sn
FROM t_setlinfo a
WHERE CONVERT(DATE, brjsrq, 23)
      BETWEEN @startTime AND @endTime
      AND isdrg = 1;
*/




---查询错误信息-----错误结果

2023131445-2-001	2025-07-05 16:43:07.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2023131445-2-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
935105-8-001	2025-07-10 10:47:15.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：935105-8-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
250069897-1-001	2025-07-15 08:32:55.0000000	错误：
###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated

###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelectiveYD-Inline
###Theerroroccurredwhilesettingparameters
###SQL：insertintoJSQDYD.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????)
###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated

；ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated
；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated
