-- 心电 17606^常规心电图自动分析
WITH ECGHL7 AS (
SELECT dr.order_application_id AS param,
			 gp.person_name AS pName,
			 gp.test_num as testNum,
			 gp.patient_id as patientId,
			 gp.id_card as idCard
    FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
    JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
		LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
    WHERE gp.del_flag <> '1'
      AND og.del_flag <> '1'
      AND go.del_flag <> '1'
      AND go.order_name = '恒德技工技术学院2025'
)

SELECT distinct DENSE_RANK() OVER (ORDER BY mid(SUBSTRING_INDEX(request_param, 'PID|', -1),2,10) ASC) AS 序号,
       id AS ID,
       name AS 名称,
       STR_TO_DATE(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, '||', 3), '||', -1), '%Y%m%d%H%i%s') AS 回传时间,
       mid(SUBSTRING_INDEX(request_param, 'PID|', -1),2,10) AS HIS号,
       SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, '^^^', 1), '|||', -1) AS 姓名,
			 a.testNum AS 体检编号,
			 a.idCard AS 身份证号,
       STR_TO_DATE(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PV1|', 1), '||', -1),14), '%Y%m%d') AS 出生日期,
       CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|SC|', -1), '^^', 1), '-', 'SC') AS 申请单号,
			 SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'OBR|', -1),'|||',1),'^',-1)AS 项目名称,
       request_param AS 请求参数
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
left join (select testNum,patientId,idCard from ECGHL7)a on t_log_f594102095fd9263b9ee22803eb3f4e5.patient_id=a.patientId
WHERE log_type = 2
  AND del_flag = 0
  AND request_param like '%ECG||RIS%'
  AND SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'ORC|SC|', -1), '^^', 1) IN (SELECT param FROM ECGHL7)
order by 序号,姓名,项目名称;

