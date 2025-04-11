
USE [master]
RESTORE DATABASE [WEGOBI_DRGS] FROM  DISK = N'D:\00145740\8.工具\1.DRG\数据库\240313模糊化数据\20240313_1.bak' WITH   REPLACE,  
MOVE N'WEGOBI_DRGS' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS.mdf',  
MOVE N'WEGOBI_DRGS_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS_log.ldf',  NOUNLOAD,  STATS = 5
GO


SELECT [dept_name] AS [dept_name科室],
[dept_code] AS [dept_code科室编码],
SUM([rwtotal]) AS [rwtotalRW全额],
SUM([outhospitalnumber]) AS [outhospitalnumber出院人数] 
FROM  [wegobi_drgs]..[t_setlinfo_summary_cmi_department] WITH (NOLOCK) 
WHERE (([dateofmonth] >= '2025-02-01 00:00:00') AND ([dateofmonth] < '2025-03-01 00:00:00')) 
GROUP BY [dept_code],[dept_name] 
ORDER BY  COUNT(0) DESC

SELECT * 
FROM WEGOBI_DRGS_TEST..t_setlinfo_summary_cmi_department 
ORDER BY dept_code,DEPT_NAME DESC;
 
select dept_code 科室代码, dept_name 科室名称,sum(rwtotal) RW,sum(outhospitalnumber) 出院总人数
from WEGOBI_DRGS_TEST..t_setlinfo_summary_cmi_department WITH (NOLOCK)
group by dept_code,dept_name;


select dept_code 科室代码, dept_name 科室名称,cmi CMI, rwtotal RW,outhospitalnumber 出院总人数
from WEGOBI_DRGS_TEST..t_setlinfo_summary_cmi_department WITH (NOLOCK)
WHERE CMI >0.7 
ORDER BY CMI,dept_code DESC;

SELECT DISTINCT dateofmonth FROM WEGOBI_DRGS_TEST..t_setlinfo_summary_cmi_department 
ORDER BY dateofmonth;


DECLARE  @P1 datetime,@P2 datetime;
SET @P1='2022-02-01 00:00:00';
SET @P2='2022-09-01 00:00:00';

SELECT [med_chrgitm] AS [med_chrgitm],SUM([amt]) AS [amt],SUM([clab_amt]) AS [clab_amt],SUM([fulamt_ownpay_amt]) AS [fulamt_ownpay_amt],SUM([oth_amt]) AS [oth_amt],SUM([claa_sumfee]) AS [claa_sumfee] 
FROM  [wegobi_drgs]..[t_setlinfo_summary_fee] WITH (NOLOCK)  WHERE (([dateofmonth] >= @P1) AND ([dateofmonth] < @P2))  
GROUP BY [med_chrgitm];

SELECT DISTINCT cyksbm FROM [wegobi_drgs]..[t_setlinfo_summary_fee] WITH (NOLOCK);


