-- Pacs
-- 心电图室-90401；影像科-90402；彩超室-90403；病理科-90404；检验科-90405；内镜中心-90120
DROP TEMPORARY TABLE IF EXISTS t_ECGHL7Log;
CREATE TEMPORARY TABLE t_ECGHL7Log (
    OrderIdLog VARCHAR(255),
    INDEX idx_OrderIdLog (OrderIdLog)
) AS
SELECT distinct left(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|SC|', -1), '^^', 1),20) AS OrderIdLog
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
WHERE log_type = 2
  AND del_flag = 0
	and left(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|SC|', -1), '^^', 1),20) like '9%'
  AND request_param like '%ECG||RIS%';

-- 1.LOG 日志部分
SELECT DISTINCT DENSE_RANK() OVER (ORDER BY patient_id ASC) AS 序号,
       dr.order_application_id AS 申请单号,
       gp.patient_id AS patient_id,
       gp.test_num AS 体检编号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.group_item_name AS 检测项目,
       dr.office_name AS 科室名称
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dr.del_flag <> '1'
  AND go.order_code = '202508310001'
  and dr.office_id in('90401')
	AND dr.order_application_id not in (SELECT OrderIdLog from t_ECGHL7Log);

-- 2.核对部分
SELECT gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.order_application_id AS 申请单号,
       dr.group_item_name AS 检测项目,
       dir.order_group_item_project_name AS 检测项目,
       dir.result AS 检测结果
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
WHERE dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND dir.order_application_id = '90001073647';
