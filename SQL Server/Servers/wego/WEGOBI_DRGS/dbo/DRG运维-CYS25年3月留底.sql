---查询入组版本 2023年不是1.1的数据
select * from t_setlinfo a left join t_drg_result_relation b on a.mdtrt_sn=b.uid left join t_drg_result c on b.drgresult_id=c.id where brjsrq>='2023-01-01' and brjsrq<'2024-01-01' and ver!='1.1'

/*重新入组 2023年数据
2023285082-6-001
078519,67-001
1109720,1-002
1112658,1-001*/


--查询上报错误信息
select a.mdtrt_sn as 流水号,a.brjsrq 结算时间,c.err_msg 错误信息
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid=c.id 
where infocode=-1 
and a.brjsrq>='2025-03-01' and a.brjsrq<'2025-04-17'
and err_msg not like '%省平台%'


/*
2025年4月2日
250009724-1-004
2023223037-1-001
1004276-7-001

错误：医疗保障基金结算清单患者手术操作信息【JSQD_OPERATION_INFO】数据校验错误：pkid：MDTRT_SN：2023223037-1-001；FIXMEDINS_CODE：000001；OPRN_OPRT_CODE：00.6500x008；OPRN_OPRT_DATE：TueMar2500：00：00CST2025；oprn_oprt_type：1；checkResult：OPER_DR_CODE_STD：必填项校验错误；OPER_DR_NAME：必填项校验错误；；
*/


/*
2025年4月3日 08点
2023223037-1-001	2025-03-30 10:04:28.0000000	错误：医疗保障基金结算清单患者手术操作信息【JSQD_OPERATION_INFO】数据校验错误：pkid：MDTRT_SN：2023223037-1-001；FIXMEDINS_CODE：000001；OPRN_OPRT_CODE：00.6500x008；OPRN_OPRT_DATE：TueMar2500：00：00CST2025；oprn_oprt_type：1；checkResult：OPER_DR_CODE_STD：必填项校验错误；OPER_DR_NAME：必填项校验错误；；
651709-13-001	2025-03-29 14:19:32.0000000	错误：医疗保障基金结算清单患者手术操作信息【JSQD_OPERATION_INFO】数据校验错误：pkid：MDTRT_SN：651709-13-001；FIXMEDINS_CODE：000001；OPRN_OPRT_CODE：92.2800；OPRN_OPRT_DATE：ThuMar2715：05：46CST2025；oprn_oprt_type：1；checkResult：ANST_DR_CODE_STD：必填项校验错误；；
077779-7-001	2025-03-17 11:15:40.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)  ；ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M) 
240069097-1-001	2025-03-28 15:10:17.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 
1049059-1-002	2025-03-20 15:30:56.0000000	错误： ###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline ###Theerroroccurredwhilesettingparameters ###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(?????????????????????????????) ###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated  ；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated ；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated 


2023223037-1-001	2025-03-30 10:04:28.0000000	错误：医疗保障基金结算清单患者手术操作信息【JSQD_OPERATION_INFO】数据校验错误：pkid：MDTRT_SN：2023223037-1-001；FIXMEDINS_CODE：000001；OPRN_OPRT_CODE：00.6500x008；OPRN_OPRT_DATE：TueMar2500：00：00CST2025；oprn_oprt_type：1；checkResult：OPER_DR_CODE_STD：必填项校验错误；OPER_DR_NAME：必填项校验错误；；
651709-13-001	2025-03-29 14:19:32.0000000	错误：医疗保障基金结算清单患者手术操作信息【JSQD_OPERATION_INFO】数据校验错误：pkid：MDTRT_SN：651709-13-001；FIXMEDINS_CODE：000001；OPRN_OPRT_CODE：92.2800；OPRN_OPRT_DATE：ThuMar2715：05：46CST2025；oprn_oprt_type：1；checkResult：ANST_DR_CODE_STD：必填项校验错误；；
*/

--手术重复处理--时间重复
---4
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

/*
1070947-5-001
250026649-1-002
*/

select  *  from  t_operation_code where insur_code='77.6904'
--63822	77.6900x061	经皮椎骨病损冷冻消融术	77.6904	椎骨病损切除术	NULL
--手术名称由  经皮椎骨病损冷冻消融术  改为 椎骨病损切除术
--433997-6-001


---查询手术时间唯一
SELECT mdtrt_sn,oprn_oprt_code,oprn_oprt_name,
	oprn_oprt_date,
    ROW_NUMBER() OVER ( PARTITION BY oprn_oprt_name, oprn_oprt_date	ORDER BY oprn_oprt_date) AS rn1,
    oprn_oprt_begn_date,
	ROW_NUMBER() OVER ( PARTITION BY oprn_oprt_name, oprn_oprt_begn_date ORDER BY oprn_oprt_begn_date) AS rn2,
	oprn_oprt_end_date,
	ROW_NUMBER() OVER ( PARTITION BY oprn_oprt_name, oprn_oprt_end_date  ORDER BY oprn_oprt_end_date) AS rn3,
	oper_dr_name, anst_dr_name
FROM t_setlinfo_oprninfo
WHERE mdtrt_sn = '250026649-1-002'
ORDER BY oprn_oprt_code, oprn_oprt_name, oprn_oprt_date;

--查询手术表和诊断表
declare @mdtrtsn varchar(255);
set @mdtrtsn='250026649-1-002';
select * from t_setlinfo_oprninfo
where mdtrt_sn=@mdtrtsn order by oprn_oprt_code,oprn_oprt_date;

select * from t_setlinfo_diseinfo
where mdtrt_sn=@mdtrtsn order by diag_code;

/*错误：
###Errorupdatingdatabase.Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated

###Theerrormayinvolvecom.dareway.opel.medical.tb.dao.JsqdOperationInfoMapper.insertSelective-Inline
###Theerroroccurredwhilesettingparameters
###SQL：insertintoMIDR.JSQD_OPERATION_INFO(IDCITY_CODEOPERATION_TIMEBITMDTRT_SNFIXMEDINS_CODE_STDFIXMEDINS_CODEOPRN_OPRT_TYPEOPRN_OPRT_NAMEOPRN_OPRT_CODEOPRN_OPRT_DATEANST_WAYOPER_DR_NAMEOPER_DR_CODEANST_DR_NAMEANST_DR_CODEMAIN_OPRN_FLAGVALI_FLAGJRSJXGSJGDBZVERSIONSYNC_FLAGYLZD1YLZD2OPRN_OPRT_BEGN_DATEOPRN_OPRT_END_DATEANST_BEGN_DATEANST_END_DATEOPER_DR_CODE_STDANST_DR_CODE_STD)values(???????????????????????????????)
###Cause：java.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated

；ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated
；nestedexceptionisjava.sql.SQLIntegrityConstraintViolationException：ORA-00001：uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated
*/

