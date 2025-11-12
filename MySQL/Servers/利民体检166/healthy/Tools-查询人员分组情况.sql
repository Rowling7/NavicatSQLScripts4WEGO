SELECT go.order_name AS 订单名称,
      og.name AS 分组名称,
			gp.test_num as 体检号,
			gp.patient_id AS his号
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
	and gp.test_num ='176290216200468'