CREATE DEFINER=`root`@`localhost` FUNCTION `buycards`(uid int) RETURNS int(11)
begin
    declare i int default 0;                                        
    declare cid int;
    declare buy int default (select recharge from player where userId = uid);
declare PR float ;
    case when buy>10 then set PR=0.1 ;
    else set PR = 0.05+0.005*buy;
    end case;
UPDATE player 
SET 
recharge = recharge + 1
WHERE
userId = uid;
    repeat 
case when rand()>PR then set cid=truncate(1,rand()*1000);
        else set cid=truncate(1,rand()*100);
        end case;
INSERT INTO collect (userId,cardId,number) 
VALUES (uid,cid,1) 
ON DUPLICATE KEY 
UPDATE number=number+1;
set i = i + 1;                
until i > 4                        
end repeat;
    return 0;
End