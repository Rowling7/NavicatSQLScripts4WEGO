SELECT b.uid,a.brjsrq,b.mininf_time ,abs(datediff(day,b.mininf_time,a.brjsrq)) diffdate /*时间差*/
from (
		/*查询所有病例结算时间*/
		SELECT distinct si.mdtrt_sn,convert(date ,si.brjsrq,23)brjsrq
		from t_setlinfo si 
		where si.isdrg=1 
			and convert(date ,si.brjsrq,23) between '2025-01-01'and '2025-03-31' /*病人结算时间区间*/
)a
left join (
		/*查询首次上报时间*/
		SELECT mr.uid,convert(date ,min(mr.inf_time),23) mininf_time--,count(*) cb
		FROM t_mihs_result mr 
		where infocode=0 /*上报成功*/
			--and mr.err_msg is null /*校验成功*/
		GROUP BY mr.uid
		--having convert(date ,min(mr.inf_time),23) between '2025-01-01'and '2025-03-31'/*首次上报时间区间*/
		--having count(*)>1
		--order by mininf_time
) b on b.uid=a.mdtrt_sn
where abs(datediff(day,b.mininf_time,a.brjsrq)) <10
order by diffdate desc
