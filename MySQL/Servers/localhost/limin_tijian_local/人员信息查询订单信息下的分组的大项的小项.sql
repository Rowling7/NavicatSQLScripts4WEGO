SELECT distinct
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
    og.person_count AS 分组总人数,
		ogi.id AS itemId,
    ogi.name AS 项目名称,
    -- ogi.short_name AS 项目简称,
    ogi.sale_price AS 原价,
		ogi.discount AS 折扣,
    ogi.discount_price AS 折扣价,
    -- ogi.suitable_range AS 适用范围,
		ogi.address AS 检查地址,
		ogip.base_project_id AS 基础项目id,
		ogip.name AS 名称
FROM
    t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
JOIN
    t_order_group_f594102095fd9263b9ee22803eb3f4e5 og
    ON gp.group_id = og.id AND og.del_flag<>'1'
JOIN
    t_group_order_f594102095fd9263b9ee22803eb3f4e5 go
    ON og.group_order_id = go.id AND go.del_flag<>'1'
JOIN 
		t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
		ON ogi.group_id = og.id AND ogi.del_flag<>'1'
JOIN
		t_order_group_item_project_f594102095fd9263b9ee22803eb3f4e5 ogip
		ON ogip.t_order_group_item_id=ogi.id AND ogip.del_flag<>'1'
WHERE
		gp.del_flag<>'1'
    AND gp.person_name='曹勇嵩'
		AND gp.id_card='371083199808117516'
		AND go.order_name='互联科技2025-07'
ORDER BY
    og.name, gp.person_name;





