select row_number() over(order by sum(sale_price) asc)rowNumHis, 
			portfolio_project_name nameHis,
			sum(sale_price) priceHis
from t_his_clinic_price
where portfolio_project_name like '%骨密度测定%' -- and portfolio_project_type ='检查'
group by portfolio_project_name
;

select *
from t_his_clinic_price
where portfolio_project_name like '%体质成分测定%'
;

SELECT name,sale_price,his_code
FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
WHERE name like '%彩超腹部+甲状腺+妇科%'
			and del_flag <> 1
;

