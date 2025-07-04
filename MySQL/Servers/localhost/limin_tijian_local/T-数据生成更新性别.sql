-- 修改字段顺序alter table info modify age int null after blry;


update info set Gender=case when SUBSTR(idcard,17,1)/2%1='0' then '女'else '男'end,age=YEAR(NOW())-SUBSTR(idcard,7,4)