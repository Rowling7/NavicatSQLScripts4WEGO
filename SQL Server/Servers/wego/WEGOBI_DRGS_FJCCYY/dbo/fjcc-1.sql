INSERT INTO [dbo].[t_setlinfo_payinfo]
		( [id]
		, [mdtrt_sn]
		, [fund_pay_type]
		, [fund_payamt])
SELECT id
		 , CASE  WHEN CHARINDEX( '^', mdtrt_sn )> 0 THEN LEFT ( mdtrt_sn, CHARINDEX( '^', mdtrt_sn ) - 1 )  ELSE mdtrt_sn  END AS mdtrt_sn
     , fund_pay_type
     , fund_payamt
FROM t_setlinfo_payinfo_mid;



INSERT INTO [dbo].[t_setlinfo_iteminfo]
			( [id]
			, [mdtrt_sn]
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt])
SELECT 
			[id]
			, CASE  WHEN CHARINDEX( '^', mdtrt_sn )> 0 THEN LEFT ( mdtrt_sn, CHARINDEX( '^', mdtrt_sn ) - 1 )  ELSE mdtrt_sn  END AS mdtrt_sn
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt]
FROM t_setlinfo_iteminfo_mid;



INSERT INTO [dbo].[t_setlinfo_iteminfo]
			([id]
			, [mdtrt_sn]
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt])
SELECT 
			[id]
			, CASE  WHEN CHARINDEX( '^', mdtrt_sn )> 0 THEN LEFT ( mdtrt_sn, CHARINDEX( '^', mdtrt_sn ) - 1 )  ELSE mdtrt_sn  END AS mdtrt_sn
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt]
FROM t_setlinfo_iteminfo_mid;



USE [master]
RESTORE DATABASE [WEGOBI_DRGS_FJCCYY] FROM  DISK = N'D:\00145740 CYS\1.日常文件\20260204 泉州字段数值核对\wegobi_drgs_fjccyy.bak' WITH  REPLACE, 
MOVE N'WEGOBI_DRGS_FJCCYY' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS_FJCCYY.mdf',  
MOVE N'WEGOBI_DRGS_FJCCYY_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS_FJCCYY_log.ldf',  NOUNLOAD,  STATS = 5

GO

