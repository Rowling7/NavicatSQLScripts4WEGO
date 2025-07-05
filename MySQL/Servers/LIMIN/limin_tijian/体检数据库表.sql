/*
* 查询团检订单
* order_name 订单名称
* group_unit_name 团建单位
* order_code 团检单号
* department_id 未知
* del_flag 1为已删除
*/
SELECT id,order_code,order_name,group_unit_id,group_unit_name,physical_type
			,person_count,order_price,order_total,order_discount
FROM t_group_order_f594102095fd9263b9ee22803eb3f4e5
where order_name like '%测试20250705-C4%'
			and del_flag<>'1' 
ORDER BY department_id desc
limit 10;


SELECT go.order_name,og.*
from t_order_group_f594102095fd9263b9ee22803eb3f4e5 og
left join t_group_order_f594102095fd9263b9ee22803eb3f4e5 go on go.id=og.group_order_id
where go.order_name like '%测试20250705-C4%'-- ='1aa8f6b72fbe870cc2e3f30d4739ce31' #关联团建订单表t_group_order
limit 100;-- 249219c852d943be9563abdece70b961

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
FROM t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og 
    ON ogi.group_id = og.id AND og.del_flag <> '1'
JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go 
    ON og.group_order_id = go.id AND go.del_flag <> '1'
WHERE ogi.del_flag <> '1'
			AND go.order_name like '%测试20250705-C4%'
ORDER BY og.name,ogi.order_num,ogi.name;


-- 总检
SELECT distinct dr.*
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
left join t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir on dr.id=dir.depart_result_id and dir.del_flag<>'1'
where dr.del_flag<>'1'
			and dr.person_id ='1ba7cbc6e2cc486ebb46bb116ab2d18a'
			-- and group_item_name='外科检查'
ORDER BY group_item_id;



SELECT *
from t_positive_person_f594102095fd9263b9ee22803eb3f4e5
where person_id='1ba7cbc6e2cc486ebb46bb116ab2d18a'
limit 10;
