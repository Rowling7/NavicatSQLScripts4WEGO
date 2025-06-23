DROP PROCEDURE IF EXISTS FACTORIAL
go
CREATE PROCEDURE FACTORIAL
    @startTime datetime,
    @endTime datetime
AS
BEGIN
    select  distinct  mdtrt_sn from   t_setlinfo  a
where  convert(date,brjsrq,23)  between  @startTime  and  @endTime and isdrg =1 ;

END;


EXEC FACTORIAL
    @startTime = '2025-03-01',
    @endTime = '2025-03-31';
