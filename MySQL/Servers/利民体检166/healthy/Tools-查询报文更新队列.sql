SELECT gp.test_num,
			 hrul.patient_id,
			 gp.person_name,
			 hrul.order_application_id,
       hrul.create_time,
       hrul.is_completed,
       hrul.status
FROM healthy_result_update_list hrul
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on gp.patient_id=hrul.patient_id
WHERE hrul.order_application_id LIKE '%90001120771%'