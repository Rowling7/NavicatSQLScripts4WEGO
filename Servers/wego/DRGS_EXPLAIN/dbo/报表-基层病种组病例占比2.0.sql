	declare @StartDate char(8);
declare @EndDate char(8);
set @StartDate='%2024%';
set @EndDate ='%2025%';
	
	SELECT 
		YEAR(si.brjsrq ) AS 年份 
		,sum( case when dr.drgcode in ('EX25','DC25','DS15','DZ15','BT25','BU25','HT25','JJ15','JU15','JV25','JZ15','LU15','LX15','QS45','RE15','SZ15','FW15','GD15','GS15','GZ15') then 1 else 0 end )基层病种组病例
		,COUNT (0) AS 同期出院总人次数
		,concat(cast(cast(sum( case when dr.drgcode in ('EX25','DC25','DS15','DZ15','BT25','BU25','HT25','JJ15','JU15','JV25','JZ15','LU15','LX15','QS45','RE15','SZ15','FW15','GD15','GS15','GZ15') then 1 else 0 end )as DECIMAL(18,2))/COUNT(0)*100 as DECIMAL(18,2)),'%') '基层病种病例占比'
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
	GROUP BY
		YEAR(si.brjsrq )