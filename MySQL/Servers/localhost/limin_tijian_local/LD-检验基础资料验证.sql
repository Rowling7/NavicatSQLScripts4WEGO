SELECT DISTINCT portfolio_project_his_code, portfolio_project_name
FROM t_his_clinic_price
WHERE portfolio_project_type = '检验';



SELECT DISTINCT req_itemcode
FROM 检验_lis_project_list;

SELECT *
FROM t_his_clinic_price a
WHERE portfolio_project_his_code = '142';


SELECT *
FROM temp_lis_check
WHERE req_itemname LIKE '%隐血%';
SELECT *
FROM temp_lis_check
WHERE req_itemcode = '182';


SELECT DISTINCT req_itemcode
FROM temp_lis_check;


SELECT *
FROM temp_lis_check
WHERE req_itemcode NOT IN
      (SELECT a.id FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 a WHERE a.project_type = '检验');


#对应his价表
CREATE TABLE temp_lis_check AS
SELECT a.*
FROM 检验_lis_project_list a
    INNER JOIN (SELECT DISTINCT portfolio_project_his_code, portfolio_project_name
                FROM t_his_clinic_price
                WHERE portfolio_project_type = '检验'
) b ON a.req_itemcode = b.portfolio_project_his_code
ORDER BY
    req_itemcode;


SELECT a.id, a.name, c.id AS id1, c.name AS name1
FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 a
    INNER JOIN relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5 b ON a.id = b.portfolio_project_id
    INNER JOIN t_base_project_f594102095fd9263b9ee22803eb3f4e5 c ON b.base_project_id = c.id
WHERE a.project_type = '检验';


#######验证
#1.验证是否存在lis 里面有， 系统中没有的情况

SELECT *
FROM temp_lis_check
WHERE req_itemcode NOT IN (SELECT a.id
                           FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 a
                               INNER JOIN relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5 b
                                          ON a.id = b.portfolio_project_id
                               INNER JOIN t_base_project_f594102095fd9263b9ee22803eb3f4e5 c ON b.base_project_id = c.id
                           WHERE a.project_type = '检验');

#2.已存在项目确认是否存在子项的偏差


SELECT *
FROM temp_lis_check a
    LEFT OUTER JOIN (SELECT a.id, a.name, c.id AS id1, c.name AS name1
                     FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 a
                         INNER JOIN relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5 b
                                    ON a.id = b.portfolio_project_id
                         INNER JOIN t_base_project_f594102095fd9263b9ee22803eb3f4e5 c ON b.base_project_id = c.id
                     WHERE a.project_type = '检验') b ON a.req_itemcode = b.id AND a.rpt_itemcode = b.id1
WHERE id IS NULL;



SELECT *
FROM (SELECT a.id, a.name, c.id AS id1, c.name AS name1
      FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 a
          INNER JOIN relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5 b ON a.id = b.portfolio_project_id
          INNER JOIN t_base_project_f594102095fd9263b9ee22803eb3f4e5 c ON b.base_project_id = c.id
      WHERE a.project_type = '检验') b
    LEFT OUTER JOIN temp_lis_check a ON a.req_itemcode = b.id AND a.rpt_itemcode = b.id1
WHERE req_itemcode IS NULL;
-- and   id<>'119'

#验证组合项目对应的基础项目个数是否一致。
SELECT *
FROM (SELECT req_itemcode, COUNT(*) AS ct1
      FROM temp_lis_check
      GROUP BY
          req_itemcode
) rst1
    LEFT OUTER JOIN (SELECT id, COUNT(*) AS ct2
                     FROM (
                         SELECT pp.id, pp.name, bp.id AS id1, bp.name AS name1
                         FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5 pp
                             INNER JOIN relation_base_portfolio_f594102095fd9263b9ee22803eb3f4e5 rbp
                                        ON pp.id = rbp.portfolio_project_id
                             INNER JOIN t_base_project_f594102095fd9263b9ee22803eb3f4e5 bp
                                        ON rbp.base_project_id = bp.id
                         WHERE pp.project_type = '检验') b
                     GROUP BY
                         id) rst2 ON rst1.req_itemcode = rst2.id

WHERE rst1.ct1 <> rst2.ct2;
