set @testNum='176240884300300';
SELECT distinct 
				gp.test_num,
       gp.person_name,
       @patientId := gp.patient_id,
       dr.barcode,
			 dr.create_date,
			 lg.request_param,
			 dr.barname
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON gp.id = dr.person_id
left join t_log_f594102095fd9263b9ee22803eb3f4e5 lg on lg.order_application_id=dr.barcode and `name` LIKE '%HL7Message%' 
WHERE gp.test_num = @testNum
order by dr.barname,dr.create_date;

# 2.查找需要的报文
SELECT create_time,request_param
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
where  request_param like  concat ('%',@patientId,'%')
	and `name` LIKE '%HL7Message%' 
ORDER BY `create_time` DESC
LIMIT 200
/*
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
WHERE gp.test_num =@testNum
order by left(hrul.create_time,19) desc;

*/