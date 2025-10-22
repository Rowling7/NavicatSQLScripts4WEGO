DECLARE @curStartTime DATE;
DECLARE @curEndTime Date;

SET @curStartTime = '2020-09-01';
SET @curEndTime = '2025-08-31';

SELECT a.jobnumber AS '工号',
       a.name AS '姓名',
       SUM(CAST(DATEDIFF(MINUTE, starttime, nodestarttime) / 60.0 AS NUMERIC(18, 2))) AS '工作时长',
       SUM(CAST(treatmentprojectprice AS numeric(18, 2))) AS '业务量',
       COUNT(patient_id) AS '工作量'
FROM [WEGO_Rehabilitation_Admin].[dbo].[t_account] a
    LEFT JOIN [WEGO_Rehabilitation].[dbo].[t_scheduling] s
              ON a.id = s.doctor_id AND nodestatus = 1 AND a.deleted = 0 AND s.deleted = 0
                  AND s.patient_id != '37512' -- 测试用户
                  AND CONVERT(date, s.starttime) BETWEEN
                     CASE WHEN ISNULL(@curStartTime, '') <> '' THEN @curStartTime
                          ELSE DATEADD(MM, DATEDIFF(M, 0, GETDATE()), 0) END
                     AND
                     CASE WHEN ISNULL(@curEndTime, '') <> '' THEN DATEADD(DAY, 1, @curEndTime)
                          ELSE DATEADD(MS, -3, DATEADD(MM, DATEDIFF(M, -1, GETDATE()), 0)) END
WHERE a.id NOT IN ('39F08CFD-8E0D-771B-A2F3-2639A62CA2FA', '2CC065F3-CD3E-E0F1-1931-3A135AEB692D') -- admin 张三
			and a.name='连丽萍'
GROUP BY
    a.id,
    a.name,
    a.jobnumber