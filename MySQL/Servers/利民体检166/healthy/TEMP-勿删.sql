/*WITH portfolioProjectCount AS (

)*/
SELECT gp.test_num AS 体检号
     , gp.patient_id AS 患者ID
     , gp.person_name AS 患者姓名
     , gp.inspection_time AS 体检业务时间-- 打印导引单时间
     , ogi.portfolio_project_id AS 项目编码
     , pp.name AS 项目名称
     , '' AS 规格
     , pp.service_type AS 类别
     , ogi.sale_price AS 单价
     , '' AS 数量
     , ogi.sale_price * 1 AS '总金额(单价*数量)'
     , ogi.discount_price AS 折扣金额
     , u.department_title AS 开单科室
     , gp.inspector AS 开单医生
     , pp.office_name AS 执行科室
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    --  LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
     LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi ON ogi.group_id = gp.group_id
     LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp ON pp.id = ogi.portfolio_project_id
     LEFT JOIN t_user u ON u.nickname = gp.inspector
WHERE gp.test_num ='176464162300036'
;


-- INSERT INTO `healthy`.`t_group_order_bill_f594102095fd9263b9ee22803eb3f4e5` (`id`, `order_id`, `order_code`, `group_unit_id`, `group_unit_name`, `create_id`, `create_time`, `delete_id`, `delete_time`, `state`, `person_count`, `order_price`, `order_total`, `adjusted_total`, `fee_Status`, `order_name`, `bill_desc`) VALUES ('6f8f98cc-8358-4cb0-a7cd-56ffadc0a9de', '2e589ff7efc16d802d33afa48d0ec92a', '202509300001', '5595ff98bcbbb4bd52b1cf55974c3539', '歌尔年检2025', '1923367675095027712', '2025-11-24 07:52:10', NULL, NULL, -1, 1, 203011.0000, 203011.0000, 203011.0000, 99, '歌尔年检2025', '东星帮我传一下帐 203011');

SELECT  dir.person_id,gp.sex,count(distinct dir.person_id)
from t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir 
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on dir.person_id =gp.id
where dir.positive =1
and dir.del_flag <>1
and gp.dept='恒科精工2025'
and gp.del_flag <>1
and gp.is_pass>2
group by dir.person_id


-- count(if(gp.sex,'男',1)),

SELECT cb.`name` AS 套餐名称
     , ci.portfolio_project_id AS 组合项目ID
     , ppb.`name` AS 实际小项名称
     , pp.id AS 当前小项ID
     , pp.`name` AS 当前小项名称
FROM t_combo_f594102095fd9263b9ee22803eb3f4e5 cb
     LEFT JOIN t_combo_item_f594102095fd9263b9ee22803eb3f4e5 ci ON cb.id = ci.combo_id
     LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5_boceng ppb ON ci.portfolio_project_id = ppb.id and ppb.del_flag<>1
     LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp ON ppb.`name` = pp.`name` and pp.del_flag<>1
		 LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp2 ON ci.portfolio_project_id = pp2.id and pp2.del_flag<>1
WHERE pp2.`name` IS NULL
	and cb.del_flag<>1	
ORDER BY ppb.`name`