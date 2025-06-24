-- 基础表-大项目
SELECT * 
from t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
where name ='血常规+CRP'
limit 100; #id 104

-- 基础表-小项目
SELECT *
from t_base_project_f594102095fd9263b9ee22803eb3f4e5 
WHERE id ='0101002' # 关联t_portfolio_project
limit 100;

-- 关系表-大项目&小项目
SELECT *
from relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5
where portfolio_project_id  ='104' #关联 portfolio_project_id(大项目id)/base_project_id(小项目id)
limit 100; 


-- 团建单位表
select *
from t_group_unit_f594102095fd9263b9ee22803eb3f4e5
where name ='测试团检1'
limit 100;-- ab199c459268bb70935c88fe49eeef7c

-- 团建订单表
SELECT *
from t_group_order_f594102095fd9263b9ee22803eb3f4e5
where group_unit_id='ab199c459268bb70935c88fe49eeef7c' #关联团建单位表t_group_unit
			and order_code='202506160004'
limit 100;-- 804a9b05afe53bd0035ce714581ec211

-- 团检订单表下的分组表
SELECT	*
from t_order_group_f594102095fd9263b9ee22803eb3f4e5
where group_order_id='804a9b05afe53bd0035ce714581ec211' #关联团建订单表t_group_order
limit 100;-- 249219c852d943be9563abdece70b961

-- 分组下面的组合项目(大项目)表(基础表-大项目)
SELECT *
FROM t_order_group_item_f594102095fd9263b9ee22803eb3f4e5
where group_id='249219c852d943be9563abdece70b961'	#关联团检订单表下的分组表 t_order_group
limit 100;-- 0120193e8d6048b784d7961db527c07f

-- 分组下面组合项目的小项目(基础表-小项目)
SELECT *
FROM t_order_group_item_project_f594102095fd9263b9ee22803eb3f4e5
where t_order_group_item_id='0120193e8d6048b784d7961db527c07f'
limit 100;-- c167eacc9ef6df8f18fb9ca48e644257


-- 团检订单表下的分组表下的人员表
	-- 通过订单下的分组查人员列表(订单分组下的部分人员信息)
SELECT * 
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
where group_id ='249219c852d943be9563abdece70b961'	#关联团检订单表下的分组表t_order_group ,t_group_person中的group_id为t_order_group的ID
limit 100;-- 3f17e041626f4ddcb78186e950f6ad14

	-- 通过订单ID查人员列表(订单全部人员信息)
SELECT * 
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
where order_id ='527dc6eb51dc6ede427ca3a91db1640f'	#关联团检订单表下的分组表t_order_group ,t_group_person中的group_id为t_order_group的ID
limit 100;

SELECT *
from t_group_order_f594102095fd9263b9ee22803eb3f4e5
where order_code='202506180004'
limit 100;

/*
 *保存信息更改: 体检人员工作部门(单位名称)、修改人、修改时间、头像
 *确认登记修改: 修改时间、是否通过检查(1-登记，2-在检,3-总检,4-已完成)、登记时间
 *
 */

-- 分诊--体检结果 
select *
from t_depart_result_f594102095fd9263b9ee22803eb3f4e5
where person_id='3f17e041626f4ddcb78186e950f6ad14'
	and del_flag=0
limit 100;

select *
from t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5
where person_id='4a3cf6356d7845aea60aca35c558f806'
			and  depart_result_id='4e6de6f44fd611f0a48e0242ac110006'
limit 100;

-- 总检表
SELECT *
FROM t_inspection_record_f594102095fd9263b9ee22803eb3f4e5
where person_id='3f17e041626f4ddcb78186e950f6ad14'
limit 100;





















---------------------------------------------
-- 查询订单下的大项目
SELECT tgo.id, tgo.order_name, tog.name as group_name, togi.name as project_name
from t_group_order_f594102095fd9263b9ee22803eb3f4e5 tgo
left JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 tog on tgo.id = tog.group_order_id and tog.del_flag = '0'
left join t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 togi on tog.id = togi.group_id and togi.del_flag = '0'
where tgo.order_code = '202506160004'
  and tgo.del_flag = '0'
limit 100;

-- 查询该分组下的大项目（组合项目）
SELECT ogi.*
FROM t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 bp
ON ogi.portfolio_project_id = bp.id and bp.del_flag = 0
WHERE ogi.group_id IN (
		SELECT group_id
		FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
		WHERE person_name = '陈震南'
		and del_flag = 0
		)
and ogi.del_flag = 0
LIMIT 100;

-- 查询该分组下每个大项目的子项目（小项目）
SELECT ogip.*, bsp.name AS sub_project_name
FROM t_order_group_item_project_f594102095fd9263b9ee22803eb3f4e5 ogip
JOIN t_base_project_f594102095fd9263b9ee22803eb3f4e5 bsp ON ogip.base_project_id = bsp.id and bsp.del_flag = 0
WHERE ogip.t_order_group_item_id IN (
		SELECT id
		FROM t_order_group_item_f594102095fd9263b9ee22803eb3f4e5
		WHERE group_id IN (
				SELECT group_id
				FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
				WHERE person_name = '陈震南'
				and del_flag = 0
				)
		)
and ogip.del_flag = 0
LIMIT 100;

-- 查询该人员的分诊结果
SELECT dr.*
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
WHERE dr.person_id IN (
	SELECT id
	FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
	WHERE person_name = '陈震南'
)
LIMIT 100;

-- 查询该人员具体的体检项目结果
SELECT dir.*
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
WHERE dir.person_id IN (
	SELECT id
	FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
	WHERE person_name = '张三'
)
LIMIT 100;
