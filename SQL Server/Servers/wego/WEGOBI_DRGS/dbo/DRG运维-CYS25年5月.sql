--老系统错误：住院流水号：11172401-001；医院编码：000001调用省平台查询本地就医信息失败，请检查报文入参是否准确！
--省内异地改定点医疗机构代码和参保地
select insuplc from t_setlinfo where hi_no like '%370099%'

--查看任务执行状态
select id,zylsh,createdtime from t_job_settlebillinglist order by createdtime desc
-- select * from  [WEGOBI_DRGS].[dbo].[t_job] where id= '362976B6-3F2D-182B-360B-3A0962538462'
-- update [WEGOBI_DRGS].[dbo].[t_job]   set  jobstatus = '1' where id= '362976B6-3F2D-182B-360B-3A0962538462'
/*2025年5月28日 14点29分
自动取数任务错误，重启任务。并手动执行一次取数任务*/

--重复手术的手术日期oprn_oprt_date中‘年月日时分秒’完全一致时，会上传失败校验不通过，
--上报失败错误信息为：违反唯一约束条件(JSQD_OPERATION_INFO)
-- exec updateOprtDate;


---查询错误信息
select a.mdtrt_sn as 流水号,a.brjsrq 结算时间,c.err_msg 错误信息
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid=c.id 
where c.infocode=-1 
and a.brjsrq>='2025-06-01' and a.brjsrq<'2025-06-30'-- cast(getdate() as date)
and err_msg not like '%省平台%'

/*修改匹配成功但是校验不通过的数据3条。*/

/*2025年5月30日 11点08分 
流水号	结算时间	错误信息
2023461649-2-001	2025-05-28 08:31:51.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) 
*/

/*2025年5月28日 14点46分  2025年5月30日 10点25分
流水号	结算时间	错误信息
1116507-3-001	2025-05-26 10:35:40.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：1116507-3-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
2023867194-6-008*/

/*2025年5月28日 08点34分 
流水号	结算时间	错误信息
083609-5-001	2025-05-24 09:39:27.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated */

/* 2025年5月22日 13点45分
流水号	结算时间	错误信息
998365-8-001	2025-05-19 10:04:23.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
1061122-8-002	2025-05-19 15:33:09.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) 
230076688-1-002	2025-05-20 12:09:48.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：230076688-1-002；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
*/

/*2025年5月21日 17点05分
流水号	结算时间	错误信息
998365-8-001	2025-05-19 10:04:23.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated */
/*2025年5月21日 14点39分
202501 医保 6960;202501 DRG	6924
202502	YB	5760;202502 DRG	5760
202503	YB	7650;202503	DRG	7650
*/

/* 2025年5月21日 13点18分
081632-27-001 有 未入组和同类修订有两条 两个问题报错
*/

/*2025年5月19日 13点34分
流水号	结算时间	错误信息
2023394767-3-001	2025-05-15 13:31:57.0000000	错误：医疗保障基金结算清单患者手术操作信息【JSQD_OPERATION_INFO】数据校验错误：pkid：MDTRT_SN：2023394767-3-001；FIXMEDINS_CODE：000001；OPRN_OPRT_CODE：99.2503；OPRN_OPRT_DATE：ThuMay0810：38：38CST2025；oprn_oprt_type：1；checkResult：ANST_DR_CODE_STD：必填项校验错误；；

*/


/* 2025年5月19日 07点49分
流水号	结算时间	错误信息
1024193-4-001	2025-05-16 08:28:04.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
436567-6-001	2025-05-16 13:33:54.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) */

/*2025年5月16日 13点29分 
流水号	结算时间	错误信息
1080400-2-001	2025-05-14 16:08:57.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) 
2023106301-2-001	2025-05-14 09:50:37.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
*/
/* 2025年5月12日 09点30分
2023546161-1-001	2025-04-03 16:30:36.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2023546161-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
999177-4-001	2025-05-04 11:23:42.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：999177-4-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
250035549-1-001	2025-05-02 09:13:37.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：250035549-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
939390-3-001	2025-04-24 08:28:48.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) 
*/


/*
--1.初始化
UPDATE t_setlinfo
SET isdrg = 0
WHERE CONVERT(DATE, brjsrq, 23)
BETWEEN '2025-04-01' AND '2025-04-30';

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
          BETWEEN '2025-04-01' AND '2025-04-30'
          AND medicalhosid = 1
) b
WHERE a.mdtrt_sn = b.zylsh;

--3.核对结果
SELECT DISTINCT
       mdtrt_sn
FROM t_setlinfo a
WHERE CONVERT(DATE, brjsrq, 23)
      BETWEEN '2025-04-01' AND '2025-04-30'
      AND isdrg = 1;
*/


select  mdtrt_sn,bill_code,bill_no from t_setlinfo where  mdtrt_sn='999177-4-001'
-- update t_setlinfo set bill_code='1001126069',bill_no='1001126069' where  mdtrt_sn='999177-4-001'
select  mdtrt_sn,bill_code,bill_no from t_setlinfo where  mdtrt_sn='250035549-1-001'
-- update t_setlinfo set bill_code='1001125623',bill_no='1001125623' where  mdtrt_sn='250035549-1-001'




/*
173350	2022974098-7-001	diseinfo	[{"diag_type":"1","diag_code":"K92.210","diag_name":"消化道出血","adm_cond_type":"1","maindiag_flag":"1","tcm_dise_flag":"0","Sort":1},{"diag_type":"2","diag_code":"K74.617+I98.3*","diag_name":"肝硬化伴食管胃底静脉曲张破裂出血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":2},{"diag_type":"2","diag_code":"D64.903","diag_name":"重度贫血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":3},{"diag_type":"2","diag_code":"K74.602","diag_name":"乙型肝炎后肝硬化失代偿期","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":4},{"diag_type":"2","diag_code":"E77.801","diag_name":"低蛋白血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":5},{"diag_type":"2","diag_code":"K72.900x003+G94.3*","diag_name":"肝性脑病","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":6},{"diag_type":"2","diag_code":"K65.902","diag_name":"自发性腹膜炎","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":7},{"diag_type":"2","diag_code":"E87.600","diag_name":"低钾血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":8}]
 1 Setlinfo_DiseinfoDto	diseinfo	[{"diag_type":"1","diag_code":"K92.210","diag_name":"消化道出血","adm_cond_type":"1","maindiag_flag":"1","tcm_dise_flag":"0","Sort":1},{"diag_type":"2","diag_code":"K74.617+I98.3*","diag_name":"肝硬化伴食管胃底静脉曲张破裂出血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":2},{"diag_type":"2","diag_code":"D64.903","diag_name":"重度贫血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":3},{"diag_type":"2","diag_code":"K74.602","diag_name":"乙型肝炎后肝硬化失代偿期","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":4},{"diag_type":"2","diag_code":"E77.801","diag_name":"低蛋白血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":5},{"diag_type":"2","diag_code":"R18.x00","diag_name":"腹水","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":6},{"diag_type":"2","diag_code":"D73.200","diag_name":"慢性充血性脾大","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":7},{"diag_type":"2","diag_code":"K72.900x003+G94.3*","diag_name":"肝性脑病","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":8},{"diag_type":"2","diag_code":"K65.902","diag_name":"自发性腹膜炎","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":9},{"diag_type":"2","diag_code":"E87.600","diag_name":"低钾血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":14},{"diag_type":"2","diag_code":"R63.801","diag_name":"营养风险","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":15}]	2025-05-12 16:07:21.4833333	DDEEFAB1-5E56-1C53-D217-3A066BD86FA8	2025-05-12 16:07:21.4833333	DDEEFAB1-5E56-1C53-D217-3A066BD86FA8
173351	2022974098-7-001	diseinfo	[{"diag_type":"1","diag_code":"K92.210","diag_name":"消化道出血","adm_cond_type":"1","maindiag_flag":"1","tcm_dise_flag":"0","Sort":1},{"diag_type":"2","diag_code":"K74.617+I98.3*","diag_name":"肝硬化伴食管胃底静脉曲张破裂出血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":2},{"diag_type":"2","diag_code":"D64.903","diag_name":"重度贫血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":3},{"diag_type":"2","diag_code":"K74.602","diag_name":"乙型肝炎后肝硬化失代偿期","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":4},{"diag_type":"2","diag_code":"E77.801","diag_name":"低蛋白血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":5},{"diag_type":"2","diag_code":"K72.900x003+G94.3*","diag_name":"肝性脑病","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":6},{"diag_type":"2","diag_code":"K65.902","diag_name":"自发性腹膜炎","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":7},{"diag_type":"2","diag_code":"E87.600","diag_name":"低钾血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":8}]
 1 Setlinfo_DiseinfoDto	diseinfo	[{"diag_type":"1","diag_code":"K92.210","diag_name":"消化道出血","adm_cond_type":"1","maindiag_flag":"1","tcm_dise_flag":"0","Sort":1},{"diag_type":"2","diag_code":"K74.617+I98.3*","diag_name":"肝硬化伴食管胃底静脉曲张破裂出血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":2},{"diag_type":"2","diag_code":"D64.903","diag_name":"重度贫血","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":3},{"diag_type":"2","diag_code":"K74.602","diag_name":"乙型肝炎后肝硬化失代偿期","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":4},{"diag_type":"2","diag_code":"E77.801","diag_name":"低蛋白血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":5},{"diag_type":"2","diag_code":"R18.x00","diag_name":"腹水","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":6},{"diag_type":"2","diag_code":"D73.200","diag_name":"慢性充血性脾大","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":7},{"diag_type":"2","diag_code":"K72.900x003+G94.3*","diag_name":"肝性脑病","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":8},{"diag_type":"2","diag_code":"K65.902","diag_name":"自发性腹膜炎","adm_cond_type":"2","maindiag_flag":"0","tcm_dise_flag":"0","Sort":9},{"diag_type":"2","diag_code":"E87.600","diag_name":"低钾血症","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":14},{"diag_type":"2","diag_code":"R63.801","diag_name":"营养风险","adm_cond_type":"1","maindiag_flag":"0","tcm_dise_flag":"0","Sort":15}]	2025-05-12 16:07:21.4833333	DDEEFAB1-5E56-1C53-D217-3A066BD86FA8	2025-05-12 16:07:21.4833333	DDEEFAB1-5E56-1C53-D217-3A066BD86FA8
沈工，解决了，修改了一个修订记录的字段”是否有效“为0。不知道为啥同一份修订记录在revise中生成了两个除了ID以外其他数据一模一样的记录.*/