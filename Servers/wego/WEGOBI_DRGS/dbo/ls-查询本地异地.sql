SELECT
	DISTINCT CAST(INSUPLC AS VARCHAR(255))本地异地代码
	,CASE WHEN DATALENGTH(CAST(INSUPLC AS VARCHAR(255)))=6 THEN '本地'
		WHEN INSUPLC IS NULL THEN 'NULL'
		ELSE '省内异地' END [本地异地]
FROM T_SETLINFO
WHERE ISDRG =1
AND BRJSRQ BETWEEN '2025-03-01' AND '2025-03-31'