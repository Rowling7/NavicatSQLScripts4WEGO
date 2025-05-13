use master;
alter database WEGOBI set single_user with rollback immediate;
drop database WEGOBI;

alter database WEGOBI_DRGS set single_user with rollback immediate;
drop database WEGOBI_DRGS;

alter database WEGOBI_Quartz set single_user with rollback immediate;
drop database WEGOBI_Quartz;

use [master];
restore database [WEGOBI]
from disk = N'C:\新建文件夹\WEGOBI'
with file = 1
   , move N'WEGOBI'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI.mdf'
   , move N'WEGOBI_log'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_log.ldf'
   , nounload
   , stats = 5;
go

use [master];
restore database [WEGOBI_DRGS]
from disk = N'C:\新建文件夹\WEGOBI_DRGS'
with file = 1
   , move N'WEGOBI_DRGS'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS.mdf'
   , move N'WEGOBI_DRGS_log'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_DRGS_log.ldf'
   , nounload
   , stats = 5;
go

use [master];
restore database [WEGOBI_Quartz]
from disk = N'C:\新建文件夹\WEGOBI_Quartz'
with file = 1
   , move N'WEGOBI_Quartz'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_Quartz.mdf'
   , move N'WEGOBI_Quartz_log'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGOBI_Quartz_log.ldf'
   , nounload
   , stats = 5;
go