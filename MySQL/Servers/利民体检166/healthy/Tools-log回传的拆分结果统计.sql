SELECT sp.order_application_id,
       GROUP_CONCAT(DISTINCT sp.projectcode) AS project_codes,
       COUNT(DISTINCT sp.projectcode) AS project_code_count,
       GROUP_CONCAT(DISTINCT sp.projectname) AS project_names,
       dr.barname,
       dr.office_name AS office_name
FROM t_small_project_f594102095fd9263b9ee22803eb3f4e5 sp
    LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON sp.order_application_id = dr.barcode
WHERE dr.order_application_id LIKE '900%'
GROUP BY
    sp.order_application_id,
    dr.barname,
    dr.office_name