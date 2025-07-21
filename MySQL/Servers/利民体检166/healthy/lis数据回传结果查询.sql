SELECT distinct pb.person_id,pb.patient_name,dr.order_application_id,ld.report_doctor,ld.report_name,ld.check_report_time
from t_person_bill_f594102095fd9263b9ee22803eb3f4e5 pb
left join t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr on dr.person_id=pb.person_id
left join t_lis_data_f594102095fd9263b9ee22803eb3f4e5 ld on ld.order_application_id=  dr.order_application_id
WHERE  pb.patient_name ='王艺安' 
			and dr.order_application_id is not null
			and ld.report_name is not null