-- 用group_conca 找尋Group By內的資料
select count(*),UserId,group_concat(UserId) ,UserGroup,group_concat(UserGroup) from t4 group by UserId;

select * from t4 where Id = 558217;

-- 無索引
select * from t4 where UserId = 2423392 and UserGroup = 38;


-- 增加索引UserId(300 s up)
ALTER TABLE `t4` ADD INDEX `UserId` (`UserId`);

select * from t4 where UserId = 2423392 and UserGroup = 38;


-- 刪除索引UserId
ALTER TABLE `t` DROP INDEX `UserId`;
-- 只增加UserGroup索引
ALTER TABLE `t` ADD INDEX `UserGroup` (`UserGroup`);

select * from t4 where UserId = 2423392 and UserGroup = 38 ;

-- 複合索引
ALTER TABLE `t4` ADD INDEX `UserGroup_UserId` (`UserGroup`, `UserId`);

explain select  * from t4 where UserId = 2423392 and UserGroup = 38 ;

 select  * from t4 where UserGroup = 38 and  UserId = 2423392 ;


explain select * from t4 where UserGroup = 38 ;
select * from t4 where UserGroup = 38 ;

explain  select * from t4 where  UserId = 2423392 ;
select  * from t4 where  UserId = 2423392;





-- 查詢資料與索引占用容量
SELECT CONCAT(ROUND(SUM(data_length)/(1024*1024),2),'MB') AS data_size, CONCAT(ROUND(SUM(index_length)/(1024*1024),2),'MB') AS index_size FROM information_schema.tables WHERE table_schema='test_database' AND table_name='t4';
