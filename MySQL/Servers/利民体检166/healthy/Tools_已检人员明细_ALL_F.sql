-- ALL
-- 心电图室-90401；影像科-90402；彩超室-90403；病理科-90404；检验科-90405；内镜中心-90120
SET @orderCode = '202508310001';
-- 2. result表没有结果
DROP TEMPORARY TABLE IF EXISTS temp_OrderIdLisLost;
CREATE TEMPORARY TABLE temp_OrderIdLisLost AS
SELECT dir.barcode AS OrderIdLost
     , gp.person_name AS 姓名
     , dir.order_group_item_name
     , SUM( ISNULL( result ) )
     , COUNT( * )
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
  AND dir.office_id IN ( '90401' , '90402' , '90403' , '90404' , '90405' , '90120' )
  AND go.order_code = @orderCode
GROUP BY dir.barcode, dir.office_id, dir.order_group_item_name, gp.person_name
HAVING SUM( ISNULL( result ) ) <> COUNT( 1 )
ORDER BY 姓名, OrderIdLost, SUM( ISNULL( result ) );

-- 3.已检人员明细&项目
SELECT DISTINCT
    DENSE_RANK( ) OVER (ORDER BY CASE
                                     WHEN rppc.state = 2 THEN '已弃检'
                                     WHEN gp.is_pass = 1 THEN 1
                                     WHEN gp.is_pass = 2 THEN 2
                                     WHEN gp.is_pass = 3 THEN 3
                                     ELSE 4
                                 END,
        og.name,gp.patient_id ) AS 序号
     , go.order_code AS 订单号
     , go.order_name AS 订单名称
     , og.name AS 分组名称
     , gp.test_num AS 体检编号
     , gp.patient_id AS HIS号
     , gp.person_name AS 姓名
     , gp.id_card AS 身份证号
     , dr.order_application_id AS 申请单号
     , dr.barcode AS 合管申请号
     , dr.office_name AS 科室名称
     , CASE
           WHEN rppc.state = 2 THEN '已弃检'
           WHEN gp.is_pass = 1 THEN '登记'
           WHEN gp.is_pass = 2 THEN '在检'
           WHEN gp.is_pass = 3 THEN '总检'
           ELSE '已完成'
       END AS 体检状态
     , CASE WHEN gp.fee_status = 2 THEN '已退费' WHEN gp.fee_status = -99 THEN '退费中' ELSE NULL END AS 收费状态
     , dr.group_item_name AS 检测项目
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
     LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
               ON dir.del_flag <> '1' AND dr.id = dir.depart_result_id
     LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
     LEFT JOIN relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 rppc
               ON rppc.person_id = gp.id AND dr.office_id = rppc.office_id AND
                  rppc.order_group_item_id = dr.group_item_id -- 弃检状态
WHERE dr.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dir.office_id IN ( '90401' , '90402' , '90403' , '90404' , '90405' , '90120' )
  AND go.order_code = @orderCode
  AND COALESCE( dr.barcode , dr.order_application_id ) IN ( SELECT OrderIdLost FROM temp_OrderIdLisLost )
-- AND rppc.state <> 2 -- 排除已弃检项目
GROUP BY go.order_code, go.order_name, og.name, gp.test_num, gp.patient_id, gp.person_name, gp.id_card, dr.barcode
       , dr.office_name
       , CASE
             WHEN rppc.state = 2 THEN '已弃检'
             WHEN gp.is_pass = 1 THEN '登记'
             WHEN gp.is_pass = 2 THEN '在检'
             WHEN gp.is_pass = 3 THEN '总检'
             ELSE '已完成'
         END
ORDER BY 序号, 分组名称, 检测项目;


-- 4
SELECT DISTINCT
    DENSE_RANK( ) OVER (ORDER BY CASE
                                     WHEN rppc.state = 2 THEN '已弃检'
                                     WHEN gp.is_pass = 1 THEN 1
                                     WHEN gp.is_pass = 2 THEN 2
                                     WHEN gp.is_pass = 3 THEN 3
                                     ELSE 4
                                 END,
        og.name,gp.patient_id ) AS 序号
     , go.order_code AS 订单号
     , go.order_name AS 订单名称
     , og.name AS 分组名称
     , gp.test_num AS 体检编号
     , gp.patient_id AS HIS号
     , gp.person_name AS 姓名
     , gp.id_card AS 身份证号
     , GROUP_CONCAT( DISTINCT dr.office_name ) 科室名称
     , CASE
           WHEN rppc.state = 2 THEN '已弃检'
           WHEN gp.is_pass = 1 THEN '登记'
           WHEN gp.is_pass = 2 THEN '在检'
           WHEN gp.is_pass = 3 THEN '总检'
           ELSE '已完成'
       END AS 体检状态
     , GROUP_CONCAT( DISTINCT dr.group_item_name ) AS 检测项目
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
     LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
               ON dir.del_flag <> '1' AND dr.id = dir.depart_result_id
     LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
     LEFT JOIN relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 rppc
               ON rppc.person_id = gp.id AND dr.office_id = rppc.office_id AND
                  rppc.order_group_item_id = dr.group_item_id
									-- AND rppc.state <> 2 -- 排除已弃检项目
WHERE dr.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dir.office_id IN ( '90401' , '90402' , '90403' , '90404' , '90405' , '90120' )
  AND go.order_code = @orderCode
  AND COALESCE( dr.barcode , dr.order_application_id ) IN ( SELECT OrderIdLost FROM temp_OrderIdLisLost )

GROUP BY go.order_code, go.order_name, og.name, gp.test_num, gp.patient_id, gp.person_name, gp.id_card
       , CASE
             WHEN rppc.state = 2 THEN '已弃检'
             WHEN gp.is_pass = 1 THEN '登记'
             WHEN gp.is_pass = 2 THEN '在检'
             WHEN gp.is_pass = 3 THEN '总检'
             ELSE '已完成'
         END
ORDER BY 序号, 分组名称, 检测项目;