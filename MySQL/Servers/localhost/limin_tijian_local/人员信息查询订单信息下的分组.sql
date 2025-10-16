-- 通过订单名称查询该订单下所有分组的人员信息
SELECT distinct

    og.id AS 分组ID,
    og.name AS 分组名称
FROM
    t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
JOIN
    t_order_group_f594102095fd9263b9ee22803eb3f4e5 og
    ON gp.group_id = og.id and og.del_flag<>'1'
JOIN
    t_group_order_f594102095fd9263b9ee22803eb3f4e5 go
    ON og.group_order_id = go.id and go.del_flag<>'1'
WHERE
		gp.del_flag<>'1'
		and go.order_code='202509100002'
ORDER BY
    og.name, gp.person_name;





