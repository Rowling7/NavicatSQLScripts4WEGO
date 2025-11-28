SELECT 'C' AS reqtype
     , dr.barcode AS barcode
     , '4' AS pat_type
     , gp.test_num AS pat_no
     , gp.patient_id AS pat_id
     , gp.patient_id AS pat_cardno
     , gp.regist_date AS np_date
     , gp.person_name AS pat_name
     , gp.sex AS pat_sex
     , gp.birth AS pat_birth
     , '0' AS emer_flag
     , dr.barcode AS original_reqno
     , '检验科' AS perform_dept
     , '' AS req_groupna
     , '' AS specimen_name
     , '' AS sample_detail
     , '' AS req_reason
     , '' AS sample_items
     , ogi.id AS his_recordid
     , ogi.order_num AS seq
     , pp.his_code AS req_itemcode
     , pp.`name` AS req_itemname
     , '' AS combitemna
     , ogi.sale_price AS base_price
     , ogi.discount_price AS item_price
     , '1' AS qty
     , ogi.discount_price AS amount
     , pp.his_code AS his_itemcode
     , ogi.create_time AS req_dt
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 AS gp
     LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 AS ogi
               ON ogi.del_flag = 0 AND gp.group_id = ogi.group_id
     LEFT JOIN ( SELECT DISTINCT apply_no, fee_status, clinic_item_id, clinic_item_name, state
                 FROM t_person_bill_list_f594102095fd9263b9ee22803eb3f4e5 ) AS pbl ON pbl.apply_no = ogi.id
     LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 AS dr
               ON gp.id = dr.person_id AND dr.del_flag = 0 AND ogi.id = dr.group_item_id
     LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 AS pp
               ON ogi.portfolio_project_id = pp.id AND pp.del_flag = 0
WHERE dr.id IS NOT NULL
  AND ogi.office_name = '检验科'
  AND gp.del_flag = 0
  AND ( ( gp.expense_id = 1 AND gp.sporadic_physical = 0 AND pbl.state = 0 ) OR
        ( gp.sporadic_physical = '1' AND pbl.state = 0 ) OR ( gp.expense_id = 0 AND gp.sporadic_physical = 0 ) )
limit 10;