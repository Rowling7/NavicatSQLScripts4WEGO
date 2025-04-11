use wegobi_drgs
DECLARE @path2 varchar(200)
set @path2='D:\00145740\9.其他文件\drgs_测试数据_'+left(replace(replace(replace(CONVERT(varchar, getdate(), 120 ),'-',''),' ',''),':',''),12)+'(BAK)'
--TRUNCATE table OYDST_USERTABLELOGData
backup database [WEGOBI_DRGS] to disk =@path2



USE [master]
RESTORE DATABASE [WEGOBI_DRGS] FROM  DISK = N'D:\00145740\8.工具\1.DRG\数据库\240313模糊化数据\20240313_1.bak' WITH   REPLACE,  
MOVE N'WEGOBI_DRGS' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS.mdf',  
MOVE N'WEGOBI_DRGS_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS_log.ldf',  NOUNLOAD,  STATS = 5
GO