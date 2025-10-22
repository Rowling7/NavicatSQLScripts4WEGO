-- 重复手术的手术日期oprn_oprt_date中‘年月日时分秒’完全一致时，会上传失败校验不通过
-- 如果有修订日志，那么这个办法不可行。需要手动修订或修改修订记录
-- exec updateOprtDate;

--对数
-- EXEC CheckDRGCHSCount '2025-07-01', '2025-07-31';

---查询错误信息
SELECT a.mdtrt_sn AS 流水号, a.brjsrq AS 结算时间, c.err_msg AS 错误信息
FROM t_setlinfo a
    LEFT JOIN t_mihs_result_relation b ON a.mdtrt_sn = b.uid
    LEFT JOIN t_mihs_result c ON b.resultid = c.id
WHERE c.infocode = -1
  AND a.brjsrq >= '2025-09-01'
  AND a.brjsrq < '3025-12-31'-- cast(getdate() as date)
  AND err_msg NOT LIKE '%省平台%'


/* --对数
--1.初始化
declare @startTime varchar(255), @endTime varchar(255);
set @startTime ='2025-08-01';
set @endTime='2025-08-31';

UPDATE t_setlinfo
SET isdrg = 0
WHERE CONVERT(DATE, brjsrq, 23)
BETWEEN @startTime AND @endTime;

--2.执行对数脚本
UPDATE a
SET a.isdrg = 1,
    a.hi_type = b.insuranceid
FROM t_setlinfo a,
(
    SELECT DISTINCT
           zylsh,
           insuranceid
    FROM t_job_settlebillinglist
    WHERE CONVERT(DATE, datebill, 23)
          BETWEEN @startTime AND @endTime
          AND medicalhosid = 1
) b
WHERE a.mdtrt_sn = b.zylsh;

--3.核对结果
SELECT DISTINCT
       mdtrt_sn
FROM t_setlinfo a
WHERE CONVERT(DATE, brjsrq, 23)
      BETWEEN @startTime AND @endTime
      AND isdrg = 1;
*/
