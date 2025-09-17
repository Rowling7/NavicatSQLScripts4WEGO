SELECT RANK() OVER (ORDER BY case when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='信息科学与工程学院研支团电子信息' then '信息科学与工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='新能源学院1+3辅导员能源动力' then '新能源学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员土木水利' then '海洋工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员机械' then '海洋工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院机械' then '海洋工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋科学与技术学院博士海洋科学' then '海洋科学与技术学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院1+3辅导员数学' then '理学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院物理学' then '理学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='经济管理学院1+3辅导员工商管理学' then '经济管理学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='计算机科学与技术学院1+3辅导员电子信息' then '计算机科学与技术学院'
				else SUBSTRING(og.name, 1, LOCATE('-', og.name) - 1) end ,
       case when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='信息科学与工程学院研支团电子信息' then '研支团电子信息'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='新能源学院1+3辅导员能源动力' then '1+3辅导员能源动力'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员土木水利' then '1+3辅导员土木水利'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员机械' then '1+3辅导员机械'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院机械' then '机械'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋科学与技术学院博士海洋科学' then '博士海洋科学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院1+3辅导员数学' then '1+3辅导员数学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院物理学' then '物理学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='经济管理学院1+3辅导员工商管理学' then '1+3辅导员工商管理学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='计算机科学与技术学院1+3辅导员电子信息' then '1+3辅导员电子信息'
				else SUBSTRING(og.name, LOCATE('-', og.name) + 1) end,dr.order_application_id ASC) AS 序号,
-- gp.dept 团检单位,
       -- go.order_name AS 订单名称,
       case when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='信息科学与工程学院研支团电子信息' then '信息科学与工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='新能源学院1+3辅导员能源动力' then '新能源学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员土木水利' then '海洋工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员机械' then '海洋工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院机械' then '海洋工程学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋科学与技术学院博士海洋科学' then '海洋科学与技术学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院1+3辅导员数学' then '理学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院物理学' then '理学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='经济管理学院1+3辅导员工商管理学' then '经济管理学院'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='计算机科学与技术学院1+3辅导员电子信息' then '计算机科学与技术学院'
				else SUBSTRING(og.name, 1, LOCATE('-', og.name) - 1) end AS 学院,
       case when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='信息科学与工程学院研支团电子信息' then '研支团电子信息'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='新能源学院1+3辅导员能源动力' then '1+3辅导员能源动力'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员土木水利' then '1+3辅导员土木水利'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院1+3辅导员机械' then '1+3辅导员机械'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋工程学院机械' then '机械'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='海洋科学与技术学院博士海洋科学' then '博士海洋科学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院1+3辅导员数学' then '1+3辅导员数学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='理学院物理学' then '物理学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='经济管理学院1+3辅导员工商管理学' then '1+3辅导员工商管理学'
				when SUBSTRING(og.name, LOCATE('-', og.name) + 1)='计算机科学与技术学院1+3辅导员电子信息' then '1+3辅导员电子信息'
				else SUBSTRING(og.name, LOCATE('-', og.name) + 1) end AS 专业,
       gp.person_name AS 姓名,
       -- gp.sex AS 性别,
       -- gp.age AS 年龄,
       -- gp.birth AS 出生日期,
       gp.id_card AS 身份证号码,
       -- gp.mobile AS 手机号码,
       dr.group_item_name AS 项目名称,
       dr.order_application_id '申请单ID'
       -- gp.test_num AS 体检号,
       -- gp.patient_id AS HIS号
FROM t_group_person_f594102095fd9263b9ee22803eb3f4e5 gp
     LEFT JOIN t_depart_result_f594102095fd9263b9ee22803eb3f4e5 dr ON dr.person_id = gp.id
     JOIN      t_order_group_f594102095fd9263b9ee22803eb3f4e5 og ON gp.group_id = og.id
     JOIN      t_group_order_f594102095fd9263b9ee22803eb3f4e5 go ON og.group_order_id = go.id
WHERE gp.del_flag <> '1'
  AND og.del_flag <> '1'
  AND go.del_flag <> '1'
  AND go.order_code = '202508270672'
  AND dr.group_item_name LIKE '%干扰素%'
ORDER BY 学院,专业,申请单ID
