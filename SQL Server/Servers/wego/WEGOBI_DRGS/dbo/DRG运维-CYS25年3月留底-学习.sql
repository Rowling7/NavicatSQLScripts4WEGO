 ----查询DRG结算的上报失败的需处理问题的清单
 select mdtrt_sn ,err_msg   
 from t_setlinfo a 
 left join t_mihs_result_relation b on a.mdtrt_sn = b.uid 
 left join t_mihs_result c on b.resultid=c.id where c.infocode=-1
 and c.err_msg  not like '%省平台%'-- and c.err_msg   like '%checkResult：OPER_DR_NAME：必填项校验错误%'
 and a.brjsrq >='2025-03-01' and a.brjsrq<'2025-04-01'   -- and  isdrg=1  

 --select * from t_setlinfo_oprninfo where  mdtrt_sn='1058796-8-001' order by oprn_oprt_code

 select * from t_setlinfo_oprninfo where mdtrt_sn in 

 select wm_dise_code from t_setlinfo where mdtrt_sn='2023368218-7-001' 

  ----查询非DRG结算且需要上传的，但上报失败的需处理的清单
 select mdtrt_sn ,err_msg   
 from t_setlinfo a 
 left join t_mihs_result_relation b on a.mdtrt_sn = b.uid 
 left join t_mihs_result c on b.resultid=c.id where c.infocode=-1
 and c.err_msg  not like '%省平台%' 
 and a.brjsrq >='2025-02-01' and a.brjsrq<'2025-03-01'    and  isdrg=0
 and a.mdtrt_sn in ( select  zylsh from  t_job_settlebillinglist   )


  --手术重复处理--时间重复
  update t_setlinfo_oprninfo set  oprn_oprt_date=dateadd(MINUTE,1,oprn_oprt_date)  where  id in (select  id from  (select   id,ROW_NUMBER() over(partition by mdtrt_sn,oprn_oprt_code,oprn_oprt_date   order by id) rn  from(select a.* from t_setlinfo_oprninfo a,(select mdtrt_sn,oprn_oprt_code,oprn_oprt_date,count(*) cont  from  t_setlinfo_oprninfo  group by  mdtrt_sn,oprn_oprt_code,oprn_oprt_date  having count(*)>1 ) b  where a.mdtrt_sn=b.mdtrt_sn and a.oprn_oprt_code=b.oprn_oprt_code  and a.oprn_oprt_date=b.oprn_oprt_date
 and a.mdtrt_sn in ( select mdtrt_sn  from t_setlinfo a  left join t_mihs_result_relation b on a.mdtrt_sn = b.uid 
 left join t_mihs_result c on b.resultid=c.id where c.infocode=-1 and c.err_msg not like '%省平台%' And c.err_msg   like  '%JSQD_OPERATION_INFO%' ) ) a   ) id    where rn=1  )

 select  * from t_mihs_result where uid='IP0000244303-001'

 select * from t_setlinfo_oprninfo where mdtrt_sn='IP0000242951-001'

 update t_setlinfo_oprninfo set oprn_oprt_type=2 where Id='D8527102-7DAD-48C9-B1A1-A08B545147A6'

 -----
 delete from t_mihs_result_relation where uid in
 (select mdtrt_sn from t_setlinfo a 
 left join t_mihs_result_relation b on a.mdtrt_sn = b.uid 
 left join t_mihs_result c on b.resultid=c.id where c.infocode=-1
 and c.err_msg  not like '%省平台%'  and c.err_msg like '%违反唯一约束条件(MIDR.OPERATION_UNIQUE_M)%'
 and a.brjsrq >='2024-11-01' and a.brjsrq<'2024-12-01'    and  isdrg=1)   --2022745135-1-001  11月25日

 -----更新手术医生标准码
 update t_setlinfo_oprninfo set oper_dr_code_std='D371072007682' where id in 
 (select id from t_setlinfo_oprninfo where  oper_dr_name='于海英'  and oper_dr_code='12140'and  (oper_dr_code_std is null or oper_dr_code_std not like 'D%') and oprn_oprt_date>'2024-10-31'and oprn_oprt_date<='2024-11-30')
      --处理完了用下面脚本查下还有没有其他手术医生存在问题，有的话参照上面处理下
 select * from t_setlinfo_oprninfo where   (oper_dr_code_std is null or oper_dr_code_std not like 'D%') and oprn_oprt_date>'2024-10-31'and oprn_oprt_date<='2024-11-30'
------更新主诊医生标准码--主诊医师代码chfpdr_code_std：N371003004401格式不正确
update t_setlinfo set chfpdr_code_std='D371003003710' where id in
 (select id from t_setlinfo where chfpdr_name='王志浩'and chfpdr_code='12127' and (chfpdr_code_std is null or chfpdr_code_std not like'D%') and brjsrq>'2024-10-31'and brjsrq<='2024-11-30' )
      --处理完了后再用下面脚本查下还有没有其他主诊医生存在问题，有问题按上面方式处理下
select * from t_setlinfo where  (chfpdr_code_std is null or chfpdr_code_std not like'D%') and brjsrq>'2024-10-31'and brjsrq<='2024-11-30'



--------更新入院科室和出院科室标准码（ADM_CATY：必填项校验错误；DSCG_CATY：必填项校验错误）
select * from t_setlinfo  where mdtrt_sn='IP0000242737-001'
UPDATE t_setlinfo SET adm_caty='A50',dscg_caty='A50' where id='755724'

---------更新结算清单患者基本信息表的 bill_code, bill_no
   select bill_code from t_setlinfo where mdtrt_sn='2023331038-4-001' ;
   select bill_code from t_setlinfo where mdtrt_sn='2023787144-1-001' 

      select * from t_setlinfo where mdtrt_sn='428005-19-001' ;
   select * from t_setlinfo where mdtrt_sn='1046940-9-003' 
   --id 478972  ---1046940-9-003  1001016814  --240126834-1-001--1001016814
   update t_setlinfo set bill_code='1000997166', bill_no='1000997166' where id='486558'    --2023331038-4-001

--428005-19-001	1001018164  ID=484696  --241125 通过试图查询了BILL后update
--1046940-9-003	1001021480  id=482368  --241125 通过试图查询了BILL后update
--230134779-1-001	这个流水号已经好多天了，在医保平台上是待上传的，但是HIS那边没有数，因为是取消结算了--后来联系高英那边处理了
--230134779-1-001 2023787144-1-001 230151276-2-001 1073731-4-001

   select mdtrt_sn,id ,bill_code,bill_no from t_setlinfo where mdtrt_sn in ('230134779-1-001', '2023787144-1-001', '230151276-2-001', '1073731-4-001')
--241202 试图查询流水单对应  bill_code,bill_no    更新好并上报了
-- 1073731-4-001	1001020818	1001020818  487061-更新好并上报了
--230134779-1-001	1000997155	1000997155  481520-更新好并上报了
--230151276-2-001	1000997166	1000997166  486558-更新好并上报了
--2023787144-1-001	                              -241202 HIS视图没数


select * from t_setlinfo where (ADM_CATY is null or DSCG_CATY is null) and BRJSRQ>'2024-10-31' and BRJSRQ<='2024-11-30'



--select * from t_setlinfo_revise

错误：医疗保障基金结算清单患者基本信息【JSQD_PATIENT_INFO】数据校验错误：pkid：MDTRT_SN：230134779-1-001；FIXMEDINS_CODE：000001；checkResult：BILL_CODE：必填项校验错误；BILL_NO：必填项校验错误；；

 2023331038-4-001  1001016814 1001016814 1001016814
 230134779-1-001
 240126834-1-001

错误：医疗保障基金结算清单患者手术操作信息【JSQD_OPERATION_INFO】数据校验错误：pkid：MDTRT_SN：431599-14-001；FIXMEDINS_CODE：000001；OPRN_OPRT_CODE：85.5300x001；OPRN_OPRT_DATE：MonNov1114：03：31CST2024；oprn_oprt_type：2；checkResult：ANST_DR_CODE_STD：必填项校验错误；OPER_DR_CODE_STD：必填项校验错误；OPER_DR_NAME：必填项校验错误；；
 1	D371072007816	D371072007678	秦春新
2	D371072007816	D371072007678	秦春新

select ANST_DR_CODE_STD,OPER_DR_CODE_STD,OPER_DR_NAME from t_setlinfo_oprninfo where mdtrt_sn='431599-14-001'

select * from t_setlinfo_oprninfo where mdtrt_sn='431599-14-001'

错误：医疗保障基金结算清单患者出院诊断信息【JSQD_OUT_DISEASE_INFO】数据校验错误：
pkid：MDTRT_SN：240001113-7-001；FIXMEDINS_CODE：000001；DIAG_CODE：；DIAG_TYPE：2；
checkResult：DIAG_CODE：必填项校验错误；DIAG_NAME：必填项校验错误；；

select * from t_setlinfo_diseinfo where mdtrt_sn='240001113-7-001'

select * from t_job_settlebillinglist where datebill>='20241101' and datebill<'20241231' and medicalhosid=1 and zylsh='1085565-4-001'  group by zylsh; 
------------对数----- 
--1\--select  distinct  zylsh from t_job_settlebillinglist where convert(date,datebill,23)>='2025-02-01' and convert(date,datebill,23)<'2025-03-01' and medicalhosid=1  ;
--2\--update t_setlinfo set isdrg=0 where convert(date,brjsrq,23)>='2025-02-01' and convert(date,brjsrq,23)<'2025-03-01';
--3\--update t_setlinfo set isdrg=1 where mdtrt_sn in (select zylsh from t_job_settlebillinglist where convert(date,datebill,23)>='2025-02-01' and convert(date,datebill,23)<'2025-03-01' and medicalhosid=1 group by zylsh);
--4\--update t_setlinfo set hi_type='310' where mdtrt_sn in (select zylsh from t_job_settlebillinglist where convert(date,datebill,23)>='2025-02-01' and convert(date,datebill,23)<'2025-03-01' and medicalhosid=1 and insuranceid='310' group by zylsh);
--5\--update t_setlinfo set hi_type='390' where mdtrt_sn in (select zylsh from t_job_settlebillinglist where convert(date,datebill,23)>='2025-02-01' and convert(date,datebill,23)<'2025-03-01'and medicalhosid=1 and insuranceid='390' group by zylsh);
--6\--delete t_drg_result_relation where uid in (select mdtrt_sn from t_setlinfo a left join t_drg_result_relation b on a.mdtrt_sn=b.uid left join t_drg_result c on b.drgresult_id=c.id where a.hi_type <> c.insurtype)

select case when hi_type=310 then '职工' when hi_type=390 then '居民' end 类别,count(*)数量 
from t_setlinfo where BRJSRQ>='2025-02-01' and BRJSRQ<'2025-03-01' and isdrg=1 group by hi_type



--2025-02-06
--select * from t_setlinfo_oprninfo where mdtrt_sn='2022753245-2-001'   2022753245-2-001--流水的手术医生名称必填项校验失败，库里有，修订没有，按1658修订后重新上传
--2023035780-2-001  1107041-2-001  250007646-1-002  --2022920595-1-001  2023733556-4-001 手术时间重复了，执行脚本后重新上传

--20081105-4-001 流水的bill_no bill_code为空，通过视图查询为 1001051239，更新后上传

----2025-02-10----
--2022756801-1-002 流水结算清单待上传，DRG里没有清单，视图中有数据hip.v_t_setlinfo ,单抽后上传

--mdtrt_sn='2023133772-2-002'  250004549-1-001  250003715-2-001  250002340-1-001  2023261362-2-001 手术时间重复了，修正后重新上报

--2022834460-1-001的流水 视图中也没有bill_no  通过HIS看是取消结算了

----2025-02-12----
--250009585-1-001 住院医疗类型 IPT_MED_TYPE 空了，查数据库得知是1，前台修订后上传


----2025-02-17----
--483120-27-001 ,250003909-1-001更新手术日期脚本无果，修订后上传;
--646877-18-001,804417-5-001 更新手术日期脚本后重新上传

---2025-02-24
--2022802800-1-008 更新手术日期脚本无果，修订后上传;     

--select * from t_setlinfo_diseinfo where mdtrt_sn='992849-14-002' order by diag_code --MIDR.OUT_UNIQUE_M 提示诊断重复，数据库表没有重复，修订中删除重复解决

--select * from t_setlinfo_oprninfo where mdtrt_sn='2022928569-1-001'  最终修订后解决 --4719于泓

select * from t_setlinfo_oprninfo where oper_dr_code_std='D371072007421' order by oprn_oprt_date
update t_setlinfo_oprninfo set oper_dr_name='于泓' where id='B165037D-6032-4DA6-AB80-9C0A18FCD435';
update t_setlinfo_oprninfo set oper_dr_name='于泓' where id='3CB9294D-93D1-489B-8EE1-B3497FF1E553';

--select * from t_setlinfo_oprninfo where oper_dr_code_std='250001793-2-001' 修订后重新上报

----2025-03-03----  手术时间重复，更新脚本加修订后解决
076081-4-001
2022852200-2-001
1046264-3-001
250012952-1-004

--select * from t_setlinfo_oprninfo where mdtrt_sn='653437-7-001'  手术时间重复，更新脚本后上传

select bill_code,bill_no from t_setlinfo where mdtrt_sn='2022834460-1-001'---2022834460-1-001  083609-3-001---1001111008

update t_setlinfo set bill_code='1001111008',bill_no='1001111008' where mdtrt_sn='2022834460-1-001'

--2024874996-1-001  修订后解决

select * from t_setlinfo_diseinfo where mdtrt_sn='240032242-2-001';

select * from t_setlinfo_diseinfo where mdtrt_sn='660584-2-001'

select * from t_setlinfo_diseinfo where diag_code='M20.100x002'  --后天性(足母)外翻 9A0EE037-A969-467C-BC0F-5F6D0EE9DC9A
update t_setlinfo_diseinfo set diag_name='后天性(足母)外翻' where id='9A0EE037-A969-467C-BC0F-5F6D0EE9DC9A'

select * from t_setlinfo_diseinfo where diag_code='T31.300' 

--2022901628-1-001  448211-7-001 2022960598-4-001 2023690968-1-001  单抽过来上传1053410-16-001    2023713619-1-001   250016529-1-002  


-----2024-03-11
-------707950-6-001  手术时间重复执行脚本后重新上传解决    2023230037-1-001修订后上传

------250015814-2-001  1001112150      1033007-2-001    1001113011  bill_code bill_no 空了，查询视图后更新解决

update t_setlinfo set bill_no='1001113011',bill_code='1001113011' where mdtrt_sn='1033007-2-001'

update t_setlinfo set bill_no='1001112150',bill_code='1001112150' where mdtrt_sn='250015814-2-001'

-----2024-03-17 三个流水手术时间重复了，执行脚本后解决       2023902412-2-001 该流水取消结算了

-----2024-03-24
--有3个手术重复的流水，2个执行完脚本解决了；1个修订更改手术时间解决
--select * from t_setlinfo_diseinfo where mdtrt_sn='2023415761-1-001' 修订里诊断有问题，告知医院完成修订
--478723-17-001 修订里手术有问题，告知医院完成修订

bill_no bill_code 空了，查询视图
--2023902412-2-001
--491173-2-001
--2023096996-1-001   1001114282
select * from t_setlinfo where mdtrt_sn='2023096996-1-001'
update t_setlinfo set bill_no='1001114282',bill_code='1001114282' where id='517832'

---077779-7-001  手术时间重复，修订后重新上传