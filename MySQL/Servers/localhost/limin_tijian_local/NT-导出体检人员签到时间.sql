SET @orderCode = '202509300001';
SELECT DISTINCT
       DENSE_RANK() OVER (ORDER BY gp.inspection_time,og.name,gp.patient_id ASC) AS 序号,
       go.order_code AS 订单号,
       go.order_name AS 订单名称,
       SUBSTRING_INDEX(og.name, '-', 1) AS 分组名称,
       gp.test_num AS 体检编号,
       gp.patient_id AS HIS号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号,
       -- dr.order_application_id AS 申请单号,
       -- dr.barcode AS 合管申请号,
       -- dr.office_name AS 科室名称,
       CAST(gp.inspection_time AS CHAR) AS 指引单打印时间,
       CAST(MIN(dir.check_date) AS CHAR) AS 体检时间
       -- CAST(MIN(IFNULL(gp.inspection_time, dir.check_date)) AS CHAR) AS 最小时间
       -- dr.group_item_name AS 检测项目
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
              ON dir.del_flag <> '1' AND dr.id = dir.depart_result_id
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE dr.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dir.office_id IN ('90401', '90402', '90403', '90404', '90405', '90120')
  AND go.order_code = @orderCode
   AND CAST(gp.inspection_time AS  CHAR(10))  = CAST(now() AS CHAR(10))
GROUP BY
    go.order_code,
    go.order_name,
    og.name,
    gp.test_num,
    gp.patient_id,
    gp.person_name,
    gp.id_card,
    gp.inspection_time
HAVING MIN(IFNULL(gp.inspection_time, dir.check_date)) IS NOT NULL
ORDER BY
    序号,
    指引单打印时间;



