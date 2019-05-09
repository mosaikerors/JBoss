drop function if exists ban;
delimiter //
create function ban(adminId int, playerId int, liftBanAt datetime)
returns varchar(10)
begin
	insert banrecord values (adminId, playerId, liftBanAt)
		on duplicate key
        update liftBanAt = liftBanAt;
    return "ok";
END //
delimiter ;

select ban(1, 2, now());