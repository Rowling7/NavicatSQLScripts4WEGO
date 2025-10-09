SELECT p.test_num,p.person_name,e.barcode,ifnull(e.order_application_id,a.order_application_id),barname,ifnull(e.name,a.group_item_name)
from  t_depart_result_f594102095fd9263b9ee22803eb3f4e5 a
LEFT OUTER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 p ON a.person_id = p.id
LEFT OUTER JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 b ON a.group_item_id = b.id
AND b.del_flag = 0
LEFT OUTER JOIN relation_bar_portfolio d ON b.portfolio_project_id = d.portfolio_code
LEFT OUTER JOIN (
	SELECT
		a.person_id,
		test_num,
		a.barcode,
		b.order_application_id,
	NAME
	FROM
		(
		SELECT
			person_id,
			test_num,
			a.barcode,
			GROUP_CONCAT( NAME ORDER BY NAME SEPARATOR ',' ) NAME
		FROM
			(
			SELECT DISTINCT
				a.person_id,
				b.test_num,
				a.group_item_name NAME,
				d.barcode
			FROM
				t_group_person_f594102095fd9263b9ee22803eb3f4e5 b
				LEFT OUTER JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 a ON a.person_id = b.id
				AND a.del_flag = 0
				LEFT OUTER JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 c ON a.group_item_id = c.id
				AND c.del_flag = 0
				LEFT OUTER JOIN relation_bar_portfolio d ON c.portfolio_project_id = d.portfolio_code
				LEFT OUTER JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 e ON c.portfolio_project_id = e.id
				AND e.del_flag = 0
			WHERE
				e.office_id = '90405'
				AND d.barcode IS NOT NULL
				AND a.del_flag = 0
			    AND b.test_num = '175919268800006'
			) a
		GROUP BY
			person_id,
			test_num,
			barcode
		) a
		LEFT OUTER JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 b ON a.person_id = b.person_id
		AND SUBSTRING_INDEX( a.NAME, ',', - 1 )= b.group_item_name
	) e ON e.person_id = a.person_id
	AND d.barcode = e.barcode
where  p.test_num='175919268800006'