--重复手术的手术日期oprn_oprt_date中‘年月日时分秒’完全一致时，会上传失败校验不通过，
--上报失败错误信息为：违反唯一约束条件(JSQD_OPERATION_INFO)
/*
---<5
update t_setlinfo_oprninfo
set  oprn_oprt_date=dateadd(MINUTE,1,oprn_oprt_date)
where  id in (
	--<4
	select  id
	from  (
		---<3
		select   id,ROW_NUMBER() over(partition by mdtrt_sn,oprn_oprt_code,oprn_oprt_date   order by id) rn
		from(
			---<2
			select a.*
			from t_setlinfo_oprninfo a,
				(select mdtrt_sn,oprn_oprt_code,oprn_oprt_date,count(*) cont
					from  t_setlinfo_oprninfo
					group by mdtrt_sn,oprn_oprt_code,oprn_oprt_date
					having count(*)>1
				 ) b
			where a.mdtrt_sn=b.mdtrt_sn
					and a.oprn_oprt_code=b.oprn_oprt_code
					and a.oprn_oprt_date=b.oprn_oprt_date
					and a.mdtrt_sn in (
						---<1
						select mdtrt_sn
						from t_setlinfo a
						left join t_mihs_result_relation b on a.mdtrt_sn = b.uid
						left join t_mihs_result c on b.resultid=c.id
						where c.infocode=-1
								and c.err_msg not like '%省平台%'
								And c.err_msg   like  '%JSQD_OPERATION_INFO%'
						---1>
						)
				---2>
				) a
			---3>
		) id
	where rn=1
	---4>
)
---5>
*/