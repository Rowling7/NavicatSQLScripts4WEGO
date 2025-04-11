--基层病种(组)病例占比
--反映各类医院住院患者中基层病种(组)病例所占的比例。计算公式：基层病种(组)住院人次数÷同期出院总人次数)×100%
declare @StartDate datetime,@EndDate datetime;
set @StartDate='2025-01-01';
set @EndDate='2025-12-31';

	SELECT 
		DATEPART( YEAR, si.brjsrq ) AS 年份 
		,sum( case when dr.drgcode in ('EX25','DC25','DS15','DZ15','BT25','BU25','HT25','JJ15','JU15','JV25','JZ15','LU15','LX15','QS45','RE15','SZ15','FW15','GD15','GS15','GZ15') then 1 else 0 end )基层病种组病例
		,COUNT (0) AS 同期出院总人次数
		,concat(cast(cast(sum( case when dr.drgcode in ('EX25','DC25','DS15','DZ15','BT25','BU25','HT25','JJ15','JU15','JV25','JZ15','LU15','LX15','QS45','RE15','SZ15','FW15','GD15','GS15','GZ15') then 1 else 0 end )as DECIMAL(18,2))/COUNT(0)*100 as DECIMAL(18,2)),'%') '基层病种(组)病例占比'
FROM
		t_setlinfo si
		INNER JOIN t_drg_result_relation drr ON si.mdtrt_sn = drr.uid
		INNER JOIN t_drg_result dr ON drr.drgresult_id = dr.id 
WHERE
		si.isdrg = 1 
		AND si.brjsrq >= @StartDate 
		AND si.brjsrq < @EndDate 
	GROUP BY
		DATEPART( YEAR, si.brjsrq ) 
