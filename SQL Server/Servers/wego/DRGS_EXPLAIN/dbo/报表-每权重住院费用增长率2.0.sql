declare @StartDate char(8);
declare @EndDate char(8);
set @StartDate='%2024%';
set @EndDate ='%2025%';

WITH  pastCost as(
SELECT YEAR(si.brjsrq ) brjsrqYear,
	CAST (SUM (dr.totalcost)/CAST (NULLIF (SUM (dr.rw), 0) AS DECIMAL (18,2)) AS DECIMAL (18,2)) AS pastTotalcostPerRW
	
FROM
	t_setlinfo si
	INNER JOIN t_drg_result_relation drr ON si.mdtrt_sn = drr.uid
	INNER JOIN t_drg_result dr ON drr.drgresult_id = dr.id 
WHERE
	si.isdrg = 1 
	and YEAR(si.brjsrq )>=
CASE WHEN ISNULL(REPLACE(@StartDate, '%', ''), '') <> '' 
		THEN CAST(CAST(REPLACE(@StartDate, '%', '') AS INT) - 1 AS VARCHAR(4))     
		ELSE YEAR(GETDATE())
END
and YEAR(si.brjsrq )< 
CASE WHEN ISNULL(REPLACE(@EndDate, '%', ''), '') <> '' 
		THEN CAST(CAST(REPLACE(@EndDate, '%', '') AS INT) + 1 AS VARCHAR(4)) 
		ELSE YEAR(GETDATE())
END
GROUP BY YEAR(si.brjsrq )
),
lastCost as(
SELECT 
	YEAR(si.brjsrq ) AS brjsrqYear
	,CAST (SUM (dr.totalcost)/CAST (NULLIF (SUM (dr.rw), 0) AS DECIMAL (18,2)) AS DECIMAL (18,2)) AS lastTotalcostPerRW
	
FROM
	t_setlinfo si
	INNER JOIN t_drg_result_relation drr ON si.mdtrt_sn = drr.uid
	INNER JOIN t_drg_result dr ON drr.drgresult_id = dr.id 
WHERE
	si.isdrg = 1 
	and YEAR(si.brjsrq )>=
		CASE WHEN ISNULL(REPLACE(@StartDate, '%', ''), '') <> '' 
				THEN CAST(REPLACE(@StartDate, '%', '')  AS VARCHAR(4))     
				ELSE YEAR(GETDATE())
		END
	and YEAR(si.brjsrq )< 
		CASE WHEN ISNULL(REPLACE(@EndDate, '%', ''), '') <> '' 
				THEN CAST(CAST(REPLACE(@EndDate, '%', '') AS INT) + 1 AS VARCHAR(4)) 
				ELSE YEAR(GETDATE())
		END
GROUP BY YEAR(si.brjsrq )
)

select lastCost.brjsrqYear 年份,lastCost.lastTotalcostPerRW 当期每权重次均住院费用,pastCost.pastTotalcostPerRW 上期每权重次均住院费用,concat(convert(DECIMAL(18,2),((lastCost.lastTotalcostPerRW/pastCost.pastTotalcostPerRW)-1)*100),'%') 每权重住院费用增长率
from lastCost 
left join pastCost on pastCost.brjsrqYear=CAST(CAST(REPLACE(lastCost.brjsrqYear, '%', '') AS INT) - 1 AS VARCHAR(4)) 
ORDER BY lastCost.brjsrqYear desc