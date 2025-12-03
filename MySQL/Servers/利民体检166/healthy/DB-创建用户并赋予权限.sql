-- 创建用户
CREATE USER 'lm'@'%' IDENTIFIED BY 'lm@123456';
-- 赋予数据库权限
GRANT SELECT ON healthy.* TO 'lm'@'%';
-- 赋予 特定数据库 权限
GRANT SELECT,SHOW VIEW ON limin_tijian_local.* TO 'lm'@'%';
-- 刷新权限
FLUSH PRIVILEGES;