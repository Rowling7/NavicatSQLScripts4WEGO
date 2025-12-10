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