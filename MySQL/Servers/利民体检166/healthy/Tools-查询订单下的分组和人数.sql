-- 通过订单名称查询该订单下所有分组的人员信息
SELECT DISTINCT
    go.order_name AS 订单名称,
    og.name AS 分组名称,
		SUM(og.person_count)AS 分组总人数
FROM t_group_order_f594102095fd9263b9ee22803eb3f4e5 go
LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.group_order_id = go.id 
WHERE	og.del_flag=0
		and go.del_flag=0
    AND go.order_name = '哈工大研究生25级'
GROUP BY go.order_name,og.name WITH ROLLUP
HAVING GROUPING(go.order_name)=GROUPING(og.name)
ORDER BY 
    分组总人数,分组名称
