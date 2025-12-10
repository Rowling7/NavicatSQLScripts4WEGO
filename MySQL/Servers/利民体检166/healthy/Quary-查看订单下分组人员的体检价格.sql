SELECT gp.test_num AS 体检号
     , gp.patient_id AS HIS号
		 , gp.person_name AS 姓名
     , SUM( ogi.discount_price ) AS 优惠价格
		 -- , gp.group_id  AS 分组id
		 , og.`name` AS 分组名称
		 ,REGEXP_REPLACE(og.`name`, '-\\d+$', '') as cleaned_value
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
left join t_order_group_f594102095fd9263b9ee22803eb3f4e5 og on gp.group_id=og.id
     LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi ON gp.group_id = ogi.group_id
WHERE gp.del_flag <> 1
  AND ogi.del_flag <> 1
	and *gp.is_pass >2
  AND gp.order_id = '2e589ff7efc16d802d33afa48d0ec92a'
  -- AND gp.id = 'ff6316ba99cb4755bd1b00bfc691ab10'
GROUP BY gp.test_num, gp.patient_id, gp.person_name, gp.group_id , og.`name`
order by og.`name`