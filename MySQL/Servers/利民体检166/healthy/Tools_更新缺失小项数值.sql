SELECT distinct b.id,
       b.person_name,
       b.test_num,
       b.dept,
       a.order_application_id,
    og.name AS 分组名称
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 a
    INNER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 b ON a.person_id = b.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = b.group_id
WHERE order_group_item_name in ( '一般检查')
  AND order_group_item_project_name = '身高'
  AND result IS NULL
  AND is_pass  in ('3','4')
  AND b.del_flag <> 1
  AND a.del_flag <> 1
  AND person_name NOT LIKE '%CS%'
	-- and b.dept ='方正外国语学生2025'
	and b.dept is not null
order by b.dept ,分组名称;

/*
SELECT b.id,
       b.person_name,
       b.test_num,
       b.dept,
       a.order_application_id
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 a
    INNER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 b ON a.person_id = b.id
WHERE order_group_item_name = '眼科检查'
  AND order_group_item_project_name = '色觉'
  AND result IS NULL
  AND is_pass  in ('3','4')
  AND b.del_flag <> 1
  AND a.del_flag <> 1
  AND person_name NOT LIKE '%CS%';


*/
/*
SELECT request_param
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
WHERE request_param LIKE '%90001081302%';
	*/
