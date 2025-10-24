-- ALL
-- 心电图室-90401；影像科-90402；彩超室-90403；病理科-90404；检验科-90405；内镜中心-90120
SET @orderCode = '202509160001';
-- 2. result表没有结果
DROP TEMPORARY TABLE IF EXISTS temp_OrderIdLisLost;
CREATE TEMPORARY TABLE temp_OrderIdLisLost AS
SELECT  dir.barcode AS OrderIdLost,
       gp.person_name AS 姓名,
			 dir.order_group_item_name,
			 SUM(ISNULL(result)),COUNT(*)
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dr.del_flag <> '1'
  AND dir.del_flag <> '1'
  AND dr.group_item_name <> 'γ干扰素释放试验'
  AND dir.office_id IN ('90401','90402','90403','90404','90405','90120')
	AND go.order_code = @orderCode		
GROUP BY
    dir.barcode,
    dir.office_id,
		dir.order_group_item_name,
		gp.person_name
HAVING SUM(ISNULL(result)) <> COUNT(1)
order by 姓名,OrderIdLost,SUM(ISNULL(result));		

-- 4.LOG表没有回传报文，result表没有结果
SELECT DISTINCT
			DENSE_RANK() OVER (ORDER BY CASE WHEN gp.is_pass = 1 THEN 1
																							WHEN gp.is_pass = 2 THEN 2
																							WHEN gp.is_pass = 3 THEN 3
																							ELSE 4 END,
								og.name,gp.patient_id ASC) AS 去重序号,
			 go.order_code AS 订单号,
       go.order_name AS 订单名称,
       og.name AS 分组名称,
       gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       dr.order_application_id AS 申请单号,
       dr.barcode AS 合管申请号,
       dr.office_name AS 科室名称,
       CASE WHEN gp.is_pass = 1 THEN '登记'
            WHEN gp.is_pass = 2 THEN '在检'
            WHEN gp.is_pass = 3 THEN '总检'
            ELSE '已完成'
           END AS 体检状态,
       CASE WHEN gp.fee_status = 2 THEN '已退费'
            WHEN gp.fee_status = -99 THEN '退费中'
            ELSE NULL
           END AS 收费状态,
       dr.group_item_name AS 检测项目
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr 
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON  dir.del_flag <> '1' AND dr.id = dir.depart_result_id
		LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE dr.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
	AND dir.office_id IN ('90401','90402','90403','90404','90405','90120')
  AND go.order_code = @orderCode
  AND COALESCE(dr.barcode,dr.order_application_id) IN (SELECT OrderIdLost FROM temp_OrderIdLisLost)
  -- AND rppc.state <> 2 -- 排除已弃检项目
	-- 	and dr.group_item_name like '%常规心电图自动分析%'
ORDER BY
去重序号,
    分组名称,
		检测项目;