/*依据港城的描述，我做了这么个样式，跟他确认过了。
按时间段统计的工作量统计报表：1.科室2.项目名称3.原价4.个检人数5.个检折扣价6.团检人数7.团检折扣价8.收费状态（先不加）
注意：1、原价、折扣价如果有多个，就显示多条，参照截图的报表；--不仅仅是折扣价有个显示多条，原价有多个也显示多条；
2、收费状态，暂时先放个空值，，，和港城商量着：等测试稳定了，再加上值

”1、原价、折扣价如果有多个，就显示多条  “   其中原价在过程表中没有存储，如果需要统计多个原价，需要在过程表中增加原价字段。
*/

-- order_group_item_project 的 code
SELECT ogi.office_name 科室,ogip.code 项目代码,ogi.name 项目名称,ogi.sale_price 原价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)=1 then 1 else 0 end),0) 个检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)=1 then ogi.discount_price else 0 end,0) 个检折扣价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)<>1 then 1 else 0 end),0) 团检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)<>1 then ogi.discount_price else 0 end,0) 团检折扣价,
			null '收费状态'
from t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on  gp.group_id=ogi.group_id and gp.del_flag<>1
left join t_order_group_item_project_f594102095fd9263b9ee22803eb3f4e5 ogip on ogip.t_order_group_item_id= ogi.id
where ogi.del_flag<>1
			and gp.id is not null
			#and ogi.office_id='90410'
group by ogi.office_name,ogip.code,ogi.name,ogi.sale_price,ogi.discount_price,gp.sporadic_physical

order by 科室,项目代码,项目名称,原价;


-- portfolio_project  的 his_code
SELECT ogi.office_name 科室,pp.his_code 项目代码,ogi.name 项目名称,ogi.sale_price 原价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)=1 then 1 else 0 end),0) 个检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)=1 then ogi.discount_price else 0 end,0) 个检折扣价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)<>1 then 1 else 0 end),0) 团检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)<>1 then ogi.discount_price else 0 end,0) 团检折扣价,
			null '收费状态'
from t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on  gp.group_id=ogi.group_id and gp.del_flag<>1
left join t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp on pp.id= ogi.portfolio_project_id and pp.del_flag<>1
where ogi.del_flag<>1
			and gp.id is not null
group by ogi.office_name,pp.his_code,ogi.name,ogi.sale_price,ogi.discount_price,gp.sporadic_physical
order by 科室,项目代码,项目名称,原价;


