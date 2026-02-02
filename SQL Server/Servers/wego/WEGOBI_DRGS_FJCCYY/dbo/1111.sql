SELECT 
			pmainindex --HIS唯一id
		 , CASE WHEN CHARINDEX('^',mdtrt_id)> 0 THEN LEFT (mdtrt_id, CHARINDEX('^',mdtrt_id) -1)  ELSE mdtrt_id  END AS mdtrt_id --mdtrt_sn
		 , CASE WHEN CHARINDEX('^',setl_id)> 0 THEN LEFT (setl_id, CHARINDEX('^',setl_id) -1)  ELSE setl_id  END AS setl_id --setl_id 结算id
		 , fixmedins_name -- 定点医药机构名称
		 , fixmedins_code -- 定点医药机构代码
		 , hi_setl_lv -- 医保结算等级 !空值
		 , hi_no -- 医保编号
		 , medcasno -- medcasno
		 , dcla_time --申报时间
		 , psn_name -- 人员姓名
		 , hi_type -- 医保类型
		 , insuplc -- 参保地编码
		 , Insuplc_desc -- 参保地描述 !空值
		 , sp_psn_type -- 特殊人员类型
		 , opsp_diag_caty -- 门诊慢特病诊断科别
		 , opsp_diag_cliccatycode -- 门诊慢特病科别编码（临床科室）
		 , opsp_diag_cliccatydesc -- 门诊慢特病科别名称（临床科室）
		 , opsp_mdtrt_date -- 门诊慢特病就诊日期
		 , ipt_med_type -- 住院医疗类型
		 , bill_code -- 票据代码 !空值
		 , bill_no -- 票据号码 !空值
		 , CASE WHEN CHARINDEX('^',biz_sn)> 0 THEN LEFT (biz_sn, CHARINDEX('^',biz_sn) -1)  ELSE biz_sn  END AS biz_sn --biz_sn 业务流水号
		 , chfpdr_name -- 主诊医师姓名
		 , chfpdr_code -- 主诊医师代码 !空值
		 , setl_begn_date -- 结算开始日期 !空值
		 , setl_end_date -- 结算结束日期 !空值
		 , psn_selfpay -- 个人自付
		 , psn_ownpay  -- 个人自费
		 , acct_pay -- 个人账户支出
		 , psn_cashpay -- 个人现金支付
		 , CASE WHEN hi_paymtd = '01' THEN '1'
						WHEN hi_paymtd = '02' THEN '2'
						WHEN hi_paymtd = '03' THEN '3'
						WHEN hi_paymtd = '04' THEN '4'
						WHEN hi_paymtd = '05' THEN '5'
						WHEN hi_paymtd = '06' THEN '6'
						WHEN hi_paymtd = '09' THEN '9'
						ELSE hi_paymtd END hi_paymtd-- 医保支付方式(建一个索引)
			, hsorg -- 医保机构
			, hsorg_code -- 医保机构代码
			, hsorg_opter -- 医保机构经办人
			, medins_fill_dept -- 医疗机构填报部门
			, medins_fill_psn -- 医疗机构填报人
			, yb_lsqd -- 清单流水号 !空值
			, yb_type_code -- 医保类型代码 !空值
			, hosp_code -- 院区编码
			, hosp_name -- 院区名称
			, fee_total -- 金额合计
			, fee_a_total -- 甲类合计
			, fee_b_total -- 乙类合计
			, fee_o_total -- 其他合计
			, fee_c_total -- 自费合计
			, polling_pay -- 医保统筹基金支付
			, fund_pay -- 基金支付(统筹+其他)
			, large_worker_pay -- 职工大额补助
			, large_resident_pay -- 居民大病保险
			, civil_pay -- 公务员补助
			, medical_pay -- 医疗救助支付
			, fee_other -- 其他支付(基金表其他支付之和)
			, substring(psn_no,9,18) psn_no -- 身份证 !有问题
		  , CASE WHEN CHARINDEX('^',DivideIdStr)> 0 THEN LEFT (DivideIdStr, CHARINDEX('^',DivideIdStr) -1) ELSE DivideIdStr END DivideIdStr -- 结算ID串
			-- , clr_options
			, med_type  -- ！用不到
			, setl_status -- 结算状态 ！用不到
			, adm_caty -- 入院科别 !新的字段还没给出
			, dscg_caty -- 出院科别 !新的字段还没给出
			, drg_pay_case_flg -- 是否DRG支付病例标志
			, tcm_treat_fee_prop -- 中医类治疗费用占比 ！用不到
			, cpd_treat_fee_prop -- 中成药费用占比  ！用不到
FROM t_setlinfo_mid
where 1=1
		-- and sp_psn_type not in ('1','2','3','4','9')
		-- and ipt_med_type not in ('1','2')
		-- and CASE WHEN hi_paymtd='01' THEN '1' WHEN hi_paymtd='02' THEN '2' WHEN hi_paymtd='03' THEN '3' WHEN hi_paymtd='04' THEN '4' WHEN hi_paymtd='05' THEN '5' WHEN hi_paymtd='06' THEN '6' WHEN hi_paymtd='09' THEN '9' ELSE hi_paymtd END not in ('1','2','3','4','5','6','7','9','901','60')
		-- and hi_paymtd not in ('310100','310200','320100','330100','340100','350100','370100','390100','390200','610100')
		-- and fee_total-fee_a_total-fee_b_total-fee_o_total-fee_c_total <>0