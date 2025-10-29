WITH RECURSIVE obx_indexes (
    index_num, 
    next_pos, 
    str_len, 
    orig_request_param,  -- 保存原始request_param
    order_application_id,
    request_param,       -- 新增：第一个计算字段
    request_param2       -- 新增：第二个计算字段
) AS (
    -- 初始步骤：计算所有基础字段（包括新增的两个字段）
    SELECT
        -- 提取OBX序号
        CASE 
            WHEN LOCATE('OBX|', UPPER(t.request_param), 1) > 0 
                AND LOCATE('|', t.request_param, LOCATE('OBX|', UPPER(t.request_param), 1) + 4) > LOCATE('OBX|', UPPER(t.request_param), 1) + 4
            THEN CAST(SUBSTRING(
                t.request_param,
                LOCATE('OBX|', UPPER(t.request_param), 1) + 4,
                LOCATE('|', t.request_param, LOCATE('OBX|', UPPER(t.request_param), 1) + 4) - (LOCATE('OBX|', UPPER(t.request_param), 1) + 4)
            ) AS UNSIGNED)
            ELSE NULL 
        END AS index_num,
        -- 下一次起始位置
        LOCATE('OBX|', UPPER(t.request_param), 1) + 1 AS next_pos,
        -- 字符串长度
        CHAR_LENGTH(t.request_param) AS str_len,
        -- 保存原始request_param（用于后续关联）
        t.request_param AS orig_request_param,
        -- 订单ID
        t.order_application_id,
        -- 计算第一个字段（注意：SUBSTRING_INDEX第三个参数是数字，非字符串）
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(
                SUBSTR(
                    SUBSTRING_INDEX(t.request_param, 'OBR|1||', -1),  -- 取'OBR|1||'之后的部分
                    9, 999  -- 从第9个字符开始取999个字符
                ), 
                '|||', 1  -- 按'|||'分割，取第1部分
            ), 
            '^', 1  -- 按'^'分割，取第1部分
        ) AS request_param,
        -- 计算第二个字段
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(
                SUBSTR(
                    SUBSTRING_INDEX(t.request_param, 'OBR|1||', -1), 
                    9, 999
                ), 
                '|||', 1
            ), 
            '^', -1  -- 按'^'分割，取最后1部分
        ) AS request_param2
    FROM t_log_f594102095fd9263b9ee22803eb3f4e5 t
    WHERE t.log_type = 2
      AND t.del_flag = 0
      -- AND t.order_application_id = '90001102629'
			AND CASE WHEN t.order_application_id IS NOT NULL THEN t.order_application_id
           WHEN request_param LIKE '%ORC|SC|%' THEN
               LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(t.request_param, 'ORC|SC|', -1), '^^', 1), 20)
           WHEN request_param LIKE '%ORC|NW|%' THEN
               LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(t.request_param, 'ORC|NW|', -1), '^^', 1), 20)
           WHEN request_param LIKE '%ORC|SN|%' THEN
               LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(t.request_param, 'ORC|SN|', -1), '|||||||', 1), 20)
           ELSE NULL END IN (SELECT dr.barcode
                    FROM t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr
                    WHERE dr.office_name = '检验科'
                      AND dr.barcode IS NOT NULL
                    GROUP BY
                        dr.barcode
                    HAVING COUNT(dr.order_application_id) < 2)
  AND t.request_param NOT LIKE 'CALL p_healthy_result%'
	and t.name = 'LisReceiveHL7Message' 
      AND LOCATE('OBX|', UPPER(t.request_param), 1) > 0

    UNION ALL

    -- 递归步骤：传递原始字段（无需重新计算新增字段，因基于原始request_param）
    SELECT 
        -- 提取当前OBX序号
        CASE 
            WHEN LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) > 0 
                AND LOCATE('|', oi.orig_request_param, LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) + 4) > LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) + 4
            THEN CAST(SUBSTRING(
                oi.orig_request_param,
                LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) + 4,
                LOCATE('|', oi.orig_request_param, LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) + 4) - (LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) + 4)
            ) AS UNSIGNED)
            ELSE NULL 
        END AS index_num,
        -- 更新下一次起始位置
        LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) + 1 AS next_pos,
        -- 传递字符串长度
        oi.str_len AS str_len,
        -- 传递原始request_param
        oi.orig_request_param,
        -- 传递订单ID
        oi.order_application_id,
        -- 传递第一个计算字段（无需重新计算）
        oi.request_param,
        -- 传递第二个计算字段（无需重新计算）
        oi.request_param2
    FROM obx_indexes oi
    -- 关联原始表（确保同一条记录）
    INNER JOIN t_log_f594102095fd9263b9ee22803eb3f4e5 t
        ON t.request_param = oi.orig_request_param
        AND t.log_type = 2
        AND t.del_flag = 0
        AND t.order_application_id = oi.order_application_id
    -- 递归终止条件
    WHERE oi.next_pos < oi.str_len
      AND LOCATE('OBX|', UPPER(oi.orig_request_param), oi.next_pos) > 0
)

-- 最终结果：同时输出所有字段
SELECT 
    order_application_id,
    request_param as ppcode,       
    request_param2 as ppname,      
    MAX(index_num) AS max_obx_number  -- 最大OBX序号
FROM obx_indexes
WHERE index_num IS NOT NULL
GROUP BY 
    order_application_id, 
    request_param, 
    request_param2  
		limit 100;