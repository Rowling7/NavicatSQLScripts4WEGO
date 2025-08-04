SELECT distinct gp.id AS 'personId',
                gp.person_name AS '人员姓名',
                pd.create_time AS '申请时间',
                dr.order_application_id'申请单ID',
                dr.group_item_name AS '分组项目名称',
                dr.diagnose_tip AS '诊断提醒',
                dr.diagnose_sum AS '诊断小结',
                dr.update_date AS '更新时间',
                -- ld.report_doctor AS 'lis报告医生',
                -- ld.apply_depart AS 'lis执行科室^^科室编号',
                ld.report_name AS 'lis报告单名称',
                ld.check_report_time'lis审核报告发布时间',
                -- pd.report_doctor'pacs报告医生',
                -- pd.apply_depart AS 'pacs执行科室^^科室编号',
                pd.obr_project_code_name AS 'pacs报告单名称',
                pd.report_time AS 'pacs报告时间'

from t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
left join t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr on dr.person_id=gp.id
left join t_lis_data_f594102095fd9263b9ee22803eb3f4e5 ld on ld.order_application_id=  dr.order_application_id
left join t_pacs_data_f594102095fd9263b9ee22803eb3f4e5 pd on pd.order_application_id=dr.order_application_id
WHERE  gp.person_name like  '%兰%'
order by gp.person_name,pd.create_time,ld.check_report_time,pd.report_time desc
