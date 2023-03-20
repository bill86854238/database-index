
-- Group By 找尋資料
select count(*),UserId ,UserGroup from t group by UserId;

-- 用group_conca 找尋Group By內的資料
select count(*),UserId,group_concat(UserId) ,UserGroup,group_concat(UserGroup) from t2 group by UserId;



select * from t2 where UserId = 897082 and UserGroup = 63184;



ALTER TABLE `t2` DROP INDEX `UserId`;
select * from t2 where UserId = 897082 and UserGroup = 63184;


ALTER TABLE `t2` ADD INDEX `UserGroup` (`UserGroup`);

select * from t where UserId = 1049 and UserGroup = 11;




