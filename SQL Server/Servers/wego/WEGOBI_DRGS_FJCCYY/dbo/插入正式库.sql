-- 1
-- 更新dise的mdtrt_sn
update sdm 
set sdm.mdtrt_sn	=CASE WHEN CHARINDEX('^',sim.mdtrt_id)> 0 THEN LEFT (sim.mdtrt_id, CHARINDEX('^',sim.mdtrt_id) -1)  ELSE sim.mdtrt_id  END 
from t_setlinfo_diseinfo_mid sdm
left join t_setlinfo_mid  sim on sdm.pmainindex=sim.pmainindex ;
DELETE FROM t_setlinfo_diseinfo WHERE mdtrt_sn IN (SELECT mdtrt_sn FROM t_setlinfo_diseinfo_mid sdm WHERE sdm.mdtrt_sn NOT IN (SELECT mdtrt_sn FROM t_setlinfo));
-- 插入diseinfo表
INSERT INTO
  t_setlinfo_diseinfo (
    id
    , mdtrt_sn
    , diag_type
    , diag_code
    , diag_name
    , adm_cond_type
    , maindiag_flag
    , tcm_dise_flag
    , sort
  )
SELECT
   id
  , mdtrt_sn
  , sdm.diag_type
  , REPLACE(sdm.diag_code  , NCHAR(8224)  , '+')
  , sdm.diag_name
  , sdm.adm_cond_type
  , CASE
    WHEN sdm.maindiag_flag = 'M' THEN '1'
    WHEN sdm.maindiag_flag = 'O' THEN '2'
    ELSE sdm.maindiag_flag
  END
  , sdm.tcm_dise_flag
  , sdm.sort
FROM
  t_setlinfo_diseinfo_mid sdm
where sdm.mdtrt_sn not in (SELECT mdtrt_sn from t_setlinfo);


--2
-- 更新 oprn 的mdtrt_sn
update som 
set som.mdtrt_sn	=CASE WHEN CHARINDEX('^',sim.mdtrt_id)> 0 THEN LEFT (sim.mdtrt_id, CHARINDEX('^',sim.mdtrt_id) -1)  ELSE sim.mdtrt_id  END 
from t_setlinfo_oprninfo_mid som
left join t_setlinfo_mid  sim on som.pmainindex=sim.pmainindex ;
DELETE from t_setlinfo_oprninfo where mdtrt_sn  in (SELECT  [mdtrt_sn] FROM t_setlinfo_oprninfo_mid where mdtrt_sn not in (SELECT mdtrt_sn from t_setlinfo));
--插入oprninfo表
INSERT INTO
  [dbo].[t_setlinfo_oprninfo] (
    [id]
    , [mdtrt_sn]
    , [oprn_oprt_type]
    , [oprn_oprt_name]
    , [oprn_oprt_code]
    , [oprn_oprt_date]
    , [anst_way]
    , [oper_dr_name]
    , [oper_dr_code]
    , [oper_dr_code_std]
    , [anst_dr_name]
    , [anst_dr_code]
    , [anst_dr_code_std]
    , [sort]
    , [oprn_oprt_lev]
    , [oprn_oprt_begntime]
    , [oprn_oprt_endtime]
    , [anst_begntime]
    , [anst_endtime]
  )
SELECT
  [id]
  , [mdtrt_sn]
  , case when oprn_oprt_type='M' then '1' when oprn_oprt_type='O' then '2'else oprn_oprt_type end
  , [oprn_oprt_name]
  , [oprn_oprt_code]
  , [oprn_oprt_date]
  , [anst_way]
  , [oper_dr_name]
  , [oper_dr_code]
  , [oper_dr_code_std]
  , [anst_dr_name]
  , [anst_dr_code]
  , [anst_dr_code_std]
  , [sort]
  , [oprn_oprt_lev]
  , [oprn_oprt_begntime]
  , [oprn_oprt_endtime]
  , [anst_begntime]
  , [anst_endtime]
FROM
  t_setlinfo_oprninfo_mid
where mdtrt_sn not in (SELECT mdtrt_sn from t_setlinfo);


--3
DELETE from t_setlinfo_payinfo where mdtrt_sn in(SELECT CASE WHEN CHARINDEX('^',mdtrt_sn)> 0 THEN LEFT (mdtrt_sn, CHARINDEX('^',mdtrt_sn) -1)  ELSE mdtrt_sn  END FROM   [dbo].[t_setlinfo_payinfo_mid] WHERE mdtrt_sn NOT IN (SELECT mdtrt_sn FROM t_setlinfo)
);
--插入payinfo
INSERT INTO
  [dbo].[t_setlinfo_payinfo] (
		[id]
  , [mdtrt_sn]
  , [fund_pay_type]
  , [fund_payamt]
)
SELECT
  [id]
  , CASE WHEN CHARINDEX('^',mdtrt_sn)> 0 THEN LEFT (mdtrt_sn, CHARINDEX('^',mdtrt_sn) -1)  ELSE mdtrt_sn  END
  , [fund_pay_type]
  , [fund_payamt]
FROM
  [dbo].[t_setlinfo_payinfo_mid]
WHERE
mdtrt_sn NOT IN (SELECT mdtrt_sn FROM t_setlinfo);

--4
DELETE from t_setlinfo_iteminfo where mdtrt_sn in (SELECT CASE WHEN CHARINDEX('^',mdtrt_sn)> 0 THEN LEFT (mdtrt_sn, CHARINDEX('^',mdtrt_sn) -1)  ELSE mdtrt_sn  END FROM [dbo].[t_setlinfo_iteminfo_mid] WHERE mdtrt_sn NOT IN (SELECT mdtrt_sn FROM t_setlinfo));
-- 插入iteminfo表
INSERT INTO
  [dbo].[t_setlinfo_iteminfo] (
    [id]
    , [mdtrt_sn]
    , [med_chrgitm]
    , [amt]
    , [claa_sumfee]
    , [clab_amt]
    , [fulamt_ownpay_amt]
    , [oth_amt]
  )
SELECT
  [id]
	, CASE WHEN CHARINDEX('^',mdtrt_sn)> 0 THEN LEFT (mdtrt_sn, CHARINDEX('^',mdtrt_sn) -1)  ELSE mdtrt_sn  END
  , [med_chrgitm]
  , [amt]
  , [claa_sumfee]
  , [clab_amt]
  , [fulamt_ownpay_amt]
  , [oth_amt]
FROM
  [dbo].[t_setlinfo_iteminfo_mid]
WHERE mdtrt_sn NOT IN (SELECT mdtrt_sn FROM t_setlinfo);

--5 最后插入setlinfo表
INSERT INTO [dbo].[t_setlinfo] (
	acct_payamt
,	acp_medins_name
,	acp_optins_code
,	act_ipt_days
,	adm_caty
,	adm_dept_codg
,	adm_dept_name
,	adm_time
,	adm_way
,	age
,	bill_code
,	bill_no
,	biz_sn
,	bld_amt
,	bld_cat
,	bld_unt
,	brdy
,	brjsrq
,	brjsrq_dateofmonth
,	certno
,	check_fee
,	chfpdr_code
,	chfpdr_code_std
,	chfpdr_name
,	chinese_drug_fee
,	chinese_slice_drug_fee
,	coner_addr
,	coner_name
,	coner_tel
,	consumable_fee
,	createtime
,	curr_addr
,	curr_addr_cotycode
,	curr_addr_provcode
,	curr_addr_rdgncode
,	cyksbm
,	cyksbm_area
,	cyksmc
,	days_rinp_flag_31
,	days_rinp_pup_31
,	dcla_time
,	diag_code_cnt
,	drug_fee
,	dscg_caty
,	dscg_dept_codg
,	dscg_dept_name
,	dscg_time
,	dscg_way
,	emp_addr
,	emp_name
,	emp_tel
,	fixmedins_code
,	fixmedins_name
,	gend
,	hi_no
,	hi_paymtd
,	hi_setl_lv
,	hi_type
,	hsorg
,	hsorg_code
,	hsorg_opter
,	hsorg_opter_code
,	insuplc
,	ipt_med_type
,	is_rjbf
,	isdrg
,	lv1_nurscare_days
,	lv3_nurscare_days
,	main_diag_code
,	main_diag_name
,	main_oper_dr_name
,	main_oper_oprn_code
,	main_oper_oprn_name
,	mdtrt_id
,	medcasno
,	medical_fee
,	medical_group
,	medical_zz_time
,	medicalinsurancecoder
,	medicalinsurancecodetime
,	medicalrecordcoder
,	medicalrecordcodetime
,	medins_fill_dept
,	medins_fill_psn
,	mul_nwb_adm_wt
,	mul_nwb_bir_wt
,	naty
,	ntly
,	nwb_adm_type
,	nwb_adm_wt
,	nwb_age
,	nwb_bir_wt
,	oprn_oprt_code_cnt
,	opsp_diag_caty
,	opsp_mdtrt_date
,	other_diag_code1
,	other_diag_name1
,	otp_tcm_dise
,	otp_wm_dise
,	patn_cert_type
,	patn_rlts
,	payloc
,	poscode
,	prfs
,	psn_cashpay
,	psn_name
,	psn_no
,	psn_ownpay_fee
,	psn_selfpay_amt
,	pwcry_afadm_coma_dura
,	pwcry_bfadm_coma_dura
,	refldept_dept
,	refldept_dept1
,	refldept_dept2
,	refldept_dept3
,	refldept_dept4
,	refldept_dept5
,	resp_nurs_code
,	resp_nurs_code_std
,	resp_nurs_name
,	ryksbm
,	ryksmc
,	scd_nurscare_days
,	setl_begn_date
,	setl_end_date
,	setl_id
,	setl_list_id
,	sp_psn_type
,	spga_nurscare_days
,	stas_type
,	tcm_dise_code
,	total_fee
,	trt_type
,	vent_used_dura
,	west_drug_fee
,	wm_dise_code
,	mdtrt_sn
)
SELECT 
	null
,	null
,	null
,	null
,	adm_caty
,	null
,	null
,	null
,	null
,	null
,	bill_code
,	bill_no
, CASE  WHEN CHARINDEX( '^', biz_sn )> 0 THEN LEFT ( biz_sn, CHARINDEX( '^', biz_sn ) - 1 )  ELSE biz_sn  END AS biz_sn
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	chfpdr_code
,	null
,	chfpdr_name
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	dcla_time
,	null
,	null
,	dscg_caty
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	fixmedins_code
,	fixmedins_name
,	null
,	hi_no
,	hi_paymtd
,	hi_setl_lv
,	hi_type
,	hsorg
,	hsorg_code
,	hsorg_opter
,	hsorg_opter_code
,	insuplc
,	ipt_med_type
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
, CASE  WHEN CHARINDEX( '^', mdtrt_id )> 0 THEN LEFT ( mdtrt_id, CHARINDEX( '^', mdtrt_id ) - 1 )  ELSE mdtrt_id  END AS mdtrt_id
,	medcasno
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	medins_fill_dept
,	medins_fill_psn
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	opsp_diag_caty
,	opsp_mdtrt_date
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	psn_cashpay
,	psn_name
,	psn_no
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	setl_begn_date
,	setl_end_date
, CASE  WHEN CHARINDEX( '^', setl_id )> 0 THEN LEFT ( setl_id, CHARINDEX( '^', setl_id ) - 1 )  ELSE setl_id  END AS setl_id
,	null
,	sp_psn_type
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	null
, CASE  WHEN CHARINDEX( '^', mdtrt_id )> 0 THEN LEFT ( mdtrt_id, CHARINDEX( '^', mdtrt_id ) - 1 )  ELSE mdtrt_id  END AS mdtrt_sn
FROM
	t_setlinfo_mid 
where CASE  WHEN CHARINDEX( '^', mdtrt_id )> 0 THEN LEFT ( mdtrt_id, CHARINDEX( '^', mdtrt_id ) - 1 )  ELSE mdtrt_id end  not in (SELECT mdtrt_sn from t_setlinfo)