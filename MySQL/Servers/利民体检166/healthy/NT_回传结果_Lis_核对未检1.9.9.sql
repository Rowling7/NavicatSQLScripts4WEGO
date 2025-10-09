/*
脚本功能说明：
该脚本用于查询LIS（实验室信息系统）中检验科未返回结果的申请单信息，主要用于排查检验结果缺失的问题。

脚本执行步骤详解：

第一步：创建临时表 t_LisHL7Log
作用：从日志表中提取LIS HL7消息处理记录，识别解析失败的报文
逻辑：
1. 从 `t_log_f594102095fd9263b9ee22803eb3f4e5` 表中筛选HL7消息日志
2. 提取申请单号：从 `request_param` 字段中解析出以'ORC|SN|'开头的申请单号
3. 识别错误记录：当 `request_type` 为 'error' 且 `response_param` 不包含 '<Response>' 时标记为解析失败
4. 只保留科室代码为9开头的日志记录
5. 创建索引提高查询效率

第二步：创建临时表 temp_OrderIdLisLost
作用：找出检验结果表中没有结果数据的申请单
逻辑：
1. 从 `t_depart_result_f594102095fd9263b9ee22803eb3f4e5` 和关联表中查询数据
2. 筛选条件：
   - 排除已删除记录（del_flag <> '1'）
   - 排除γ干扰素释放试验项目
   - 限定科室为检验科（office_id = '90405'）
   - 匹配指定订单号
3. 通过 GROUP BY 和 HAVING 条件筛选出所有检测项目都没有结果的申请单

第三步：查询最终结果
作用：关联所有相关表，展示缺失检验结果的详细信息
逻辑：
1. 多表关联查询，获取申请单的完整信息
2. 左连接 t_LisHL7Log 表获取错误原因
3. 使用窗口函数 DENSE_RANK() 进行排序和统计
4. 筛选条件包括：
   - 排除已删除记录
   - 匹配指定订单号
   - 申请单号在缺失结果的申请单列表中
5. 按错误原因、序号、分组名称排序输出结果
*/

-- LIS
-- 心电图室-90401；影像科-90402；彩超室-90403；病病理科-90404；检验科-90405；内镜中心-90120
SET @orderCode = '202509060001';
DROP TEMPORARY TABLE IF EXISTS t_LisHL7Log;
CREATE TEMPORARY TABLE t_LisHL7Log
(
    OrderIdLog    VARCHAR(255),
    responseParam VARCHAR(255),
    INDEX idx_OrderIdLog (OrderIdLog),
    INDEX idx_responseParam (responseParam)
) AS
SELECT DISTINCT
       LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(l.request_param, 'ORC|SN|', -1), '|||||||', 1), 20) AS OrderIdLog,
       CASE
           WHEN EXISTS(
                   SELECT 1
                   FROM `t_log_f594102095fd9263b9ee22803eb3f4e5` l2
                   WHERE l2.request_type = 'error'
                     AND l2.response_param NOT LIKE '%<Response>%'
                     AND l2.id = l.id
               ) THEN '解析报文失败(request_type:error)'
           ELSE NULL
           END AS responseParam
FROM t_log_f594102095fd9263b9ee22803eb3f4e5 l
WHERE l.log_type = 2
  AND l.del_flag = 0
  AND LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(l.request_param, 'ORC|SN|', -1), '|||||||', 1), 20) LIKE '9%'
  AND (l.name = 'LisReceiveHL7Message' OR l.name = 'ReceiveHL7Message');


-- 2. result表没有结果
DROP TEMPORARY TABLE IF EXISTS temp_OrderIdLisLost;
CREATE TEMPORARY TABLE temp_OrderIdLisLost AS
SELECT DISTINCT dir.order_application_id AS 申请单号
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND dr.group_item_name <> 'γ干扰素释放试验'
  AND dir.office_id IN ('90405')
  AND go.order_code = @orderCode
GROUP BY
    dir.order_application_id,
    dir.office_id
HAVING SUM(ISNULL(result)) = COUNT(1);

-- 4.LOG表没有回传报文，result表没有结果
SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY CASE WHEN gp.is_pass = 1 THEN 1
                                        WHEN gp.is_pass = 2 THEN 2
                                        WHEN gp.is_pass = 3 THEN 3
                                        ELSE 4 END,
           IFNULL(t.responseParam, 'log无返回报文'),og.name,gp.patient_id ASC) AS 序号,
       go.order_code AS 订单号,
       go.order_name AS 订单名称,
       og.name AS 分组名称,
       gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.order_application_id AS 申请单号,
       dr.barcode AS 合管申请号,
       dr.office_name AS 科室名称,
       CASE WHEN gp.is_pass = 1 THEN '登记'
            WHEN gp.is_pass = 2 THEN '在检'
            WHEN gp.is_pass = 3 THEN '总检'
            ELSE '已完成'
           END AS 体检状态,
       CASE WHEN gp.fee_status = 2 THEN '已退费'
            WHEN gp.fee_status = -99 THEN '退费中'
            ELSE NULL
           END AS 收费状态,
       dr.group_item_name AS 检测项目,
       IFNULL(t.responseParam, 'log无返回报文') AS 原因,
       DENSE_RANK() OVER (PARTITION BY IFNULL(t.responseParam, 'log无返回报文')
           ORDER BY CASE WHEN gp.is_pass = 1 THEN 1 WHEN gp.is_pass = 2 THEN 2 WHEN gp.is_pass = 3 THEN 3 ELSE 4 END,
               IFNULL(t.responseParam, 'log无返回报文'),og.name,gp.patient_id,IFNULL(t.responseParam, 'log无返回报文') ASC) AS 统计
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
    LEFT JOIN t_LisHL7Log t ON t.OrderIdLog = dr.barcode AND responseParam IS NOT NULL
WHERE dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND go.order_code = @orderCode
  AND dr.barcode IN (SELECT 申请单号 FROM temp_OrderIdLisLost)
ORDER BY
    原因,
    序号,
    分组名称;
