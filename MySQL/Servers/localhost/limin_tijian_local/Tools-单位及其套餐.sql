-- 查询单位和单位所有套餐名
SELECT DISTINCT
       go.order_name AS 订单名称,
       cb.name AS 套餐名称
FROM t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON ogi.group_id = og.id AND og.del_flag <> '1'
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
    LEFT JOIN t_combo_f594102095fd9263b9ee22803eb3f4e5 cb ON og.combo_id = cb.id
WHERE ogi.del_flag <> '1'
  -- AND go.order_name = '恒德技工技术学院2025'
  AND cb.name IS NOT NULL
  AND og.create_time > '2025-09-01'
GROUP BY
    go.id,
    go.order_name,
    og.id,
    og.name,
    og.combo_id;
