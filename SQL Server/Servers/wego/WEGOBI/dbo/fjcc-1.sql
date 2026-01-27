SELECT distinct user_code,trim(user_name)
from OPENROWSET('Microsoft.ACE.OLEDB.12.0','Excel 8.0;HDR=YES;index=1;DATABASE=D:\00145740 CYS\2.工作软件\6.泉州DRG_病案_智审\1.DRG\科室人员信息3.xlsx',[人员$]);


./*INSERT INTO [dbo].[t_account] ( 
    [type], [username], [password], [name], [jobnumber], 
    [phone], [email], [status], [islock], [closedtime], 
    [closedby], [lastlogintime], [lastloginip], [createdtime], 
    [createdby], [modifiedtime], [modifiedby], [deleted], 
    [deletedtime], [deletedby]
) 
SELECT 
    1 AS [type],
    user_code AS [username],  
    N'C7F87A07CA65FB084F52D358CF3D5314' AS [password],  
    TRIM(user_name) AS [name],
    user_code AS [jobnumber], 
    N' ' AS [phone],
    N' ' AS [email],
    1 AS [status],
    '0' AS [islock],
    '2026-01-26 15:50:46.500000' AS [closedtime], 
    '00000000-0000-0000-0000-000000000000' AS [closedby], 
    null AS [lastlogintime], 
    null AS [lastloginip],
    '2026-01-26 15:50:46.500000' AS [createdtime], 
    '00000000-0000-0000-0000-000000000000' AS [createdby],
    '2026-01-26 15:50:46.500000' AS [modifiedtime],
    '00000000-0000-0000-0000-000000000000' AS [modifiedby], 
    '0' AS [deleted], 
    '2026-01-26 15:50:46.500000' AS [deletedtime], 
    '00000000-0000-0000-0000-000000000000' AS [deletedby] 
FROM 
    OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'Excel 8.0;HDR=YES;index=1;DATABASE=D:\00145740 CYS\2.工作软件\6.泉州DRG_病案_智审\1.DRG\科室人员信息3.xlsx',
        [人员$]
    )
WHERE 
    user_code IS NOT NULL AND TRIM(user_code) <> ''
GROUP BY 
    user_code, TRIM(user_name); 

update t_account set password=UPPER(substring(sys.fn_sqlvarbasetostr(HashBytes('MD5',cast(lower(username)+'_Yy@2025@' as  varchar(100)))),3,32)) where [closedtime] LIKE N'%2026-01-26%' 
*/


update t_account set password=UPPER(substring(sys.fn_sqlvarbasetostr(HashBytes('MD5',cast(lower(username)+'_Yy@2025@' as  varchar(100)))),3,32)) where username='030313'