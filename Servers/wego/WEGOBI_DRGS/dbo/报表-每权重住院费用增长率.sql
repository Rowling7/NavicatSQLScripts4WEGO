--[(住院总费用/总权重)÷(上年住院总费用/上年总权重)-1]×100%
declare @StartDate datetime,@EndDate datetime;
set @StartDate='2025-01-01';
set @EndDate='2025-12-31';
--SELECT 	@StartDate,DATEADD(YEAR,-1,@StartDate),@EndDate,DATEADD(YEAR,-1,@EndDate)

select aa.YEAR,aa.当期每权重次均住院费用,aa.上期每权重次均住院费用,concat(convert(DECIMAL(18,2),((aa.当期每权重次均住院费用/aa.上期每权重次均住院费用)-1)*100),'%') 每权重住院费用增长率
from 
(
	SELECT 
		DATEPART(YEAR,si.brjsrq) AS YEAR
		,CAST (SUM (dr.totalcost)/CAST (NULLIF (SUM (dr.rw), 0) AS DECIMAL (18,2)) AS DECIMAL (18,2)) AS 当期每权重次均住院费用
		,
		(
				SELECT 
				CAST (SUM (dr.totalcost)/CAST (NULLIF (SUM (dr.rw), 0) AS DECIMAL (18,2)) AS DECIMAL (18,2)) AS AverageInpatientCostPerWeight
				
			FROM
				t_setlinfo si
				INNER JOIN t_drg_result_relation drr ON si.mdtrt_sn = drr.uid
				INNER JOIN t_drg_result dr ON drr.drgresult_id = dr.id 
			WHERE
				si.isdrg = 1 
				AND si.brjsrq >= DATEADD(YEAR,-1,@StartDate)
				AND si.brjsrq < DATEADD(YEAR,-1,@EndDate)
			GROUP BY
				DATEPART(YEAR, si.brjsrq)
		)上期每权重次均住院费用
		
	FROM
		t_setlinfo si
		INNER JOIN t_drg_result_relation drr ON si.mdtrt_sn = drr.uid
		INNER JOIN t_drg_result dr ON drr.drgresult_id = dr.id 
	WHERE
		si.isdrg = 1 
		AND si.brjsrq >= @StartDate 
		AND si.brjsrq < @EndDate 
	GROUP BY
		DATEPART(YEAR, si.brjsrq)
		)aa
