# database-index

使用工具：MySQL Workbench 8.0 CE  

# 測試

新增 database
```
CREATE DATABASE `test_database` 
```
匯入
t.sql  



# 產生測試

此語法新增 table t 與一萬筆資料
```
CREATE TABLE T( 
	Id INT AUTO_INCREMENT PRIMARY KEY, 
	UserId INT, 
	UserGroup INT 
); 
INSERT INTO T (UserId,UserGroup) 
    SELECT ROUND(1.0 + RAND() * 10000), 
        ROUND(1.0 + RAND() * 10000 / 1000) + 1 
    FROM information_schema.columns t1 CROSS JOIN information_schema.columns t
LIMIT 10000;
```
## MySQL測試t.sql(1,147,453筆資料)



Group By 找尋資料  
```
select count(*),UserId ,UserGroup from t group by UserId;
```

用group_conca 找尋Group By內的資料  
```
select count(*),UserId,group_concat(UserId) ,UserGroup,group_concat(UserGroup) from t group by UserId;
```

直接查詢所需時間(4.516 s)
```
select * from t where UserId = 1049 and UserGroup = 11;
```

-- 增加索引UserId (1.938 s)  
```
ALTER TABLE `t` ADD INDEX `UserId` (`UserId`);
```

再查詢一次(0.00 s)
```
select * from t where UserId = 1049 and UserGroup = 11;
```

-- 刪除索引UserId
```
ALTER TABLE `t` DROP INDEX `UserId`;
```

-- 只留下UserGroup索引(比UserId索引還慢)(12.140 s)
```
select * from t where UserId = 1049 and UserGroup = 11;
```


-- 刪除索引UserGroup
```
ALTER TABLE `t` DROP INDEX `UserGroup`;
```


-- 複合索引
```
ALTER TABLE `t` ADD INDEX `UserId_UserGroup` (`UserId`, `UserGroup`);
select * from t where UserId = 1049 and UserGroup = 11;
```
<br>
<br>
<br>

## MySQL測試t4.sql(139,000,000筆資料)


-- 無索引(50 s)
```
select * from t4 where UserId = 2423392 and UserGroup = 38;
```

-- 增加索引UserId(300 s up)
```
ALTER TABLE `t4` ADD INDEX `UserId` (`UserId`);
```

增加索引後再查詢一次(0 s)
```
select * from t4 where UserId = 2423392 and UserGroup = 38;
```

-- 刪除索引UserId
```
ALTER TABLE `t` DROP INDEX `UserId`;
```

-- 只增加UserGroup索引
```
ALTER TABLE `t` ADD INDEX `UserGroup` (`UserGroup`);
```

增加索引後再查詢一次(0 s)
```
select * from t4 where UserId = 2423392 and UserGroup = 38;
```

-- 複合索引
```
ALTER TABLE `t4` ADD INDEX `UserGroup_UserId` (`UserGroup`, `UserId`);
```


### explain  

7 rows
0 + 0s
```
explain  select  * from t4 where UserGroup = 38 and  UserId = 2423392 ;
```
| id | select_type | table | type | possible_keys    | key              | key_len | ref          | rows | Extra |
|----|-------------|-------|------|------------------|------------------|---------|--------------|------|-------|
| 1  | SIMPLE      | t4    | ref  | UserGroup_UserId | UserGroup_UserId | 10      | const,const | 7    |       |


2777258 rows
0.016 + 1253 s
```
explain  select  * from t4 where UserGroup = 38  ;
```
| id | select_type | table | type | possible_keys    | key              | key_len | ref   | rows    | Extra |
|----|-------------|-------|------|------------------|------------------|---------|-------|---------|-------|
| 1  | SIMPLE      | t4    | ref  | UserGroup_UserId | UserGroup_UserId | 5       | const | 5642904 |       |


65 rows
48.375 + 0 s
```
explain  select  * from t4 where  UserId = 2423392  ;
```
| id | select_type | table | type | possible_keys | key | key_len | ref  | rows      | Extra        |
|----|-------------|-------|------|---------------|-----|---------|------|-----------|--------------|
| 1  | SIMPLE      | t4    | ALL  | NULL          | NULL | NULL    | NULL | 139000409 | Using where |



<br>
<br>
<br>

|  data_size   | index_size  |
|  ----  | ----  |
| 5647.00MB  | 2831.98MB |
	