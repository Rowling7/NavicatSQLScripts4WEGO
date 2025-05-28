declare @settleTimeStart char(8);
declare @settleTimeEnd char(8);
set @settleTimeStart='%2024%';
set @settleTimeEnd ='%2025%';

if object_id('tempdb..#temp_lastTotalRW') is not null drop table #temp_lastTotalRW

SELECT lst.settletimeYear settletimeYear,sum(lst.totalRW) sumTotalRW
into #temp_lastTotalRW
from (
		SELECT year(A.settletime)settletimeYear,rw *COUNT(0) totalRW
    from t_drg_result a
		,t_drg_result_relation b 
		,t_setlinfo c
		where 
		a.id=b.drgresult_id and a.jzlsh=c.mdtrt_sn and c.isdrg=1
		--<查询时间范围
		and year(A.settletime)>=
			CASE WHEN ISNULL(REPLACE(@settleTimeStart, '%', ''), '') <> '' 
					THEN CAST(CAST(REPLACE(@settleTimeStart, '%', '') AS INT) - 1 AS VARCHAR(4))     
					ELSE YEAR(GETDATE())
			END
		and year(A.settletime)< 
			CASE WHEN ISNULL(REPLACE(@settleTimeEnd, '%', ''), '') <> '' 
					THEN CAST(CAST(REPLACE(@settleTimeEnd, '%', '') AS INT) + 1 AS VARCHAR(4)) 
					ELSE YEAR(GETDATE())
			END
		--查询时间范围>
		group by year(A.settletime),rw
)lst
group by lst.settletimeYear
			
select  
year(A.settletime) AS 年份
,count(*)  例数
,sum(settlepoint)  总点数
,(SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime))当期总权重
,(SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime)-1)上年同期总权重
,case when (SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime)-1) is null or (SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime)-1) = 0 then null 
			when (SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime)) is null or (SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime)) = 0 then null 
			else concat(convert(decimal(18,2),((SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime))/(SELECT sumTotalRW from #temp_lastTotalRW where settletimeyear =year(A.settletime)-1)-1)*100),'%') end '实际发生总权重增长率'
,sum(drug_fee)   药费
,sum(consumable_fee)   材料费
,sum(check_fee)   检验检查费
,sum(medical_fee) 	 医务性收入
,sum(total_fee )  总费用
,convert(decimal(18,2),convert(decimal(18,2),sum(act_ipt_days )) /convert(decimal(18,2), count(distinct jzlsh)))  平均住院日
,sum(settlecost)  预计结算金额
,sum(profitloss)  预计盈亏

from t_drg_result a
,t_drg_result_relation b 
,t_setlinfo c
where 
a.id=b.drgresult_id and a.jzlsh=c.mdtrt_sn and c.isdrg=1
--<查询时间范围
		and year(A.settletime)>=
			CASE WHEN ISNULL(REPLACE(@settleTimeStart, '%', ''), '') <> '' 
					THEN CAST(REPLACE(@settleTimeStart, '%', '')  AS VARCHAR(4))     
					ELSE YEAR(GETDATE())
			END
		and year(A.settletime)< 
			CASE WHEN ISNULL(REPLACE(@settleTimeEnd, '%', ''), '') <> '' 
					THEN CAST(CAST(REPLACE(@settleTimeEnd, '%', '') AS INT) + 1 AS VARCHAR(4)) 
					ELSE YEAR(GETDATE())
			END
		--查询时间范围>
GROUP BY year(A.settletime) 
ORDER BY year(A.settletime) desc