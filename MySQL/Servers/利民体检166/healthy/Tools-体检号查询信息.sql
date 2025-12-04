SELECT DISTINCT
       go.order_name AS 订单名称,
       og.name AS 分组名称,
			 gp.id AS ID,
       gp.person_name AS 姓名,
       gp.test_num AS 体检号,
       gp.patient_id AS HIS号,
       gp.id_card AS 身份证号,
       gp.inspection_time AS 导引单打印时间,
       dr.barcode AS 申请合管号,
       dr.barname AS 项目名称
       -- dir.barcode
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON gp.id = dr.person_id
		LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
		LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
	AND dr.del_flag <> '1'
	AND gp.test_num='175924507200238'
			-- and dr.office_name='彩超室'
order by 申请合管号;

 
 
/*
person_id in (SELECT DISTINCT
			 gp.id AS ID 
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
		LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
		LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
	and go.id='2e589ff7efc16d802d33afa48d0ec92a')
	*/