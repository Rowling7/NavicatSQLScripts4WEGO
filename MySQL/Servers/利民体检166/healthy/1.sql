SELECT 

       gp.person_name AS 姓名,
			 gp.id_card as 身份证号,
			 SUBSTRING(og.name, 1, LOCATE('-', og.name) - 1) AS 学院,
       SUBSTRING(og.name, LOCATE('-', og.name) + 1) AS 专业,
       gp.test_num AS 体检号
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     JOIN
     t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
     JOIN
     t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND go.order_name = '哈工大新生25级-国际教育学院'
	and gp.person_name IN 

('何同同','徐梓淇','杨晋航','张城玮','张昕悦','孙铭泽','黄书航','谷思源','孙铭泽','李奕泽','徐宁泽','谭珏','赵婉汝','刘小幼','高翌芙','吴浩宇','闵智筱','张恩与','辛孝楠','盛奕塍','李雨涵','郭紫涵','苏海露')