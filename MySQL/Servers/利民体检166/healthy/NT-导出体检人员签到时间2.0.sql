SET @orderCode = '202511060002';

SELECT DISTINCT
    DENSE_RANK( ) OVER (ORDER BY gp.patient_id) AS 序号
     , og.name AS 分组名称
     , gp.test_num AS 体检编号
     , gp.patient_id AS HIS号
     , gp.person_name AS 姓名
     , gp.id_card AS 身份证号
     , gp.mobile AS 手机号
     , CAST( gp.inspection_time AS CHAR ) AS 指引单打印时间
     , CAST( MIN( dir.check_date ) AS CHAR ) AS 体检时间
FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
     LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
               ON dir.del_flag <> '1' AND dr.id = dir.depart_result_id
     LEFT JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
     LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id
     LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE dr.del_flag <> '1'
  AND gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND dir.office_id IN ( '90401' , '90402' , '90403' , '90404' , '90405' , '90120' )
  AND go.order_code = @orderCode
	-- or gp.test_num ='176240884500360'
  AND CAST( gp.inspection_time AS CHAR(10) ) <= CAST( NOW( ) AS CHAR(10) )
	 and SUBSTRING(CAST( gp.inspection_time AS CHAR(19)), 12, 8) BETWEEN '06:00:00' AND '12:00:00'
	-- and (og.name like  '%2025年东星集团套餐体检方案三-幽门螺旋杆菌检测（男）%')
GROUP BY go.order_code, go.order_name, og.name, gp.test_num, gp.patient_id, gp.person_name, gp.id_card
       , gp.inspection_time
HAVING MIN( IFNULL( gp.inspection_time , dir.check_date ) ) IS NOT NULL
-- order by CAST( gp.inspection_time AS CHAR )