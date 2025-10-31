-- 职业体检套餐
SELECT DISTINCT
       ROW_NUMBER() OVER ( ORDER BY name) AS 序号,
       '职业体检套餐',
       name AS 套餐名称,
       type AS 套餐类别,
       fit_sex AS 适合性别,
       remark AS 套餐介绍,
       hazard_factors AS 危险因素编码,
       hazard_factors_text AS 危险因素名称,
       career_stage AS 职业阶段,
       occupational_diseases AS 职业病,
       occupational_diseases_code AS 职业病编码,
       occupational_taboo AS 职业禁忌,
       occupational_taboo_code AS 职业禁忌编码,
       diagnostic_criteria AS 诊断条件,
       symptom_inquiry AS 症状查询,
       health_classification AS 健康分类,
       tags AS 套餐标签,
       check_time AS 检查时间
FROM t_combo
WHERE type = '职业体检';

-- 危害因素
SELECT DISTINCT
       ROW_NUMBER() OVER ( ORDER BY hazard_factor_id) AS as序号,
       '危害因素',
       hazard_factor_id AS 危险因素编码,
       hazard_factor_name AS 危险因素名称,
       ask_project AS 问诊项目
FROM t_ask_project;

-- 职业病
SELECT DISTINCT
       ROW_NUMBER() OVER ( ORDER BY value) AS 序号,
       '疑似职业病',
       value AS 职业病编码,
       title AS 职业病名称
FROM t_dict_data
WHERE dict_id = '1456563728605646848';

-- 职业禁忌证
SELECT DISTINCT
       ROW_NUMBER() OVER ( ORDER BY value) AS 序号,
       '职业禁忌证',
       value AS 职业病编码,
       title AS 职业病名称
FROM t_dict_data
WHERE dict_id = '1456565626662424576';