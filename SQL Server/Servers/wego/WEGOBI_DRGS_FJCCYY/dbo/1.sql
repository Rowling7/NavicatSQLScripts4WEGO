/*
TRUNCATE TABLE t_setlinfo_iteminfo_mid;
TRUNCATE TABLE t_setlinfo_payinfo_mid;
TRUNCATE TABLE t_setlinfo_opspdiseinfo_mid;
TRUNCATE TABLE t_setlinfo_mid;
TRUNCATE TABLE t_mdtrtSn_setlDate;
*/
SELECT * from t_setlinfo_iteminfo_mid;
SELECT * from t_setlinfo_payinfo_mid;
SELECT * from t_setlinfo_opspdiseinfo_mid;
SELECT * from t_setlinfo_mid;
SELECT * from t_mdtrtSn_setlDate;

SELECT pmainindex,mdtrt_id,setl_id,count(*)
from t_setlinfo_mid
GROUP BY pmainindex,mdtrt_id,setl_id
order by count(*) desc



SELECT mdtrt_sn,count(*)
from t_mdtrtSn_setlDate
GROUP BY mdtrt_sn
order by count(*) desc

/*

BACKUP DATABASE [WEGOBI_DRGS_FJCCYY] TO  DISK ='/var/opt/mssql/data/bak/bak20260130/wegobi_drgs_fjccyy_2026013_1.bak' WITH NOFORMAT, NOINIT,  NAME = N'WEGOBI_DRGS_FJCCYY-完整 数据库 备份', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


docker cp 17980e31cfce:/var/opt/mssql/data/bak/bak20260130/wegobi_drgs_fjccyy_2026013_1.bak /data/bak/
*/