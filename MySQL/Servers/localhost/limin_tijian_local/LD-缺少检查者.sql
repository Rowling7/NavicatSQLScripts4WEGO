SELECT DISTINCT
       gp.id AS personId,
			 go.order_name as name,
       gp.test_num AS 体检编号,
			 gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
			 gp.is_pass AS passcode,
       dir.office_name AS 科室名称,
       -- dir.order_group_item_project_name AS 项目名称,
       -- dir.result AS 体检结果,
       dir.diagnose_sum AS 体检小结,
       dir.check_date AS 检查日期,
       dir.check_doc AS 检查医生,
			 dir.barcode AS 申请单号
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dir.person_id = gp.id AND gp.del_flag <> '1'
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
WHERE dir.result IS NOT NULL
  AND office_name = '内科'
  AND (dir.check_date IS NULL OR dir.check_date IS NULL)
  AND dir.del_flag <> '1'
  AND go.id = 'c69cde7f08365de258fa2e9d93fbf4e0'




/*
SELECT DISTINCT
       gp.id AS personId,
			 go.order_name as name,
       gp.test_num AS 体检编号,
			 gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
			 gp.is_pass AS passcode,
       dir.office_name AS 科室名称,
       -- dir.order_group_item_project_name AS 项目名称,
       -- dir.result AS 体检结果,
       dir.diagnose_sum AS 体检小结,
       dir.check_date AS 检查日期,
       dir.check_doc AS 检查医生,
			 dir.barcode AS 申请单号
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dir.person_id = gp.id AND gp.del_flag <> '1'
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
WHERE dir.result IS NOT NULL
  AND office_name = '一般检查'
  AND (dir.check_date IS NULL OR dir.check_date IS NULL)
  AND dir.del_flag <> '1'
  AND gp.person_name in ('于文轩','宋锡林','胡俊熙','孙然','杨佳乐','仇成山','孙子皓','王正昊','陈泉宇','王翔')
*/