SELECT distinct
lg.create_by ,
       lg.create_time,
       lg.order_application_id AS 申请单号,
       gp.person_name AS 姓名
FROM t_log_f594102095fd9263b9ee22803eb3f4e5 lg
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
              ON lg.order_application_id = dir.barcode AND dir.del_flag <> '1'
    LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON gp.id = dir.person_id AND gp.del_flag <> '1'
WHERE lg.order_application_id IN (
    SELECT DISTINCT
           dir.barcode AS 申请单号
    FROM t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
        LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dir.person_id = gp.id AND gp.del_flag <> '1'
        LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id AND og.del_flag <> '1'
        LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
    WHERE dir.result IS NOT NULL
      AND office_name = '一般检查'
      AND (dir.check_date IS NULL OR dir.check_date IS NULL)
      AND dir.del_flag <> '1'
      AND  gp.person_name in ('于文轩','宋锡林','胡俊熙','孙然','杨佳乐','仇成山','孙子皓','王正昊','陈泉宇','王翔')
)
