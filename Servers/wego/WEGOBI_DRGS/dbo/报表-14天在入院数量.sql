--14天在入院人数，没区分是否是非计划
--14天非计划再入院率	反映医疗服务质量和是否存在分解住院的 风险。计算公式：(出院14天内以同一ADRG非计划再入院人次数÷同期出院总人次)×100%(排除肿瘤放化疗、肾 透析、产科分娩和日间手术)

declare @SettleTimeStart datetime,@SettleTimeEnd datetime,@DaysDifference int;
set @SettleTimeStart='2024-10-01 00:00:00';
set @SettleTimeEnd='2024-11-01 00:00:00';
set @DaysDifference=14;

select count(0) 再入院人次  
from (
	select a.medcasno 
	from t_setlinfo a  
	right join  
	(
		select * 
		from 
		 (
		 select medcasno, count(0) number, min(dscg_time) time /*出院时间 */ 
		 from t_setlinfo  
		 where brjsrq >=  case when isnull( @SettleTimeStart,'') <> '' then @SettleTimeStart 
					else dateadd(month,datediff(month,0,getdate()-1)-1,0) 
					end  
				 and brjsrq <  case when isnull( @SettleTimeEnd,'') <> '' then DATEADD(day,1, @SettleTimeEnd) 
							else DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1)) 
					end  
		 and isdrg = 1  
		 group by medcasno) as d  where d.number > 1
	 )  b  on a.medcasno=b.medcasno  
	 where a.brjsrq >=  case when isnull( @SettleTimeStart,'') <> '' then  @SettleTimeStart 
					else dateadd(month,datediff(month,0,getdate()-1)-1,0) 
				end  
				and a.brjsrq <  case when isnull( @SettleTimeEnd,'') <> '' then DATEADD(day,1, @SettleTimeEnd)
						else DATEADD(day,1,dateadd(month,datediff(month,01,getdate()),-1))
				end  
	 and isdrg = 1  
	 and a.adm_time > b.time  
	 and a.adm_time <= DATEADD(d, @DaysDifference, b.time) /*出院时间 */  
	 group by a.medcasno
 ) as v
