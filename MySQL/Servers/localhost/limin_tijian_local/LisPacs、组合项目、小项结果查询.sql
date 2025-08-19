-- 组合项目结果
SELECT DISTINCT
       gp.test_num AS '体检编号',
       gp.person_name AS '人员姓名',
       gp.patient_id AS 'HIS编号',
       og.name AS '分组名称',
       ogi.name AS '分组项目',
       dr.diagnose_sum AS '诊断结果'
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
     LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi ON og.id = ogi.group_id
     LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.group_item_id = ogi.id
WHERE gp.person_name = '刘书村'
  -- AND GP.test_num = ''
  AND gp.del_flag <> 1
  AND og.del_flag <> 1
  AND dr.del_flag <> 1;


-- 组合项目的小项结果
SELECT DISTINCT
       gp.test_num AS '体检编号',
       gp.person_name AS '人员姓名',
       gp.patient_id AS 'HIS编号',
       og.name AS '分组名称',
       ogi.name AS '分组项目',
			 dir.order_application_id AS '申请单号',
			 dir.create_date AS '申请时间',
       dir.update_date AS '检查时间',
       dir.order_group_item_project_name AS '小项名称',
       dir.result AS '项目结果'
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
     LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi ON og.id = ogi.group_id
     LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dir.order_group_item_id = ogi.id
WHERE gp.person_name = '王艺安'
  -- AND GP.test_num = ''
	AND DATE_FORMAT(dir.create_date, '%Y-%m-%d') like '%2025-08-18%'
  AND dir.del_flag <> 1
  AND gp.del_flag <> 1
  AND og.del_flag <> 1
ORDER BY DATE_FORMAT(dir.create_date, '%Y-%m-%d') desc,项目结果 desc,检查时间 desc;

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
     LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
     LEFT JOIN t_lis_data_f594102095fd9263b9ee22803eb3f4e5 ld ON ld.order_application_id = dr.order_application_id
     LEFT JOIN t_pacs_data_f594102095fd9263b9ee22803eb3f4e5 pd ON pd.order_application_id = dr.order_application_id
WHERE gp.person_name LIKE '%刘书村%'
  -- AND GP.test_num = ''
  AND gp.del_flag <> 1
  AND dr.del_flag <> 1
  AND pd.del_flag <> 1
  AND ld.del_flag <> 1
ORDER BY gp.person_name
       , pd.create_time
       , ld.check_report_time
       , pd.report_time DESC
