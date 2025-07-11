SELECT
'确认等级后'as 'info',
id as '主键',
person_name as '人员姓名',
sex as '性别',
id_card as '证件号码',
birth as '出生日期',
age as '年龄',
is_marry as '是否结婚',
mobile as '手机号码',
dept as '体检人员工作部门(单位名称)',
work_num as '人员工号',
work_name as '工种其他名称',
work_state_code as '在岗状态编码',
work_state_text as '在岗状态',
work_type_code as '工种代码',
work_type_text as '工种名称',
jc_type as '监测类型',
del_flag as '删除标识（0-未删除，1-删除）',
create_id as '创建人',
create_time as '创建时间',
update_id as '修改人',
update_time as '修改时间',
delete_id as '是否网报确认(0或null未确认,1已确认)',
delete_time as '删除时间',
order_id as '订单id',
group_id as '分组id',
is_pass as '是否通过检查(1-登记，2-在检,3-总检,4-已完成)',
test_num as '体检编号',
avatar as '头像',
hazard_factors as '危害因素编码',
hazard_factors_text as '危害因素名称',
is_check as '是否检查(0-否，1-是)',
is_wz_check as '问诊科是否检查',
past_medical_history as '既往病史',
diagnosis_date as '诊断日期',
diagnostic_unit as '诊断单位',
regist_date as '登记时间',
report_printing_num as '报告打印次数',
physical_type as '体检类型',
address_unit as '单位地址',
is_recheck as '是否复查（0-不复查，1-复查）',
unit_id as '单位id',
statu as '状态（是否过审 0 未过审 1 已过审）',
check_result as '体检结果（0-未见异常，1-其他异常，2-职业禁忌症，3-疑似职业病）',
old_group_id as '原分组id  用于健康体检',
other_hazard_factors as '其他危害因素名称',
sporadic_physical as '是否零星体检(0-否，1-是)',
print_state as '打印状态(0-未打印，1-已打印)',
review_statu as '复查状态(0-未出结论，1-已出结论)',
check_date as '体检日期',
department as '所属部门',
certificate_type as '从业类别',
nation as '民族',
home_address as '家庭住址',
check_org_id as '体检机构id',
is_charge as '是否社区体检',
lis_time as '同步到lis系统的时间',
tc_time as '同步到听测时间',
fgc_time as '同步到 肺功能时间',
birthplace_name as '出生地',
enterprise_name as 'enterprise_name',
job_id as '工号',
print_time as '打印时间',
patient_id as 'his患者id',
feeStatus as 'feeStatus',
PatientName as '患者姓名',
LC_Diagnosis as '临床诊断',
SurgeryFindings as '手术所见',
Ward as '病区',
BedNumber as '床位',
WardName as '病区名称',
AdmissionRoute as '入院途径',
SMTCode as '体检号',
SMTDoctor as '就诊医生',
AgainFlag as '复诊标识',
SpecialPatientFlag as '特殊患者标识',
AdmissCase as '入院情况',
VisitNumber as '就诊次数',
RecordNumber as '病历号',
DiagnosisCode as '诊区代码',
DiagnosisArea as '诊区',
OrderApplyID as '医嘱号',
DiagnosisType as '诊断类型',
DiagnosisAttribute as '诊断属性',
PinYin as 'PinYin',
fee_status as '缴费状态',
visit_id as 'visit_id',
is_retained as '是否保留(1保留 其他不保留)'

FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5
where group_id ='249219c852d943be9563abdece70b961'
