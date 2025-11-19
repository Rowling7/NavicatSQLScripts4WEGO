# 1.查人得项目
-- 个检176059820000002  2025048590
-- 团检176059799600001  2025048588
SELECT gp.test_num,
       gp.person_name,
       gp.patient_id,
       dr.group_item_name,
       dr.barcode,
			 dr.barname
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON gp.id = dr.person_id
WHERE gp.test_num IN ('176240883200003')
-- and dr.barcode ='90001104535';
--  AND dr.group_item_name LIKE '%血常规%';

# 2.查找需要的报文
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

# 3.查看更新进度
SELECT gp.test_num,
			 hrul.patient_id,
			 gp.person_name,
       hrul.order_application_id,
       dr.group_item_name,
       left(hrul.create_time,19),
       hrul.is_completed,
       hrul.`status`
FROM healthy_result_update_list hrul
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON hrul.order_application_id = dr.barcode
		LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on dr.person_id=gp.id
WHERE gp.test_num IN ('176284648300464')
order by gp.test_num asc,left(hrul.create_time,19) desc;