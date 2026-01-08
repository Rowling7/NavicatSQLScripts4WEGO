set @param ='2026000770';  -- 任宇宁CS-团
-- set @param ='2026000768';  -- 范璐CS-个

SELECT *
from t_log_f594102095fd9263b9ee22803eb3f4e5
where patient_id =@param;

SELECT *
from V_rmjysqd
where pat_id =@param;

SELECT *
from V_c13sqd
where patient_id =@param;

SELECT *
from VI_HONO_TM
where _patientId ='176783978400011';  -- 任宇宁CS-团
-- _patientId ='176783972600010'; -- 范璐CS-个
