SELECT DISTINCT
       gp.id AS ID,
       gp.person_name AS 姓名,
       gp.test_num AS 体检号,
       gp.dept AS 单位,
       dir.order_application_id AS 申请单号,
       og.name AS 分组名称,
       SUM(CAST(IFNULL(dir.result, 0) AS DECIMAL(18, 2))) AS R
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.id = dir.depart_result_id
    INNER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dir.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
WHERE dir.order_group_item_project_name IN ('矫正（右）', '矫正（左）', '裸眼（右）', '裸眼（左）')
  AND gp.is_pass IN ('3', '4')
  AND gp.del_flag <> 1
  AND dir.del_flag <> 1
  AND person_name NOT LIKE '%CS%'
  AND gp.dept IS NOT NULL
GROUP BY
    gp.id,
    gp.person_name,
    gp.test_num,
    gp.dept,
    dir.order_application_id,
    og.name
HAVING SUM(CAST(IFNULL(dir.result, 0) AS DECIMAL(18, 2))) = 0
ORDER BY
    单位,
    分组名称;