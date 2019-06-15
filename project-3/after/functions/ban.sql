CREATE DEFINER=`root`@`localhost` FUNCTION `ban`(playerId int, liftBanAt timestamp) RETURNS varchar(10) CHARSET utf8
begin
	update player_account
		set status = liftBanAt
        where userId = playerId;
    return "ok";
END