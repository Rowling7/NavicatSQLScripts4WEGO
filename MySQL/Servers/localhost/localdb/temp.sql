SELECT go.id AS 订单ID,
       go.order_code AS 订单编号,
       go.order_name AS 订单名称,
			 CAST(go.create_time AS  CHAR(10)),
       COUNT(SUBSTRING(og.name, LOCATE('-', og.name) + 1)) AS 人数
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
WHERE gp.del_flag <> '1'
  -- and go.create_id='1945638889813315584'
  AND CAST(go.create_time AS  CHAR(10)) >=  '2025-08-31'
--  AND go.order_code = '202508310001'
GROUP BY
    go.id,
    go.order_code,
    go.order_name,
    CAST(go.create_time AS  CHAR(10))
ORDER BY
   go.create_time
