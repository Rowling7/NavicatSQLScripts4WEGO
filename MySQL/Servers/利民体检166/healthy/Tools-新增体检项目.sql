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