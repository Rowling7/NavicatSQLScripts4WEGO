SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY CASE WHEN go.order_code = '202509100002' THEN '方正外国语学生2025年'
                                        ELSE '方正外国语老师2025年' END,gp.person_name,dir.order_group_item_name ASC) AS 序号,
       CASE WHEN go.order_code = '202509100002' THEN '方正外国语学生2025年' ELSE '方正外国语老师2025年' END AS 订单名,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号码,
       gp.mobile AS 手机号码,
       gp.test_num AS 检测编号,
       gp.patient_id AS HIS号,
       dir.order_group_item_name AS 检测项目,
       dir.order_group_item_project_name AS 检测项目名称,
       dir.result AS 检测结果,
       dir.crisis_degree AS 危机等级,
       dir.check_date AS 检测时间,
       dir.positive AS 异常标志
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dir.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE dir.del_flag <> 1
  AND gp.del_flag <> 1
  AND og.del_flag <> 1
  AND go.del_flag <> 1
  AND dir.positive = 1
  AND go.order_code IN ('202509100002', '202509100004')
ORDER BY 订单名,姓名,检测项目;