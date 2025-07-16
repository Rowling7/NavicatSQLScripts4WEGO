DROP PROCEDURE IF EXISTS updateOprtDate;
GO

-- 创建全局临时表来存储执行历史
IF OBJECT_ID('tempdb..##OprtDateUpdateHistory') IS NULL
BEGIN
    CREATE TABLE ##OprtDateUpdateHistory (
        execution_time DATETIME,
        id VARCHAR(50),
        mdtrt_sn VARCHAR(50),
        oprn_oprt_code VARCHAR(50),
        old_oprt_date DATETIME,
        new_oprt_date DATETIME,
        revise_status NVARCHAR(100),
        result_message NVARCHAR(200)
    );
END

GO

CREATE PROCEDURE updateOprtDate
AS
BEGIN
    -- 检查全局临时表是否存在，不存在则创建
    IF OBJECT_ID('tempdb..##OprtDateUpdateHistory') IS NULL
    BEGIN
        CREATE TABLE ##OprtDateUpdateHistory (
            execution_time DATETIME,
            id VARCHAR(50),
            mdtrt_sn VARCHAR(50),
            oprn_oprt_code VARCHAR(50),
            old_oprt_date DATETIME,
            new_oprt_date DATETIME,
            revise_status NVARCHAR(100),
            result_message NVARCHAR(200)
        );
    END

    DECLARE @reviseCount INT;
    DECLARE @message NVARCHAR(100);
    DECLARE @rowsAffected INT;
    DECLARE @resultMessage NVARCHAR(200);
    DECLARE @executionTime DATETIME = GETDATE();

    -- 修改临时表定义，增加id字段
    DECLARE @tempTable TABLE (
        id VARCHAR(50),
        mdtrt_sn VARCHAR(50)
    );

    -- 创建临时表存储更新前后的值
    DECLARE @updateLog TABLE (
        id VARCHAR(50),
        mdtrt_sn VARCHAR(50),
        oprn_oprt_code VARCHAR(50),
        old_oprt_date DATETIME,
        new_oprt_date DATETIME
    );

    -- 检查修订记录并将结果存入临时表
    INSERT INTO @tempTable
    SELECT DISTINCT a.id, a.mdtrt_sn
    FROM t_setlinfo a
    LEFT JOIN t_mihs_result_relation b ON a.mdtrt_sn = b.uid
    LEFT JOIN t_mihs_result c ON b.resultid = c.id
    WHERE c.infocode = -1
        AND c.err_msg NOT LIKE '%省平台%'
        AND c.err_msg LIKE '%JSQD_OPERATION_INFO%';

    -- 检查修订记录
    SELECT @reviseCount = COUNT(1)
    FROM t_setlinfo_revise
    WHERE mdtrt_sn IN (SELECT mdtrt_sn FROM @tempTable)
        AND fieldname = 'oprninfo';

    IF @reviseCount > 0
    BEGIN
        SET @message = '注意！已有修订记录！';
        PRINT @message;
    END

    -- 先获取要更新的记录的原始值
    INSERT INTO @updateLog(id, mdtrt_sn, oprn_oprt_code, old_oprt_date)
    SELECT
        a.id,
        a.mdtrt_sn,
        a.oprn_oprt_code,
        a.oprn_oprt_date
    FROM t_setlinfo_oprninfo a
    WHERE a.id IN (
        SELECT id
        FROM (
            SELECT id, ROW_NUMBER() OVER(PARTITION BY mdtrt_sn, oprn_oprt_code, oprn_oprt_date ORDER BY id) rn
            FROM(
                SELECT a.*
                FROM t_setlinfo_oprninfo a,
                    (SELECT mdtrt_sn, oprn_oprt_code, oprn_oprt_date, COUNT(*) cont
                     FROM t_setlinfo_oprninfo
                     GROUP BY mdtrt_sn, oprn_oprt_code, oprn_oprt_date
                     HAVING COUNT(*) > 1
                    ) b
                WHERE a.mdtrt_sn = b.mdtrt_sn
                    AND a.oprn_oprt_code = b.oprn_oprt_code
                    AND a.oprn_oprt_date = b.oprn_oprt_date
                    AND a.mdtrt_sn IN (SELECT mdtrt_sn FROM @tempTable)
                ) a
            ) id
        WHERE rn = 1
    );

    -- 执行更新
    UPDATE t_setlinfo_oprninfo
    SET oprn_oprt_date = DATEADD(MINUTE, 1, oprn_oprt_date)
    WHERE id IN (
        SELECT id
        FROM (
            SELECT id, ROW_NUMBER() OVER(PARTITION BY mdtrt_sn, oprn_oprt_code, oprn_oprt_date ORDER BY id) rn
            FROM(
                SELECT a.*
                FROM t_setlinfo_oprninfo a,
                    (SELECT mdtrt_sn, oprn_oprt_code, oprn_oprt_date, COUNT(*) cont
                     FROM t_setlinfo_oprninfo
                     GROUP BY mdtrt_sn, oprn_oprt_code, oprn_oprt_date
                     HAVING COUNT(*) > 1
                    ) b
                WHERE a.mdtrt_sn = b.mdtrt_sn
                    AND a.oprn_oprt_code = b.oprn_oprt_code
                    AND a.oprn_oprt_date = b.oprn_oprt_date
                    AND a.mdtrt_sn IN (SELECT mdtrt_sn FROM @tempTable)
                ) a
            ) id
        WHERE rn = 1
    );

    -- 更新日志表中的新值
    UPDATE ul
    SET ul.new_oprt_date = a.oprn_oprt_date
    FROM @updateLog ul
    JOIN t_setlinfo_oprninfo a ON ul.id = a.id
    WHERE a.mdtrt_sn IN (SELECT mdtrt_sn FROM @tempTable);

    -- 检查受影响的行数并合并消息
    SET @rowsAffected = @@ROWCOUNT;
    SET @resultMessage = CASE
        WHEN @rowsAffected = 0 THEN '0行受影响,已未作修改！'
        ELSE CAST(@rowsAffected AS VARCHAR) + '行受影响,已更新完！'
    END;

    -- 将本次执行结果存入全局临时表
    INSERT INTO ##OprtDateUpdateHistory (
        execution_time, id, mdtrt_sn, oprn_oprt_code,
        old_oprt_date, new_oprt_date, revise_status, result_message
    )
    SELECT DISTINCT
        @executionTime,
        ul.id,
        ul.mdtrt_sn,
        ul.oprn_oprt_code,
        ul.old_oprt_date,
        ul.new_oprt_date,
        CASE
            WHEN r.mdtrt_sn IS NOT NULL THEN '注意！已有修订记录！'
            ELSE NULL
        END,
        @resultMessage
    FROM @updateLog ul
    LEFT JOIN t_setlinfo_revise r ON ul.mdtrt_sn = r.mdtrt_sn;

    -- 输出所有历史记录
    SELECT
        execution_time AS '执行时间',
        id AS 'ID',
        mdtrt_sn AS '就诊流水号',
        oprn_oprt_code AS '手术操作代码',
        old_oprt_date AS '原手术操作时间',
        new_oprt_date AS '新手术操作时间',
        revise_status AS '修订状态',
        result_message AS '执行结果'
    FROM ##OprtDateUpdateHistory
    ORDER BY execution_time DESC;

    PRINT @resultMessage;
END;

exec updateOprtDate;
