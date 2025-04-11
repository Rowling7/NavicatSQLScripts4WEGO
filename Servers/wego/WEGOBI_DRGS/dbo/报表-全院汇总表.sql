declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';

WITH LstTotalRW AS (
    SELECT rw, COUNT(0) AS cnt
    from t_drg_result a
		,t_drg_result_relation b 
		,t_setlinfo c
		where 
		a.id=b.drgresult_id and a.jzlsh=c.mdtrt_sn and c.isdrg=1
		--<查询时间范围
		and settletime>=case 
				when isnull(@settleTimeStart,'') <> ''then @settleTimeStart
				else dateadd(month,datediff(month,0,getdate()-1)-1,0)
		end
		and settletime<case
				when isnull(@settleTimeEnd,'') <> ''then DATEADD(day,1,@settleTimeEnd)
				else DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
		end
		--查询时间范围>
		group by rw
),
PstTotalRW AS (
    SELECT rw, COUNT(0) AS cnt
    from t_drg_result a
		,t_drg_result_relation b 
		,t_setlinfo c
		where 
		a.id=b.drgresult_id and a.jzlsh=c.mdtrt_sn and c.isdrg=1
		--<查询时间范围
		and settletime>=case when isnull(@settleTimeStart,'') <> ''then dateadd(YEAR ,-1,@settleTimeStart)
		else dateadd(YEAR ,-1,dateadd(month,datediff(month,0,getdate()-1)-1,0)) end
		and settletime<
		case when isnull(@settleTimeEnd,'') <> ''then dateadd(YEAR ,-1,DATEADD(day,1,@settleTimeEnd))
		else dateadd(YEAR ,-1,DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1)))end
		--查询时间范围>
		group by rw
)


select  
year(@settleTimeEnd) 年份
,count(*)  例数
,sum(settlepoint)  总点数
,(SELECT SUM(rw * cnt) AS total FROM LstTotalRW) 当期总权重
,(SELECT SUM(rw * cnt) AS total FROM PstTotalRW) 上年同期总权重
,case when (SELECT SUM(rw * cnt) AS total FROM PstTotalRW) is null or (SELECT SUM(rw * cnt) AS total FROM PstTotalRW) = 0 then null 
			when (SELECT SUM(rw * cnt) AS total FROM LstTotalRW) is null or (SELECT SUM(rw * cnt) AS total FROM LstTotalRW) = 0 then null 
			else concat(convert(decimal(18,2),((SELECT SUM(rw * cnt) AS total FROM LstTotalRW)/(SELECT SUM(rw * cnt) AS total FROM PstTotalRW)-1)*100),'%') end '实际发生总权重（总分值）增长率'
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
and settletime>=case when isnull(@settleTimeStart,'') <> ''then @settleTimeStart
else dateadd(month,datediff(month,0,getdate()-1)-1,0) end
and settletime<
case when isnull(@settleTimeEnd,'') <> ''then DATEADD(day,1,@settleTimeEnd)
else DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))end
--查询时间范围>