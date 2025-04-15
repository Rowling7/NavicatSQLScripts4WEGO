SELECT b.mdtrt_sn,a.brjsrq,b.mininf_time ,abs(datediff(day,b.mininf_time,a.brjsrq)) diffdate /*时间差*/
from (
		/*查询所有病例结算时间*/
		SELECT distinct si.mdtrt_sn,convert(date ,si.brjsrq,23)brjsrq
		from t_setlinfo si 
		where si.isdrg=1 
			and convert(date ,si.brjsrq,23) between '2025-01-01'and '2025-03-31' /*病人结算时间区间*/
)a
left join (
		/*查询首次上报时间*/
		SELECT si.mdtrt_sn,convert(date ,min(mr.inf_time),23) mininf_time--,count(*) cb
		FROM t_setlinfo si 
		left join t_mihs_result mr on mr.uid=si.mdtrt_sn
		where si.isdrg=1 
			and convert(date ,si.brjsrq,23) between '2025-01-01'and '2025-03-31' /*病人结算时间区间*/
			--and mr.err_msg is null /*上报成功*/
		GROUP BY si.mdtrt_sn
		--having convert(date ,min(mr.inf_time),23) between '2025-01-01'and '2025-03-31'/*首次上报时间区间*/
		--having count(*)>1
		--order by mininf_time
) b on b.mdtrt_sn=a.mdtrt_sn
where abs(datediff(day,b.mininf_time,a.brjsrq)) <10
order by diffdate desc
