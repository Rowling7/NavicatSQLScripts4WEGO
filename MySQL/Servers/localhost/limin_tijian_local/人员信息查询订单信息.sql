SELECT
    gp.id AS personId,
    gp.person_name 姓名,
    gp.sex 性别,
    gp.id_card 身份证号,
    gp.mobile 手机号,
    gp.dept AS 团检单位,
		go.id AS orderID,
		go.order_name AS 订单名称,
    og.id AS 分组ID,
    og.name AS 分组名称,
    og.person_count AS 分组总人数
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
    AND gp.person_name='田晓明'
		and gp.id_card='824299195501309857'
ORDER BY
    og.name, gp.person_name;





