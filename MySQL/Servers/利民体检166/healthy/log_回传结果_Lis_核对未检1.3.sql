-- LIS
-- 心电图室-90401；影像科-90402；彩超室-90403；病理科-90404；检验科-90405；内镜中心-90120
set @orderCode ='202508310001';
DROP TEMPORARY TABLE IF EXISTS t_LisHL7Log;
CREATE TEMPORARY TABLE t_LisHL7Log
(
    OrderIdLog VARCHAR(255),
    INDEX idx_OrderIdLog (OrderIdLog)
) AS
SELECT DISTINCT
       LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|SN|', -1), '|||||||', 1), 20) AS OrderIdLog
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
WHERE log_type = 2
  AND del_flag = 0
  AND LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|SN|', -1), '|||||||', 1), 20) LIKE '9%'
  AND (name = 'LisReceiveHL7Message' OR name = 'ReceiveHL7Message');

-- 1. LOG表没有回传报文
DROP TEMPORARY TABLE IF EXISTS t_OrderIdDRLis;
CREATE TEMPORARY TABLE t_OrderIdDRLis AS
SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY og.name,patient_id ASC) AS 序号,
       go.order_code AS 订单号,
       go.order_name AS 订单名称,
       og.name AS 分组名称,
       gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.order_application_id AS 申请单号,
       dr.office_name AS 科室名称,
       dr.group_item_name AS 检测项目,
       NULL AS 'LOG表没有回传报文'
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dr.del_flag <> '1'
  AND go.order_code = @orderCode
  AND dr.office_id IN ('90405')
  AND dr.order_application_id NOT IN (SELECT OrderIdLog FROM t_LisHL7Log)
  AND dr.group_item_name <> 'γ干扰素释放试验';
SELECT * FROM t_OrderIdDRLis ORDER BY 序号,分组名称;;



SELECT dir.order_application_id AS 申请单号
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE dir.office_id IN ('90405')
  AND go.order_code = @orderCode
GROUP BY
    dir.order_application_id,
    dir.office_id
HAVING SUM(ISNULL(result)) = COUNT(1)


-- 2. result表没有结果
SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY og.name,gp.patient_id ASC) AS 序号,
       go.order_code AS 订单号,
       go.order_name AS 订单名称,
       og.name AS 分组名称,
       gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.order_application_id AS 申请单号,
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
       NULL AS 'result表没有结果'
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND dir.order_application_id IN (SELECT order_application_id
																		FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5
																		where office_id IN ('90405')
																		group by order_application_id,office_id
																		having sum(isnuLL(result))=count(1))
ORDER BY 序号,分组名称;

/*
-- 3.核对详细数据部分
SELECT gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.order_application_id AS 申请单号,
			 CASE WHEN gp.is_pass = 1 THEN '登记'
            WHEN gp.is_pass = 2 THEN '在检'
            WHEN gp.is_pass = 3 THEN '总检'
            ELSE '已完成'
       END AS 体检状态,
       CASE WHEN gp.fee_status = 2 THEN '已退费'
						when gp.fee_status = -99 THEN '退费中'
            ELSE NULL
       END AS 收费状态,
       dr.group_item_name AS 组合项目,
       dir.order_group_item_project_name AS 检测项目,
       dir.result AS 检测结果
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
WHERE dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND dir.order_application_id in (SELECT 申请单号 from t_OrderIdDRLis)
	-- AND ISNULL(dir.result)=0;
	order by ISNULL(dir.result) asc;
*/


-- 4.LOG表没有回传报文，result表没有结果
SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY og.name,gp.patient_id ASC) AS 序号,
       go.order_code AS 订单号,
       go.order_name AS 订单名称,
       og.name AS 分组名称,
       gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.order_application_id AS 申请单号,
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
       NULL AS 'LOG表没有回传报文，result表没有结果'
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND dir.order_application_id IN  (SELECT order_application_id
																			FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5
																			where order_application_id in (SELECT 申请单号 FROM t_OrderIdDRLis)
																			group by order_application_id,office_id
																			having sum(isnuLL(result))=count(1))
ORDER BY 序号,分组名称;
