SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY gp.patient_id ASC) AS 去重序号,
       go.group_unit_name AS 团检单位名称,
       gp.test_num AS 体检号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.sex AS 性别,
       gp.id_card AS 身份证号,
       gp.mobile AS 手机号,
       pp.order_group_item_name AS 检测项目,
       pp.order_group_item_project_name AS 基础项目,
       pp.diagnose_sum AS 诊断小结,
       pp.positive_name AS 阳性名称,
       pp.positive_suggestion AS 阳性建议,
       pp.medical_explanation AS 医疗解释,
       pp.create_time AS 创建时间

FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_positive_person_f594102095fd9263b9ee22803eb3f4e5 pp ON pp.person_id = gp.id AND pp.del_flag <> '1'
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
WHERE gp.del_flag <> '1'
  AND go.order_code = '202508280001'
  AND gp.patient_id <> '2023006550'
  AND pp.positive_name <> '本次体检所查项目未发现异常'
ORDER BY
    gp.patient_id,
    pp.order_group_item_name,
    pp.order_group_item_project_name;
