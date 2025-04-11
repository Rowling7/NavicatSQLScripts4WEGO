SELECT 
	MDTRT_SN '就诊流水号'
	,BRJSRQ '病人结算日期'
	,PSN_NAME '患者姓名'
	,GD_STATUS '审核状态'
FROM HIP.V_SETLINFO
WHERE MDTRT_SN  IN('240127728-1-001','250024423-1-001','2022892110-1-002')
			AND TO_CHAR(BRJSRQ,'YYYY-MM-DD') BETWEEN '2025-03-01' AND '2025-01-31'