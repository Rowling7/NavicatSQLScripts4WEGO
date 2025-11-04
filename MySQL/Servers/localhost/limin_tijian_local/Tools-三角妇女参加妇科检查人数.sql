/*dr.id = dir.depart_result_id  不可用！
dir.barname dir.barcode 可能为空 不可用!*/

SELECT distinct  ROW_NUMBER() OVER (ORDER BY 姓名 ASC ) AS 序号,体检号,姓名,身份证号
from (
SELECT DISTINCT
       gp.test_num AS 体检号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dir.person_id = gp.id AND dir.del_flag <> '1'
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id AND og.del_flag <> '1'
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
WHERE gp.del_flag <> '1'
  AND dir.order_group_item_name in ( '妇科检查','阴道分泌物检查','液基薄层细胞制片术（TCT）')
  AND go.order_code = '202509160001'
 AND dir.check_date < '2025-11-01 00:00:00'
-- AND gp.id_card ='230713198411050627'
	and gp.is_pass >=2
GROUP BY
    gp.test_num,
    gp.person_name,
    gp.id_card
HAVING
    SUM(CASE WHEN dir.result IS NULL OR dir.result = '' THEN 0 ELSE 1 END) <= COUNT(dir.order_group_item_project_name)
   AND SUM(CASE WHEN dir.result IS NULL OR dir.result = '' THEN 0 ELSE 1 END) > 0



union 
SELECT DISTINCT
       gp.test_num AS 体检号,
       gp.person_name AS 姓名,
       gp.id_card AS 身份证号
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
    LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir ON dir.person_id = gp.id AND dir.del_flag <> '1'
    LEFT JOIN t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON og.id = gp.group_id AND og.del_flag <> '1'
    LEFT JOIN t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id AND go.del_flag <> '1'
	left join relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 rppc on rppc.person_id = gp.id
WHERE gp.del_flag <> '1'
  AND dir.order_group_item_name in ( '妇科检查','阴道分泌物检查','液基薄层细胞制片术（TCT）')
	and rppc.order_group_item_id in ('05a083d9879c4cd1b25c51e45cc2e775','9e849d70f1ce489ba7e6db9654568b0a','fabf1a18ed5c4870b7a34f142aee7230')
  AND go.order_code = '202509160001'
	and gp.is_pass >=2
and rppc.state ='2'
)a