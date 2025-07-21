SELECT distinct pb.person_id 'personId',pb.patient_name '姓名',dr.order_application_id'申请单ID',
ld.report_doctor 'lis报告医生',
ld.apply_depart 'lis执行科室^^科室编号',
ld.report_name 'lis报告单名称',
ld.check_report_time'lis审核报告发布时间',
pd.report_doctor'pacs报告医生',
pd.apply_depart 'pacs执行科室^^科室编号',
pd.obr_project_code_name 'pacs报告单名称',
pd.report_time 'pacs报告时间'
from t_person_bill_f594102095fd9263b9ee22803eb3f4e5 pb
left join t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr on dr.person_id=pb.person_id
left join t_lis_data_f594102095fd9263b9ee22803eb3f4e5 ld on ld.order_application_id=  dr.order_application_id
left join t_pacs_data_f594102095fd9263b9ee22803eb3f4e5 pd on pd.order_application_id=dr.order_application_id
WHERE  pb.patient_name ='王艺安' 
			and dr.order_application_id is not null
			and (ld.report_name is not null or pd.report_name is not null)
order by ld.check_report_time,pd.report_time