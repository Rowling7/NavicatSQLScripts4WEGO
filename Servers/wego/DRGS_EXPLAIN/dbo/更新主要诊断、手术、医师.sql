DECLARE @mdtrt_sn varchar(255);
set @mdtrt_sn='408456-2-001'
--更新主要诊断、手术、医师
update t_setlinfo set  
main_diag_code=(select top 1 diag_code from t_setlinfo_diseinfo where maindiag_flag=1 and mdtrt_sn=@mdtrt_sn) ,
main_diag_name=(select top 1 diag_name from t_setlinfo_diseinfo where maindiag_flag=1 and mdtrt_sn=@mdtrt_sn) ,
other_diag_code1=(select top 1 diag_code from t_setlinfo_diseinfo where maindiag_flag=0 and mdtrt_sn=@mdtrt_sn order by sort),
other_diag_name1 =(select top 1 diag_name from t_setlinfo_diseinfo where maindiag_flag=0 and mdtrt_sn=@mdtrt_sn order by sort),
main_oper_oprn_code=(select top 1 oprn_oprt_code from t_setlinfo_oprninfo where oprn_oprt_type=1 and mdtrt_sn=@mdtrt_sn) ,
main_oper_oprn_name=(select top 1 oprn_oprt_name from t_setlinfo_oprninfo where oprn_oprt_type=1 and mdtrt_sn=@mdtrt_sn),
Main_oper_dr_name=(select top 1 oper_dr_name from t_setlinfo_oprninfo where oprn_oprt_type=1 and mdtrt_sn=@mdtrt_sn) 
where    mdtrt_sn =@mdtrt_sn
