SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY gp.person_name ASC) AS 序号,
       go.order_name AS 订单名称,
       gp.test_num AS 体检编号,
       gp.person_name AS 姓名,
       IFNULL(dr.barcode, dr.order_application_id) AS 申请单号,
       dr.group_item_name AS 检测项目,
       CASE WHEN rppc.state = 2 THEN '已弃检'
            WHEN gp.is_pass = 1 THEN '登记'
            WHEN gp.is_pass = 2 THEN '在检'
            WHEN gp.is_pass = 3 THEN '总检'
            ELSE '已完成'
           END AS 体检状态,
       SUM(CASE WHEN dir.result IS NOT NULL THEN 1 ELSE 0 END) AS R,
       ifnull(lg.username,'无log') AS 添加人
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
    LEFT JOIN relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 rppc
              ON rppc.person_id = gp.id AND dr.office_id = rppc.office_id AND
                 rppc.order_group_item_id = dr.group_item_id AND rppc.state <> 2
    LEFT JOIN t_log_f594102095fd9263b9ee22803eb3f4e5 lg
              ON lg.order_application_id = IFNULL(dr.barcode, dr.order_application_id) AND
                 lg.name = '添加组合项目检查结果以及添加基础项目结果'
WHERE dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND dir.order_group_item_name IN ('眼科检查', '外科检查', '内科检查', '耳鼻喉科检查', '妇科检查', '一般检查')
  AND go.order_code IN ('202508280001', '202509060001', '202509100001', '202508310001', '202509100002', '202509100004')
  -- and dir.office_id in('90116','1932021488400076800','1932019096271065088','1932019282980507648','90114','1933406003349557248','1932021583648526336','9021303')
GROUP BY
    go.order_name,
    gp.test_num,
    IFNULL(dr.barcode, dr.order_application_id),
    dr.group_item_name,
    CASE WHEN rppc.state = 2 THEN '已弃检'
         WHEN gp.is_pass = 1 THEN '登记'
         WHEN gp.is_pass = 2 THEN '在检'
         WHEN gp.is_pass = 3 THEN '总检'
         ELSE '已完成' END
HAVING SUM(CASE WHEN dir.result IS NOT NULL THEN 1 ELSE 0 END) = 0
