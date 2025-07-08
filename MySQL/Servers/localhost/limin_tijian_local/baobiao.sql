
SELECT ogi.office_name 科室,ogip.code 项目代码,ogi.name 项目名称,ogi.sale_price 原价,
			sum(case when ifnull(gp.sporadic_physical,0)=1 then 1 else 0 end) 个检人数 ,
			case when ifnull(gp.sporadic_physical,0)=1 then ogi.discount_price else 0 end 个检折扣价,
			sum(case when ifnull(gp.sporadic_physical,0)<>1 then 1 else 0 end) 团检人数 ,
			case when ifnull(gp.sporadic_physical,0)<>1 then ogi.discount_price else 0 end 团检折扣价,
			null '收费状态'
from t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on  gp.group_id=ogi.group_id and gp.del_flag<>1
left join t_order_group_item_project_f594102095fd9263b9ee22803eb3f4e5 ogip on ogip.t_order_group_item_id= ogi.id
where ogi.del_flag<>1
			and gp.id is not null
			#and ogi.office_id='90410'
group by ogi.office_name,ogip.code,ogi.name,ogi.sale_price,ogi.discount_price,gp.sporadic_physical

order by 科室,项目代码,项目名称,原价