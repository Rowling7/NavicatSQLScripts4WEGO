SELECT distinct
    gp.id AS personId,

    ogi.name AS 项目名称
FROM
    t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
JOIN
    t_order_group_f594102095fd9263b9ee22803eb3f4e5 og
    ON gp.group_id = og.id and og.del_flag<>'1'
JOIN
    t_group_order_f594102095fd9263b9ee22803eb3f4e5 go
    ON og.group_order_id = go.id and go.del_flag<>'1'
join 
		t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
		on ogi.group_id = og.id and ogi.del_flag<>'1'
join t_order_group_item_project_f594102095fd9263b9ee22803eb3f4e5 ogip
		on ogip.t_order_group_item_id=ogi.id and ogip.del_flag<>'1'
WHERE
		gp.del_flag<>'1'
		and gp.test_num ='176068344400001'
ORDER BY
    og.name, gp.person_name;
		
		
		
		SELECT ogi.office_name,ogi.name
from t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
left join t_order_group_f594102095fd9263b9ee22803eb3f4e5 og  on og.id=ogi.group_id
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on og.id=gp.group_id
where gp.test_num ='176068344400001'
order by ogi.office_name
 and ogi.office_name='检验科'





