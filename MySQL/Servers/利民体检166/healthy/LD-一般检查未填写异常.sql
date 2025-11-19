SELECT go.order_name AS 订单名称,
       dir.id AS ID,
       dir.person_id AS personid,
       gp.person_name AS 姓名,
       dir.order_application_id AS 申请单号,
       dir.barcode AS 合管号,
       dir.order_group_item_project_name AS 体检项目,
       CAST(dir.result AS DECIMAL(18, 2)) AS 结果,
       IFNULL(dir.positive, '0') AS 是否异常,
       CASE WHEN dir.order_group_item_project_name = '体重指数BMI' AND
                 (CAST(dir.result AS DECIMAL(18, 2)) < 18 OR CAST(dir.result AS DECIMAL(18, 2)) > 28) AND
                 IFNULL(dir.positive, '0') <> '1' THEN 'false'
            WHEN dir.order_group_item_project_name = '收缩压' AND
                 (CAST(dir.result AS DECIMAL(18, 2)) < 90 OR CAST(dir.result AS DECIMAL(18, 2)) > 139) AND
                 IFNULL(dir.positive, '0') <> '1' THEN 'false'
            WHEN dir.order_group_item_project_name = '舒张压' AND
                 (CAST(dir.result AS DECIMAL(18, 2)) < 60 OR CAST(dir.result AS DECIMAL(18, 2)) > 89) AND
                 IFNULL(dir.positive, '0') <> '1' THEN 'false'
            ELSE '1' END AS 是否填写异常
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dir.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE  CASE WHEN dir.order_group_item_project_name = '体重指数BMI' AND
                 (CAST(dir.result AS DECIMAL(18, 2)) < 18 OR CAST(dir.result AS DECIMAL(18, 2)) > 28) AND
                 IFNULL(dir.positive, '0') <> '1' THEN 'false'
            WHEN dir.order_group_item_project_name = '收缩压' AND
                 (CAST(dir.result AS DECIMAL(18, 2)) < 90 OR CAST(dir.result AS DECIMAL(18, 2)) > 139) AND
                 IFNULL(dir.positive, '0') <> '1' THEN 'false'
            WHEN dir.order_group_item_project_name = '舒张压' AND
                 (CAST(dir.result AS DECIMAL(18, 2)) < 60 OR CAST(dir.result AS DECIMAL(18, 2)) > 89) AND
                 IFNULL(dir.positive, '0') <> '1' THEN 'false'
            ELSE '1' END = 'false'
				and go.order_name is not null



SELECT gp.test_num AS 体检号
     , gp.person_name AS 姓名
     , gp.patient_id AS HIS号
     , dir.order_group_item_project_name AS 基础项目
     , dir.result AS 结果
     , dir.check_date AS 检查日期
     , dir.check_doc AS 检查医生
     , rppc.state AS 检查状态
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dir.person_id = gp.id
     LEFT JOIN relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 rppc
               ON gp.id = rppc.person_id AND dir.order_group_item_project_id = rppc.order_group_item_id
WHERE gp.del_flag <> 1
  AND dir.del_flag <> 1
  AND gp.order_id = '02705591e03726d8272fe1e0cf3e0916'
  AND dir.office_name = '一般检查'
  AND (dir.result IS NULL OR dir.result ='')
  AND gp.is_pass IN ( '2','3' )
