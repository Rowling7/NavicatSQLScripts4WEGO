SELECT 'C' AS reqtype
     , d.barcode AS barcode
     , '4' AS pat_type
     , A.test_num AS pat_no
     , A.patient_id AS pat_id
     , A.patient_id AS pat_cardno
     , A.regist_date AS np_date
     , A.person_name AS pat_name
     , A.sex AS pat_sex
     , A.birth AS pat_birth
     , '0' AS emer_flag
     , d.barcode AS original_reqno
     , '检验科' AS perform_dept
     , '' AS req_groupna
     , '' AS specimen_name
     , '' AS sample_detail
     , '' AS req_reason
     , '' AS sample_items
     , B.id AS his_recordid
     , B.order_num AS seq
     , C.his_code AS req_itemcode
     , C.name AS req_itemname
     , '' AS combitemna
     , B.sale_price AS base_price
     , B.discount_price AS item_price
     , '1' AS qty
     , B.discount_price AS amount
     , C.his_code AS his_itemcode
     , B.create_time AS req_dt
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 A
     LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 B
               ON B.del_flag = 0 AND A.group_id = B.group_id
     LEFT JOIN ( SELECT DISTINCT
                     apply_no
                      , fee_status
                      , clinic_item_id
                      , clinic_item_name
                      , state
                 FROM t_person_bill_list_f594102095fd9263b9ee22803eb3f4e5 ) tp ON tp.apply_no = B.id
     LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 d
               ON A.id = d.person_id AND d.del_flag = 0 AND B.id = d.group_item_id
     LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 C
               ON B.portfolio_project_id = C.id AND C.del_flag = 0
WHERE d.id IS NOT NULL
  AND B.office_name = '检验科'
  AND A.del_flag = 0
  AND (
    ( A.expense_id = 1 AND A.sporadic_physical = 0 AND tp.state = 0 )
        OR ( A.sporadic_physical = '1' AND tp.state = 0 )
        OR ( A.expense_id = 0 AND A.sporadic_physical = 0 )
    )
