WITH singleCode AS (SELECT dr.barcode
                    FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
                    WHERE dr.office_name = '检验科'
										-- and dr.group_item_name ='T肝功5项'
                      AND dr.barcode IS NOT NULL
                    GROUP BY
                        dr.barcode
                    HAVING COUNT(dr.order_application_id) < 2)

SELECT DISTINCT 
       substring_index(substring_index(substr(SUBSTRING_INDEX(lg.request_param, 'OBR|1||', -1),9,999),'|||','1'),'^','1') AS request_param,
       substring_index(substring_index(substr(SUBSTRING_INDEX(lg.request_param, 'OBR|1||', -1),9,999),'|||','1'),'^','-1') AS request_param2

FROM t_log_f594102095fd9263b9ee22803eb3f4e5 lg
WHERE lg.log_type = 2
  AND lg.del_flag = 0
  AND CASE WHEN lg.order_application_id IS NOT NULL THEN lg.order_application_id
           WHEN request_param LIKE '%ORC|SC|%' THEN
               LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(lg.request_param, 'ORC|SC|', -1), '^^', 1), 20)
           WHEN request_param LIKE '%ORC|NW|%' THEN
               LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(lg.request_param, 'ORC|NW|', -1), '^^', 1), 20)
           WHEN request_param LIKE '%ORC|SN|%' THEN
               LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(lg.request_param, 'ORC|SN|', -1), '|||||||', 1), 20)
           ELSE NULL END IN (SELECT * FROM singleCode)
  and lg.request_param not LIKE 'CALL p_healthy_result%'
	and lg.name = 'LisReceiveHL7Message' 
  -- AND lg.order_application_id = '90001102629'
LIMIT 100;



SELECT @lgId :=lg.id,length(lg.request_param)
from t_log_f594102095fd9263b9ee22803eb3f4e5 lg 
where request_param like '%血常规%'
and lg.log_type = 2
  AND lg.del_flag = 0
  and lg.request_param not LIKE 'CALL p_healthy_result%'
	and lg.name = 'LisReceiveHL7Message' 
order by length(lg.request_param) desc 
limit 1;
SELECT lg.patient_id,lg.create_time,lg.request_param
from t_log_f594102095fd9263b9ee22803eb3f4e5 lg 
where lg.id =@lgId;