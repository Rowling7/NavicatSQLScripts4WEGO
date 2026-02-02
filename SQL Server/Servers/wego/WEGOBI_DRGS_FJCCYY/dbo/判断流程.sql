-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE  [dbo].[P_DRG_CHECK_UPDATE_NEWHIS]
  
AS
BEGIN
	 
--获取有变化的流水号
select  a.mdtrt_sn   into #temp_del     from   [WEGOBI_DRGS].[dbo].[t_setlinfo_mid_newhis]  a,
[WEGOBI_DRGS].[dbo].[t_setlinfo] b
where   a.mdtrt_sn=b.mdtrt_sn  
	and (convert(date,a.brjsrq,23)<>convert(date,b.brjsrq,23) 
		
		or convert(date,a.MedicalRecordCodeTime,23)<>convert(date,b.MedicalRecordCodeTime,23)
		);




insert into  #temp_del select  mdtrt_sn  from   [t_setlinfo_mid_newhis]
where   mdtrt_sn not in (
	  select  mdtrt_sn from  [WEGOBI_DRGS].[dbo].[t_setlinfo]);


 
 --删除历史数据 及上报、入组信息
delete    from  WEGOBI_DRGS.dbo.t_setlinfo  where  mdtrt_sn in (select  mdtrt_sn   from #temp_del);
delete    from  WEGOBI_DRGS.dbo.t_setlinfo_diseinfo  where  mdtrt_sn in (select  mdtrt_sn   from #temp_del);
delete    from  WEGOBI_DRGS.dbo.t_setlinfo_oprninfo  where  mdtrt_sn in (select  mdtrt_sn   from #temp_del);
delete    from  WEGOBI_DRGS.dbo.t_setlinfo_iteminfo  where  mdtrt_sn in (select  mdtrt_sn   from #temp_del);
delete    from  WEGOBI_DRGS.dbo.t_setlinfo_icuinfo  where  mdtrt_sn in (select  mdtrt_sn   from #temp_del);
delete  from   [WEGOBI_DRGS].[dbo].[t_mihs_result_relation]    where  uid in (select  mdtrt_sn   from #temp_del);
delete  from   [WEGOBI_DRGS].[dbo].[t_drg_result_relation]    where  uid in (select  mdtrt_sn   from #temp_del);


--更新修正状态
UPDATE WEGOBI_DRGS.dbo.t_setlinfo_revise SET isvalid = 0 WHERE   mdtrt_sn    in (select  mdtrt_sn   from #temp_del);

 
--将更新后数据插入正式表
insert into WEGOBI_DRGS.dbo.t_setlinfo(  [mdtrt_sn]
      ,[BRJSRQ]
      ,[fixmedins_name]
      ,[fixmedins_code]
      ,[hi_setl_lv]
      ,[hi_no]
      ,[medcasno]
      ,[dcla_time]
      ,[psn_name]
      ,[gend]
      ,[brdy]
      ,[age]
      ,[ntly]
      ,[nwb_age]
      ,[naty]
      ,[patn_cert_type]
      ,[certno]
      ,[prfs]
      ,[curr_addr]
      ,[curr_addr_provcode]
      ,[curr_addr_rdgncode]
      ,[curr_addr_cotycode]
      ,[emp_name]
      ,[emp_addr]
      ,[emp_tel]
      ,[poscode]
      ,[coner_name]
      ,[patn_rlts]
      ,[coner_addr]
      ,[coner_tel]
      ,[hi_type]
      ,[insuplc]
      ,[sp_psn_type]
      ,[nwb_adm_type]
      ,[nwb_bir_wt]
      ,[nwb_adm_wt]
      ,[opsp_diag_caty]
      ,[opsp_mdtrt_date]
      ,[ipt_med_type]
      ,[adm_way]
      ,[trt_type]
      ,[adm_time]
      ,[adm_caty]
      ,[RYKSbm]
      ,[refldept_dept]
      ,[refldept_dept1]
      ,[refldept_dept2]
      ,[refldept_dept3]
      ,[refldept_dept4]
      ,[refldept_dept5]
      ,[dscg_time]
      ,[dscg_caty]
      ,[CYKSbm]
      ,[cyksbm_sub]
      ,[act_ipt_days]
      ,[otp_wm_dise]
      ,[wm_dise_code]
      ,[otp_tcm_dise]
      ,[tcm_dise_code]
      ,[diag_code_cnt]
      ,[oprn_oprt_code_cnt]
      ,[vent_used_dura]
      ,[pwcry_bfadm_coma_dura]
      ,[pwcry_afadm_coma_dura]
      ,[bld_cat]
      ,[bld_amt]
      ,[bld_unt]
      ,[spga_nurscare_days]
      ,[lv1_nurscare_days]
      ,[scd_nurscare_days]
      ,[lv3_nurscare_days]
      ,[dscg_way]
      ,[acp_medins_name]
      ,[acp_optins_code]
      ,[bill_code]
      ,[bill_no]
      ,[biz_sn]
      ,[days_rinp_flag_31]
      ,[days_rinp_pup_31]
      ,[chfpdr_name]
      ,[chfpdr_code]
      ,[chfpdr_code_std]
      ,[resp_nurs_code]
      ,[resp_nurs_name]
      ,[resp_nurs_code_std]
      ,[setl_begn_date]
      ,[setl_end_date]
      ,[psn_selfpay]
      ,[psn_ownpay]
      ,[acct_pay]
      ,[psn_cashpay]
      ,[hi_paymtd]
      ,[hsorg_code]
      ,[hsorg]
      ,[hsorg_opter_code]
      ,[hsorg_opter]
      ,[medins_fill_dept]
      ,[medins_fill_psn]
      ,[setl_list_id]
        ,[ryksmc]     
      ,[cyksmc]       
      ,[brjsrq_dateofmonth]
      ,[medical_group]
      ,[drug_fee]
      ,[consumable_fee]
      ,[check_fee]
      ,[medical_fee]
      ,[total_fee]
      ,[Main_oper_dr_name]
      ,[sort]
      ,[bedno]
      ,[MedicalInsuranceCodeTime]
      ,[MedicalInsuranceCoder]
      ,[Medical_ZZ_Time]
      ,[MedicalRecordCodeTime]
      ,[MedicalRecordCoder]
  
	  ,IS_NEWHIS
	  ,is_rjbf
 
 )

select  [mdtrt_sn]
      ,[BRJSRQ]
      ,[fixmedins_name]
      ,[fixmedins_code]
      ,[hi_setl_lv]
      ,[hi_no]
      ,[medcasno]
      ,[dcla_time]
      ,[psn_name]
      ,[gend]
      ,[brdy]
      ,[age]
      ,[ntly]
      ,[nwb_age]
      ,[naty]
      ,[patn_cert_type]
      ,[certno]
      ,[prfs]
      ,[curr_addr]
      ,[curr_addr_provcode]
      ,[curr_addr_rdgncode]
      ,[curr_addr_cotycode]
      ,[emp_name]
      ,[emp_addr]
      ,[emp_tel]
      ,[poscode]
      ,[coner_name]
      ,[patn_rlts]
      ,[coner_addr]
      ,[coner_tel]
      ,[hi_type]
      ,[insuplc]
      ,[sp_psn_type]
      ,[nwb_adm_type]
      ,[nwb_bir_wt]
      ,[nwb_adm_wt]
      ,[opsp_diag_caty]
      ,[opsp_mdtrt_date]
      ,[ipt_med_type]
      ,[adm_way]
      ,[trt_type]
      ,[adm_time]
      ,[adm_caty]
      ,[RYKSbm]
      ,[refldept_dept]
      ,[refldept_dept1]
      ,[refldept_dept2]
      ,[refldept_dept3]
      ,[refldept_dept4]
      ,[refldept_dept5]
      ,[dscg_time]
      ,[dscg_caty]
      ,[CYKSbm]
      ,[cyksbm_sub]
      ,[act_ipt_days]
      ,[otp_wm_dise]
      ,[wm_dise_code]
      ,[otp_tcm_dise]
      ,[tcm_dise_code]
      ,[diag_code_cnt]
      ,[oprn_oprt_code_cnt]
      ,[vent_used_dura]
      ,[pwcry_bfadm_coma_dura]
      ,[pwcry_afadm_coma_dura]
      ,[bld_cat]
      ,[bld_amt]
      ,[bld_unt]
      ,[spga_nurscare_days]
      ,[lv1_nurscare_days]
      ,[scd_nurscare_days]
      ,[lv3_nurscare_days]
      ,[dscg_way]
      ,[acp_medins_name]
      ,[acp_optins_code]
      ,[bill_code]
      ,[bill_no]
      ,[biz_sn]
      ,[days_rinp_flag_31]
      ,[days_rinp_pup_31]
      ,[chfpdr_name]
      ,[chfpdr_code]
      ,[chfpdr_code_std]
      ,[resp_nurs_code]
      ,[resp_nurs_name]
      ,[resp_nurs_code_std]
      ,[setl_begn_date]
      ,[setl_end_date]
      ,[psn_selfpay]
      ,[psn_ownpay]
      ,[acct_pay]
      ,[psn_cashpay]
      ,[hi_paymtd]
      ,[hsorg_code]
      ,[hsorg]
      ,[hsorg_opter_code]
      ,[hsorg_opter]
      ,[medins_fill_dept]
      ,[medins_fill_psn]
      ,[setl_list_id]
      ,[RYKSbm]    -- ,[ryksmc]名称调整成编码(实际编码就是名称)
      ,[CYKSbm]	   -- ,[cyksmc]名称调整成编码(实际编码就是名称)
      ,[brjsrq_dateofmonth]
      ,[medical_group]
      ,[drug_fee]
      ,[consumable_fee]
      ,[check_fee]
      ,[medical_fee]
      ,[total_fee]
      ,[Main_oper_dr_name]
      ,[sort]
      ,[bedno]
      ,[MedicalInsuranceCodeTime]
      ,[MedicalInsuranceCoder]
      ,[Medical_ZZ_Time]
      ,[MedicalRecordCodeTime]
      ,[MedicalRecordCoder]
	  ,1
	  ,is_rjbf
 	  from    [WEGOBI_DRGS].[dbo].[t_setlinfo_mid_newhis]  where  mdtrt_sn in (select mdtrt_sn  from #temp_del)    ;
	  


---诊断信息
insert into   [WEGOBI_DRGS].[dbo].[t_setlinfo_diseinfo] (
 [mdtrt_sn]
      ,[diag_type]
      ,[SORT]
      ,[diag_code]
      ,[diag_name]
      ,[adm_cond_type]
      ,[maindiag_flag]
      ,[tcm_dise_flag]
	  ,isupload
)
select   [mdtrt_sn]
      ,[diag_type]
      ,[SORT]
      ,[diag_code]
      ,[diag_name]
      ,[adm_cond_type]
      ,[maindiag_flag]
      ,[tcm_dise_flag]
	  ,isupload
  FROM [WEGOBI_DRGS].[dbo].[t_setlinfo_diseinfo_mid_newhis]  where  mdtrt_sn in (select mdtrt_sn  from #temp_del) ;

--手术信息
insert into [WEGOBI_DRGS].[dbo].[t_setlinfo_oprninfo] (  [mdtrt_sn]
      ,[oprn_oprt_type]
      ,[sort]
      ,[oprn_oprt_name]
      ,[oprn_oprt_code]
      ,[oprn_oprt_date]
      ,[oprn_oprt_begn_date]
      ,[oprn_oprt_end_date]
      ,[anst_way]
      ,[oper_dr_name]
      ,[oper_dr_code]
      ,[oper_dr_code_std]
      ,[anst_dr_name]
      ,[anst_dr_code]
      ,[anst_dr_code_std]
      ,[anst_begn_date]
      ,[anst_end_date]
      ,[oprn_oprt_lev]
      ,[is_mis]
  )
select   [mdtrt_sn]
      ,[oprn_oprt_type]
      ,[sort]
      ,[oprn_oprt_name]
      ,[oprn_oprt_code]
      ,[oprn_oprt_date]
      ,[oprn_oprt_begn_date]
      ,[oprn_oprt_end_date]
      ,[anst_way]
      ,[oper_dr_name]
      ,[oper_dr_code]
      ,[oper_dr_code_std]
      ,[anst_dr_name]
      ,[anst_dr_code]
      ,[anst_dr_code_std]
      ,[anst_begn_date]
      ,[anst_end_date]
      ,[oprn_oprt_lev]
      ,[is_mis]
  FROM [WEGOBI_DRGS].[dbo].[t_setlinfo_oprninfo_mid_newhis] where  mdtrt_sn in (select mdtrt_sn  from #temp_del)  ;

--费用信息
insert into  [WEGOBI_DRGS].[dbo].[t_setlinfo_iteminfo] ( [mdtrt_sn]
      ,[med_chrgitm]
      ,[amt]
      ,[claa_sumfee]
      ,[clab_amt]
      ,[fulamt_ownpay_amt]
      ,[oth_amt]
)
select  [mdtrt_sn]
      ,[med_chrgitm]
      ,[amt]
      ,[claa_sumfee]
      ,[clab_amt]
      ,[fulamt_ownpay_amt]
      ,[oth_amt]
  FROM [WEGOBI_DRGS].[dbo].[t_setlinfo_iteminfo_mid_newhis]   where  mdtrt_sn in (select mdtrt_sn  from #temp_del)  ;
---重症信息	  
insert into   [WEGOBI_DRGS].[dbo].[t_setlinfo_icuinfo] ( [mdtrt_sn]
      ,[scs_cutd_ward_type]
      ,[scs_cutd_inpool_time]
      ,[scs_cutd_exit_time]
      ,[scs_cutd_sum_dura]
)
select  [mdtrt_sn]
      ,[scs_cutd_ward_type]
      ,[scs_cutd_inpool_time]
      ,[scs_cutd_exit_time]
      ,[scs_cutd_sum_dura]
  FROM [WEGOBI_DRGS].[dbo].[t_setlinfo_icuinfo_mid_newhis]  where  mdtrt_sn in (select mdtrt_sn  from #temp_del) ;

   update   a  set  a.payLoc=b.payLoc  
 from wegobi_drgs.dbo.t_setlinfo  a , (select   distinct  zylsh ,payLoc from wegobi_drgs.dbo.t_job_settlebillinglist) b
 where  a.mdtrt_sn=b.zylsh; 
update  t_setlinfo   set  payLoc='2'   where fixmedins_code not like 'H%' and len(insuplc)=6   and payLoc  is null;
update  t_setlinfo   set  payLoc='3'   where fixmedins_code   like 'H%' and len(insuplc)>6   and payLoc  is null;

END