use master;
alter database WEGO_Rehabilitation_Admin set single_user with rollback immediate;
drop database WEGO_Rehabilitation_Admin;

alter database WEGO_Rehabilitation_ECharts set single_user with rollback immediate;
drop database WEGO_Rehabilitation_ECharts;

alter database WEGO_Rehabilitation_Portal set single_user with rollback immediate;
drop database WEGO_Rehabilitation_Portal;

alter database WEGO_Rehabilitation_Quartz set single_user with rollback immediate;
drop database WEGO_Rehabilitation_Quartz;

use [master];
restore database [WEGO_Rehabilitation_Admin]
from disk = N'C:\新建文件夹\WEGO_Rehabilitation_Admin.bak'
with file = 1
   , move N'WEGO_Rehabilitation_Admin'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_Admin.mdf'
   , move N'WEGO_Rehabilitation_Admin_log'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_Admin_log.ldf'
   , nounload
   , stats = 5;
go

use [master];
restore database [WEGO_Rehabilitation_ECharts]
from disk = N'C:\新建文件夹\WEGO_Rehabilitation_ECharts.bak'
with file = 1
   , move N'WEGO_Rehabilitation_ECharts'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_ECharts.mdf'
   , move N'WEGO_Rehabilitation_ECharts_log'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_ECharts_log.ldf'
   , nounload
   , stats = 5;
go

use [master];
restore database [WEGO_Rehabilitation_Portal]
from disk = N'C:\新建文件夹\WEGO_Rehabilitation_Portal.bak'
with file = 1
   , move N'WEGO_Rehabilitation_Portal'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_Portal.mdf'
   , move N'WEGO_Rehabilitation_Portal_log'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_Portal_log.ldf'
   , nounload
   , stats = 5;
go


use [master];
restore database [WEGO_Rehabilitation_Quartz]
from disk = N'C:\新建文件夹\WEGO_Rehabilitation_Quartz.bak'
with file = 1
   , move N'WEGO_Rehabilitation_Quartz'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_Quartz.mdf'
   , move N'WEGO_Rehabilitation_Quartz_log'
     to N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WEGO_Rehabilitation_Quartz_log.ldf'
   , nounload
   , stats = 5;
go