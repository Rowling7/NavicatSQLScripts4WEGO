UPDATE t_depart_item_result_f594102095fd9263b9ee22803eb3f4e5 AS a
INNER JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 AS b
    ON a.person_id = b.person_id
    AND a.order_group_item_name = b.group_item_name
SET
    -- ① diagnose_sum 为空才更新
    a.diagnose_sum = CASE
        WHEN (a.diagnose_sum IS NULL OR a.diagnose_sum = '') THEN b.diagnose_sum
        ELSE a.diagnose_sum
    END,
    -- ② check_doc 为空才更新
    a.check_doc = CASE
        WHEN (a.check_doc IS NULL OR a.check_doc = '') THEN b.check_doc
        ELSE a.check_doc
    END,
    -- ③ ignore_status 直接更新为 1
    a.ignore_status = 1,
    -- ④ 如果 b.diagnose_sum 为“未见异常”或“未见明显异常”，则更新 positive 和 crisis_degree
    a.positive = CASE
        WHEN b.diagnose_sum IN ('未见异常', '未见明显异常') THEN 0
        ELSE a.positive
    END,
    a.crisis_degree = CASE
        WHEN b.diagnose_sum IN ('未见异常', '未见明显异常') THEN '正常'
        ELSE a.crisis_degree
    END
WHERE
    a.person_id in('53dfacabf42c4e22ae8b4e2588e30f4d',
'71c74d5f2de2436aaa35efee5c7453cb',
'8842d623364f4f9fbb36335769ab77da',
'8bf33f2de6954f44a07396fb549a5b98',
'9c281bf6725941a7aa2eca4131730154',
'dfb526a60d974a13a9af75a6ae680014',
'f8f2b5cc9e774de9b9b42624e32b0e4b'
)
    AND a.order_group_item_name = '眼科检查';