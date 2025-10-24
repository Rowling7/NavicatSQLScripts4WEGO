SELECT go.order_name AS 订单名称,
       SUBSTRING(og.name, 1, LOCATE('-', og.name) - 1) AS 学院,
			 SUBSTRING(og.name, LOCATE('-', og.name) + 1) AS 专业,
       count(SUBSTRING(og.name, LOCATE('-', og.name) + 1)) 人数
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  -- AND go.order_name = '恒德技工技术学院2025'
	AND go.order_code in ('202509100003','202508270672','202508270671','202508270670')

group by go.order_name,SUBSTRING(og.name, 1, LOCATE('-', og.name) - 1),SUBSTRING(og.name, LOCATE('-', og.name) + 1) with rollup
having grouping(学院)=grouping(专业)and go.order_name is not null
order by 人数


