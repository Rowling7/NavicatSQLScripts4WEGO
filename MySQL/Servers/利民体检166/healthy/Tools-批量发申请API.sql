-- 第一步：

SELECT id, order_code, order_name, group_unit_name
FROM t_group_order_f594102095fd9263b9ee22803eb3f4e5 go
WHERE go.order_code = '202510220001';-- 订单号

SELECT * -- 重要：必须核对人数
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
WHERE order_id = '360c386d59efac1d056409a3f1696a60'
  AND del_flag = '0'
  AND is_pass = 1;

-- 第二步：
-- UPDATE t_group_person_f594102095fd9263b9ee22803eb3f4e5 
SET is_pass = 2,regist_date = NOW()
WHERE order_id = '360c386d59efac1d056409a3f1696a60'
  AND del_flag = '0'
  AND is_pass = 1;

-- 第三步：
SELECT CONCAT('CALL p_healthy_result_ins(''', test_num, ''', ''f594102095fd9263b9ee22803eb3f4e5'');') AS exec_sql 
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
WHERE order_id = '8ebef809f15aac50ead197945c119bc7'
  AND del_flag = '0'
  AND is_pass = 2;