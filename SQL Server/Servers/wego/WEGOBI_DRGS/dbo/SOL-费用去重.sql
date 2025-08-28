
DELETE from t_setlinfo_iteminfo where 
id IN(
select ID  from   t_setlinfo_iteminfo     where  id in (  
  select  id  from  (
select    ROW_NUMBER()  over(partition by  mdtrt_sn,med_chrgitm  order by id)  rn , *     from   t_setlinfo_iteminfo    where      mdtrt_sn  in   (
select　 mdtrt_sn　   from t_setlinfo_iteminfo 
group  by  mdtrt_sn,med_chrgitm
having count(*)>1)  )  a  where  rn =1
)
)