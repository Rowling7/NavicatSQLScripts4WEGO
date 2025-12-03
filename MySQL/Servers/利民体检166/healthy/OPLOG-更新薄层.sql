-- 更新薄层
SELECT name, REPLACE(name, '（revolution）', '（薄层扫描）')
FROM t_base_project_f594102095fd9263b9ee22803eb3f4e5
WHERE name LIKE '%CT%'
  AND `name` LIKE '%（revolution）%';
-- update t_base_project_f594102095fd9263b9ee22803eb3f4e5
SET name = REPLACE(name, '（revolution）', '（薄层扫描）')
    WHERE NAME LIKE '%CT%' AND `name` LIKE '%（revolution）%';

SELECT short_name, REPLACE(short_name, '（revolution）', '（薄层扫描）')
FROM t_base_project_f594102095fd9263b9ee22803eb3f4e5
WHERE short_name LIKE '%CT%'
  AND short_name LIKE '%（revolution）%';
-- update t_base_project_f594102095fd9263b9ee22803eb3f4e5
SET short_name = REPLACE(short_name, '（revolution）', '（薄层扫描）')
    WHERE short_name LIKE '%CT%' AND short_name LIKE '%（revolution）%';



SELECT name, REPLACE(name, '（revolution）', '（薄层扫描）')
FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
WHERE name LIKE '%CT%'AND name LIKE '%（revolution）%';
-- UPDATE t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
SET name = REPLACE(name, '（revolution）', '（薄层扫描）')
WHERE NAME LIKE '%CT%'AND name LIKE '%（revolution）%';


SELECT short_name, REPLACE(short_name, '（revolution）', '（薄层扫描）')
FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
WHERE short_name LIKE '%CT%'AND short_name LIKE '%（revolution）%';
-- UPDATE t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
SET short_name = REPLACE(short_name, '（revolution）', '（薄层扫描）')
WHERE short_name LIKE '%CT%'AND short_name LIKE '%（revolution）%';



SELECT name, REPLACE(name, '64排', '薄层扫描')
FROM t_base_project_f594102095fd9263b9ee22803eb3f4e5
WHERE name LIKE '%64%';
-- UPDATE t_base_project_f594102095fd9263b9ee22803eb3f4e5
SET name = REPLACE(name, '64排', '薄层扫描')
WHERE NAME LIKE '%64%';


SELECT short_name, REPLACE(short_name, '64排', '薄层扫描')
FROM t_base_project_f594102095fd9263b9ee22803eb3f4e5
WHERE short_name LIKE '%64%';
-- UPDATE t_base_project_f594102095fd9263b9ee22803eb3f4e5
SET short_name = REPLACE(short_name, '64排', '薄层扫描')
WHERE short_name LIKE '%64%';

SELECT name, REPLACE(name, '64排', '薄层扫描')
FROM t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
WHERE name LIKE '%64%';
-- UPDATE t_portfolio_project_f594102095fd9263b9ee22803eb3f4e5
SET name = REPLACE(name, '64排', '薄层扫描')
WHERE NAME LIKE '%64%';
