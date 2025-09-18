-- Pacs
-- 心电图室-90401；影像科-90402；彩超室-90403；病理科-90404；检验科-90405；内镜中心-90120
SET @orderCode = '202509100004';
DROP TEMPORARY TABLE IF EXISTS t_PacsHL7Log;
CREATE TEMPORARY TABLE t_PacsHL7Log
(
    OrderIdLog    VARCHAR(255),
    responseParam VARCHAR(255),
    INDEX idx_OrderIdLog (OrderIdLog,responseParam)
) AS
SELECT DISTINCT
       LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|NW|', -1), '^^', 1), 20) AS OrderIdLog,
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
  AND LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|NW|', -1), '^^', 1), 20) LIKE '9%'
  AND (name in( 'PacsReceiveHL7Message','ReceiveHL7Message'));


-- 2. result表没有结果
DROP TEMPORARY TABLE IF EXISTS temp_OrderIdPacsLost;
CREATE TEMPORARY TABLE temp_OrderIdPacsLost AS
SELECT  dir.barcode AS OrderIdLost
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
  AND dir.office_id IN ('90402')
  AND go.order_code = @orderCode
GROUP BY
    dir.barcode,
    dir.office_id
HAVING SUM(ISNULL(result)) = COUNT(1); -- 未检
-- HAVING SUM(ISNULL(result)) <> COUNT(1);		--有检


-- 4.LOG表没有回传报文，result表没有结果
SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY CASE WHEN gp.is_pass = 1 THEN 1
                                        WHEN gp.is_pass = 2 THEN 2
                                        WHEN gp.is_pass = 3 THEN 3
                                        ELSE 4 END,
          IFNULL(t.responseParam, 'log无返回报文/未参与体检'),og.name,gp.patient_id ASC) AS 序号,
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
       CASE WHEN rppc.state = 2 THEN '已弃检'
            WHEN gp.is_pass = 1 THEN '登记'
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
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON  dir.del_flag <> '1' AND dr.id = dir.depart_result_id
		LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
    LEFT JOIN t_PacsHL7Log t ON t.OrderIdLog = dr.barcode AND responseParam IS NOT NULL
    LEFT JOIN relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 rppc
              ON rppc.person_id = gp.id AND dr.office_id=rppc.office_id and rppc.state ='2' AND rppc.order_group_item_id = dr.group_item_id
WHERE dr.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND go.order_code = @orderCode
  AND COALESCE(dr.barcode,dr.order_application_id) IN (SELECT OrderIdLost FROM temp_OrderIdPacsLost)
  -- AND rppc.state <> 2 -- 排除已弃检项目
ORDER BY
    原因,
    序号,
    分组名称,
		合管申请号;