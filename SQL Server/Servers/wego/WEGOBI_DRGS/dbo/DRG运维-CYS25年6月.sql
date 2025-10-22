--查看任务执行状态
select id,zylsh,createdtime from t_job_settlebillinglist order by createdtime desc
-- select * from  [WEGOBI_DRGS].[dbo].[t_job] where id= '362976B6-3F2D-182B-360B-3A0962538462'
-- update [WEGOBI_DRGS].[dbo].[t_job]   set  jobstatus = '1' where id= '362976B6-3F2D-182B-360B-3A0962538462'

--重复手术的手术日期oprn_oprt_date中‘年月日时分秒’完全一致时，会上传失败校验不通过，
-- exec updateOprtDate;

---查询错误信息
select a.mdtrt_sn as 流水号,a.brjsrq 结算时间,c.err_msg 错误信息
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid=c.id 
where c.infocode=-1 
and a.brjsrq>='2025-06-01' and a.brjsrq<'2025-06-30'-- cast(getdate() as date)
and err_msg not like '%省平台%'


/* --对数
--1.初始化
UPDATE t_setlinfo
SET isdrg = 0
WHERE CONVERT(DATE, brjsrq, 23)
BETWEEN '2025-05-01' AND '2025-05-31';

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
          BETWEEN '2025-05-01' AND '2025-05-31'
          AND medicalhosid = 1
) b
WHERE a.mdtrt_sn = b.zylsh;

--3.核对结果
SELECT DISTINCT
       mdtrt_sn
FROM t_setlinfo a
WHERE CONVERT(DATE, brjsrq, 23)
      BETWEEN '2025-05-01' AND '2025-05-31'
      AND isdrg = 1;
*/




---查询错误信息-----错误结果

--2025年6月10日 14点34分
/*流水号	结算时间	错误信息
240143742-1-001	2025-06-01 19:12:16.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：240143742-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
250030620-1-001	2025-06-05 10:19:05.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
*/

--2025年6月16日 08点13分 
/*流水号	结算时间	错误信息
1111611-6-002	2025-06-02 11:48:49.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
250003715-4-001	2025-06-10 09:34:54.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
451381-15-001	2025-06-10 10:50:43.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
1064573-3-001	2025-06-11 08:36:04.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated */