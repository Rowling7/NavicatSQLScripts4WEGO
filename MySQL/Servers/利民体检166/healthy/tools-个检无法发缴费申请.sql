SELECT distinct 
    A.id AS id, 
    A.patient_id AS patientId, 
    A.person_name AS patientName, 
    A.id_card AS identityNum, 
    A.visit_id AS visitId, 
    A.create_id AS operator, 
    A.test_num AS paiVisitId, 
    B.office_id AS currentOrgdCode, 
    B.order_application_id as orderId, 
    B.id AS applyNo, 
    C.his_code AS clinicItemId, 
    B.name AS clinicItemName, 
    CASE 
        WHEN E.section_name = '检验科' THEN 'C' 
        ELSE 'D' 
    END AS itemType, 
    CASE 
        WHEN E.section_name = '检验科' THEN '1' 
        ELSE '0' 
    END AS feeType, 
    C1.base_project_his_code AS feeItemId, 
    C1.base_project_his_name AS feeItemName, 
    CASE 
        WHEN E.section_name = '检验科' THEN '1' 
        ELSE '0' 
    END AS billingMethod, 
    C1.sale_price AS unitPrice, 
    C1.sale_price AS totalPrice, 
    C1.sale_price AS charges, 
    B.discount_price AS discountPrice, 
    B.discount AS discount, 
    A.create_id AS applyDoctorCode, 
    D.nickname AS applyDoctorName, 
    B.office_id AS execOrgCode, 
    B.office_name AS execOrgName 
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 A 
LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 B 
    ON A.order_id = B.group_order_id and A.group_id=B.group_id 
LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 C 
    ON B.portfolio_project_id = C.id 
LEFT JOIN t_user D 
    ON A.create_id = D.id 
LEFT JOIN t_his_clinic_price C1 
    ON C.his_code=C1.portfolio_project_his_code 
LEFT JOIN t_section_office_f594102095fd9263b9ee22803eb3f4e5 E 
    ON B.office_id = E.id 
WHERE A.test_num = '176094430600017'  AND C1.sale_price is NULL