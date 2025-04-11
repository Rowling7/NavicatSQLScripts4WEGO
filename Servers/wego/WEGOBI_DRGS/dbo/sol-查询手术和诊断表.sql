--查询手术和诊断表
declare @mdtrtsn varchar(255);
set @mdtrtsn='250026649-1-002';
select * from t_setlinfo_oprninfo
where mdtrt_sn=@mdtrtsn order by oprn_oprt_code,oprn_oprt_date;

select * from t_setlinfo_diseinfo
where mdtrt_sn=@mdtrtsn order by diag_code;