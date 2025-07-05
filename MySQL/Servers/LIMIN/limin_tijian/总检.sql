
-- 总检
SELECT distinct dr.*
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
left join t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir on dr.id=dir.depart_result_id and dir.del_flag<>'1'
where dr.del_flag<>'1'
			and dr.person_id ='1ba7cbc6e2cc486ebb46bb116ab2d18a'
			-- and group_item_name='外科检查'
ORDER BY group_item_id;
