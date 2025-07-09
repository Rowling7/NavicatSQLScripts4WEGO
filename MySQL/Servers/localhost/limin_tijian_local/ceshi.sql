
-- portfolio_project  的 his_code
SELECT so.section_name 科室,pp.his_code 项目代码,ogi.name 项目名称,ogi.sale_price 原价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)=1 then 1 else 0 end),0) 个检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)=1 then ogi.discount_price else 0 end,0) 个检折扣价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)<>1 then 1 else 0 end),0) 团检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)<>1 then ogi.discount_price else 0 end,0) 团检折扣价,
			null '收费状态'
from t_section_office_f594102095fd9263b9ee22803eb3f4e5 so
left join t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp on so.id=pp.office_id and pp.del_flag<>1
left join t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi on pp.id= ogi.portfolio_project_id and ogi.del_flag<>1
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on  gp.group_id=ogi.group_id and gp.del_flag<>1
where so.del_flag<>1
			and gp.id is not null
group by so.section_name,pp.his_code,ogi.name,ogi.sale_price,ogi.discount_price,gp.sporadic_physical
order by 科室,项目代码,项目名称,原价;


SELECT so.section_name 科室,pp.his_code 项目代码,ogi.name 项目名称,ogi.sale_price 原价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)=1 then 1 else 0 end),0) 个检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)=1 then ogi.discount_price else 0 end,0) 个检折扣价,
			nullif(sum(case when ifnull(gp.sporadic_physical,0)<>1 then 1 else 0 end),0) 团检人数 ,
			nullif(case when ifnull(gp.sporadic_physical,0)<>1 then ogi.discount_price else 0 end,0) 团检折扣价,
			null '收费状态'
from t_section_office_f594102095fd9263b9ee22803eb3f4e5 so
left join t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp on so.id=pp.office_id and pp.del_flag<>1
left join t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi on pp.id= ogi.portfolio_project_id and ogi.del_flag<>1
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on  gp.group_id=ogi.group_id and gp.del_flag<>1
where so.del_flag<>1
			and gp.id is not null
group by so.section_name,pp.his_code,ogi.name,ogi.sale_price,ogi.discount_price,gp.sporadic_physical
order by 科室,项目代码,项目名称,原价;
