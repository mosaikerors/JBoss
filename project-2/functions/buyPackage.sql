drop function if exists buyPackage;
set global log_bin_trust_function_creators=1;
delimiter //
create function buyPackage(id int)
returns varchar(45)
begin
    declare i int;
    declare cardid int;
    declare money int default (select recharge from player where userId = id);
    declare possibility double;
    
    if (money < 10) then
		set possibility = 0.1;
	elseif (money < 30) then
		set possibility = 0.2;
	elseif (money < 60) then
		set possibility = 0.3;
	elseif (money < 100) then
		set possibility = 0.4;
	else
		set possibility = 0.5;
	end if;
    
    set i = 0;
    while i < 5 do 
		if  (rand() < possibility) then
			select rarecards.cardId into cardid
            from (
				select * 
					from card
					where rarity = 'rare' 
					order by rand()
			) as rarecards
			limit 1;  
		else 
			select commoncards.cardId into cardid
            from (
				select * 
					from card
					where rarity = 'common' 
					order by rand()
			) as commoncards
			limit 1;  
		end if; 
        
        update player
			set recharge = money + 10
            where userId = id;
		
		insert into Collect (userId, cardId, number) 
			values (id, cardid, 1) 
			on duplicate key
			update number = number + 1;
		set i = i + 1;
	end while;
    return "ok";
end //
delimiter ;

select buyPackage(2)

