CREATE TABLE T4 (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT,
    UserGroup INT,
    UserAge INT,
    UserNumber INT
); 



INSERT INTO T4 (UserId,UserGroup,UserAge,UserNumber)
SELECT ROUND(1.0 + RAND() * 50000),
       ROUND(1.0 + RAND() * 50000 / 1000) + 1,
       ROUND(1.0 + RAND() * 10000 / 100) + 1,
       ROUND(1.0 + RAND() * 50000 / 100) + 1
FROM information_schema.columns t1 CROSS JOIN information_schema.columns t2
LIMIT 50000;
