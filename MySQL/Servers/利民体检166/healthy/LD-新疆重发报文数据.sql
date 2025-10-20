
SELECT gp.patient_id,
       gp.test_num,
       gp.person_name,
			 gp2.name,
       gp2.barcode,
       og.name,
       lg.order_application_id,
       lg.request_param
FROM t_log_f594102095fd9263b9ee22803eb3f4e5 lg
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.barcode = lg.order_application_id
    LEFT JOIN (SELECT gp.id,
                      gp.patient_id,
                      gp.person_name,
                      gp.test_num,
                      og.name,
                      gp.group_id
               FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
                   LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
               WHERE og.id = 'd1717631b4544b6fa7c95edcfbfb2ace'
                 AND gp.patient_id IN (
                   SELECT gp.patient_id
                   FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
                   WHERE gp.group_id = 'a7e45e24f0154aac92a8c8227844167d'
                     AND gp.patient_id <> '2025046508'
               )) gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN (SELECT gp.patient_id,
                      og.name,
                      dr.barname,
                      dr.barcode
               FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
                   LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
                   LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
               WHERE og.id = 'a7e45e24f0154aac92a8c8227844167d'
                 AND gp.patient_id IN (
                   SELECT gp.patient_id
                   FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
                   WHERE gp.group_id = 'a7e45e24f0154aac92a8c8227844167d'
                     AND gp.patient_id <> '2025046508'
               )
                 AND dr.barname = '常规心电图自动分析') gp2 ON gp2.patient_id = gp.patient_id
WHERE dr.barname = '常规心电图自动分析'
  AND lg.request_param LIKE '%常规心电图自动分析%'
  AND lg.log_type = 2
  AND lg.name IN ('PacsReceiveHL7Message', 'ReceiveHL7Message')
  AND gp.patient_id IS NOT NULL;