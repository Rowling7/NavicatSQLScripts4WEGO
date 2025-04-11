/*
	4. 重复手术的手术日期oprn_oprt_date中‘年月日时分秒’完全一致时，会上传失败校验不通过，
	上报失败错误信息为：违反唯一约束条件(JSQD_OPERATION_INFO)；
*/
UPDATE t_setlinfo_oprninfo 
SET oprn_oprt_date = dateadd( MINUTE, 1, oprn_oprt_date ) 
WHERE
	id IN (
	SELECT
		id 
	FROM
		(
		SELECT
			id,
			ROW_NUMBER ( ) OVER ( partition BY mdtrt_sn, oprn_oprt_code, oprn_oprt_date ORDER BY id ) rn 
		FROM
			(
			SELECT
				a.* 
			FROM
				t_setlinfo_oprninfo a,
				(
				SELECT
					mdtrt_sn,
					oprn_oprt_code,
					oprn_oprt_date,
					COUNT ( * ) cont 
				FROM
					t_setlinfo_oprninfo 
				GROUP BY
					mdtrt_sn,
					oprn_oprt_code,
					oprn_oprt_date 
				HAVING
					COUNT ( * ) > 1 
				) b 
			WHERE
				a.mdtrt_sn= b.mdtrt_sn 
				AND a.oprn_oprt_code= b.oprn_oprt_code 
				AND a.oprn_oprt_date= b.oprn_oprt_date 
				AND a.mdtrt_sn IN (
				SELECT
					mdtrt_sn 
				FROM
					t_setlinfo a
					LEFT JOIN t_mihs_result_relation b ON a.mdtrt_sn = b.uid
					LEFT JOIN t_mihs_result c ON b.resultid= c.id 
				WHERE
					c.infocode=- 1 
					AND c.err_msg NOT LIKE '%省平台%' --每个医院要求不一样
					AND c.err_msg LIKE '%JSQD_OPERATION_INFO%' 
				) 
			) a 
		) id 
	WHERE
	rn = 1 
	) 