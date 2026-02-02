INSERT INTO [dbo].[t_setlinfo_payinfo]
		( [id]
		, [mdtrt_sn]
		, [fund_pay_type]
		, [fund_payamt])
SELECT id
		 , CASE  WHEN CHARINDEX( '^', mdtrt_sn )> 0 THEN LEFT ( mdtrt_sn, CHARINDEX( '^', mdtrt_sn ) - 1 )  ELSE mdtrt_sn  END AS mdtrt_sn
     , fund_pay_type
     , fund_payamt
FROM t_setlinfo_payinfo_mid;



INSERT INTO [dbo].[t_setlinfo_iteminfo]
			( [id]
			, [mdtrt_sn]
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt])
SELECT 
			[id]
			, CASE  WHEN CHARINDEX( '^', mdtrt_sn )> 0 THEN LEFT ( mdtrt_sn, CHARINDEX( '^', mdtrt_sn ) - 1 )  ELSE mdtrt_sn  END AS mdtrt_sn
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt]
FROM t_setlinfo_iteminfo_mid;



INSERT INTO [dbo].[t_setlinfo_iteminfo]
			([id]
			, [mdtrt_sn]
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt])
SELECT 
			[id]
			, CASE  WHEN CHARINDEX( '^', mdtrt_sn )> 0 THEN LEFT ( mdtrt_sn, CHARINDEX( '^', mdtrt_sn ) - 1 )  ELSE mdtrt_sn  END AS mdtrt_sn
			, [med_chrgitm]
			, [amt]
			, [claa_sumfee]
			, [clab_amt]
			, [fulamt_ownpay_amt]
			, [oth_amt]
FROM t_setlinfo_iteminfo_mid;