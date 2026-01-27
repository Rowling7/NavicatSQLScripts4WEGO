select ROW_NUMBER() OVER (ORDER BY CONVERT(VARCHAR(19), a.brjsrq, 120) deSC) AS 序号
     , a.mdtrt_sn   as 住院流水号
     , a.psn_name   as 患者姓名
     , a.CYKSMC as 出院科室
     , CONVERT(VARCHAR(19), a.brjsrq, 120)as 结算时间
		 , case when convert(varchar(max),c.err_msg) like '%诊断信息结点信息为空%' then '诊断信息为空'
			when convert(varchar(max),c.err_msg) like '%act_ipt_days%' then
			'入院时间:'+RIGHT(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('adm_time：', convert(varchar(max),c.err_msg)) + 9, 23), 4)
			+'-'+CASE SUBSTRING(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('adm_time：', convert(varchar(max),c.err_msg)) + 9, 23), 4, 3) 
			WHEN 'Jan' THEN '01' WHEN 'Feb' THEN '02' WHEN 'Mar' THEN '03'
			WHEN 'Apr' THEN '04' WHEN 'May' THEN '05' WHEN 'Jun' THEN '06'
			WHEN 'Jul' THEN '07' WHEN 'Aug' THEN '08' WHEN 'Sep' THEN '09'
			WHEN 'Oct' THEN '10' WHEN 'Nov' THEN '11' WHEN 'Dec' THEN '12'END
			+'-'+SUBSTRING(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('adm_time：', convert(varchar(max),c.err_msg)) + 9, 23), 7, 2)
			+' '+replace(SUBSTRING(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('adm_time：', convert(varchar(max),c.err_msg)) + 9, 23), 9, 8),'：',':')
			+', '+'出院时间:'+RIGHT(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('dscg_time：', convert(varchar(max),c.err_msg)) + 10, 23), 4)
			+'-'+CASE SUBSTRING(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('dscg_time：', convert(varchar(max),c.err_msg)) + 10, 23), 4, 3) 
			WHEN 'Jan' THEN '01' WHEN 'Feb' THEN '02' WHEN 'Mar' THEN '03'
			WHEN 'Apr' THEN '04' WHEN 'May' THEN '05' WHEN 'Jun' THEN '06'
			WHEN 'Jul' THEN '07' WHEN 'Aug' THEN '08' WHEN 'Sep' THEN '09'
			WHEN 'Oct' THEN '10' WHEN 'Nov' THEN '11' WHEN 'Dec' THEN '12'END
			+'-'+SUBSTRING(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('dscg_time：', convert(varchar(max),c.err_msg)) + 10, 23), 7, 2)
			+' '+replace(SUBSTRING(SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('dscg_time：', convert(varchar(max),c.err_msg)) + 10, 23), 9, 8),'：',':')+', '+'实际住院天数:'+SUBSTRING(convert(varchar(max),c.err_msg), CHARINDEX('实际住院天数act_ipt_days', convert(varchar(max),c.err_msg))+ 19, CHARINDEX('不准确，应为', convert(varchar(max),c.err_msg))-CHARINDEX('实际住院天数act_ipt_days', convert(varchar(max),c.err_msg))-19)+', '+'应为:'+SUBSTRING(convert(varchar(max),c.err_msg),  CHARINDEX('不准确，应为', convert(varchar(max),c.err_msg))+6,11)
		 WHEN convert(varchar(max),c.err_msg) LIKE ('%uniqueconstraint(MIDR.OUT_UNIQUE_M)violated%') or convert(varchar(max),c.err_msg) LIKE('%uniqueconstraint(JSQDYD.OUT_UNIQUE_M)violated%') THEN '诊断信息重复'	
		 WHEN convert(varchar(max),c.err_msg) LIKE ('%OPER_DR_NAME：必填项校验错误%') or  convert(varchar(max),c.err_msg) LIKE ('%checkResult：OPER_DR_CODE：必填项校验错误；OPER_DR_CODE_STD：必填项校验错误%') THEN '手术医师未填写或填写错误'	
		 when convert(varchar(max),c.err_msg) LIKE ('%诊断信息中缺少主诊段数据%') then '诊断信息中缺少主诊段数据'
		 when convert(varchar(max),c.err_msg) LIKE ('%NATY：字典项校验错误%') then '民族信息填写错误或未填写'
		 when convert(varchar(max),c.err_msg) LIKE ('%ORA-00001：违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)%') or convert(varchar(max),c.err_msg) LIKE ('%uniqueconstraint(MIDR.OPERATION_UNIQUE_M)violated%')then '手术时间重复'
		 when convert(varchar(max),c.err_msg) LIKE ('%checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误%') then '票据代码/票据号码 未填写或填写错误'
		 when convert(varchar(max),c.err_msg) LIKE ('%checkResult：ANST_DR_CODE_STD：必填项校验错误%') then '麻醉医师标准代码 未填写或填写错误'
		 when convert(varchar(max),c.err_msg) LIKE ('%DIAG_CODE：必填项校验错误误%') or convert(varchar(max),c.err_msg) LIKE ('%DIAG_NAME：必填项校验错误%')  then '诊断名称/诊断名称 未填写或填写错误'
		 when convert(varchar(max),c.err_msg) LIKE ('%格式不正确，应上传D或N开头的13位的国标码%') or convert(varchar(max),c.err_msg) LIKE ('%主诊医师代码chfpdr_code_std：-格式不正确，应上传D或N开头的13位的国标码%')  then '主诊医师代码格式不正确，应上传D或N开头的13位的国标码'
		else convert(varchar(max),c.err_msg) -- '请联系DRG工程师'
		end as 错误信息
from t_setlinfo a
left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
left join t_mihs_result c on b.resultid = c.id
where c.infocode = -1
  /*and a.brjsrq >= DATEADD(MONTH, -1, DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE)))
  and a.brjsrq < CAST(GETDATE() AS DATE)*/
	and a.brjsrq >='2025-01-01'
	and a.brjsrq <'3025-01-01'
  and err_msg not like '%省平台%'
ORDER BY 结算时间 desc