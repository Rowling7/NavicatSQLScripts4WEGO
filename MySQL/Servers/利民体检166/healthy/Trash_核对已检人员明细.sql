SET @ordercode = '202509160001';-- 文登北洋幸星电子2025
SELECT @orderId := id
FROM t_group_order_f594102095fd9263b9ee22803eb3f4e5
WHERE order_code = @ordercode;


DROP TEMPORARY TABLE IF EXISTS temp_OrderIdLisLost;
CREATE TEMPORARY TABLE temp_OrderIdLisLost AS
SELECT dir.barcode AS OrderIdLost,
       gp.person_name AS 姓名,
       dir.order_group_item_name,
       SUM(ISNULL(result)),
       COUNT(*)
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
  AND dir.office_id IN ('90401', '90402', '90403', '90404', '90405', '90120')
  AND go.order_code = @orderCode
GROUP BY
    dir.barcode,
    dir.office_id,
    dir.order_group_item_name,
    gp.person_name
HAVING SUM(ISNULL(result)) <> COUNT(1)
ORDER BY
    姓名,
    OrderIdLost,
    SUM(ISNULL(result));


WITH lvselect AS (
    SELECT DISTINCT
           b.person_name,
           b.id_card,
           b.dept
    FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 a
        INNER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 b ON a.person_id = b.id
        INNER JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 c ON b.group_id = c.group_id
        AND a.group_item_id = c.id
        AND c.`name` = a.group_item_name
    WHERE confirm_status > 0
      AND a.office_id IS NOT NULL
      AND b.del_flag = 0
      AND a.check_date BETWEEN '2025-09-01 00:00:00'
        AND '2025-09-30 23:59:59'
      AND NOT EXISTS(
            SELECT 1
            FROM relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 r2
            WHERE r2.person_id = b.id
              AND r2.state = 2
              AND r2.office_id = a.office_id
              AND r2.order_group_item_id = a.group_item_id
        )
      AND a.office_name = c.office_name
      AND c.group_order_id = @orderId
),
     passedCnt AS (
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
           AND COALESCE(dr.barcode, dr.order_application_id) IN (SELECT OrderIdLost FROM temp_OrderIdLisLost)
     )

SELECT rst1.订单号, rst1.姓名, rst1.身份证号, rst1.HIS号, rst1.is_pass
FROM (
    SELECT go.order_code AS 订单号,
           go.order_name AS 订单名称,
           og.name AS 分组名称,
           gp.patient_id AS HIS号,
           gp.person_name AS 姓名,
           gp.id_card AS 身份证号,
           gp.is_pass
    FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
        JOIN
    t_order_group_f594102095fd9263b9ee22803eb3f4e5 og
    ON gp.group_id = og.id AND og.del_flag <> '1'
        JOIN
    t_group_order_f594102095fd9263b9ee22803eb3f4e5 go
    ON og.group_order_id = go.id AND go.del_flag <> '1'
    WHERE gp.del_flag <> '1'
      AND go.order_code = @ordercode
      AND gp.id_card NOT IN ( -- 不在吕工统计表里
        SELECT id_card
        FROM lvselect
    )
) rst1
WHERE rst1.身份证号 IN (SELECT 身份证号 FROM passedCnt) -- 在已检人员名单里
;

-- 查看log表日志
(
    SELECT lg.create_time, lg.*
    FROM t_log_f594102095fd9263b9ee22803eb3f4e5 lg
    WHERE lg.request_param LIKE CONCAT('%', 2022571356, '%')
      AND lg.name <> '检查开立'
);

/*订单号 ('202509100003','202508270672','202508270671','202508270670','202508280001','202509060001',
'202508310001','202509100002','202509100004','202509100001')
*/
