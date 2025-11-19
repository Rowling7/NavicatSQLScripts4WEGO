SET @orderCode = '202511060002';

SELECT
    序号,
    分组名称,
    体检编号,
    HIS号,
    姓名,
    身份证号,
    手机号,
    指引单打印时间,
    体检时间
FROM (
    SELECT DISTINCT
        DENSE_RANK() OVER (ORDER BY og.name, gp.patient_id) AS 序号,
        og.name AS 分组名称,
        gp.test_num AS 体检编号,
        gp.patient_id AS HIS号,
        gp.person_name AS 姓名,
        gp.id_card AS 身份证号,
        gp.mobile AS 手机号,
        CAST(gp.inspection_time AS CHAR) AS 指引单打印时间,
        CAST(MIN(dir.check_date) AS CHAR) AS 体检时间
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
      AND CAST(gp.inspection_time AS CHAR(10)) = CAST(NOW() AS CHAR(10))
    GROUP BY go.order_code, go.order_name, og.name, gp.test_num, gp.patient_id, gp.person_name, gp.id_card, gp.inspection_time
    HAVING MIN(IFNULL(gp.inspection_time, dir.check_date)) IS NOT NULL

    UNION ALL

    -- 汇总行
    SELECT
        NULL AS 序号,
        CONCAT('已检人数：',COUNT(DISTINCT gp.patient_id)) AS 分组名称,
        NULL AS 体检编号,
        NULL AS HIS号,
        NULL AS 姓名,
        NULL AS 身份证号,
        NULL AS 手机号,
        concat('指引单打印时间(最早):', MIN(CAST(gp.inspection_time AS CHAR))) AS 指引单打印时间,
        concat('指引单打印时间(最晚):',MAX(CAST(dir.check_date AS CHAR))) AS 体检时间
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
      AND CAST(gp.inspection_time AS CHAR(10)) = CAST(NOW() AS CHAR(10))
) AS final_result
ORDER BY 序号, 指引单打印时间;
