SELECT id,
       create_time AS 创建时间,
       update_time AS 更新时间,
       name AS 名称,
       request_param AS 请求参数,
       SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PID||', -1), '|||', 1) AS pNumber,
       SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, '^^^', 1), '|||', -1) AS pName,
			 left(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PV1||', 1),'|', -1),18) as pIDCARD,
       SUBSTRING_INDEX(CASE
           WHEN request_param LIKE '%PHYS%' AND request_param LIKE '%ORC|NW|%' THEN SUBSTRING_INDEX(
                   SUBSTRING_INDEX(request_param, 'ORC|NW|', -1), '|||||||', 1)
           WHEN request_param LIKE '%PHYS%' AND request_param LIKE '%ORC|CA|%' THEN SUBSTRING_INDEX(
                   SUBSTRING_INDEX(request_param, 'ORC|CA|', -1), '|||||||', 1)
           WHEN request_param LIKE '%ECG%'                                     THEN SUBSTRING_INDEX(
                   SUBSTRING_INDEX(request_param, 'ORC|SC|', -1), '|||F||||', 1)
           WHEN request_param LIKE '%PACS%'                                    THEN SUBSTRING_INDEX(
                   SUBSTRING_INDEX(request_param, 'ORC|NW|', -1), '|||||||', 1)
           WHEN request_param LIKE '%LIS%'                                     THEN SUBSTRING_INDEX(
                   SUBSTRING_INDEX(request_param, 'ORC|SN|', -1), '|||||||', 1)
           ELSE NULL
           END,'^^',1) AS 申请单号,
       response_param AS 响应参数
FROM t_log_f594102095fd9263b9ee22803eb3f4e5
WHERE log_type = 2
  AND del_flag = 0
	-- AND name ='检查开立'
  AND left(SUBSTRING_INDEX(SUBSTRING_INDEX(request_param, 'PV1||', 1),'|', -1),18) IN (
    SELECT gp.id_card AS idCard
    FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
         JOIN
         t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
         JOIN
         t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
    WHERE gp.del_flag <> '1'
      AND og.del_flag <> '1'
      AND go.del_flag <> '1'
      AND go.order_name = '哈工大研究生25级'
)
ORDER BY pName;






