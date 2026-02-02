/*
INSERT INTO [dbo].[t_drg_dept] ([dept_code], [dept_name])
SELECT dept_code,dept_name
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',  
    'Excel 12.0 Xml;HDR=YES;IMEX=1;DATABASE=D:\00145740 CYS\1.日常文件\20260127 昌财kettle\科室人员信息.xlsx', 
    科室$  
)
*/

/*
INSERT INTO t_drg_users (CODE,NAME,st_code)
SELECT USER_CODE,USER_NAME,ST_CODE
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',  
    'Excel 12.0 Xml;HDR=YES;IMEX=1;DATABASE=D:\00145740 CYS\1.日常文件\20260127 昌财kettle\科室人员信息.xlsx', 
    人员$  
)
*/
/*
insert into t_dept_user_info(emp_no,name,dept_code,dept_name)
SELECT xlsx.user_code,xlsx.USER_NAME,dd.dept_code,dd.dept_name
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',  
    'Excel 12.0 Xml;HDR=YES;IMEX=1;DATABASE=D:\00145740 CYS\1.日常文件\20260127 昌财kettle\科室人员信息.xlsx', 
    人员$  
)xlsx
left join t_drg_dept dd on  xlsx.dept_code=dd.dept_code

*/
/* -- 去除特殊符号
UPDATE t_department
SET NAME = REPLACE(REPLACE(REPLACE(NAME, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''),CODE = REPLACE(REPLACE(REPLACE(CODE, CHAR(13), ''), CHAR(10), ''), CHAR(9), '');

*/