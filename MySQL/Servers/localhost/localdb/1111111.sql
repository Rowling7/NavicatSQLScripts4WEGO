-- 个检176059820000002  2025048590
-- 团检176059799600001  2025048588
SELECT gp.test_num,
       gp.person_name,
       gp.patient_id,
       dr.group_item_name,
       dr.barcode
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON gp.id = dr.person_id
WHERE gp.test_num IN ('176066179500001');
 --  AND dr.group_item_name LIKE '%T肝功12项%';



SELECT hrul.patient_id,
			 gp.person_name,
       hrul.order_application_id,
       dr.group_item_name,
       hrul.create_time,
       hrul.is_completed,
       hrul.`status`
FROM healthy_result_update_list hrul
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON hrul.order_application_id = dr.barcode
		LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on dr.person_id=gp.id
WHERE hrul.patient_id IN ('2025034902')
order by hrul.patient_id;