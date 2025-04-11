declare @settleTimeStart datetime,@settleTimeEnd datetime;
set @settleTimeStart ='2024-01-01';
set @settleTimeEnd ='2024-12-31';

--CTE 计算总权重
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

SELECT lst.组编码
,lst.组名
,lst.例数
,lst.权重
,lst.总点数
,lst.总权重 总权重
,pst.总权重 上年同期总权重
,case when pst.总权重 is null or pst.总权重 = 0 then null 
			when lst.总权重 is null or lst.总权重 = 0 then null 
			else concat(convert(decimal(18,2),(lst.总权重/pst.总权重-1)*100),'%') end '实际发生总权重（总分值）增长率'
,lst.药费
,lst.材料费
,lst.检验检查费
,lst.医务性收入
,lst.总费用
,lst.平均住院日
,lst.预计结算金额
,lst.预计盈亏
from 
(
select  
case 
when a.drgcode is null
then '未入组'
else
a.drgcode 
end 组编码,
case 
when a.drgname is null
then '未入组'
else
a.drgname  
end 组名
,count(*)  例数
,a.rw 权重
,sum(settlepoint)  总点数
,a.rw*count(0) 总权重
,sum(drug_fee)   药费
,sum(consumable_fee)   材料费
,sum(check_fee)   检验检查费
,sum(medical_fee) 	 医务性收入
,sum(total_fee )  总费用
,convert(decimal(18,2),sum(act_ipt_days )/convert(decimal(18,2), count(distinct jzlsh)) )  平均住院日
,sum(settlecost)  预计结算金额
,sum(profitloss)  预计盈亏
  from t_drg_result a
  ,t_drg_result_relation b 
  ,t_setlinfo c
 
  where 
  a.id=b.drgresult_id   and a.jzlsh=c.mdtrt_sn
  and c.isdrg=1
  and 
settletime>=
case 
when isnull(@settleTimeStart,'') <> ''
then @settleTimeStart
else
dateadd(month,datediff(month,0,getdate()-1)-1,0)
end

and 
 settletime<
case 
when isnull(@settleTimeEnd,'') <> ''
then DATEADD(day,1,@settleTimeEnd)
else
DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
end
 group by case 
when a.drgcode is null
then '未入组'
else
a.drgcode  
end  ,
case 
when a.drgname is null
then '未入组'
else
a.drgname  
end   ,a.rw
) lst
--FULL OUTER JOIN 
left join 
(
select
case 
when a.drgcode is null
then '未入组'
else
a.drgcode 
end 组编码
,a.rw*count(0) 总权重
from t_drg_result a
,t_drg_result_relation b 
,t_setlinfo c
where 
a.id=b.drgresult_id   and a.jzlsh=c.mdtrt_sn
and c.isdrg=1
and 
settletime>=
case 
when isnull(@settleTimeStart,'') <> ''
then dateadd(year,-1,@settleTimeStart)
else
dateadd(year,-1,dateadd(month,datediff(month,0,getdate()-1)-1,0))
end

and 
 settletime<
case 
when isnull(@settleTimeEnd,'') <> ''
then dateadd(year,-1,DATEADD(day,1,@settleTimeEnd))
else
dateadd(year,-1,DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1)))
end
group by case 
when a.drgcode is null
then '未入组'
else
a.drgcode 
end ,a.rw
 )pst on lst.组编码=pst.组编码
 
UNION

select  
null 组编码
,null 组名
,count(*)  例数
,null 权重
,sum(settlepoint)  总点数
,(SELECT SUM(rw * cnt) AS total FROM LstTotalRW) 总权重
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

order by lst.总权重 desc
 