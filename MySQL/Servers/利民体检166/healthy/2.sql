SELECT SUBSTRING(og.name, LOCATE('-', og.name) + 1) AS 专业,
       gp.person_name AS 姓名,
			 count(gp.person_name)
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     JOIN
     t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
     JOIN
     t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND go.order_name = '文登北洋幸星电子2025'
GROUP BY SUBSTRING(og.name, LOCATE('-', og.name) + 1),gp.person_name
HAVING gp.person_name >1