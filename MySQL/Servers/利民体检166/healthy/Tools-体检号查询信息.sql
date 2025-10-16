SELECT DISTINCT
       gp.id AS ID,
       gp.person_name AS 姓名,
       gp.test_num AS 体检号,
       gp.patient_id AS HIS号,
       gp.id_card AS 身份证号,
       dr.barcode AS 申请合管号,
       gp.inspection_time AS 导引单打印时间,
       dr.barname AS 项目名称
       -- dir.barcode
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON gp.id = dr.person_id
-- left join t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir  on dir.depart_result_id=dr.id
WHERE gp.id IN ('e7ccc4ecdca8427499f5d1d58dd52d17', 'dcdfc717c9264ab899ca0504a853c585')
   OR gp.test_num = '176032406800095'

 /*gp.person_name in('于文轩','宋锡林','胡俊熙','孙然','杨佳乐','仇成山','孙子皓','王正昊','陈泉宇','王翔')




person_id in (
SELECT distinct gp.id
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
left join t_depart_result_f594102095fd9263b9ee22803eb3f4e5  dr on  gp.id=dr.person_id
-- left join t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir  on dir.depart_result_id=dr.id
where  gp.person_name in('于文轩','宋锡林','胡俊熙','孙然','杨佳乐','仇成山','孙子皓','王正昊','陈泉宇','王翔')
 and dr.barname ='内科检查'
 )
 
 
 
 
 
 
 person_id in (
 SELECT DISTINCT gp.id
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON gp.id = dr.person_id AND dr.del_flag <> '1'
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
WHERE gp.del_flag <> '1'
  AND dr.barname IN ('内科检查', '外科检查', '一般检查', '眼科检查')
  AND og.id IN
      ('1aed38db5ab3487c8865d466de4320ca', 'ab84ea6be1f44c77af559e6b4496d097', '6747ccb13a8e46409a23c5a208878add')
 )
 */