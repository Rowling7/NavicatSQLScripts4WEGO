select id,parent_id,title
from t_department ;


select id,section_code,section_name,section_alphbet,department_id
from t_section_office_f594102095fd9263b9ee22803eb3f4e5	;

select id,name,short_name,office_id,office_name,market_price,sale_price,address,lis_id,lis_code,his_code,project_type,pacs_code
from t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5	
order by name;