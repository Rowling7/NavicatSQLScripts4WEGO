/*
Tools-查询阳性体征-A重度
SELECT ROW_NUMBER( ) OVER (ORDER BY gu.`name`,og.`name`,person_name) AS 序号
     , gp.person_name AS 姓名
     , gp.test_num AS 体检号
		 , gp.age AS 年龄
     , gp.sex AS 性别
     , gp.mobile AS 手机号
     , gu.`name` AS 单位
		 -- , og.`name` as 分组
     , REGEXP_REPLACE(og.`name`, '-\\d+$', '') AS 分组
     , pp.order_group_item_name AS 检测项目
     , pp.positive_name AS 阳性名称
     , pp.medical_explanation AS 医学解释
     , pp.positive_suggestion AS 阳性建议
     , pp.feedback AS 阳性备注
     , tu.nickname AS 上报人
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
     LEFT JOIN t_group_unit_f594102095fd9263b9ee22803eb3f4e5 gu ON go.group_unit_id = gu.id
     LEFT JOIN t_positive_person_f594102095fd9263b9ee22803eb3f4e5 pp ON gp.id = pp.person_id
     LEFT JOIN t_user tu ON COALESCE( pp.update_id , pp.create_id ) = tu.id
WHERE pp.del_flag <> 1
  AND tu.del_flag <> 1
  AND gp.del_flag <> 1
  AND og.del_flag <> 1
  AND go.del_flag <> 1
  AND gu.del_flag <> 1
  AND pp.heavy = 'A';*/

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
      AND go.order_code IN ('202511070001')
			-- and gp.id <>'b96eb73c7c984615bc6d300676d7ff6e'
			-- and gp.person_name IN ('姜辉','路笃山','毕彦斌','张春光','谷欣欣','夏茜','董光宇','于群','赵鑫杰','苗爱煜','于晓谕','刘琳','田野','董伟','黄艳丽','于学良','阎萌蕾','李明阳','邴丛丛','郭可可','魏清荃','商敬贵','陈志红')
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