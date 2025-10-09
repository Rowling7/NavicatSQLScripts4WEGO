-- 申请开立|心电图室-0401 影像科-0402 彩超室-0403 内镜中心-0120
WITH OrderIdHL7 AS (
SELECT distinct dr.barcode AS param
			FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
			LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5  og ON gp.group_id = og.id
			LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5  go ON og.group_order_id = go.id
			LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
			WHERE gp.del_flag <> '1'
				AND og.del_flag <> '1'
				AND go.del_flag <> '1'
				AND dr.del_flag <> '1'
				AND go.order_code='202509300001'
				-- and gp.person_name ='王丽'
				-- AND go.order_name = '威海市明德职业中等专业学校2025'
)

SELECT distinct DENSE_RANK() OVER (ORDER BY SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PID||', -1), '|||', 1) ASC) AS 序号,
id AS ID,
			 STR_TO_DATE(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, '||', 3), '||', -1), '%Y%m%d%H%i%s')  AS 申请时间,
       name AS 名称,
       rtrim(substring_index(substring_index(substring_index(request_param,'D|||',-1),'OBR|',1),'^^',1)) AS 科室,
			 SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, '^^^', 1), '|||', -1) AS 姓名,
       SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PID||', -1), '|||', 1) AS HIS号,-- patient_id AS HIS号,
			 left(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PV1||', 1),'|', -1),18) as 身份证号,
       SUBSTRING_INDEX(CASE
           WHEN request_param LIKE '%ORC|NW|%' 
							THEN concat(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|NW|', -1), '|||||||', 1),'-','NW')
           WHEN request_param LIKE '%ORC|CA|%' 
							THEN concat(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|CA|', -1), '|||||||', 1),'-','CA')
           ELSE NULL END,'^^',-1) AS 申请单号
			 ,request_param AS 请求参数
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
WHERE log_type = 2
	AND del_flag = 0
	AND name ='检查开立'
	AND LEFT(substring_index(substring_index(substring_index(request_param,'D|||',-1),'OBR|',1),'^^',-1),4) in( '0401','0402','0403','0120')
	AND SUBSTRING_INDEX(CASE
           WHEN request_param LIKE '%ORC|NW|%'THEN SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|NW|', -1), '|||||||', 1)
           WHEN request_param LIKE '%ORC|CA|%'THEN SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|CA|', -1), '|||||||', 1)
           ELSE NULL END,'^^',-1) IN (SELECT param FROM OrderIdHL7)
ORDER BY 序号 asc,申请单号 desc;

/*
SELECT distinct dr.barcode AS param
			FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
			LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5  og ON gp.group_id = og.id
			LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5  go ON og.group_order_id = go.id
			LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
			WHERE gp.del_flag <> '1'
				AND og.del_flag <> '1'
				AND go.del_flag <> '1'
				AND dr.del_flag <> '1'
				AND go.order_code='202509300001'
				and dr.office_id in( '90401','90402','90403','90120')*/