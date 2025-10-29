set @ppname='血常规';
SELECT row_number() OVER (order by bp.`code` asc ) as 序号,pp.`name`, bp.`code`,bp.`name`
FROM relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5 rbp
    LEFT JOIN t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp ON rbp.portfolio_project_id = pp.id
    LEFT JOIN t_base_project_f594102095fd9263b9ee22803eb3f4e5 bp ON bp.id = rbp.base_project_id
WHERE pp.`name` IS NOT NULL
	and pp.office_name ='检验科'
	and pp.name =@ppname