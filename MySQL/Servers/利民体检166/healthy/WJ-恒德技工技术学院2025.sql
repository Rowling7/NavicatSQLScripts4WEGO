
-- LIS、PACS 结果
SELECT DISTINCT
       gp.id AS 'personId',
       gp.person_name AS '人员姓名',
       pd.create_time AS '申请时间',
       dr.order_application_id '申请单ID',
       dr.group_item_name AS '分组项目名称',
       dr.diagnose_tip AS '诊断提醒',
       dr.diagnose_sum AS '诊断小结',
       dr.update_date AS '更新时间',
       ld.report_doctor AS 'lis报告医生',
       ld.report_name AS 'lis报告单名称',
       ld.check_report_time 'lis审核报告发布时间',
       ld.project_result AS 'lis项目结果',
       pd.report_doctor 'pacs报告医生',
       pd.obr_project_code_name AS 'pacs报告单名称',
       pd.report_time AS 'pacs报告时间',
       pd.check_result AS 'pacs项目结果'
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
     LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
     LEFT JOIN t_lis_data_f594102095fd9263b9ee22803eb3f4e5 ld ON ld.order_application_id = dr.order_application_id
     LEFT JOIN t_pacs_data_f594102095fd9263b9ee22803eb3f4e5 pd ON pd.order_application_id = dr.order_application_id
WHERE-- gp.person_name LIKE '%徐礼帅%'
  -- AND GP.test_num = ''
  -- AND pd.report_time <'2025-09-03 08:05:23'  
  go.order_name = '恒德技工技术学院2025'
  AND dr.group_item_name in( 'T肝功5项','血常规','胸部正位')
  AND gp.del_flag <> 1
  -- AND dr.del_flag <> 1
  -- AND pd.del_flag <> 1
  -- AND ld.del_flag <> 1
	and ld.report_doctor is null 
	and pd.report_doctor is null
ORDER BY gp.person_name
       , pd.create_time
       , ld.check_report_time
       , pd.report_time DESC
