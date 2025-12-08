SELECT pp.person_id
     , gp.person_name
     , gp.test_num
     , pp.positive_name
     , IF( pp.positive_name REGEXP '\\d+$' , '是' , '否' ) AS is_end_with_num
FROM t_positive_person_f594102095fd9263b9ee22803eb3f4e5 pp
     LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON gp.id = pp.person_id
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE pp.del_flag <> 1
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
	AND pp.positive_name REGEXP '^\\d+'-- 匹配连字符，\\d+ 匹配 1 个及以上数字（MySQL 中 \d 需转义为 \\d），^ 匹配字符串开头
  AND pp.positive_name REGEXP '\\d+$'-- $ 匹配字符串末尾。
  -- and pp.positive_name REGEXP '[0-9]' 
	-- and pp.positive_name REGEXP REGEXP '\\d' -- [0-9]和\\d 匹配任意单个数字，只要字段中存在至少一个数字就会匹配
  -- and gp.is_pass >=3
  AND go.id = '2e589ff7efc16d802d33afa48d0ec92a'
;




/*
person_id in (

SELECT DISTINCT
			 gp.id AS ID,gp.test_num
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
		LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
		LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
	and gp.is_pass >=3
	and go.id='2e589ff7efc16d802d33afa48d0ec92a'
	
	)
	*/