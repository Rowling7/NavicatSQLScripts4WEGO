SELECT distinct gp.id,
			gp.person_name,
			gp.test_num,
			gp.patient_id,
			gp.id_card,
			dr.barcode,
			dr.barname
			-- dir.barcode
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
left join t_depart_result_f594102095fd9263b9ee22803eb3f4e5  dr on  gp.id=dr.person_id
-- left join t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir  on dir.depart_result_id=dr.id
where gp.test_num='175997412700240'

 gp.person_name in('于文轩','宋锡林','胡俊熙','孙然','杨佳乐','仇成山','孙子皓','王正昊','陈泉宇','王翔')




person_id in (
SELECT distinct gp.id
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
left join t_depart_result_f594102095fd9263b9ee22803eb3f4e5  dr on  gp.id=dr.person_id
-- left join t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir  on dir.depart_result_id=dr.id
where  gp.person_name in('于文轩','宋锡林','胡俊熙','孙然','杨佳乐','仇成山','孙子皓','王正昊','陈泉宇','王翔')
 and dr.barname ='内科检查'
 )