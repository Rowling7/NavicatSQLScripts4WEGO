--数据所占空间
	declare @PageSize float 
	select @PageSize=v.low/1024.0 from master.dbo.spt_values v where v.number=1 and v.type='E'
--索引所占空间
	declare @PageSize2 float 
	select @PageSize2=v.low/1024.0 from master.dbo.spt_values v where v.number=1 and v.type='E'
	
SELECT
tbl.name,
@PageSize*0.001*((SELECT sum(sidx.dpages)
		 FROM dbo.sysindexes sidx
		 WHERE sidx.indid < 2 and sidx.id = tbl.id)
		+
		(SELECT isnull(sum(sidx.used), 0)
		 FROM dbo.sysindexes sidx
		 WHERE sidx.indid = 255 and sidx.id = tbl.id)) AS [DataSpaceUsed(MB)],
@PageSize2*0.001*(SELECT sum(isnull(sidx.used,0)-isnull(sidx.dpages,0))
		 FROM dbo.sysindexes sidx
		 WHERE sidx.indid < 2 and sidx.id = tbl.id) AS [IndexSpaceUsed(MB)]
FROM
dbo.sysobjects AS tbl
INNER JOIN sysusers AS stbl ON stbl.uid = tbl.uid
WHERE
((tbl.type='U' or tbl.type='S'))
ORDER BY [IndexSpaceUsed(MB)]DESC ,[DataSpaceUsed(MB)] DESC
-- and(tbl.name=N'k001' and stbl.name=N'dbo')
