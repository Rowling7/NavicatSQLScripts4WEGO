WITH 
dim_age AS (
    SELECT '<18岁' AS age_group UNION ALL 
    SELECT '18~29岁' UNION ALL 
    SELECT '30~39岁' UNION ALL 
    SELECT '40~49岁' UNION ALL 
    SELECT '50~59岁' UNION ALL 
    SELECT '60~69岁' UNION ALL 
    SELECT '>=70岁'
),
dim_positive AS (
    SELECT DISTINCT a.positive_name 
    FROM t_positive_person_f594102095fd9263b9ee22803eb3f4e5 a
    INNER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 b ON a.person_id = b.id
    WHERE b.dept = '恒科精工2025'
      AND a.del_flag = 0
      AND b.del_flag = 0
      AND b.is_pass > 2
			-- and b.id <>'b96eb73c7c984615bc6d300676d7ff6e' -- 去除重名
			-- and b.person_name IN ('姜辉','路笃山','毕彦斌','张春光','谷欣欣','夏茜','董光宇','于群','赵鑫杰','苗爱煜','于晓谕','刘琳','田野','董伟','黄艳丽','于学良','阎萌蕾','李明阳','邴丛丛','郭可可','魏清荃','商敬贵','陈志红')
),
dim_all AS (
    SELECT p.positive_name, a.age_group
    FROM dim_positive p
    CROSS JOIN dim_age a
),
base AS (
    SELECT 
        a.positive_name,
        b.sex,
        CASE
            WHEN b.age < 18              THEN '<18岁'
            WHEN b.age BETWEEN 18 AND 29 THEN '18~29岁'
            WHEN b.age BETWEEN 30 AND 39 THEN '30~39岁'
            WHEN b.age BETWEEN 40 AND 49 THEN '40~49岁'
            WHEN b.age BETWEEN 50 AND 59 THEN '50~59岁'
            WHEN b.age BETWEEN 60 AND 69 THEN '60~69岁'
            ELSE '>=70岁'
        END AS age_group
    FROM t_positive_person_f594102095fd9263b9ee22803eb3f4e5 a
    INNER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 b ON a.person_id = b.id
    WHERE b.dept = '恒科精工2025'
      AND a.del_flag = 0
      AND b.del_flag = 0
      AND b.is_pass > 2
			-- and b.id <>'b96eb73c7c984615bc6d300676d7ff6e' -- 去除重名
			-- and b.person_name IN ('姜辉','路笃山','毕彦斌','张春光','谷欣欣','夏茜','董光宇','于群','赵鑫杰','苗爱煜','于晓谕','刘琳','田野','董伟','黄艳丽','于学良','阎萌蕾','李明阳','邴丛丛','郭可可','魏清荃','商敬贵','陈志红')
),
total AS (
    SELECT 
        sex,
        CASE
            WHEN age < 18              THEN '<18岁'
            WHEN age BETWEEN 18 AND 29 THEN '18~29岁'
            WHEN age BETWEEN 30 AND 39 THEN '30~39岁'
            WHEN age BETWEEN 40 AND 49 THEN '40~49岁'
            WHEN age BETWEEN 50 AND 59 THEN '50~59岁'
            WHEN age BETWEEN 60 AND 69 THEN '60~69岁'
            ELSE '>=70岁'
        END AS age_group,
        COUNT(*) AS total_cnt
    FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
    WHERE dept = '恒科精工2025'
      AND del_flag = 0
      AND is_pass > 2
			-- and id <>'b96eb73c7c984615bc6d300676d7ff6e' -- 去除重名
			-- and person_name IN ('姜辉','路笃山','毕彦斌','张春光','谷欣欣','夏茜','董光宇','于群','赵鑫杰','苗爱煜','于晓谕','刘琳','田野','董伟','黄艳丽','于学良','阎萌蕾','李明阳','邴丛丛','郭可可','魏清荃','商敬贵','陈志红')
    GROUP BY sex, age_group
),

calc_base AS (
    SELECT 
        d.positive_name AS 阳性项目,
        d.age_group AS 年龄范围,
        IFNULL(SUM(CASE WHEN b.sex = '男' THEN 1 ELSE 0 END), 0) AS 男性人数,
        -- 男性检出率数值（无分母时为0）
        IFNULL(
            SUM(CASE WHEN b.sex = '男' THEN 1 ELSE 0 END) / 
            NULLIF((SELECT t.total_cnt FROM total t WHERE t.sex = '男' AND t.age_group = d.age_group), 0),
            0
        ) * 100 AS 男性检出率数值,
        IFNULL(SUM(CASE WHEN b.sex = '女' THEN 1 ELSE 0 END), 0) AS 女性人数,
        -- 女性检出率数值（无分母时为0）
        IFNULL(
            SUM(CASE WHEN b.sex = '女' THEN 1 ELSE 0 END) / 
            NULLIF((SELECT t.total_cnt FROM total t WHERE t.sex = '女' AND t.age_group = d.age_group), 0),
            0
        ) * 100 AS 女性检出率数值
    FROM dim_all d
    LEFT JOIN base b 
        ON d.positive_name = b.positive_name 
        AND d.age_group = b.age_group
  --   WHERE d.positive_name LIKE '%淋巴细胞比率偏低%'
    GROUP BY d.positive_name, d.age_group
)


SELECT 
    阳性项目,
    年龄范围,
    男性人数,
    CONCAT(
        CASE 
            WHEN 男性检出率数值 = ROUND(男性检出率数值, 0) THEN CAST(ROUND(男性检出率数值, 0) AS CHAR)
            ELSE ROUND(男性检出率数值, 2)
        END,
        '%'
    ) AS 男性检出率,
    女性人数,
    CONCAT(
        CASE 
            WHEN 女性检出率数值 = ROUND(女性检出率数值, 0) THEN CAST(ROUND(女性检出率数值, 0) AS CHAR)
            ELSE ROUND(女性检出率数值, 2)
        END,
        '%'
    ) AS 女性检出率
FROM calc_base
ORDER BY 
    阳性项目,
    FIELD(年龄范围, '<18岁', '18~29岁', '30~39岁', '40~49岁', '50~59岁', '60~69岁', '>=70岁');