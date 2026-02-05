-- 更新诊断中间表的mdtrt_sn、maindiag_flag和医保码中的特殊字符
-- update sdm 
set 
	  sdm.mdtrt_sn	=CASE WHEN CHARINDEX('^',sim.mdtrt_id)> 0 THEN LEFT (sim.mdtrt_id, CHARINDEX('^',sim.mdtrt_id) -1)  ELSE sim.mdtrt_id  END 
	, sdm.maindiag_flag =case when sdm.maindiag_flag='M' then '1' when sdm.maindiag_flag='O' then '2'else sdm.maindiag_flag end
	, sdm.diag_code=REPLACE(sdm.diag_code, NCHAR(8224), '+')
from t_setlinfo_diseinfo_mid sdm
left join t_setlinfo_mid  sim on sdm.pmainindex=sim.pmainindex 

-- 更新手术中间表的mdtrt_sn、maindiag_flag
-- update som 
set som.mdtrt_sn	=CASE WHEN CHARINDEX('^',sim.mdtrt_id)> 0 THEN LEFT (sim.mdtrt_id, CHARINDEX('^',sim.mdtrt_id) -1)  ELSE sim.mdtrt_id  END 
	,som.oprn_oprt_type = case when som.oprn_oprt_type='M' then '1' when som.oprn_oprt_type='O' then '2'else som.oprn_oprt_type end
from t_setlinfo_oprninfo_mid som
left join t_setlinfo_mid  sim on som.pmainindex=sim.pmainindex 

-- 更新pay的mdtrt_sn
-- update t_setlinfo_payinfo_mid 
set mdtrt_sn	=CASE WHEN CHARINDEX('^',mdtrt_sn)> 0 THEN LEFT (mdtrt_sn, CHARINDEX('^',mdtrt_sn) -1)  ELSE mdtrt_sn  END 





--更新主要诊断、手术、医师
/*
update t_setlinfo set  
main_diag_code=(select top 1 diag_code from t_setlinfo_diseinfo where maindiag_flag=1 and mdtrt_sn=t_setlinfo.mdtrt_sn) ,
main_diag_name=(select top 1 diag_name from t_setlinfo_diseinfo where maindiag_flag=1 and mdtrt_sn=t_setlinfo.mdtrt_sn) ,
other_diag_code1=(select top 1 diag_code from t_setlinfo_diseinfo where maindiag_flag=0 and mdtrt_sn=t_setlinfo.mdtrt_sn order by sort),
other_diag_name1 =(select top 1 diag_name from t_setlinfo_diseinfo where maindiag_flag=0 and mdtrt_sn=t_setlinfo.mdtrt_sn order by sort),
main_oper_oprn_code=(select top 1 oprn_oprt_code from t_setlinfo_oprninfo where oprn_oprt_type=1 and mdtrt_sn=t_setlinfo.mdtrt_sn) ,
main_oper_oprn_name=(select top 1 oprn_oprt_name from t_setlinfo_oprninfo where oprn_oprt_type=1 and mdtrt_sn=t_setlinfo.mdtrt_sn),
Main_oper_dr_name=(select top 1 oper_dr_name from t_setlinfo_oprninfo where oprn_oprt_type=1 and mdtrt_sn=t_setlinfo.mdtrt_sn);
*/

/*更新清单费用*/
/*
update t_setlinfo 
set 
[west_drug_fee]= (select sum(amt) from t_setlinfo_iteminfo where med_chrgitm in ('09') and mdtrt_sn=t_setlinfo.mdtrt_sn),
[chinese_drug_fee]= (select sum(amt) from t_setlinfo_iteminfo where med_chrgitm in ('11') and mdtrt_sn=t_setlinfo.mdtrt_sn),
chinese_slice_drug_fee=(select sum(amt) from t_setlinfo_iteminfo where med_chrgitm in ('10') and mdtrt_sn=t_setlinfo.mdtrt_sn),
drug_fee = (select sum(amt) from t_setlinfo_iteminfo where med_chrgitm in ('09','10','11') and mdtrt_sn=t_setlinfo.mdtrt_sn),
consumable_fee = (select sum(amt) from t_setlinfo_iteminfo where med_chrgitm in ('08') and mdtrt_sn=t_setlinfo.mdtrt_sn),
check_fee = (select sum(amt) from t_setlinfo_iteminfo where med_chrgitm in ('03','04') and mdtrt_sn=t_setlinfo.mdtrt_sn),
medical_fee=(select sum(amt) from t_setlinfo_iteminfo where med_chrgitm in ('01','02','05','06','07','12','13','14') and mdtrt_sn=t_setlinfo.mdtrt_sn),
total_fee=(select sum(amt) from t_setlinfo_iteminfo where  mdtrt_sn=t_setlinfo.mdtrt_sn)
update t_setlinfo set drug_fee=0 where drug_fee is null
update t_setlinfo set consumable_fee=0 where consumable_fee is null
update t_setlinfo set total_fee=0 where total_fee is null
update t_setlinfo set check_fee=0 where check_fee is null
update t_setlinfo set medical_fee=0 where medical_fee is null
update t_setlinfo set west_drug_fee=0 where west_drug_fee is null
update t_setlinfo set chinese_drug_fee=0 where chinese_drug_fee is null
update t_setlinfo set chinese_slice_drug_fee=0 where chinese_slice_drug_fee is null;
*/