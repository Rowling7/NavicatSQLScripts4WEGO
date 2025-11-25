SELECT ROW_NUMBER( ) OVER (ORDER BY gu.`name`,og.`name`,person_name) AS 序号
     , gp.person_name AS 姓名
     , gp.test_num AS 体检号
		 , gp.age AS 年龄
     , gp.sex AS 性别
     , gp.mobile AS 手机号
     , gu.`name` AS 单位
		 -- , og.`name` as 分组
     , REGEXP_REPLACE(og.`name`, '-\\d+$', '') AS 分组
     , pp.order_group_item_name AS 检测项目
     , pp.positive_name AS 阳性名称
     , pp.medical_explanation AS 医学解释
     , pp.positive_suggestion AS 阳性建议
     , pp.feedback AS 阳性备注
     , tu.nickname AS 上报人
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
     LEFT JOIN t_group_unit_f594102095fd9263b9ee22803eb3f4e5 gu ON go.group_unit_id = gu.id
     LEFT JOIN t_positive_person_f594102095fd9263b9ee22803eb3f4e5 pp ON gp.id = pp.person_id
     LEFT JOIN t_user tu ON COALESCE( pp.update_id , pp.create_id ) = tu.id
WHERE pp.del_flag <> 1
  AND tu.del_flag <> 1
  AND gp.del_flag <> 1
  AND og.del_flag <> 1
  AND go.del_flag <> 1
  AND gu.del_flag <> 1
  AND pp.heavy = 'A';