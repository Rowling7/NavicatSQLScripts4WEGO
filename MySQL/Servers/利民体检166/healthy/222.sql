-- 第一步：
SELECT
	*
FROM
	t_group_person_f594102095fd9263b9ee22803eb3f4e5
WHERE
	order_id = '2e589ff7efc16d802d33afa48d0ec92a' AND del_flag = '0' AND is_pass = 1
	
	
UPDATE
	t_group_person_f594102095fd9263b9ee22803eb3f4e5 SET is_pass = 2 ,regist_date = NOW()
WHERE
	order_id = '2e589ff7efc16d802d33afa48d0ec92a' AND del_flag = '0' AND is_pass = 1 and PERSON_NAME <>'李红星'
	
-- 第二步：
	
SELECT CONCAT('CALL p_healthy_result_ins(''', test_num, ''', ''f594102095fd9263b9ee22803eb3f4e5'');') as exec_sql
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
WHERE order_id = '2e589ff7efc16d802d33afa48d0ec92a' 
AND del_flag = '0' 
AND is_pass = 2
and PERSON_NAME <>'李红星';


6eaa3672e5f5d36b087b1d79af68dec4
