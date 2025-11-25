SELECT DISTINCT p2.person_name
            , p2.groupName
            , p2.group_id
            , p2.test_num
            , p2.physical_type
            , p2.dept
            , p2.is_pass
            , p2.sex
            , p2.mobile
            , p2.age
            , p2.sporadic_physical
            , p2.update_time
            , tppffbeefe.person_id
            , tu.nickname
            , tppffbeefe.update_time AS zjTime
            , tppffbeefe.heavy
            , tppffbeefe.id
            , tppffbeefe.result
            , tppffbeefe.positive_name
            , tppffbeefe.positive_suggestion
            , tppffbeefe.conclusion_type
            , tppffbeefe.feedback
            , tppffbeefe.unit_name
            , tppffbeefe.scope
            , tppffbeefe.order_group_item_name
            , tppffbeefe.order_group_item_project_name
            , gi.id AS groupItemId
            , gi.office_id AS officeId
            , gi.office_name AS officeName
            , dir.order_application_id AS orderApplicationId
       FROM t_positive_person_f594102095fd9263b9ee22803eb3f4e5 tppffbeefe
            LEFT JOIN
       t_user tu ON tu.id = tppffbeefe.update_id
            LEFT JOIN ( SELECT p.*
                             , tog.name AS groupName
                        FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 p
                           , t_order_group_f594102095fd9263b9ee22803eb3f4e5 tog
                        WHERE tog.id = p.group_id
                          AND tog.del_flag = '0' ) p2 ON tppffbeefe.person_id = p2.id
            LEFT JOIN t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 gi ON gi.group_id = p2.group_id
           AND gi.name = tppffbeefe.order_group_item_name
           AND gi.del_flag = '0'
            LEFT JOIN t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 dir
                      ON dir.person_id = p2.id
                          AND dir.order_group_item_name = tppffbeefe.order_group_item_name
                          AND dir.del_flag = '0'
       WHERE tppffbeefe.del_flag = '0'
         AND tppffbeefe.heavy = 'A'
         AND p2.person_name != ''

ORDER BY zjTime DESC