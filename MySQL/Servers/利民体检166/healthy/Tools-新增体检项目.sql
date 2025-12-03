-- his 价表 portfolio_project_his_code portfolio_project_name  482	[三]T骨质疏松4项
SELECT * FROM t_his_clinic_price WHERE portfolio_project_name LIKE '%骨质疏松3%'
/*
portfolio_project_his_code ; portfolio_project_name
271	[三]骨质疏松3项
271	[三]骨质疏松3项
271	[三]骨质疏松3项
*/


-- lis数据库查询 rpt_itemcode	rpt_itemname
SELECT * FROM lab_reqitemrptitem WHERE req_itemcode = '271'
/*
rpt_itemcode	rpt_itemname
0404430	总I型胶原氨基端延长肽
0404431	骨钙素
0404432	β胶联降解产物
*/

-- 基础资料  组合项目  
SELECT * FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5  where `name` like '%骨质疏松3项%'
/*
id	name
271	骨质疏松3项
*/

-- 基础资料  明细项目
SELECT * FROM t_base_project_f594102095fd9263b9ee22803eb3f4e5  where id in ('0404430','0404431','0404432')
/*
id	code	name
0404430	0404430	总I型胶原氨基端延长肽
0404431	0404431	骨钙素
0404432	0404432	β胶联降解产物
*/


-- 组合项目和明细项目映射
SELECT * FROM relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5 where portfolio_project_id ='271'
/*
base_project_id	portfolio_project_id
0404430	271
0404431	271
0404432	271
*/

-- 检验项目 确认管颜色，合管规则











-- 示例2 ---   

select * from    t_his_clinic_price     #   limit 100 
where  portfolio_project_name  like '%风湿%'   
-- JY795	T类风湿因子测定

select * from   t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5   
where  name  like '%风湿%'

-- JY795	T类风湿因子测定		1		检验科	90405	9.00	9.00				一楼体检科		0	admin_insert	2025-10-09 08:19:08															62633			f594102095fd9263b9ee22803eb3f4e5		JY795	检验			0	黄


select  *  from 检验类        where  req_itemname   like '%T类风湿因子测定%'
-- 62633	T类风湿因子测定	0301045	类风湿因子	RF	0	20

select * from   t_base_project_f594102095fd9263b9ee22803eb3f4e5     --   结果类型
where  name  like '%风湿%' 
-- 62633	62633	T类风湿因子测定	T类风湿因子测定	1	90405	检验科				数值			62633	0	admin_insert	2025-10-09 08:21:48						f594102095fd9263b9ee22803eb3f4e5		JY795				检验	


select  *   from  relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5     where portfolio_project_id  ='JY795'
-- 1e0bba51-45ba-11f0-90d1-0242ac110001	62633	JY795