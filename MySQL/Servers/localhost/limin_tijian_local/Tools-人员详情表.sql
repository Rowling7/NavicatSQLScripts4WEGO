SELECT gp.dept 团检单位,
       -- go.order_name AS 订单名称,
       SUBSTRING(og.name, 1, LOCATE('-', og.name) - 1) AS 学院,
       SUBSTRING(og.name, LOCATE('-', og.name) + 1) AS 专业,
       gp.person_name AS 姓名,
       -- gp.sex AS 性别,
       -- gp.age AS 年龄,
       -- gp.birth AS 出生日期,
       gp.id_card AS 身份证号码,
       -- gp.mobile AS 手机号码,
       gp.test_num AS 体检号,
       gp.patient_id AS HIS号
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND go.order_code='202509100002'-- 团检单号
	-- AND gp.create_time >'2025-09-08 00:05:52'
