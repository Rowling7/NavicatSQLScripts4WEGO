CREATE OR ALTER PROCEDURE CheckDRGCHSCount
    @InputStartTime VARCHAR(255),
    @InputEndTime VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- 声明局部变量
        DECLARE @startTime DATE, @endTime DATE;
        
        -- 输入参数验证与转换
        BEGIN
            -- 检查输入参数格式
            IF ISDATE(@InputStartTime) = 0 OR ISDATE(@InputEndTime) = 0
            BEGIN
                RAISERROR('输入的日期格式不正确，请使用YYYY-MM-DD格式', 16, 1);
                RETURN;
            END
            
            -- 转换为DATE类型
            SET @startTime = CONVERT(DATE, @InputStartTime, 23);
            SET @endTime = CONVERT(DATE, @InputEndTime, 23);
            
            -- 检查日期逻辑
            IF @startTime > @endTime
            BEGIN
                RAISERROR('开始日期不能大于结束日期', 16, 1);
                RETURN;
            END
        END
        
        -- 开始事务处理
        BEGIN TRANSACTION;
        
        -- 步骤1: 初始化DRG状态
        UPDATE t_setlinfo
        SET isdrg = 0
        WHERE CONVERT(DATE, brjsrq, 23) BETWEEN @startTime AND @endTime;
        
        -- 步骤2: 执行对数脚本更新DRG状态和保险类型
        UPDATE a
        SET a.isdrg = 1,
            a.hi_type = b.insuranceid
        FROM t_setlinfo a
        INNER JOIN (
            SELECT DISTINCT 
                zylsh,
                insuranceid
            FROM t_job_settlebillinglist
            WHERE CONVERT(DATE, datebill, 23) BETWEEN @startTime AND @endTime
                AND medicalhosid = 1
        ) b ON a.mdtrt_sn = b.zylsh;
        
        -- 提交事务
        COMMIT TRANSACTION;
        
        -- 步骤3: 返回更新结果
        SELECT DISTINCT
            mdtrt_sn
        FROM t_setlinfo a
        WHERE CONVERT(DATE, brjsrq, 23) BETWEEN @startTime AND @endTime
            AND isdrg = 1;
    END TRY
    BEGIN CATCH
        -- 错误处理
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END CATCH
END;    


-- EXEC CheckDRGCHSCount '2025-06-01', '2025-06-30';