DROP TEMPORARY TABLE IF EXISTS t_OrderIdHL7Log;
CREATE TEMPORARY TABLE t_OrderIdHL7Log
(
    OrderIdLog VARCHAR(40) ,
    INDEX idx_OrderIdLog ( OrderIdLog )
) AS
SELECT SUBSTR( SUBSTRING_INDEX( request_param , 'ORC|' , -1 ) , 4 , 11 ) AS OrderIdLog
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
WHERE log_type = 2
  AND del_flag = 0
  AND NAME = '检查开立';

--  心电图室-90401；影像科-90402；彩超室-90403；病理科-90404；检验科-90405；内镜中心-90120
SELECT DISTINCT DENSE_RANK( ) OVER (ORDER BY og.name,patient_id ) AS 序号
              , go.order_code AS 订单号
              , go.order_name AS 订单名称
              , og.name AS 分组名称
              -- dr.order_application_id AS 申请单号,
              , gp.patient_id AS HIS号
              , gp.test_num AS 体检编号
              , gp.person_name AS 姓名
              , gp.id_card AS 身份证号
              , dr.group_item_name AS 检测项目
              , dr.order_application_id AS 申请单号
              , dr.barcode AS 合管号
              , dr.office_name AS 科室名称
              , CASE
                    WHEN gp.is_pass = 1 THEN '登记'
                    WHEN gp.is_pass = 2 THEN '在检'
                    WHEN gp.is_pass = 3 THEN '总检'
                    ELSE '已完成'
                END AS 体检状态
              , CASE
                    WHEN gp.fee_status = 2   THEN '已退费'
                    WHEN gp.fee_status = -99 THEN '退费中'
                    ELSE NULL
                END AS 收费状态
							,NULL '已发送'
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
     LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id AND dr.del_flag <> '1'
WHERE gp.del_flag <> '1'
  AND go.order_code = '202511070001'
  AND dr.office_id IN ( '90401' , '90402' , '90403' , '90404' , '90120' ) -- 去除检验科，检验项目不发申请
  AND EXISTS( SELECT 1
              FROM t_OrderIdHL7Log
              WHERE OrderIdLog = dr.barcode )
ORDER BY 序号, 分组名称;
