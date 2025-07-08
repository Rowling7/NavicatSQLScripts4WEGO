/*依据港城的描述，我做了这么个样式，跟他确认过了。

按时间段统计的工作量统计报表：1.科室2.项目名称3.原价4.个检人数5.个检折扣价6.团检人数7.团检折扣价8.收费状态（先不加）

注意：1、原价、折扣价如果有多个，就显示多条，参照截图的报表；--不仅仅是折扣价有个显示多条，原价有多个也显示多条；
2、收费状态，暂时先放个空值，，，和港城商量着：等测试稳定了，再加上值


”1、原价、折扣价如果有多个，就显示多条  “   其中原价在过程表中没有存储，如果需要统计多个原价，需要在过程表中增加原价字段。

*/


SELECT  *
from t_group_person_f594102095fd9263b9ee22803eb3f4e5
where sporadic_physical ='1' #1=个检

SELECT distinct og.id ogId,case when gp.sporadic_physical <>'1'then 0 else 1 end gpSporadicPhysical
from t_order_group_f594102095fd9263b9ee22803eb3f4e5 og
left join t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp on gp.group_id=og.id and gp.del_flag<>'1'
where og.del_flag<>'1'

SELECT  *
from t_order_group_f594102095fd9263b9ee22803eb3f4e5
where group_order_id='ad41db39f45c401ea091a668af14ffe4'



SELECT so.*,pp.* -- so.id,so.section_name,pp.name,pp.office_id
from t_section_office_f594102095fd9263b9ee22803eb3f4e5 so
left join t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp on so.id=pp.office_id
where pp.name like '%胸部CT1%'

SELECT *
FROM t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi


case when gp.sporadic_physical <> 1 then 0 else 1 end as


SELECT  so.section_name AS 科室,ogi.name AS 项目名称,
sum(case when gpSporadicPhysical<>1 then ogi.sale_price else 0 end) AS sumSingleSalePrice,#个检原价
sum(case when gpSporadicPhysical<>1 then ogi.discount_price else 0 end) as sumSingleDiscountPrice, #个检折扣价格,
sum(case when gpSporadicPhysical=1 then ogi.sale_price else 0 end) AS sumGroupSalePrice,#团检原价
sum(case when gpSporadicPhysical=1 then ogi.discount_price else 0 end) as sumGroupDiscountPrice, #团检折扣价格,
a.gpSporadicPhysical 个团检
FROM t_order_group_item_f594102095fd9263b9ee22803eb3f4e5 ogi
left join t_section_office_f594102095fd9263b9ee22803eb3f4e5 so on ogi.office_id=so.id
left join (SELECT distinct gp.id gpId,og.id ogId,gp.person_name,ifnull(gp.sporadic_physical,0) gpSporadicPhysical 
from t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
left join t_order_group_f594102095fd9263b9ee22803eb3f4e5 og on gp.group_id=og.id and og.del_flag<>'1'
where gp.del_flag<>'1'
)a ON a.ogId=ogi.group_id
where  ogi.del_flag <>'1'
			and so.section_name='健康管理中心'
GROUP BY so.section_name,ogi.name,a.gpSporadicPhysical
order by 科室,项目名称
