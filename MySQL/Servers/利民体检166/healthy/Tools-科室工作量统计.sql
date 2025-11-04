WITH base AS ( SELECT dr.office_name
                    , dr.group_item_name
                    , dr.group_item_id
                    , dr.office_id
                    , gp.id AS person_id
                    , gp.group_id
                    , gp.person_name
                    , ogi.discount_price
                    , ogi.discount
                    , ogi.sale_price
               FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
                   INNER JOIN t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp ON dr.person_id = gp.id
                   INNER JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi ON gp.group_id = ogi.group_id
                   AND dr.group_item_id = ogi.id
                   AND ogi.`name` = dr.group_item_name
               WHERE confirm_status > 0
                 AND dr.office_id IS NOT NULL
                 AND gp.del_flag = 0
                 AND dr.check_date BETWEEN '2025-11-01 00:00:00' AND '2025-11-30 23:59:59'
                 AND NOT EXISTS
                   ( SELECT 1
                     FROM relation_person_project_check_f594102095fd9263b9ee22803eb3f4e5 rppc
                     WHERE rppc.person_id = gp.id
                       AND rppc.state = 2
                       AND rppc.office_id = dr.office_id
                       AND rppc.order_group_item_id = dr.group_item_id
                     )
                 AND dr.office_name = ogi.office_name
                 AND gp.dept IS NOT NULL
               )
-- 明细行
SELECT office_name
     , group_item_name
     , discount_price
     , discount
     , sale_price
     , COUNT( person_id ) AS person_count
     , SUM( discount_price ) AS item_total
     , '明细' AS row_type
     , 1 AS sort_in_office
     , 0 AS sort_total
FROM base
GROUP BY
    office_name
  , group_item_name
  , discount_price
  , discount
  , sale_price
UNION ALL
-- 科室汇总行
SELECT office_name
     , NULL AS group_item_name
     , NULL AS discount_price
     , NULL AS discount
     , NULL AS sale_price
     , COUNT( person_id ) AS person_count
     , SUM( discount_price ) AS item_total
     , '科室汇总' AS row_type
     , 2 AS sort_in_office
     , 0 AS sort_total
FROM base
GROUP BY
    office_name
UNION ALL
-- 总汇总行
SELECT '全部科室' AS office_name
     , NULL AS group_item_name
     , NULL AS discount_price
     , NULL AS discount
     , NULL AS sale_price
     , COUNT( person_id ) AS person_count
     , SUM( discount_price ) AS item_total
     , '总汇总' AS row_type
     , 0 AS sort_in_office
     , 1 AS sort_total
FROM base
ORDER BY
    sort_total     ASC
  , -- 总汇总最后
    office_name
  , sort_in_office ASC
  , group_item_name;
