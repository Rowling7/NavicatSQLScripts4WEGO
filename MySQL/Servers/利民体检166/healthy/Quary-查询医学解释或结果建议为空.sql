SELECT gp.test_num,og.name,pp.medical_explanation,pp.positive_suggestion
from t_positive_person_f594102095fd9263b9ee22803eb3f4e5 pp 
left join  t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on pp.person_id=gp.id
		LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
		LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
	and go.id='2e589ff7efc16d802d33afa48d0ec92a'
	and pp.del_flag <>1
	and (pp.medical_explanation is null  or pp.positive_suggestion is null)