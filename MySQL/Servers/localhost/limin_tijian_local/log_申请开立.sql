SELECT DISTINCT 
id,
       create_time AS 创建时间,
       update_time AS 更新时间,
       name AS 名称,
       request_param AS 请求参数,
       case when name ='PacsReceiveHL7Message' then NULL else SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PID||', -1), '|||', 1) end  AS pNumber,
       SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, '^^^', 1), '|||', -1) AS pName,
       response_param AS 响应参数
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
WHERE log_type = 2
  -- AND request_param LIKE '%腹部彩超%'
  -- AND request_param LIKE '%%'
  AND del_flag = 0
  AND (name ='检查开立'or name ='PacsReceiveHL7Message')
	
  AND SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, '^^^', 1), '|||', -1) IN (
    SELECT gp.person_name AS personName
    FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
         JOIN
         t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
         JOIN
         t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
    WHERE gp.del_flag <> '1'
      AND og.del_flag <> '1'
      AND go.del_flag <> '1'
      AND go.order_name = '文登北洋幸星电子2025'
)
ORDER BY pName;



