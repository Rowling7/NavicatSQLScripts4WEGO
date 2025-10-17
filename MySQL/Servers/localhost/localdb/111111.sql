SELECT DISTINCT
       
       dir.person_id,
       gp.person_name,
       dir.positive,
			 dir.office_name,
       dr.diagnose_sum  'dr小结', 
			 dir.diagnose_sum 'dir小结',
       og.name,
			 dir.order_group_item_project_name
FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.id = dir.depart_result_id AND dr.del_flag <> '1'
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON gp.id = dir.person_id AND gp.del_flag <> '1'
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
left JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go     ON og.group_order_id = go.id and go.del_flag<>'1'
WHERE dir.del_flag <>'1'
  and dir.office_name IN ('内科检查', '外科检查', '一般检查', '眼科检查')
 and go.order_code='202509100002'
 and og.name in('韩语1','韩语2','电商1')
 and dir.positive = 0
 
 
 and length(dir.diagnose_sum) >1 and dir.diagnose_sum <>'未见异常'
