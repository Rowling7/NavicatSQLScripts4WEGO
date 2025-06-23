SELECT * 
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
where group_id ='249219c852d943be9563abdece70b961'
limit 100;

-- 分诊--体检结果 
select *
from t_depart_result_f594102095fd9263b9ee22803eb3f4e5
where person_id='3f17e041626f4ddcb78186e950f6ad14'
limit 100;

select *
from t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5
where person_id='3f17e041626f4ddcb78186e950f6ad14'
limit 100;


-- 总检表
SELECT *
FROM t_inspection_record_f594102095fd9263b9ee22803eb3f4e5
where person_id='3f17e041626f4ddcb78186e950f6ad14'
limit 100;






