SELECT gp.patient_id,
       gp.test_num,
			 gp.person_name,
       dr.barcode,
			 dr.barname,
       dr.group_item_name,
       lg.request_param
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_positive_person_f594102095fd9263b9ee22803eb3f4e5 pp ON pp.person_id = gp.id
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON pp.order_group_item_name = dr.group_item_name
    LEFT JOIN t_log_f594102095fd9263b9ee22803eb3f4e5 lg ON dr.barcode = lg.order_application_id
WHERE pp.order_group_item_name LIKE '%T-尿常规%'
			and lg.name like '%ReceiveHL7Message%'
order by length(dr.barname) desc
LIMIT 30;
