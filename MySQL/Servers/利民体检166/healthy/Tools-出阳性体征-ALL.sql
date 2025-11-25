SELECT ROW_NUMBER() OVER (ORDER BY 团检单位名称, HIS号) AS 序号,
       团检单位名称,
			 HIS号,
       体检号,
       姓名,
       性别,
			 年龄,
			 手机号,
       身份证号,
			 指引单打印时间,
       GROUP_CONCAT(
               单项阳性名称
               ORDER BY CAST(SUBSTRING_INDEX(单项阳性名称, '.', 1) AS UNSIGNED)
               SEPARATOR ';'
           ) AS 阳性名称
FROM (
    SELECT go.group_unit_name AS 团检单位名称,
           gp.test_num AS 体检号,
           gp.patient_id AS HIS号,
           gp.person_name AS 姓名,
           gp.sex AS 性别,
					 gp.age AS 年龄,
           gp.id_card AS 身份证号,
           gp.mobile AS 手机号,
					 CAST(gp.inspection_time AS CHAR) AS 指引单打印时间,
           ifnull(CONCAT(
                   ROW_NUMBER() OVER (
                       PARTITION BY gp.patient_id
                       ORDER BY pp.order_group_item_name, pp.order_group_item_project_name
                       ),
                   '.',
                   pp.positive_name
               ),'1.本次体检所查项目未发现异常') AS 单项阳性名称
    FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
        LEFT JOIN t_positive_person_f594102095fd9263b9ee22803eb3f4e5 pp ON pp.person_id = gp.id AND pp.del_flag != '1'
        LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag != '1'
        LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag != '1'
    WHERE gp.del_flag != '1'
      AND go.order_code IN ('202509100002')
    -- AND pp.positive_name != '本次体检所查项目未发现异常'
) t
GROUP BY
    团检单位名称,
    体检号,
    HIS号,
    姓名,
    性别,
	  年龄,
    手机号,
		身份证号,
		指引单打印时间
ORDER BY
    团检单位名称,
    HIS号;