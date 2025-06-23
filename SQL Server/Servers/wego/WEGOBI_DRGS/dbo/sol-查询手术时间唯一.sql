---查询手术时间唯一
SELECT mdtrt_sn,oprn_oprt_code,oprn_oprt_name,
	oprn_oprt_date,--手术时间
  ROW_NUMBER() OVER ( PARTITION BY oprn_oprt_name, oprn_oprt_date	ORDER BY oprn_oprt_date) AS rn1,
  oprn_oprt_begn_date,--手术开始时间
	ROW_NUMBER() OVER ( PARTITION BY oprn_oprt_name, oprn_oprt_begn_date ORDER BY oprn_oprt_begn_date) AS rn2,
	oprn_oprt_end_date,--手术结束时间
	ROW_NUMBER() OVER ( PARTITION BY oprn_oprt_name, oprn_oprt_end_date  ORDER BY oprn_oprt_end_date) AS rn3,
	oper_dr_name, anst_dr_name
FROM t_setlinfo_oprninfo
WHERE mdtrt_sn = '250026649-1-002'
ORDER BY oprn_oprt_code, oprn_oprt_name, oprn_oprt_date;