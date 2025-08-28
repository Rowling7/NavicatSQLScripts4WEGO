-- 通过订单名称查询分组下的项目名称
SELECT 
    go.id AS orderId,
    go.order_name AS 订单名称,
    og.id AS groupId,
    og.name AS 分组名称,
    ogi.id AS itemId,
    ogi.name AS 项目名称,
    ogi.short_name AS 项目简称,
    ogi.sale_price AS 原价,
    ogi.discount_price AS 折扣价,
    ogi.suitable_range AS 适用范围
FROM 
    t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
JOIN 
    t_order_group_f594102095fd9263b9ee22803eb3f4e5 og 
    ON ogi.group_id = og.id AND og.del_flag <> '1'
JOIN 
    t_group_order_f594102095fd9263b9ee22803eb3f4e5 go 
    ON og.group_order_id = go.id AND go.del_flag <> '1'
WHERE 
    ogi.del_flag <> '1'
    AND go.order_name = '恒德技工技术学院2025'
ORDER BY 
    og.name,ogi.order_num,ogi.name;
