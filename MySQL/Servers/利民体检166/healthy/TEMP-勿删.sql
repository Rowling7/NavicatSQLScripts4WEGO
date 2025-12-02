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