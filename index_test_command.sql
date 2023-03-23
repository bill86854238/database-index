
-- Group By 找尋資料
select count(*),UserId ,UserGroup from t group by UserId;

-- 用group_conca 找尋Group By內的資料
select count(*),UserId,group_concat(UserId) ,UserGroup,group_concat(UserGroup) from t group by UserId;


-- 無索引
select * from t where UserId = 1049 and UserGroup = 11;

-- 增加索引UserId
ALTER TABLE `t` ADD INDEX `UserId` (`UserId`);

select * from t where UserId = 1049 and UserGroup = 11;

-- 刪除索引UserId
ALTER TABLE `t` DROP INDEX `UserId`;

select * from t where UserId = 1049 and UserGroup = 11;


-- 只增加UserGroup索引(比UserId索引還慢)
ALTER TABLE `t` ADD INDEX `UserGroup` (`UserGroup`);
-- 刪除索引UserGroup
ALTER TABLE `t` DROP INDEX `UserGroup`;


select * from t where UserId = 1049 and UserGroup = 11;

explain select  * from t where UserId = 1049 and UserGroup = 11;



-- 強制不使用索引
select * from t IGNORE INDEX (UserGroup) where UserId = 1049 and UserGroup = 11;
select * from t where UserId = 1049 and UserGroup = 11;
select * from t where  UserGroup = 11 and UserId = 1049 ;

select * from t IGNORE INDEX (UserGroup) where  UserGroup = 11;
select * from t where UserGroup = 11 ;




-- 複合索引
ALTER TABLE `t` ADD INDEX `UserId_UserGroup` (`UserId`, `UserGroup`);
-- 刪除複合索引
ALTER TABLE `t` DROP INDEX `UserId_UserGroup`;

select * from t where UserId = 1049 and UserGroup = 11;

-- 複合索引順序錯誤
select * from t where  UserGroup = 11 and UserId = 1049 ;

-- 查詢資料占用容量
SELECT CONCAT(ROUND(SUM(data_length)/(1024*1024),2),'MB') AS data_size FROM information_schema.tables WHERE table_schema='test_database' AND table_name='t';
-- 查詢索引占用容量 
SELECT CONCAT(ROUND(SUM(index_length)/(1024*1024),2),'MB') FROM information_schema.tables WHERE table_schema='test_database' AND table_name='t';

-- 查詢資料與索引占用容量
SELECT CONCAT(ROUND(SUM(data_length)/(1024*1024),2),'MB') AS data_size, CONCAT(ROUND(SUM(index_length)/(1024*1024),2),'MB') AS index_size FROM information_schema.tables WHERE table_schema='test_database' AND table_name='t';



-- 寫入資料測試 
INSERT INTO t (UserId, UserGroup)
	SELECT ROUND(1.0 + RAND() * 50000),
		   ROUND(1.0 + RAND() * 50 / 1000) + 2
	FROM information_schema.columns
	LIMIT 1;

