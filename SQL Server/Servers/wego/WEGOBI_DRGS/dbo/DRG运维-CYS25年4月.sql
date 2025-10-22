--查看任务执行状态 ，先执行update ,后改掉“医保结算数据汇总计划循环任务”为通用后执行，执行完毕后改回cron并启动
select id,zylsh,createdtime from t_job_settlebillinglist order by createdtime desc
-- update [WEGOBI_DRGS].[dbo].[t_job]   set  jobstatus = '1' where id= '362976B6-3F2D-182B-360B-3A0962538462'

---查询错误信息
select a.mdtrt_sn as 流水号,a.brjsrq 结算时间,c.err_msg 错误信息
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid=c.id 
where infocode=-1 
and a.brjsrq>='2025-03-01' and a.brjsrq<'2025-04-30'-- cast(getdate() as date)
and err_msg not like '%省平台%'
-- select cast(getdate() as date)

/* 2025年4月27日 14点49分

2023431602-1-001	2025-04-21 08:31:12.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2023431602-1-001；FIXMEDINS_CODE：000001；checkResult：MEDINS_FILL_DEPT：必填项校验错误；；
250025120-1-001	2025-04-23 13:07:25.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
917506-4-001	2025-04-22 10:28:35.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) 
2023546161-1-001	2025-04-03 16:30:36.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2023546161-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
*/



/* 2025年4月24日 13点11分 
230050091-1-002	2025-04-18 08:36:47.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 

2023431602-1-001	2025-04-21 08:31:12.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2023431602-1-001；FIXMEDINS_CODE：000001；checkResult：MEDINS_FILL_DEPT：必填项校验错误；；

*/

/*2025年4月23日 08点03分 手术时间重复

250036306-1-001	2025-04-19 10:37:44.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
2023805742-1-002	2025-04-20 08:41:55.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
2023546161-1-001	2025-04-03 16:30:36.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2023546161-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
*/

/*
2025年4月14日 08点31分
250032353-1-001	2025-04-11 10:42:30.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelectiveYD-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoJSQDYD.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(JSQDYD.OPERATION_UNIQUE_M)violated */


/*2022892110-1-002	2025-03-27 08:33:27.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2022892110-1-002；FIXMEDINS_CODE：000001；checkResult：MEDINS_FILL_DEPT：必填项校验错误；；
250024423-1-001	2025-03-29 08:07:00.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：250024423-1-001；FIXMEDINS_CODE：000001；checkResult：MEDINS_FILL_DEPT：必填项校验错误；；*/


/*

java.lang.RuntimeException: 机构医保系统在调用[山大地纬]-[新数据共享交换](服务地址:http://10.78.40.25:9099/collect/v1/insmedi)的服务时返回异常：org.json.JSONException: A JSONObject text must begin with '{' at character 1 of ??????4101??????è?·?±??????°???300??????è?·??????????????????è°???¨???????????????
2023546161-1-001	2025-04-03 16:30:36.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2023546161-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
968117-4-001	2025-04-02 08:13:15.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：968117-4-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
250026370-1-001	2025-04-04 14:55:57.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(JSQDYD.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelectiveYD-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoJSQDYD.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(JSQDYD.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(JSQDYD.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(JSQDYD.OPERATION_UNIQUE_M) 
2022950325-1-001	2025-04-07 09:14:40.0000000	错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：2022950325-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；
1076408-3-002	2025-04-07 17:37:22.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) 


*/

select mdtrt_sn,bill_code,bill_no from t_setlinfo where mdtrt_sn='968117-4-001'
select count(*)from t_setlinfo where mdtrt_sn='968117-4-001'
--update t_setlinfo set bill_code='1001112246 ',bill_no='1001112246 ' where  mdtrt_sn='968117-4-001'
/*2022950325-1-001
2023546161-1-001视图无数据*/
--2025年4月17日14点26分
--update t_setlinfo set bill_code='1001121209',bill_no='1001121209' where  mdtrt_sn='2022950325-1-001'
--update t_setlinfo set bill_code='1001119311',bill_no='1001119311' where  mdtrt_sn='2023609970-2-001'
/*错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：240127728-1-001；FIXMEDINS_CODE：000001；checkResult：MEDINS_FILL_DEPT：必填项校验错误；；*/ 
--his中的数据：乳腺医学中心外科组

/*495163-6-001 错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) */

select  MEDINS_FILL_DEPT from t_setlinfo where mdtrt_sn in('2022892110-1-002')
--泌尿外科和平病区

select count(*), MEDINS_FILL_DEPT
from t_setlinfo 
group by MEDINS_FILL_DEPT
having MEDINS_FILL_DEPT='泌尿外科和平病区'


-- EXEC updateOprtDate ;

--手术时间重复
/*
update t_setlinfo_oprninfo 
set  oprn_oprt_date=dateadd(MINUTE,1,oprn_oprt_date)  
where  id in (
	---3
	select  id
	from  (
		---2
		select   id,ROW_NUMBER() over(partition by mdtrt_sn,oprn_oprt_code,oprn_oprt_date   order by id) rn  
		from(
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
						 ---1
						select mdtrt_sn
						from t_setlinfo a  
						left join t_mihs_result_relation b on a.mdtrt_sn = b.uid 
						left join t_mihs_result c on b.resultid=c.id
						where c.infocode=-1 
								and c.err_msg not like '%省平台%' 
								And c.err_msg   like  '%JSQD_OPERATION_INFO%' 
						)---1
				) a---2
		) id---3
	where rn=1
)---4
*/


/*对数
 --初始化
update t_setlinfo   set  isdrg=0   where  convert(date,brjsrq,23)  between  '2025-03-01'  and  '2025-03-31';

 --执行对数脚本
update  a  set  a.isdrg=1 ,a.hi_type=b.insuranceid 
from   t_setlinfo  a  
	,( select distinct zylsh,insuranceid from  t_job_settlebillinglist    
			where convert(date,datebill,23) between  '2025-03-01'  and  '2025-03-31'    and 
			medicalhosid =1  
 	  )  b 
 where a.mdtrt_sn=b.zylsh      ;

 --核对结果
  select  distinct  mdtrt_sn from   t_setlinfo  a 
 where  convert(date,brjsrq,23)  between  '2025-03-01'  and  '2025-03-31' and isdrg =1 ;
 */




select a.mdtrt_sn,a.psn_name,c.infocode
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid=c.id 
WHERE mdtrt_sn IN ('449356-3-002','240152569-1-003','2023263112-2-002','709178-3-002','230100780-1-002',
'2023233577-2-002','240085726-1-002','250019955-1-003','2023781465-1-001','2022871318-1-002',
'230148441-1-002','2023748754-1-002','230070967-2-001','2022880019-1-002','922544-4-003',
'713362-2-006','2023331028-4-004','230104398-2-001','2023478365-1-001')
order by a.mdtrt_sn

select * 
from t_job_settlebillinglist
WHERE zylsh IN ('449356-3-002','240152569-1-003','2023263112-2-002','709178-3-002','230100780-1-002',
'2023233577-2-002','240085726-1-002','250019955-1-003','2023781465-1-001','2022871318-1-002',
'230148441-1-002','2023748754-1-002','230070967-2-001','2022880019-1-002','922544-4-003',
'713362-2-006','2023331028-4-004','230104398-2-001','2023478365-1-001')


